//
//  Mock.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 14/10/24.
//

import Foundation

let mockWordData = WordModel(
    word: "keyboard",
    phonetic: "/ˈkiːbɔːd/",
    phonetics: [
        Phonetic(
            text: "/ˈkiːbɔːd/",
            audio: nil
        ),
        Phonetic(
            text: "/ˈkiːbɔːd/",
            audio: nil
        ),
        Phonetic(
            text: "/ˈkibɔɹd/",
            audio: "https://api.dictionaryapi.dev/media/pronunciations/en/keyboard-us.mp3"
        )
    ],
    origin: nil,  // Este campo no está en el JSON proporcionado, pero puedes añadir un valor si lo necesitas.
    meanings: [
        Meaning(
            partOfSpeech: "noun",
            definitions: [
                Definition(
                    definition: "(etc.) A set of keys used to operate a typewriter, computer etc.",
                    example: nil,
                    synonyms: [],
                    antonyms: []
                ),
                Definition(
                    definition: "A component of many instruments including the piano, organ, and harpsichord consisting of usually black and white keys that cause different tones to be produced when struck",
                    example: nil,
                    synonyms: [],
                    antonyms: []
                ),
                Definition(
                    definition: "A device with keys of a musical keyboard, used to control electronic sound-producing devices which may be built into or separate from the keyboard device.",
                    example: nil,
                    synonyms: [],
                    antonyms: []
                )
                
            ],
            synonyms: nil
        ),
        Meaning(
            partOfSpeech: "verb",
            definitions: [
                Definition(
                    definition: "To type on a computer keyboard.",
                    example: "Keyboarding is the part of this job I hate the most.",
                    synonyms: [],
                    antonyms: []
                )
            ],
            synonyms: nil
        )
    ]
)
