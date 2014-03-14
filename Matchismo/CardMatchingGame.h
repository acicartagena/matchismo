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

#define MatchStatusTypeChangedNotification @"MatchStatusTypeChanged"

#define MISMATCH_PENALTY 2

typedef enum MatchStatusTypes{
    MatchStatusTypePreviouslyMatched,
    MatchStatusTypeNoCardSelected,
    MatchStatusTypeNotEnoughMoves,
    MatchStatusTypeMatchFound,
    MatchStatusTypeMatchNotFound
} MatchStatus;

@interface CardMatchingGame : NSObject

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic,readonly) NSInteger matchScore;
@property (nonatomic) NSUInteger numberOfCardsMatchMode;
@property (nonatomic,strong) NSMutableArray *chosenCards; //of Cards
@property (nonatomic) MatchStatus matchStatus;

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void) chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
//- (void)removeCard:(Card *)card;
- (NSTimeInterval)endGame;
- (BOOL) drawNewCardsWithCount:(NSInteger)newCards;
- (NSInteger)cardCount;





@end
