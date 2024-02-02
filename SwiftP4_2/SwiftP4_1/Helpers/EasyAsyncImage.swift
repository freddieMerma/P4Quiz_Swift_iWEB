//
//  EasyAsyncImage.swift
//  SwiftP4_1
//
//  Created by c092 DIT UPM on 21/11/23.
//

import SwiftUI

// Define una estructura llamada EasyAsyncImage que conforma al protocolo View
struct EasyAsyncImage: View {
    var url: URL? // Define una propiedad opcional url de tipo URL
    
    // Define el cuerpo de la vista utilizando la propiedad body
    var body: some View {
        
        // Utiliza la vista AsyncImage con la URL proporcionada y un cierre que maneja las diferentes fases de la carga de la imagen
        AsyncImage(url: url) { phase in
            // Verifica si la URL es nula
            if url == nil {
                Color.yellow // Muestra un color amarillo si la URL es nula
            } else if let image = phase.image {
                image.resizable() // Si la imagen se obtiene con éxito, la hace redimensionable
            } else if phase.error != nil {
                Color.red // Si hay un error durante la carga, muestra un color rojo
            } else {
                ProgressView() // Muestra un indicador de progreso en la fase de carga inicial
            }
        }
    }
}

#Preview {
    EasyAsyncImage()
}
