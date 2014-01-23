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
#import "Card.h"

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


-(UIImage *) backgroundImageForCard:(Card *)card{
    //NSLog(@"card is chosen: %i ui image: %@",card.isChosen, temp);
    return [UIImage imageNamed:card.isChosen ? @"matchedSetCard" : @"cardFront"];
}

-(NSAttributedString *) attributedTitleForCard:(Card *)card{
    NSMutableAttributedString *temp;
    SetCard *setCard = (SetCard*)card;
    if (card.contentsDictionary){
        NSString *stringTemp = @"";
        for (int i=1;i<=setCard.rank;i++){
            stringTemp = [stringTemp stringByAppendingString:[NSString stringWithFormat:@"%@ ",setCard.symbol]];
        }
        temp = [[NSMutableAttributedString alloc] initWithString:stringTemp];
        
        if (setCard.shading == SetCardShadingOpen){
            [temp addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, stringTemp.length)];
            
            [temp addAttribute:NSStrokeWidthAttributeName value:@-4 range:NSMakeRange(0, stringTemp.length)];
            if ([setCard.color isEqualToString:RED_COLOR]){
                [temp addAttribute:NSStrokeColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, stringTemp.length)];
            }else if ([setCard.color isEqualToString:GREEN_COLOR]){
                [temp addAttribute:NSStrokeColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, stringTemp.length)];
            }else if ([setCard.color isEqualToString:PURPLE_COLOR]){
                [temp addAttribute:NSStrokeColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, stringTemp.length)];
            }
        }
        else if (setCard.shading == SetCardShadingStriped){
            NSLog(@"stripe:%@",[setCard contents]);
            if ([setCard.color isEqualToString:RED_COLOR]){
                [temp addAttribute:NSForegroundColorAttributeName value:[[UIColor redColor] colorWithAlphaComponent:0.3f] range:NSMakeRange(0, stringTemp.length)];
            }else if ([setCard.color isEqualToString:GREEN_COLOR]){
                [temp addAttribute:NSForegroundColorAttributeName value:[[UIColor greenColor] colorWithAlphaComponent:0.3f] range:NSMakeRange(0, stringTemp.length)];
            }else if ([setCard.color isEqualToString:PURPLE_COLOR]){
                [temp addAttribute:NSForegroundColorAttributeName value:[[UIColor purpleColor] colorWithAlphaComponent:0.3f] range:NSMakeRange(0, stringTemp.length)];
            }
            
        }
        else{
            
            if ([setCard.color isEqualToString:RED_COLOR]){
                [temp addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, stringTemp.length)];
            }else if ([setCard.color isEqualToString:GREEN_COLOR]){
                [temp addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, stringTemp.length)];
            }else if ([setCard.color isEqualToString:PURPLE_COLOR]){
                [temp addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, stringTemp.length)];
            }
        }
    }
    return temp;
}

-(void) updateGameHistoryWithChosenCard:(NSUInteger) chosenButtonIndex{
    NSLog(@"status label text:%@",self.statusLabel.text);
    NSLog(@"status label attributed text:%@",self.statusLabel.attributedText);
    if (self.game.matchStatus != MatchStatusTypePreviouslyMatched){
        [self.gameHistory addObject:@{CHOSEN_CARD_KEY:@(chosenButtonIndex),MATCHED_CARDS_KEY:[self.indexOfMatchedCards copy],STATUS_KEY:self.statusLabel.attributedText, SCORE_KEY:@(self.game.score)}];
        //        [self.gameHistorySlider setMaximumValue:(float) [self.gameHistory count]-1];
    }
    //    [self.gameHistorySlider setValue:[self.gameHistorySlider maximumValue]];
}


@end
