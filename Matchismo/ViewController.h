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

#define ALERT_OK_BUTTON @"yes"
#define ALERT_CANCEL_BUTTON @"no"

#define TWO_CARD_MATCH_MODE_INDEX 0
#define THREE_CARD_MATCH_MODE_INDEX 1

#define CHOSEN_CARD_KEY @"chosenCard"
#define MATCHED_CARDS_KEY @"matchedCards"
#define STATUS_KEY @"status"
#define SCORE_KEY @"score"

@interface ViewController : UIViewController

@property (strong,readonly,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

-(Deck *)createDeck;//abstract method for subclassing
-(void) updateUI;


@end
