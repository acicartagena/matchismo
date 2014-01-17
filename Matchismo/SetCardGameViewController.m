//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by it_admin on 1/17/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

-(Deck*) createDeck{
    return [[SetCardDeck alloc] init];
    
}

-(NSString *) titleForCard:(Card *)card{
    //NSString *title = card.isChosen ? card.contents : @"";
    NSString *title = card.contents;
    return title;
}

@end
