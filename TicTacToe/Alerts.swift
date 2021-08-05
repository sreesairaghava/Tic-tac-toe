//
//  Alerts.swift
//  TicTacToe
//
//  Created by Sree Sai Raghava Dandu on 05/08/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win!"),
                              message: Text("You are so smart! You beat your own AI."),
                              buttonTitle: Text("Hell yeah!"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                              message: Text("You have programmed super AI!"),
                              buttonTitle: Text("Rematch"))
    static let drawGame = AlertItem(title: Text("Huh, Close game!"),
                              message: Text("What a battle"),
                              buttonTitle: Text("Try Again!"))
}
