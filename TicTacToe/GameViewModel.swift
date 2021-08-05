//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Sree Sai Raghava Dandu on 05/08/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Published  var moves:[Move?] = Array(repeating: nil, count: 9)
    @Published  var isGameboarDisabled = false
    @Published  var alertItem: AlertItem?
    //Enum: Player
    enum Player {
        case human, computer
    }

    //Struct: Move
    struct Move {
        let player: Player
        let boardIndex: Int
        
        //Computed property to detect computer or human
        var indicator: String{
            return player == .human ? "xmark" : "circle"
        }
    }
    

    //Functions
    
    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func processPlayerMove(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position){ return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        //Check for win condition or draw
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves){
            alertItem = AlertContext.drawGame
            return
        }
        //Disable Gameboard
        isGameboarDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboarDisabled = false
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.drawGame
                return
            }
        }
    }
    
    //AI: Condtions to make program logic better
    // If AI can win, then win
    // If AI can't win, then block
    // If AI can't block, then take middle square
    // if AI can't take middle square, take the random square
    //function: determineComputerMovePosition
    func determineComputerMovePosition(in moves: [Move?]) -> Int{
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap{ $0 }.filter{$0.player == .computer}
        let computerPositions = Set(computerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        // If AI can't win, then block
        let humanMoves = moves.compactMap{ $0 }.filter{$0.player == .human}
        let humanPositions = Set(humanMoves.map{$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        // If AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        // if AI can't take middle square, take the random square
        var movePosition = Int.random(in: 0..<9)
        if isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    //function: checkWinConditon
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){
            return true
        }
        return false
    }
    func checkForDraw(in moves: [Move?]) -> Bool{
        return moves.compactMap{$0}.count == 9
    }
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
}
