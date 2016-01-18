//
//  QuestionProvider.m
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import "QuestionProvider.h"

@interface QuestionProvider ()

- (NSString *) tableNameForBank:(QuestionBank) qnBank;

@end

@implementation QuestionProvider

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
@synthesize databaseFilePath;

- (FMDatabase *) dataStore:(NSError **) error
{
    BOOL fileExists    = [[NSFileManager defaultManager] fileExistsAtPath: databaseFilePath];
    if (!fileExists)
    {
        *error = [NSError errorWithDomain:@"truth-or-dare"
                                     code:0
                                 userInfo:@{@"message": @"No such file exists for database file"}];
        return nil;
    }
    FMDatabase *db     = [FMDatabase databaseWithPath: databaseFilePath];
    if (![db open] || [[db lastError] code] != 0)
    {
        *error = [NSError errorWithDomain:@"truth-or-dare"
                                     code:0
                                 userInfo:@{@"message": [db lastErrorMessage]}];
        nil;
        ;
    }
    return db;
}

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
    NSError *error = nil;
    FMDatabase *db = [self dataStore: &error];
    if (error != nil)
    {
        [NSException raise:@"bad-database-error" format:@"Error: %@", error.userInfo[@"message"]];
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
