//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    public var gameMode:GameMode = .vsPlayer
    private var nextStateMode:(()->Void)!
    
    private var countOfSteps = 0
    
    private var gameboard = Gameboard()
    
    private var currentState: GameState! {
        didSet
        { self.currentState.begin()}
    }
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        if gameMode == .vsPlayer {
            nextStateMode = {
                if let playerInputState = self.currentState as? PlayerInputState {
                    let player = playerInputState.player.next
                    self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype,gameViewController: self, gameboard: self.gameboard, gameboardView: self.gameboardView)
                }
            }
        } else {
            nextStateMode = {
                if let playerInputState = self.currentState as? PlayerInputState {
                    let player = playerInputState.player.next
                    self.currentState = ComputerInputState(player: player, markViewPrototype: player.markViewPrototype,gameViewController: self, gameboard: self.gameboard, gameboardView: self.gameboardView)
                    guard let position = self.gameboard.getFirstFreePosition() else {
                        self.currentState = GameEndedState(winner: nil, gameViewController: self)
                        return
                    }
                    (self.gameboardView.onSelectPosition ?? {_ in})(position)
                    
                } else if let computerInputState = self.currentState as? ComputerInputState {
                    let player = computerInputState.player.next
                    self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype,gameViewController: self, gameboard: self.gameboard, gameboardView: self.gameboardView)
                }
            }
            
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                self.countOfSteps+=1
                self.currentState.addMark(at: position)
                
                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            }
        }
    }
        
    private func goToFirstState() {
        let player = Player.first
        self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if countOfSteps == 9 {
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }
        
        nextStateMode()
        
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restartGame)
        countOfSteps = 0
        gameboardView.clear()
        gameboard.clear()
        self.goToFirstState()
    }
}

