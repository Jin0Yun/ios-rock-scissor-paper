import Foundation

//MARK: - GameRules init & deinit
final class GameRules {
    private let computerPlayer = ComputerPlayer()
    private let rpsLinkedList = CircularRpsLinkedList()
    var onRequstSecondGame: (() -> Void)?
    var onUpdateMessage: ((String) -> Void)?
    var onReStartGame: (() -> Void)?
    var gameTurn: TurnModel?
    
    deinit { print("GameRules Deinit!!") }
}

//MARK: - GameRules method
extension GameRules {
    func playGameWithUserInput( input: String) {
        
        guard let userChoice = convertInputToRPSOption(input)
        else { onUpdateMessage? (GameResult.error.message); return }
        
        let gameResult = determineFirstGameWinner(userChoice: userChoice)
    }
    
    func playSecondGameWithUserInput( input: String) {
        
        guard let userChoice = convertInputToRPSOption(input)
        else { onUpdateMessage? (GameResult.error.message); return }
        
        let secoundGamsResult = determineSecondGameWinner(userChoice: userChoice)
    }
    
    func dipslaySecondGameComment() {
        switch gameTurn {
        case .userTurn:
            onUpdateMessage? (TurnModel.userTurn.message)
        case .computerTurn:
            onUpdateMessage? (TurnModel.computerTurn.message)
        default:
            break
        }
    }
    
    func convertInputToRPSOption(_ input: String) -> RPSModel? {
        switch Int(input) {
        case RPSModel.scissors.rawValue:
            return .scissors
        case RPSModel.rock.rawValue:
            return .rock
        case RPSModel.paper.rawValue:
            return .paper
        default:
            return nil
        }
    }
    
    private func determineFirstGameWinner(userChoice: RPSModel) {
        let computerChoice = computerPlayer.makeRandomChoice()
        
        onUpdateMessage?("유저 선택:::\(userChoice), 컴퓨터 선택:::\(computerChoice)")
        
        guard let computerNode = rpsLinkedList.node(for: computerChoice)
        else { return }
        
        if computerNode.next?.value == userChoice {
            onUpdateMessage?(GameResult.win.message)
            gameTurn = .userTurn
            onRequstSecondGame?()
        } else if computerNode.value == userChoice {
            onUpdateMessage?(GameResult.draw.message)
            onReStartGame?()
        } else {
            onUpdateMessage?(GameResult.loss.message)
            gameTurn = .computerTurn
            onRequstSecondGame?()
            
        }
    }
    
    //두번째 게임(묵찌빠)규칙 로직
    private func determineSecondGameWinner(userChoice: RPSModel)  {
        let computerChoice = computerPlayer.makeRandomChoice()
        
        if gameTurn == .userTurn && computerChoice == userChoice {
            onUpdateMessage?("사용자 승")
        } else if gameTurn == .userTurn && computerChoice != userChoice {
            onUpdateMessage?("컴퓨터 턴입니다.")
            onUpdateMessage?(TurnModel.computerTurn.message)
        } else if gameTurn == .computerTurn && computerChoice == userChoice {
            onUpdateMessage?("컴퓨터 승")
        } else {
            onUpdateMessage?("사용자 턴입니다.")
            onUpdateMessage?(TurnModel.userTurn.message)
        }
    }
}
