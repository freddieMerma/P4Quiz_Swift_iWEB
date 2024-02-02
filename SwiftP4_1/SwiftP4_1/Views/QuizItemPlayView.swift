//
//  QuizItemPlayView.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI


// Declaración del operador
infix operator =+-=: ComparisonPrecedence

// Implementación del operador
extension String {
    static func =+-= (lhs: String, rhs: String) -> Bool {
        return lhs.lowercased().contains(rhs.lowercased()) || rhs.lowercased().contains(lhs.lowercased())
    }
}



struct QuizItemPlayView: View {

    @Environment(ScoresModel.self) var scoresModel //Scores
    @Environment(\.verticalSizeClass) var vsc //Vista horizontal iPhone

    var quizItem: QuizItem
    @State var answer: String = ""
    @State var showCheckAlert = false


    private var titulo: some View {
        HStack{
            Text(quizItem.question)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Image(quizItem.favourite ? "yellow_star" : "gray_star")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }

    private var pregunta: some View {
        VStack{
            TextField("Escribe tu respuesta", text: $answer)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    showCheckAlert = true
                    scoresModel.check(quizItem: quizItem, answer: answer)

                }

            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showCheckAlert = true
                scoresModel.check(quizItem: quizItem, answer: answer)
            }) {
                HStack {
                    Image(systemName: "chevron.up.circle.fill")
                    Text("Comprobar")
                }
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color .blue, lineWidth: 2))

            .alert("Respuesta", isPresented: $showCheckAlert) {
            } message: {
                Text(answer =+-= quizItem.answer ? "CORRECTA" : "INCORRECTA")
            }

        }
    }

    private var adjunto: some View {
        GeometryReader { geometry in
            EasyAsyncImage(url: quizItem.attachment?.url)
                .saturation(showCheckAlert ? 0 : 1) //Si showCheckAlert = true, de-satura
                .rotationEffect(Angle(degrees: showCheckAlert ? 180 : 0))
                .animation(.easeInOut, value: showCheckAlert)

                //.frame(width: 100, height: 100)
                //.scaledToFit() // Escala la vista para que se ajuste dentro del espacio disponible, manteniendo la proporción original de la vista.
                .scaledToFill() // Escala la vista para que llene completamente el espacio disponible. (Debug: Error en horizontal input)
                .frame(width: geometry.size.width, height: geometry.size.height )
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .contentShape(RoundedRectangle(cornerRadius: 25.0))
                .overlay {
                RoundedRectangle(cornerRadius: 25.0).stroke(Color.black, lineWidth: 4)
                }
        }
    }

    private var autor: some View {
        HStack{
            Spacer()
            Text(quizItem.author?.username ?? quizItem.author?.profileName ?? "No Name")
            EasyAsyncImage(url: quizItem.author?.photo?.url)
            .frame(width: 60, height: 60)
            .scaledToFit()
            .clipShape(Circle())
            .overlay {
                Circle().stroke(Color.blue, lineWidth: 3)
            }
            .shadow(color: .blue, radius: 5, x:0.0, y: 0.0)
        }

    }

    private var puntos: some View {
        Text("\(scoresModel.acertadas.count)")
            .font(.title)
            .bold()
            .foregroundColor(.blue)

    }


    var body: some View {

        VStack {
            titulo
            if vsc == .compact {
                ScrollView{

                    //Horizontal
                    HStack{
                        VStack{
                            Spacer()
                            pregunta
                            Spacer()
                            HStack{
                                VStack{
                                    puntos
                                    Text("Puntuación")
                                        .bold()
                                }
                                Spacer()
                                autor
                            }
                        }
                        Spacer()
                        adjunto
                        Spacer()
                    }

                }


            } else {

                VStack{
                    //Vertical
                    Spacer()
                    pregunta
                    Spacer()
                    adjunto
                    Spacer()
                    HStack{
                        VStack{
                            puntos
                            Text("Puntuación")
                                .bold()
                        }
                        Spacer()
                        autor
                    }
                }

            }

        }
        .padding()
        .navigationTitle("Play")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    //SCORE
    let qm = QuizzesModel()
    qm.load()
    let sm = ScoresModel()

    return NavigationStack{
        // Crea una pila de navegación que contendrá la vista de juego del elemento de cuestionario
        QuizItemPlayView(quizItem: qm.quizzes[0]).environment(sm)
    }

}
