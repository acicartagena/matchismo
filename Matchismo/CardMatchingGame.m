//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,readwrite) NSInteger matchScore;
@property (nonatomic,strong) NSMutableArray *cards; //of Cards


@end

@implementation CardMatchingGame

//static const int MATCH_BONUS = 4;
static const int TWOCARD_MATCH_BONUS = 4;
static const int THREECARD_MATCH_BONUS = 2;
static const int COST_TO_CHOOSE = 1;

-(NSMutableArray *) cards{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    if (self){
        for (int i = 0; i<count; i++){
            Card *card = [deck drawRandomCard];
            if (card){
                [[self cards] addObject:card];
            }else{
                self = nil;
                break;
            }
            //set the default to 2 card match mode
            self.numberOfCardsMatchMode = 2;
            self.matchStatus = MatchStatusTypeNoCardSelected;
        }
    }
    return self;
}

-(Card *) cardAtIndex:(NSUInteger)index{
    return (index<[self.cards count]) ? [self.cards objectAtIndex:index]:nil;
}

-(NSMutableArray *) chosenCards{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

-(void) chooseCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    
    //if card is matched, do nothing
    if (card.isMatched)
        return;
    
    //toggle
    if (card.isChosen){
        self.currentCard = nil;
        card.chosen = NO;
        if ([self.chosenCards containsObject:card]){
            [self.chosenCards removeObject:card];
        }
        self.matchStatus = MatchStatusTypeNoCardSelected;
        return;
    }
    self.currentCard = card;
    
    self.matchStatus = MatchStatusTypeNotEnoughMoves;
    [[NSNotificationCenter defaultCenter] postNotificationName:MatchStatusTypeChangedNotification object:nil];
    
    if ([[self chosenCards] count] < self.numberOfCardsMatchMode-1){
        card.chosen = YES;
        [[self chosenCards] addObject:card];
        self.score -= COST_TO_CHOOSE;
    }else {
        self.matchScore = [card match:self.chosenCards];
        
        //for 3 card match mode, check for the match between the 1st and 2nd cards
        if (self.numberOfCardsMatchMode == 3){
            self.matchScore += [self.chosenCards[0] match:@[self.chosenCards[1]]];
        }
        
        if (self.matchScore){
            self.matchScore *=(self.numberOfCardsMatchMode == 2 ? 4:2);
            self.score += self.matchScore ;
            for (Card *card in [self chosenCards]){
                card.matched = YES;
            }
            card.matched = YES;
            self.chosenCards = nil;
            
            self.matchStatus = MatchStatusTypeMatchFound;
        }else{
            self.score -= MISMATCH_PENALTY;
            for (Card *card in [self chosenCards]){
                card.chosen = NO;
            }
            self.chosenCards = nil;
            [self.chosenCards addObject:card];
            
            self.matchStatus = MatchStatusTypeMatchNotFound;
        }
        card.chosen = YES;
    }
    
    
}
@end
