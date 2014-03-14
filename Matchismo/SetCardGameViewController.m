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
- (Deck *)createDeck{
    return [[SetCardDeck alloc] init];
}

- (CardMatchingGame *)createGame
{
    return [self createGameWithCardCount:self.cardCount];;
}

- (CardView *)cardViewForCardAtIndex:(NSInteger)index Frame:(CGRect)frame
{
    //SetCardView *cardView =[[SetCardView alloc] initWithFrame:CGRectMake(self.view.center.x - frame.size.width + index*1.0f, self.view.center.y - frame.size.height*2 + index*1.f, frame.size.width, frame.size.height)];
    
    SetCardView *cardView =[[SetCardView alloc] initWithFrame:CGRectMake(160.0f - frame.size.width*0.5f, 600.0f - frame.size.height*0.5f, frame.size.width, frame.size.height)];
    return cardView;
}

- (void)updateUIMatchDone
{
    [super updateUIMatchDone];
    
    self.waitingForAnimationFinish = YES;
    
    for (CardView *cardView in self.cardViews){
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardViewIndex];
        if (card.isMatched && !cardView.isHidden){
            [UIView animateWithDuration:1.5f delay:0.5f options:0 animations:^{
                cardView.frame = CGRectMake(160.0f - cardView.frame.size.width*0.5f, 600.0f - cardView.frame.size.height*0.5f, cardView.frame.size.width, cardView.frame.size.height);
            } completion:^(BOOL finished) {
                cardView.hidden = YES;
                self.waitingForAnimationFinish = NO;
            }];
        }
    }
    [self performSelector:@selector(updateCardsView) withObject:self afterDelay:0.5f];
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
        [self updateView:cardView forCard:card defaultEnable:YES];
    }
}


@end
