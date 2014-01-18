//
//  Deck.h
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

@property (nonatomic) NSUInteger numberOfCardsMatchMode;

-(void)addCard:(Card *)card atTop:(BOOL) atTop;
-(void)addCard:(Card *)card;
-(Card*)drawRandomCard;



@end
