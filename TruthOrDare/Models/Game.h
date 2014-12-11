//
//  Game.h
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionProvider.h"
#import "Player.h"

@interface Game : NSObject
{
    QuestionProvider *_questionProvider;
    Question *_currentQuestion;
    NSInteger _currentPlayerIdx;
}

@property NSArray *players;
@property Player *currentPlayer;
@property Question *currentQuestion;
@property NSInteger pointsToWin;
@property (readonly, getter=isGameOver) BOOL gameOver;
@property (readonly) Player *winner;

- (instancetype) initWithPlayers:(NSArray *)aPlayers
                     pointsToWin:(NSInteger)aPointsToWin
                typesOfQuestions:(QuestionBank) types;

/**
 * Advances the game to the next player
 */
- (void) advanceToNextPlayer;

/**
 * Prompts the player with a truth or dare
 * @param   type    Truth or dare was selected
 * @return  The question string that needs to be answered
 */
- (NSString*) promptTruthOrDare:(QuestionType) type;

/**
 * Finalises the result to the current question
 * @param   didSkip Whether or not the player skipped the question
 */
- (void) resolveTruthOrDare:(BOOL)didSkip;

@end
