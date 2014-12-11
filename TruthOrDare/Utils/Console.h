//
//  Console.h
//  TruthOrDare
//
//  Created by Alex on 10/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>

typedef enum ConsoleColor { RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, NONE } ConsoleColor;

@interface Console : NSObject

#pragma mark - Write

+ (void) write:(NSString*) string;
+ (void) write:(NSString*) string withColor:(ConsoleColor) color;
+ (void) writeLine:(NSString*) string;
+ (void) writeLine:(NSString*) string withColor:(ConsoleColor) color;

#pragma mark - Read

+ (NSString *) readString;
+ (NSInteger) readInteger;
+ (char) readChar;

#pragma mark - Utils

+ (void) setColor:(ConsoleColor) color;
+ (void) resetColor;
+ (void) clearConsole;

@end
