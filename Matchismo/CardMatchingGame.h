//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Deck.h"
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

//designated initializer
-(instancetype) initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;
-(void) chooseCardAtIndex:(NSUInteger)index;
- (Card *) cardAtIndex:(NSUInteger)index;


@property (nonatomic,readonly) NSInteger score;
@property (nonatomic) NSUInteger numberOfCardsMatchMode;



@end
