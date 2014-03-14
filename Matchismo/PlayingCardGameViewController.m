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
    self.grid.minimumNumberOfCells = self.cardCount;
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
//    PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:CGRectMake(self.view.center.x - frame.size.width + index*1.0f, self.view.center.y - frame.size.height*2 + index*1.f, frame.size.width, frame.size.height)];
    PlayingCardView *cardView =[[PlayingCardView alloc] initWithFrame:CGRectMake(160.0f - frame.size.width*0.5f, 600.0f - frame.size.height*0.5f, frame.size.width, frame.size.height)];
    
    return cardView;
}

- (void)updateUIMatchDone
{
    [super updateUIMatchDone];
    
    self.waitingForAnimationFinish = YES;
    [self performSelector:@selector(updateCardsView) withObject:self afterDelay:1.0f];
}

- (void)updateCardsView
{
    self.waitingForAnimationFinish = NO;
    
    for (CardView *cardView in self.cardViews){
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        if (card == self.activeCard && !card.isMatched){
            self.activeCard.chosen = NO;
        }
        [self updateView:cardView forCard:card defaultEnable:NO];
    }
    self.activeCard = nil;
}

@end
