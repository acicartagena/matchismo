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

#define PLAYING_CARD_COUNT 30

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cardCount = PLAYING_CARD_COUNT;
    self.grid.minimumNumberOfCells = PLAYING_CARD_COUNT;
    [self game];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.gameType = GAME_TYPE_PLAY;
}

#pragma mark - overwritten methods
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createGame
{
    return [self createGameWithCardCount:self.cardCount];
}

- (CardView *)cardViewForCardAtIndex:(NSInteger)index Frame:(CGRect)frame
{
    PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:CGRectMake(self.view.center.x - frame.size.width + index*1.0f, self.view.center.y - frame.size.height*2 + index*1.f, frame.size.width, frame.size.height)];
    return cardView;
}

- (void)updateView:(CardView *)cardView forCard:(Card *)card defaultEnable:(BOOL)defaultEnable
{

    PlayingCard* playingCard = (PlayingCard *)card;
    PlayingCardView *playingCardView = (PlayingCardView *)cardView;

    [playingCardView setRank:playingCard.rank];
    [playingCardView setSuit:playingCard.suit];
    [playingCardView setFaceUp:card.isChosen?YES:NO];
    [playingCardView setEnable:defaultEnable ? YES:!card.isMatched];
}

@end
