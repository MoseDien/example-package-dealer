//
//  File.swift
//  
//
//  Created by Bell Dien on 2024/3/24.
//

#if os(Linux)
import Glibc
#endif

import Foundation
import DeckOfPlayingCards
import PlayingCard
import ArgumentParser

@main
struct Sample: ParsableCommand {
    enum Error: Swift.Error, CustomStringConvertible {
        case notEnoughCards

        var description: String {
            switch self {
            case .notEnoughCards:
                return "Not enough cards"
            }
        }
    }

    static var configuration = CommandConfiguration(
            abstract: "Shuffles a deck of playing cards and deals a number of cards.",
            discussion: """
                For each count argument, prints a line of tab-delimited cards to stdout,
                or if there aren't enough cards remaining,
                prints "Not enough cards" to stderr and exits with a nonzero status.
                """)

    @Argument(help: .init("The number of cards to deal at a time.",
                          valueName: "count"))
    var counts: [UInt] = [2]

    mutating func run() throws {
        #if os(Linux)
        srandom(UInt32(clock()))
        #endif

        var deck = Deck.standard52CardDeck()
        deck.shuffle()

        for count in counts {
            var cards: [PlayingCard] = []

            for _ in 0..<count {
                guard let card = deck.deal() else {
                    Self.exit(withError: Error.notEnoughCards)
                }

                cards.append(card)
            }

            print(cards.map(\.description).joined(separator: "\t"))
        }
    }
}

