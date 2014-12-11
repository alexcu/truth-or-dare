//
//  Player.h
//  TruthOrDare
//
//  Created by Alex on 9/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Gender { MALE, FEMALE } Gender;

@interface Player : NSObject

@property NSString *name;
@property NSInteger points;
@property Gender gender;

- (instancetype) initWithName:(NSString*) aName gender:(Gender) aGender;

@end
