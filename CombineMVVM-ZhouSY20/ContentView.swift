//
//  ContentView.swift
//  CombineMVVM-ZhouSY20
//
//  Created by cmStudent on 2022/08/18.
//

import SwiftUI
import Combine

//struct PostModel: Identifiable, Codable {
//    let userId: Int
//    let id: Int
//    let title: String
//    let body: String
//}

//class DownloadWithCombineViewModel: ObservableObject {
//    @Published var posts: [PostModel] = []
//
//    var cancellables = Set<AnyCancellable>()
//
//    @Published var count: Int = 0
//
//    @Published var textFieldText: String = ""
//    @Published var textIsValid: Bool = false
//
//    @Published var showButton: Bool = false
//
//    init() {
//        getPosts()
//        addTextFieldSubscriber()
        //addButtonSubscriber()
//    }
//    func getPosts() {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
//        URLSession.shared.dataTaskPublisher(for: url)
//            .receive(on: DispatchQueue.main)
//            .tryMap(handleOutput)
//            .decode(type: [PostModel].self, decoder: JSONDecoder())
//            .replaceError(with: [])
//            .sink(receiveValue: { [weak self] (returnedPosts) in
//                self?.posts = returnedPosts
//
//            })
//            .store(in: &cancellables)
//    }
//
//    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
//        guard let response = output.response as? HTTPURLResponse,
//              response.statusCode >= 200 && response.statusCode < 300 else {
//                  throw URLError(.badServerResponse)
//        }
//        return output.data
//
//    }
    
//    func addTextFieldSubscriber() {
//        $textFieldText
//            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .map { (text) -> Bool in
//                if text.count > 3 {
//                    return true
//                }
//                return false
//            }
//            .sink(receiveValue: {[weak self](isVaild) in
//                self?.textIsValid = isVaild
//            })
//            .store(in: &cancellables)
//    }
    
//    func addButtonSubscriber(){
//        $textIsValid
//            .combineLatest($count)
//            .sink { [weak self] (isValid, count) in
//                guard let self = self else { return }
//                if isValid && count >= 10 {
//                    self.showButton = true
//                } else {
//                    self.showButton = false
//                }
//            }
//            .store(in: &cancellables)
//    }
    
//}

struct ContentView: View {
    
    @StateObject var viewModel = DownloadWithCombineViewModel()
    @StateObject var SViewModel = SubscriberViewModel()
    
    @State var showSheet: Bool = false
        
    var body: some View {
        
        VStack {
            TextField("こちらで入力してください...", text: $SViewModel.textFieldText)
                .padding(.leading)
                .padding()
                .frame(height: 55)
                .font(.headline)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    ZStack {
                        HStack{
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .opacity(
                                    SViewModel.textFieldText.count < 1 ? 0.0 :
                                        SViewModel.textIsValid ? 0.0 : 1.0)
                        
                            Text("\(SViewModel.count)")
                            
                        }
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(SViewModel.textIsValid ? 1.0 : 0.0)

                    }
                        .font(.headline)
                        .padding(.trailing), alignment: .trailing
                )
            Button(action: {
                showSheet.toggle()
            },
                   label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .opacity(SViewModel.showButton ? 1.0 : 0.6)
            })
                .disabled(!SViewModel.showButton)
                .fullScreenCover(isPresented: $showSheet, content: {
                    SecondScreen()
                })
            List {
                ForEach(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
    }
}

struct SecondScreen: View {
    @StateObject var viewModel = DownloadWithCombineViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
//        ZStack(alignment: .topLeading) {
//            Color.green.ignoresSafeArea(.all)
//
//        }
        
        VStack {
            Button(action: {
                presentationMode.wrappedValue
                    .dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding(20)
                    .padding(.leading)
        })
            List {
                ForEach(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .listStyle(DefaultListStyle())
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
