//
//  Game.m
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize players;
@synthesize pointsToWin;
@synthesize currentPlayer;
@synthesize currentQuestion;

- (Player*) winner
{
    for (Player *p in players)
        if (p.points >= self.pointsToWin)
            return p;
    return nil;
}

- (BOOL) isGameOver
{
    return [self winner] != nil;
}

- (instancetype) initWithPlayers:(NSArray *)aPlayers pointsToWin:(NSInteger)aPointsToWin typesOfQuestions:(QuestionBank)types
{
    if (self = [super init])
    {
        self.players = aPlayers;
        self.pointsToWin = aPointsToWin;
        _currentPlayerIdx = 0;
        _questionProvider = [QuestionProvider defaultProvider];
        _questionProvider.bank = types;
        _questionProvider.playerCount = self.players.count;
        [self advanceToNextPlayer];
    }
    return self;
}

- (void) advanceToNextPlayer
{
    _currentPlayerIdx = _currentPlayerIdx + 1 > self.players.count - 1 ? 0 : _currentPlayerIdx + 1;
    self.currentPlayer = [self.players objectAtIndex:_currentPlayerIdx];
}

- (NSString *) promptTruthOrDare:(QuestionType)type
{
    self.currentQuestion = [_questionProvider randomQuestion:type];
    
    // We need to format the question if it needs it
    if (!self.currentQuestion.isFormat)
        return self.currentQuestion.rawQuestion;
    
    NSMutableArray *playersRnd = [NSMutableArray arrayWithArray:self.players];
    [playersRnd shuffle];
        
    NSMutableString *result = [NSMutableString stringWithString:self.currentQuestion.rawQuestion];
    
    // Get this player
    NSInteger playerIdx = 0;
    for (int i = 0; i < result.length; i++)
    {
        if ([result characterAtIndex:i] == '%')
        {
            char modifier = toupper([result characterAtIndex:i+1]);
            BOOL requiresFemaleName = modifier == 'F';
            BOOL requiresMaleName   = modifier == 'M';
            BOOL requiresOtherName  = modifier == 'O' || modifier == 'R' || modifier == 'S';
            
            // If requires random name is YES, then conditions are satisified
            BOOL conditionsSatisifed;
            
            Player *playerToUse;
            
            do
            {
                // Update playerIdx for next time
                playerIdx = playerIdx + 1 > playersRnd.count - 1 ? 0 : playerIdx + 1;
                
                playerToUse = [playersRnd objectAtIndex:playerIdx];
                
                // Condition checks
                conditionsSatisifed =
                    ((requiresFemaleName && playerToUse.gender == FEMALE && playerToUse != self.currentPlayer) ||
                     (requiresMaleName   && playerToUse.gender == MALE   && playerToUse != self.currentPlayer) ||
                     (requiresOtherName  && playerToUse != self.currentPlayer));
                
            }
            while (!conditionsSatisifed);
            
            // 2 for % and {o, r, m, f}
            [result replaceCharactersInRange:NSMakeRange(i, 2)
                                  withString:playerToUse.name];
        }
    }
        
    return result;
}

- (void) resolveTruthOrDare:(BOOL)didSkip
{
    if (didSkip)
        return;
    self.currentPlayer.points += self.currentQuestion.points;
}

@end
