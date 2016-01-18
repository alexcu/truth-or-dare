//
//  main.m
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Console.h"
#import <stdlib.h>

void welcome_message()
{
    [Console write:@"Welcome to "];
    [Console write:@"TRUTH" withColor:YELLOW];
    [Console write:@" or "];
    [Console write:@"DARE" withColor:RED];
    [Console writeLine:@"!"];
}

NSString* determine_database_file_path(const char * argv[])
{
    NSString* path;
    if (argv[1] != nil)
    {
        path = [NSString stringWithCString:argv[1] encoding: NSUTF8StringEncoding];
        if ([path length] > 0)
        {
            return path;
        }
    }
    [Console write:@"No database file provided. Checking for questions.db..." withColor:YELLOW];
    NSString* cwd = [[NSFileManager defaultManager] currentDirectoryPath];
    path = [NSString stringWithFormat:@"%@/questions.db", cwd];
    BOOL questionsDbExists = [[NSFileManager defaultManager] fileExistsAtPath: path];
    if (questionsDbExists)
    {
        return path;
    }
    [Console write:[NSString stringWithFormat:@"Can't find a questions.db file in %@.\nYou need to place a questions.db file here or provide a location to a SQLite database containing the questions when executing. E.g.:\n\n./TruthOrDare /path/to/questions.db\n\n.", cwd] withColor:RED];
    return nil;
}

NSInteger read_points_to_win()
{
    [Console write:@"Enter the number of points to win the game: "];
    NSInteger result = [Console readInteger];
    return result;
}

QuestionBank read_game_mode()
{
    char input;
    BOOL valid = NO;
    do
    {
        [Console writeLine:@"What shall the questions be like?"];
        [Console write:@"[C]" withColor:GREEN];
        [Console writeLine:@"lean"];
        [Console write:@"[N]" withColor:YELLOW];
        [Console writeLine:@"aughty"];
        [Console write:@"[D]" withColor:RED];
        [Console writeLine:@"are Devil"];
        [Console write:@"=> "];
        input = toupper([Console readChar]);
        valid = input == 'C' || input == 'N' || input == 'D';
    }
    while (!valid);
    
    switch (input) {
        case 'C': return CLEAN;
        case 'N': return NAUGHTY;
        case 'D': return DAREDEVIL;
        default : return CLEAN;
    }
}

NSArray *read_gender(Gender gender)
{
    [Console write:@"Enter how many "];
    if (gender == MALE)
        [Console write:@"males" withColor:CYAN];
    else
        [Console write:@"females" withColor:MAGENTA];
    [Console write:@" are playing: "];
    
    NSInteger noPlayers = [Console readInteger];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:noPlayers];
    
    [Console write:@""];
    
    [Console write:@"Enter the names of each "];
    if (gender == MALE)
        [Console write:@"male" withColor:CYAN];
    else
        [Console write:@"female" withColor:MAGENTA];
    [Console writeLine:@" playing: "];
    
    for (int i = 0; i < noPlayers; i++)
    {
        NSString *fmt = [NSString stringWithFormat:@" [%d/%ld] -> ", i+1, (long)noPlayers];
        [Console write:fmt withColor:gender == MALE ? CYAN : MAGENTA];
        Player *player = [[Player alloc] initWithName:[Console readString] gender:gender];
        [result addObject:player];
    }
    
    return result;
}

NSArray *read_players()
{
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:read_gender(MALE)];
    [result addObjectsFromArray:read_gender(FEMALE)];
    return result;
}

void print_scoreboard(Game *game)
{
    [Console writeLine:@"Scoreboard:"];
    
    NSArray *sortedPlayers = [game.players sortedArrayUsingComparator:^NSComparisonResult(Player *p1, Player *p2) {
        return p1.points < p2.points;
    }];
    
    for (int i = 0; i < sortedPlayers.count; i++)
    {
        Player *p = [sortedPlayers objectAtIndex:i];
        NSString *fmt = [NSString stringWithFormat:@"[#%d] %@ on %ld (%ld to go)", i + 1, p.name, p.points, game.pointsToWin - p.points];
        [Console writeLine:fmt];
    }
}

