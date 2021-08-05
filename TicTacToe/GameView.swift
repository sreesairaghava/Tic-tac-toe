//
//  GameView.swift
//  TicTacToe
//
//  Created by Sree Sai Raghava Dandu on 05/08/21.
//

import SwiftUI


struct GameView: View {

    //MARK: - Properties
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        //To get dynamic size and suit layout to all screen sizes
        GeometryReader{ reader in
            Text("Tic Tac Toe by Raghava Codes")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .padding()
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns,spacing:5){
                    ForEach(0..<9){ i in
                        ZStack{
                            GameCircleView(proxy: reader)
                            if ((viewModel.moves[i]?.indicator) != nil){
                                PlayerIndicator(systemImageName: viewModel.moves[i]!.indicator)
                            }
                        }//:ZSTACK
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }//:LOOP
                }//:LAZYVGRID
                Spacer()
            } //:VSTACK
            .disabled(viewModel.isGameboarDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) {alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetGame()
                }))
            }
        }//:GEOMETRY
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameCircleView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(Color(.systemRed))
            .opacity(0.5)
            .frame(width: proxy.size.width/3 - 15, height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
