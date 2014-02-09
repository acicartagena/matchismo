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

@interface CardMatchingGame : NSObject

//designated initializer
-(instancetype) initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;
-(void) chooseCardAtIndex:(NSUInteger)index;
- (Card *) cardAtIndex:(NSUInteger)index;
- (NSTimeInterval ) endGame;


@property (nonatomic,readonly) NSInteger score;
@property (nonatomic,readonly) NSInteger matchScore;
@property (nonatomic) NSUInteger numberOfCardsMatchMode;
@property (nonatomic,strong) NSMutableArray *chosenCards; //of Cards
@property (nonatomic,weak) Card *currentCard;

typedef enum MatchStatusTypes{
    MatchStatusTypePreviouslyMatched,
    MatchStatusTypeNoCardSelected,
    MatchStatusTypeNotEnoughMoves,
    MatchStatusTypeMatchFound,
    MatchStatusTypeMatchNotFound
} MatchStatus;
@property (nonatomic) MatchStatus matchStatus;



@end
