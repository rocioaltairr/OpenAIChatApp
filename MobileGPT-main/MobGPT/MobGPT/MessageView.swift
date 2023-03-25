//
//  MessageView.swift
//  chat-App
//
//  Created by 白睿琛 on 2023/3/25.
//

import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            } else {
                Text(message.text)
                    .padding(10)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}

struct Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    let id: UUID
    let text: String
    let isMe: Bool
}
