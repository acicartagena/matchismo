//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetCardView.h"

#define SET_CARD_GAME_INIT_COUNT 12

@implementation SetCardGameViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cardCount =SET_CARD_GAME_INIT_COUNT;
    self.grid.minimumNumberOfCells = self.cardCount;
    
    [self game];
    [self updateUINewGame];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setGameType:GAME_TYPE_SET];
    
}
#pragma mark - 
-(Deck*) createDeck{
    return [[SetCardDeck alloc] init];
}

- (CardMatchingGame *)createGame
{
    return [self createGameWithCardCount:self.cardCount];
}

- (CardView *)cardViewForCardAtIndex:(NSInteger)index Frame:(CGRect)frame
{
    SetCardView *cardView =[[SetCardView alloc] initWithFrame:CGRectMake(self.view.center.x - frame.size.width + index*1.0f, self.view.center.y - frame.size.height*2 + index*1.f, frame.size.width, frame.size.height)];
    return cardView;
}

- (void)updateView:(CardView *)cardView forCard:(Card *)card defaultEnable:(BOOL)defaultEnable
{
    
    SetCard* setCard = (SetCard *)card;
    SetCardView *setCardView = (SetCardView *)cardView;
    
    [setCardView setRank:setCard.rank];
    [setCardView setShade:setCard.shading];
    [setCardView setShape:setCard.symbol];
    [setCardView setColor:setCard.color];
    [setCardView setEnable:!card.isChosen];
}

@end
