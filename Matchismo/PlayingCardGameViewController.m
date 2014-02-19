//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(Deck*) createDeck{
    
    return [[PlayingCardDeck alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.gameType = GAME_TYPE_PLAY;
}

- (void)updateView:(CardView *)cardView forCard:(Card *)card
{
    PlayingCard* playingCard = (PlayingCard *)card;
    PlayingCardView *playingCardView = (PlayingCardView *)cardView;
    
    [playingCardView setEnable:!card.isMatched];
    [playingCardView setRank:playingCard.rank];
    [playingCardView setSuit:playingCard.suit];
    [playingCardView setFaceUp:card.isChosen?YES:NO];
}

@end
