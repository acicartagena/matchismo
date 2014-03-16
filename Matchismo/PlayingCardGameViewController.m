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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.setupNewGame){
        self.cardCount =PLAYING_CARD_COUNT;
        self.gameType = GAME_TYPE_PLAY;
        [self createGameWithCardCount:self.cardCount];
    }else{
        [self layoutCardViews];
    }
}

#pragma mark - overwritten methods
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (CardView *)cardViewForCardAtIndex:(NSInteger)index Frame:(CGRect)frame
{
    PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:CGRectMake(160.0f - frame.size.width*0.5f, 600.0f - frame.size.height*0.5f, frame.size.width, frame.size.height)];
    cardView.delegate = self;
    [self.cardViews addObject:cardView];
    
    return cardView;
}

- (void)updateUIMatchDone
{
    [super updateUIMatchDone];
    
    self.waitingForAnimationFinish = YES;
    [self performSelector:@selector(updateCardsView) withObject:self afterDelay:1.0f];
}



@end
