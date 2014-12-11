//
//  Console.m
//  TruthOrDare
//
//  Created by Alex on 10/12/2014.
//  Copyright (c) 2014 Alex Cummaudo. All rights reserved.
//

#import "Console.h"

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

@interface Console ()
+ (char*) getColorString:(ConsoleColor) color;
@end

static ConsoleColor _CurrentColor;

@implementation Console

+ (void) initialize
{
    [self resetColor];
}

#pragma mark - Write

+ (void) write:(NSString*) string
{
    printf("%s%s", [self getColorString:_CurrentColor], [string UTF8String]);
}
+ (void) writeLine:(NSString*) string
{
    [self write:[string stringByAppendingString:@"\n"]];
}
+ (void) write:(NSString *)string withColor:(ConsoleColor)color
{
    [self setColor:color];
    [self write:string];
    [self resetColor];
}
+ (void) writeLine:(NSString *)string withColor:(ConsoleColor)color
{
    [self write:[string stringByAppendingString:@"\n"] withColor:color];
}

#pragma mark - Read

+ (NSString *) readString
{
    char buff[255];
    scanf(" %255[^\n]", buff);
    return [NSString stringWithUTF8String:buff];
}
+ (NSInteger) readInteger
{
    int result;
    char temp;
    const char* input;
   	do
    {
        input = [[self readString] UTF8String];
    }
    while ( sscanf(input, " %d %c", &result, &temp) != 1 );
    return result;
}
+ (char) readChar
{
    return [[self readString] characterAtIndex:0];
}

#pragma mark - Utils

+ (char*) getColorString:(ConsoleColor) color
{
    switch (color) {
        case RED: return KRED;
        case GREEN: return KGRN;
        case YELLOW: return KYEL;
        case BLUE: return KBLU;
        case MAGENTA: return KMAG;
        case CYAN: return KCYN;
        case WHITE: return KWHT;
        case NONE: return KNRM;
    }
}
+ (void) setColor:(ConsoleColor) color
{
    _CurrentColor = color;
}
+ (void) resetColor
{
    _CurrentColor = NONE;
}
+ (void) clearConsole
{
    system("clear");
}

@end
