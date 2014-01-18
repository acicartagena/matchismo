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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
    
}

-(Deck*) createDeck{
    return [[SetCardDeck alloc] init];
    
}

-(NSString *) titleForCard:(Card *)card{
    //NSString *title = card.isChosen ? card.contents : @"";
    NSString *title = card.contents;
    return title;
}

-(UIImage *) backgroundImageForCard:(Card *)card{
    UIImage *temp =[UIImage imageNamed:card.isChosen ? @"matchedSetCard" : @"cardFront"];
    NSLog(@"card is chosen: %i ui image: %@",card.isChosen, temp);
    return temp;
}

@end
