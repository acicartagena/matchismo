//
//  Deck.m
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import "Deck.h"

@interface Deck ()

@property (strong,nonatomic)NSMutableArray *cards; //private property

@end

@implementation Deck

-(NSMutableArray*)cards{
    if (!_cards) _cards = [[NSMutableArray alloc] init];//lazy initialization
    return _cards;

}

-(void)addCard:(Card *)card atTop:(BOOL)atTop{
    if (atTop){
        [self.cards insertObject:card atIndex:0];
    }else{
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card{
    [self addCard:card atTop:NO];
}

-(Card*) drawRandomCard{
    Card *randomCard = nil;
    
    //make sure array is not empty before calling object at index (index out of bounds)
    if ([self.cards count]){
        unsigned index = arc4random()%[self.cards count];
        randomCard = [self.cards objectAtIndex:index];
        [self.cards removeObject:randomCard];
    }
    
    return randomCard;
}
@end
