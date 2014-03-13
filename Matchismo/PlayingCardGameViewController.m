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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    self.grid.size = self.gameCardsView.frame.size;
    self.grid.cellAspectRatio = [CardView cardViewDefaultAspectRatio];
    self.grid.minimumNumberOfCells = PLAYING_CARD_COUNT;
    
    int x = 0;
    for (int i=0; i<self.grid.rowCount; i++){
        for (int j=0; j<self.grid.columnCount; j++){
            x +=1;
            if (x> PLAYING_CARD_COUNT){
                break;
            }
            CGRect frame =[self.grid frameOfCellAtRow:i inColumn:j];
            NSLog(@"frame: x:%f y:%f width:%f height:%f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
            [self.cardViews[x-1] setFrame:frame];
        
        }
        if (x> PLAYING_CARD_COUNT){
            break;
        }
    }
}

#pragma mark - overwritten methods

- (Deck *)createDeck{
    
    return [[PlayingCardDeck alloc] init];
    
}

- (CardMatchingGame *)createGame
{
    if ([self.cardViews count]>0){
        [self.cardViews removeAllObjects];
    }
    if ([[self.gameCardsView subviews] count]>0){
        for (UIView *cardView in [self.gameCardsView subviews]){
            [cardView removeFromSuperview];
        }
    }
    
    NSLog(@"center x:%f y:%f",self.view.center.x,self.view.center.y);
    
    int x = 0;
    for (int i=0; i<self.grid.rowCount; i++){
        for (int j=0; j<self.grid.columnCount; j++){
            x +=1;
            if (x> PLAYING_CARD_COUNT){
                break;
            }
            CGRect frame =[self.grid frameOfCellAtRow:i inColumn:j];
            PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:CGRectMake(self.view.center.x - frame.size.width + x*1.0f, self.view.center.y - frame.size.height*2 + x*1.f, frame.size.width, frame.size.height)];
            cardView.delegate = self;
            [UIView animateWithDuration:0.5f delay:x*0.2f options:0 animations:^{
                cardView.frame = frame;
            } completion:^(BOOL finished) {
                [self.gameCardsView sendSubviewToBack:cardView];
            }];
    
            [self.cardViews addObject:cardView];
            if (x==1){
                [self.gameCardsView addSubview:cardView];
            }else{
                [self.gameCardsView insertSubview:cardView belowSubview:self.cardViews[x-2]];
            }

        }
        if (x> PLAYING_CARD_COUNT){
            break;
        }
    }
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
}

- (void)updateUINewGame
{
    int i=0;
    for (PlayingCardView *cardView in self.cardViews){
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:i++];
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
