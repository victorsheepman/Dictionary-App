//
//  Constansts.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 17/10/24.
//

import Foundation

struct Constansts {
    struct Url {
        static let base = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    }
    struct NoData{
        static let title = "No Definitions Found"
        static let body  = "Sorry pal, we couldn't find definitions for the word you were looking for. You can try the search again at later time or head to the web instead."
        static let empty = "Whoops, can’t be empty…"
    }
    struct Icons {
        static let book   = "book.closed"
        static let moon   = "moon"
        static let danger = "exclamationmark.triangle.fill"
        static let search = "magnifyingglass"
        static let play   = "play.fill"
        static let circle = "circle.fill"
    }
    
    struct sections {
        static let noun     = "noun"
        static let meaning  = "Meaning"
        static let synonyms = "Synonyms"
        static let verb     = "verb"
    }
    
    struct Errors {
        static let emptySearch     = "Error: La búsqueda está vacía."
        static let invalidData     = "Error: Datos inválidos."
        static let invalidURL      = "Error: La URL es inválida."
        static let invalidResponse = "Error: La respuesta del servidor no es válida."
        static let unexpected      = "Error: Inesperado."
    }
}
