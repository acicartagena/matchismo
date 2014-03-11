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
 //   if (fromInterfaceOrientation == UIInterfaceOrientationPortrait){
    
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
   // }
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
    
    int x = 0;
    for (int i=0; i<self.grid.rowCount; i++){
        for (int j=0; j<self.grid.columnCount; j++){
            x +=1;
            if (x> PLAYING_CARD_COUNT){
                break;
            }
            CGRect frame =[self.grid frameOfCellAtRow:i inColumn:j];
            //NSLog(@"frame: x:%f y:%f width:%f height:%f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
            PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:frame];
            cardView.delegate = self;
            [self.cardViews addObject:cardView];
            [self.gameCardsView addSubview:cardView];
        }
        if (x> PLAYING_CARD_COUNT){
            break;
        }
    }
    CardMatchingGame *temp =  [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
    return temp;
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
