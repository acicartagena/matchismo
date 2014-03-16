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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.setupNewGame){
        self.cardCount =SET_CARD_GAME_INIT_COUNT;
        self.gameType = GAME_TYPE_SET;
        [self createGameWithCardCount:self.cardCount];
    }else{
        [self layoutCardViews];
    }
}

#pragma mark - 

- (void)createGameWithCardCount:(NSInteger)cardCount
{
    [super createGameWithCardCount:cardCount];
    
    self.dealMoreCardsButton.enabled = YES;
    self.dealMoreCardsButton.hidden = NO;
}
- (Deck *)createDeck{
    return [[SetCardDeck alloc] init];
}

- (CardView *)cardViewForCardAtIndex:(NSInteger)index Frame:(CGRect)frame
{
    SetCardView *cardView =[[SetCardView alloc] initWithFrame:CGRectMake(160.0f - frame.size.width*0.5f, 600.0f - frame.size.height*0.5f, frame.size.width, frame.size.height)];
    cardView.delegate = self;
    [self.cardViews addObject:cardView];
    
    return cardView;
}

- (void)updateUIMatchDone
{
    [super updateUIMatchDone];
    
    self.waitingForAnimationFinish = YES;
    int cardsMatchCount = 0;
    
    for (CardView *cardView in self.cardViews){
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardViewIndex];
        if (card.isMatched && cardView.inPlay){
            cardsMatchCount += 1;
            cardView.inPlay = NO;
            [UIView animateWithDuration:1.5f delay:0.5f options:0 animations:^{
                cardView.frame = CGRectMake(160.0f - cardView.frame.size.width*0.5f, 600.0f - cardView.frame.size.height*0.5f, cardView.frame.size.width, cardView.frame.size.height);
            } completion:^(BOOL finished) {
                cardView.hidden = YES;
                if (cardsMatchCount == 3){
                    self.waitingForAnimationFinish = NO;
                    [self drawNewCards:3];
                }
            }];
        }
    }
    [self performSelector:@selector(updateCardsView) withObject:self afterDelay:0.5f];
}

- (void)drawNewCards:(NSInteger)numberOfCards
{
    [super drawNewCards:numberOfCards];

    if (self.cardViews.count == [SetCardDeck totalNumberOfCards]){
        self.dealMoreCardsButton.enabled = NO;
        self.dealMoreCardsButton.hidden = YES;
    }
}

- (IBAction)dealThreeMoreCards:(id)sender
{
    [self drawNewCards:3];
}

@end
