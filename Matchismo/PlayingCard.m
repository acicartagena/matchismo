//
//  PlayingCard.m
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard ()
+(NSArray *)rankStrings;
@end

@implementation PlayingCard

@synthesize suit = _suit;//synthesize when both setter & getter are provided

-(NSString *)contents{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

-(int)match:(NSArray *)otherCards{
    int score = 0;
    if ([otherCards count] ==1){
        PlayingCard *otherCard = [otherCards firstObject];//same as [NSArray objectAtIndex:0] return nil if array is empty
        if (otherCard.rank == self.rank){
            score = 4;
        }else if ([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        }
        
    }
    return score;
}


-(NSString *) suit{
    return _suit ? _suit:@"?";
}

-(void)setSuit:(NSString*)suit{
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

-(void)setRank:(NSUInteger)rank{
    if (rank<= [PlayingCard maxRank]){
        _rank = rank;
    }
}

+(NSArray *)validSuits{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+(NSArray *)rankStrings{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank{
    return [[self rankStrings] count] -1;
}

@end
