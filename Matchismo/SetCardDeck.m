//
//  SetCardDeck.m
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init{
    self = [super init];
    if (self){
        for (NSNumber *symbol in [SetCard validSymbols]){
            for (NSNumber *color in [SetCard validColors]){
                for (NSNumber *shading in [SetCard validShades]){
                    for (int i=1; i<=[SetCard maxRank];i++){
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = [symbol integerValue];
                        card.color = [color integerValue];
                        card.rank = i;
                        card.shading = [shading integerValue];
                        [self addCard:card];
                    }
                }
            }
        }
        self.numberOfCardsMatchMode = 3;
    }
    return self;
}

@end
