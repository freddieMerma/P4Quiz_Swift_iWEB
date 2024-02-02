//
//  QuizItemPlayView.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI


// Declaración del operador - P4.1
infix operator =+-=: ComparisonPrecedence

// Implementación del operador - P4.1
extension String {
    static func =+-= (lhs: String, rhs: String) -> Bool {
        return lhs.lowercased().contains(rhs.lowercased()) || rhs.lowercased().contains(lhs.lowercased())
    }
}



struct QuizItemPlayView: View {

    @Environment(ScoresModel.self) var scoresModel
    @Environment(QuizzesModel.self) var quizzesModel

    @Environment(\.verticalSizeClass) var vsc //Vista Horizontal iPhone

    var quizItem: QuizItem

    @State var answer: String = ""
    @State var showCheckAlert = false

    @State var checkingResponse = false
    @State var checkAnswer = false

    @State var answerIsOk = false

    @State var errorMsg = "" {
        didSet {
            showErrorMsgAlert = true
        }
    }

    @State var showErrorMsgAlert = false

    @State var aldoble = false


    //Func. Verificar Respuesta
    func checkResponde() async {
        do {
            checkingResponse = true
            answerIsOk = try await quizzesModel.check(quizItem: quizItem, answer: answer)
            showCheckAlert = true

            if answerIsOk{
                scoresModel.add(quizItem: quizItem)
            }
            checkingResponse = false
        } catch {
            errorMsg = error.localizedDescription
        }
    }

    private var titulo: some View {
        HStack{
            Text(quizItem.question)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(3)
            Spacer()
            Button {
                Task {
                    do {
                        try await quizzesModel.toggleFavourite(quizItem: quizItem)
                    } catch {
                        print("ERROR = ", error)
                        errorMsg = error.localizedDescription
                    }
                }
            } label: {
                Image(quizItem.favourite ? "yellow_star" : "gray_star")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
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
            if checkingResponse {
                ProgressView()
            } else {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    checkingResponse = true
                    showCheckAlert = true
                    Task {
                        await checkResponde()
                    }

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
                    Text(answerIsOk ? "CORRECTA" : "INCORRECTA")
                }
            }


        }

    }

    @State var scale = 1.0
    private var adjunto: some View {
        GeometryReader { geometry in
            EasyAsyncImage(url: quizItem.attachment?.url)
                .saturation(showCheckAlert ? 0 : 1) //Si showCheckAlert = true, desatura
                .rotationEffect(Angle(degrees: showCheckAlert ? 180 : 0))
                .animation(.easeInOut, value: showCheckAlert)
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height )
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .contentShape(RoundedRectangle(cornerRadius: 25.0))
                .overlay {
                    RoundedRectangle(cornerRadius: 25.0).stroke(Color.black, lineWidth: 4)
                }
                .scaleEffect(scale)
                //Doble Tap - Respuesta Correcta
                .onTapGesture(count: 2) {
                    Task { //Task pa Func Asincronas
                        do {
                            let respuesta = try await quizzesModel.verRespuesta(quizItem: quizItem, answer: answer)
                            answer = respuesta.answer
                            aldoble = true
                            // Animación al hacer Doble Tap
                            withAnimation {
                                scale = scale - 0.08
                            } completion: {
                                scale = scale + 0.08
                            }
                        } catch {
                            // Maneja el error aquí
                            print("Se produjo un error: \(error)")
                        }

                    }
                }
                .saturation(aldoble ? 0 : 1)

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
            .contextMenu(menuItems: {
                Button(action: {
                    answer = ""
                }, label: {
                    Label("Limpiar", systemImage: "x.circle")
                })
                Button(action: {
                    Task {
                        do {
                            let respuesta = try await quizzesModel.verRespuesta(quizItem: quizItem, answer: answer)
                            answer = respuesta.answer
                        } catch {
                            // Maneja el error aquí
                            print("Se produjo un error: \(error)")
                        }
                    }

                }, label: {
                    Label("Ver respuesta", systemImage: "checkmark.circle.fill")
                })
            })


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
