//
//  Player.m
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize name;
@synthesize points;

- (instancetype) initWithName:(NSString *)aName gender:(Gender)aGender
{
    if (self = [super init])
    {
        self.name = aName;
        self.gender = aGender;
        self.points = 0;
    }
    return self;
}

@end
