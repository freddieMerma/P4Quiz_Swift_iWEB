//
//  QuizzesListView.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI

struct QuizzesListView: View {

    //@State var quizzesModel = QuizzesModel()
    @Environment(QuizzesModel.self) var quizzesModel

    var body: some View {
        NavigationStack {
            List {
                ForEach (quizzesModel.quizzes) { quizItem in

                    NavigationLink {
                        QuizItemPlayView(quizItem: quizItem)
                    } label: {
                        QuizItemRowView(quizItem: quizItem)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("P4 Quizzes")
        }
        .onAppear(perform: {
            guard quizzesModel.quizzes.count == 0 else {return}
            quizzesModel.load()
        })
        .padding(5) //.padding()
    }
}

#Preview {
    QuizzesListView()
        .environment(QuizzesModel()) //Importante!
        .environment(ScoresModel()) //Importante!
}
