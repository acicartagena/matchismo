//
//  ViewController.h
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "Grid.h"

#define ALERT_OK_BUTTON @"ok"
#define ALERT_CANCEL_BUTTON @"nope"

#define TWO_CARD_MATCH_MODE_INDEX 0
#define THREE_CARD_MATCH_MODE_INDEX 1

#define CHOSEN_CARD_KEY @"chosenCard"
#define MATCHED_CARDS_KEY @"matchedCards"
#define STATUS_KEY @"status"
#define SCORE_KEY @"score"

#define GAME_TYPE_PLAY @"play"
#define GAME_TYPE_SET @"set"

#define SAVE_KEY_NAME @"name"
#define SAVE_KEY_SCORE @"score"
#define SAVE_KEY_GAME_TYPE @"game"
#define SAVE_KEY_TIME @"time"

#define SAVE_KEY @"scoreData"

@interface ViewController : UIViewController <CardViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *gameCardsView;

@property (strong, nonatomic) NSString *gameType;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) Card *activeCard;

@property (nonatomic) BOOL waitingForAnimationFinish;
@property (nonatomic) NSInteger cardCount;


- (Deck *)createDeck;
- (CardMatchingGame *)createGame;
- (CardMatchingGame *)createGameWithCardCount:(NSInteger)cardCount;
- (void)drawNewCards:(NSInteger)numberOfCards;
- (void)layoutCardViews;
- (void)updateUINewGame;
- (void)updateUIMatchDone;
- (void)updateCardsView;
- (void)updateView:(CardView *)cardView forCard:(Card *)card defaultEnable:(BOOL)defaultEnable;
- (CardView *)cardViewForCardAtIndex:(NSInteger)index Frame:(CGRect)frame;


@end