void print_question(Game *game, QuestionType type)
{
    NSString *questionStr = [game promptTruthOrDare:type];
    NSString *fmt = [NSString stringWithFormat:@"%@: %@", type == TRUTH ? @"TRUTH" : @"DARE",questionStr];
    
    [Console writeLine:fmt withColor:type == TRUTH ? YELLOW : RED];
    
    fmt = [NSString stringWithFormat:@"(Worth %ld points)", (long)game.currentQuestion.points];
    [Console writeLine:fmt];
}

QuestionType prompt_truth_or_dare(Game *game)
{
    [Console write:@"It's "];
    [Console write:[game.currentPlayer.name stringByAppendingFormat:@"'s"] withColor:game.currentPlayer.gender == MALE ? CYAN : MAGENTA];
    [Console writeLine:@" turn!"];
    
    char input;
    BOOL valid = NO;
    do
    {
        [Console write:@"[T]RUTH" withColor:YELLOW];
        [Console write:@" or "];
        [Console writeLine:@"[D]ARE" withColor:RED];
        [Console write:@"=> "];
        input = toupper([Console readChar]);
        valid = input == 'T' || input == 'D';
    }
    while (!valid);

    switch (input) {
        case 'T': return TRUTH;
        case 'D': return DARE;
        default: return TRUTH;
    }
}

BOOL resolve_skip(Game *game)
{
    [Console write:@"Did "];
    [Console write:game.currentPlayer.name withColor:game.currentPlayer.gender == MALE ? CYAN : MAGENTA];
    [Console writeLine:@" do it?"];
    
    char input;
    BOOL valid = NO;
    BOOL isDare = game.currentQuestion.type == DARE;
    do
    {
        [Console writeLine:@"[S]kip" withColor:BLUE];
        if (isDare)
        {
            [Console writeLine:@"[N]ot applicable" withColor:YELLOW];
        }
        [Console writeLine:@"[C]ontinue"  withColor:GREEN];
        [Console write:@"=> "];
        input = toupper([Console readChar]);
        valid = input == 'S' || input == 'C' || (isDare && input == 'N');
    }
    while (!valid);
    
    switch (input) {
        case 'S': return YES;
        case 'C': return NO;
        case 'N':
        {
            // Not applicable, so prompt with a truth
            print_question(game, TRUTH);
            return resolve_skip(game);
        }
        default: return NO;
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // TruthOrDare --points [points] --mode [mode] --females [females...] --males
        [Console clearConsole];
        welcome_message();
        
        NSString *dbFilePath = determine_database_file_path(argv);
        
        [[QuestionProvider defaultProvider] setDatabaseFilePath: dbFilePath];
        
        // Try and see if valid file
        NSError *error = nil;
        [[QuestionProvider defaultProvider] dataStore: &error];
        if (error != nil)
        {
            return 1;
        }
        
        NSInteger ptw = read_points_to_win();
        NSArray *players = read_players();
        QuestionBank gameType = read_game_mode();
        
        Game *g = [[Game alloc] initWithPlayers:players
                                    pointsToWin:ptw
                               typesOfQuestions:gameType];
        
        [Console clearConsole];
        
        while (!g.isGameOver)
        {
            [Console clearConsole];
            print_scoreboard(g);
            
            QuestionType type = prompt_truth_or_dare(g);
            print_question(g, type);
            
            BOOL didSkip = resolve_skip(g);

            [g resolveTruthOrDare:didSkip];
            
            [g advanceToNextPlayer];
        }
        
        [Console write:@"And the winner is "];
        [Console writeLine:[NSString stringWithFormat:@"%@ with %ld points!", g.winner.name, g.winner.points] withColor:YELLOW];
    }
    return 0;
}
