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

-(instancetype) init{
    self = [super init];
    if (self){
        for (NSString *symbol in [SetCard validSymbols]){
            for (NSString *color in [SetCard validColors]){
                for (NSNumber *shading in [SetCard validShades]){
                    for (int i=0; i<[SetCard maxRank];i++){
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
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
