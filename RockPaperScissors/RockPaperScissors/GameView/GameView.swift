
import Foundation

//MARK: - GameView init & deinit
final class GameView {
    
    private let gameRules: GameRules
    
    init(gameRules: GameRules) {
        self.gameRules = gameRules
    }
    
    deinit {
        print("gameView deinit")
    }
}

//MARK: - GameView 메서드
extension GameView {
    
    func gameStart() {
        print("가위(1), 바위(2), 보(3) ! <종료: 0> : ", terminator: "")
        if let playerInput = readLine() { handleUserInsetNum(playerInput: playerInput) }
    }
    
    private func handleUserInsetNum(playerInput: String) {
        switch Int(playerInput) {
        case 0:
            print("게임 종료"); return
        case 1,2,3:
            let (result, userChoice, computerChoice) = gameRules.playGameWithUserInput(playerInput)
            displayChoices(userChoice, computerChoice)
            handleGameResult(result)
        default:
            print("잘못된 입력입니다 다시 시도해주세요")
            gameStart()
        }
    }
    
    private func displayChoices(_ userChoice: RPSModel?, _ computerChoice: RPSModel?) {
        if let userChoice = userChoice, let computerChoice = computerChoice {
            print("나의 선택: \(userChoice.rawValue)")
            print("컴퓨터의 선택: \(computerChoice.rawValue)")
        }
    }
    
    private func handleGameResult(_ result: String) {
        switch result {
        case "승리":
            print("승리하셨습니다!")
        case "패배":
            print("패배하셨습니다!")
        default:
            print("무승부하셨습니다!")
            gameStart()
        }
    }
}