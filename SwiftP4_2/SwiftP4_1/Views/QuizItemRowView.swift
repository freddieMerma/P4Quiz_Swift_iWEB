//
//  QuizItemRowView.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI

struct QuizItemRowView: View {

    var quizItem: QuizItem

    var body: some View {
        HStack(spacing: 20){
            EasyAsyncImage(url: quizItem.attachment?.url)
                .frame(width: 60, height: 60)
                .scaledToFill()
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.green, lineWidth: 4)
                }
                .shadow(color: .gray, radius: 2, x:0.0, y: 0.0)

            VStack(alignment: .leading){
                Image(quizItem.favourite ? "yellow_star" : "gray_star")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text (quizItem.question)
                    .font(.body)
                    .fontWeight(.bold)
                    .lineLimit(3) // Limita a 3 líneas
            }

            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Text(quizItem.author?.username ?? quizItem.author?.profileName ?? "No Name")
                        .font(.system(size: 12))
                    EasyAsyncImage(url: quizItem.author?.photo?.url)
                    .frame(width: 30, height: 30)
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.blue, lineWidth: 2)
                    }
                    .shadow(color: .blue, radius: 1, x:0.0, y: 0.0)
                }
                Spacer()
            }

        }

    }
}

#Preview {
    
    QuizItemRowView(quizItem: QuizItem.qip)

}
