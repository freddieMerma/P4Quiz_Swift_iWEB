//
//  QuizzesModel.swift
//  P4.1 Quiz
//
//  Created by Santiago Pavón Gómez on 11/9/23.
//

import Foundation

//Para solucionar errores del archivo original
extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

@Observable class QuizzesModel {

    //Datos
    private(set) var quizzes = [QuizItem]()

    //Descargar Datos
    func download() async throws {
        guard let url = Endpoints.random10() else {
            throw "Fallos no deseados, intentalo más tarde"
        }
        let(data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "No puedes hacerlo"
        }
        guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data) else {
            throw "Recibidos datos corruptos"
        }
        self.quizzes = quizzes
        print("Quizzes cargados")
    }

    func check (quizItem: QuizItem, answer: String) async throws -> Bool {
        guard let url = Endpoints.checkAnswer(quizItem: quizItem, answer: answer) else { throw "No se puede comprobar la respuesta" }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "No es posible realizar esto"
        }

        guard let res = try? JSONDecoder().decode(CheckResponseItem.self, from: data) else {
            throw "Recibidos datos corruptos"
        }
        return res.result
    }

    func toggleFavourite(quizItem: QuizItem) async throws {

        guard let url = Endpoints.toggleFav(quizItem: quizItem) else { throw "No se puede cambiar favorito" }
        print("URL=", url)
        var request = URLRequest(url: url)
        request.httpMethod = quizItem.favourite ? "DELETE" : "PUT"


        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "No es posible realizar esto"
        }

        guard let res = try? JSONDecoder().decode(FavouriteStatusItem.self, from: data) else {
            throw "Error: recibido datos corruptos"
        }
        guard let index = quizzes.firstIndex(where: {qi in qi.id == quizItem.id}) else {
            throw "Error en la base de datos"
        }
        quizzes[index].favourite = res.favourite
    }

    func verRespuesta(quizItem: QuizItem, answer: String) async throws -> mostrarRespuesta {
        guard let url = Endpoints.verRes(quizItem: quizItem, answer: answer) else { throw "No se puede obtener la respuesta" }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "No es posible realizar esto"
        }

        guard let res = try? JSONDecoder().decode(mostrarRespuesta.self, from: data) else {
            throw "Recibido datos corruptos"
        }

        return res

    }
}
