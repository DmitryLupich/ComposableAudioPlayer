//
//  BookModel.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 17.01.2024.
//

import Foundation

struct BookModel: Equatable {
    let lyrics, cover: String
    let chapters: [Chapter]
}

struct Chapter: Equatable {
    let description, audioFile: String
    let duration: TimeInterval
}

//MARK: - Mock Book Object

extension BookModel {
    static let mock: Self = BookModel(
        lyrics: "",
        //TODO: - Use Cover instead mock image
        cover: "cover",
        chapters: [
            Chapter(
                description: "Design is not how a thing looks, but how it works",
                audioFile: "sample1",
                duration: 291
            ),
            Chapter(
                description: "Chapter 2",
                audioFile: "sample2",
                duration: 220
            ),
            Chapter(
                description: "Chapter 3",
                audioFile: "sample3",
                duration: 163
            ),
            Chapter(
                description: "Chapter 4",
                audioFile: "sample4",
                duration: 100
            ),
            Chapter(
                description: "Chapter 5",
                audioFile: "sample5",
                duration: 198
            )
        ]
    )
}
