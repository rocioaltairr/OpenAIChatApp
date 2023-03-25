//
//  ChatView.swift
//  chat-App
//
//  Created by 白睿琛 on 2023/3/25.
//

import SwiftUI

struct ChatView: View {
    
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @ObservedObject var apiRequestManager = ChatRequestManager()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(messages, id: \.id) { message in
                            MessageView(message: message)
                                .id(message.id) // add an ID to each view
                        }
                    }.padding(.horizontal, 12)
                }.onChange(of: messages) { _ in
                    scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }

            HStack {
                TextField("Type a message", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding(.trailing)
            }
        }
        .padding(.vertical)
        .navigationBarTitle("Chat")
    }

    func sendMessage() {
        let message = Message(id: UUID(), text: inputText, isMe: true)
        messages.append(message)

        inputText = ""
        DispatchQueue.main.async {
            apiRequestManager.makeRequest(text: message.text) { responseData in
                DispatchQueue.main.async {
                    if let data = responseData {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("json \(json)")
                            if let choices = json["choices"] as? [[String: Any]] {
                                if let text = choices[0]["text"] as? String {
                                    let replyMessage = Message(id: UUID(), text: text, isMe: false)
                                    messages.append(replyMessage)

                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
}
