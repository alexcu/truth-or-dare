//
//  Question.h
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "NSMutableArray+Shuffling.h"

typedef enum QuestionType { TRUTH, DARE } QuestionType;

@interface Question : NSObject

@property NSString*     rawQuestion;
@property NSInteger     minPeople;
@property NSInteger     points;
@property QuestionType  type;
@property (readonly, getter=isFormat) BOOL  format;

@end
