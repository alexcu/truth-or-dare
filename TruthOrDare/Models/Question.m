//
//  Question.m
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import "Question.h"

@interface Question ()

- (NSInteger) playerReferenceCount;

@end

@implementation Question

@synthesize rawQuestion;
@synthesize minPeople;
@synthesize points;
@synthesize type;

- (NSInteger) playerReferenceCount
{
    return [self.rawQuestion componentsSeparatedByString:@"%"].count - 1;
}

- (BOOL) isFormat
{
    return [self playerReferenceCount] > 0;
}

@end
