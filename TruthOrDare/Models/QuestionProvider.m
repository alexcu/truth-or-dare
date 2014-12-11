//
//  QuestionProvider.m
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import "QuestionProvider.h"

@interface QuestionProvider ()

+ (FMDatabase *) getDataStore;
- (NSString *) tableNameForBank:(QuestionBank) qnBank;

@end

@implementation QuestionProvider

+ (FMDatabase *) getDataStore
{
    NSString *dbPath   = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"db"];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
        return nil;
    return db;
}

+ (QuestionProvider *) defaultProvider
{
    static QuestionProvider *provider;
    if (!provider)
        provider = [[QuestionProvider alloc] init];
    return provider;
}

#pragma mark - Instance methods

@synthesize playerCount;
@synthesize bank;

- (NSString*) tableNameForBank:(QuestionBank)qnBank
{
    switch (qnBank) {
        case DAREDEVIL:
            return @"DareDevilQuestions";
        case NAUGHTY:
            return @"NaughtyQuestions";
        case CLEAN:
            return @"CleanQuestions";
    }
}

- (Question*) randomQuestion:(QuestionType) type
{
    // SQL for random question in bank
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE TYPE = :type ORDER BY RANDOM() LIMIT 1", [self tableNameForBank:self.bank]];
    FMDatabase *db = [QuestionProvider getDataStore];
    if (!db)
    {
        NSLog(@"Error!");
        return nil;
    }
    
    FMResultSet *resultSet = [db executeQuery:sql withParameterDictionary:@{ @"type" : type == DARE ? @"dare" : @"truth" }];
    
    // Find the question
    while ([resultSet next])
    {
        Question *qn = [[Question alloc] init];
        qn.rawQuestion = [resultSet stringForColumn:@"QUESTION"];
        qn.minPeople   = [resultSet intForColumn:@"MIN_PEOPLE"];
        qn.points      = [resultSet intForColumn:@"POINTS"];
        qn.type        = type;
        
        // Return this question
        [db close];
        return qn;
    }
    
    [db close];
    return nil;
}

@end
