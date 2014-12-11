//
//  QuestionProvider.h
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import <FMDB.h>

typedef enum QuestionBank { CLEAN, NAUGHTY, DAREDEVIL } QuestionBank;

@interface QuestionProvider : NSObject

@property NSInteger     playerCount;
@property QuestionBank  bank;

/**
 * Gets a question from the given question bank
 */
- (Question*) randomQuestion:(QuestionType) type;

/**
 * Gets the default question provider
 */
+ (QuestionProvider *) defaultProvider;

@end
