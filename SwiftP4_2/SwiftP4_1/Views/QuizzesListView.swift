//
//  QuizzesListView.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI

struct QuizzesListView: View {

    @Environment(QuizzesModel.self) var quizzesModel

    @Environment(ScoresModel.self) var scoresModel

    @State var errorMsg = "" {
        didSet {
            showErrorMsgAlert = true
        }
    }

    @State var showErrorMsgAlert = false

    @State var showAll = true


    var body: some View {
        NavigationStack {
            List {
                Toggle("Ver todos", isOn: $showAll)
                ForEach(quizzesModel.quizzes.filter { quizItem in
                    return showAll || scoresModel.pendiente(quizItem: quizItem)
                }) { quizItem in
                    NavigationLink(destination: QuizItemPlayView(quizItem: quizItem)) {
                        QuizItemRowView(quizItem: quizItem)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("P4 Quizzes")
            //Boton Recargar y Record
            .navigationBarItems(
                leading: Text("RECORD: \(scoresModel.record.count)")
                    .bold()
                    .foregroundColor(.red),
              trailing: Button(action: {
                  Task {
                      do {
                          try await quizzesModel.download()
                          scoresModel.cleanup()
                      } catch {
                          errorMsg = error.localizedDescription
                      }
                  }
              }, label: {
                  Label("Refrescar", systemImage: "arrow.counterclockwise")
              }))


        }
        .alert("Error", isPresented: $showErrorMsgAlert) {
        } message: { Text(errorMsg)
        }
        //Al inicio descargue datos
        .task {
            do {
                guard quizzesModel.quizzes.count == 0 else {return}
                try await quizzesModel.download()
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        .padding(5)
    }
}

#Preview {
    QuizzesListView()
        .environment(QuizzesModel())
        .environment(ScoresModel())
}
