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
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) Deck *deck;

@end

@implementation CardMatchingGame

//static const int MATCH_BONUS = 4;
static const int TWOCARD_MATCH_BONUS = 4;
static const int THREECARD_MATCH_BONUS = 2;
static const int COST_TO_CHOOSE = 1;

- (instancetype)initWithDeck:(Deck *)deck
{
    self = [super init];
    if (self){
        self.deck = deck;
        self.numberOfCardsMatchMode = [deck numberOfCardsMatchMode];
        self.matchStatus = MatchStatusTypeNoCardSelected;
        self.startDate = [NSDate date];
    }
    return self;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? [self.cards objectAtIndex:index]:nil;
}

- (Card *)drawNewCard
{
    Card *card = [self.deck drawRandomCard];
    if (card){
        [self.cards addObject:card];
    }
    return card;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    //if card is matched, do nothing
    if (card.isMatched){
        self.matchStatus = MatchStatusTypePreviouslyMatched;
        return;
    }
    //toggle
    if (card.isChosen){
        [self toggleCard:card];
        return;
    }

    self.matchStatus = MatchStatusTypeNotEnoughMoves;
    //[[NSNotificationCenter defaultCenter] postNotificationName:MatchStatusTypeChangedNotification object:nil];
    
    //there are still not enough cards to determine a match
    if ([[self chosenCards] count] < self.numberOfCardsMatchMode-1){
        card.chosen = YES;
        [[self chosenCards] addObject:card];
        self.score -= COST_TO_CHOOSE;
    }
    else {
        //check if the existing cards in the array match the current card
        self.matchScore = [card match:self.chosenCards];
        
        if (self.matchScore){
            [self matchFoundForCard:card];
        }else{
            [self matchNotFoundForCard:card];
        }
        card.chosen = YES;
    }
}

- (void)toggleCard:(Card *)card
{
    card.chosen = NO;
    if ([self.chosenCards containsObject:card]){
        [self.chosenCards removeObject:card];
    }
    self.matchStatus = MatchStatusTypeNoCardSelected;

}

- (void)matchFoundForCard:(Card *)card
{
    self.matchScore *=(self.numberOfCardsMatchMode == 2 ? 4:2);
    self.score += self.matchScore ;
    
    //set all cards to be matched
    for (Card *card in [self chosenCards]){
        card.matched = YES;
    }
    card.matched = YES;
    
    //clean up array of chosen cards
    self.chosenCards = nil;
    self.matchStatus = MatchStatusTypeMatchFound;
    
}

- (void)matchNotFoundForCard:(Card *)card
{
    self.score -= MISMATCH_PENALTY;
    
    //set all previous/other cards to not chosen
    for (Card *card in [self chosenCards]){
        card.chosen = NO;
    }
    
    //clean up array of chosen cards
    self.chosenCards = nil;
    self.matchStatus = MatchStatusTypeMatchNotFound;
}

- (NSTimeInterval)endGame
{
    self.endDate = [NSDate date];
    NSTimeInterval temp = [self.endDate timeIntervalSinceDate:self.startDate];
    return temp;
}
@end
