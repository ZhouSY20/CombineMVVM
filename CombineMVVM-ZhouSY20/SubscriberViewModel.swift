//
//  SubscriberViewModel.swift
//  CombineMVVM-ZhouSY20
//
//  Created by cmStudent on 2022/08/19.
//

import Foundation
import Combine

final class SubscriberViewModel: ObservableObject {
    
    @Published var count: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    
    
    @Published var textFieldText: String = ""
    @Published var textIsValid: Bool = false
    
    @Published var showButton: Bool = false
    
    
    init() {
        addTextFieldSubscriber()
        setUpTimer()
        addButtonSubscriber()
    }
    
    
    func addTextFieldSubscriber() {
        $textFieldText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text) -> Bool in
                if text.count > 3 {
                    return true
                }
                return false
            }
            .sink(receiveValue: {[weak self](isVaild) in
                self?.textIsValid = isVaild
            })
            .store(in: &cancellables)
    }
    func setUpTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink() { [weak self] _ in
                guard let self = self else { return }
                self.count += 1
                
                if self.count >= 10 {
                    for item in self.cancellables {
                        item.cancel()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func addButtonSubscriber(){
        $textIsValid
            .combineLatest($count)
            .sink { [weak self] (isValid, count) in
                guard let self = self else { return }
                if isValid && count >= 10 {
                    self.showButton = true
                } else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
    
}
