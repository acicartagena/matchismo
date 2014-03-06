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

#define PLAYING_CARD_COUNT 24

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController


#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.grid.size = self.gameCardsView.frame.size;
    self.grid.cellAspectRatio = [CardView cardViewDefaultAspectRatio];
    self.grid.minimumNumberOfCells = PLAYING_CARD_COUNT;
    
    [self game];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.gameType = GAME_TYPE_PLAY;
}

#pragma mark - overwritten methods

- (Deck *)createDeck{
    
    return [[PlayingCardDeck alloc] init];
    
}

- (CardMatchingGame *)createGame
{
    for (int i=0; i<self.grid.rowCount; i++){
        for (int j=0; j<self.grid.columnCount; j++){
            CGRect frame =[self.grid frameOfCellAtRow:i inColumn:j];
            NSLog(@"frame: x:%f y:%f width:%f height:%f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
            PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:frame];
            cardView.delegate = self;
            [self.cardViews addObject:cardView];
            [self.gameCardsView addSubview:cardView];
        }
    }
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
}

- (void)updateUINewGame
{
    int i=0;
    for (PlayingCardView *cardView in self.cardViews){
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:i];
        [self updateView:cardView forCard:card defaultEnable:NO];
    }
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
