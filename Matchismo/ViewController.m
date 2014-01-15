//
//  ViewController.m
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
//@property (nonatomic) int flipCount;
//@property (strong,nonatomic) Deck *deck;
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons; //contain all UIButtons in random order
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ViewController

//-(Deck *) deck{
//    //if (!_deck) _deck = [[PlayingCardDeck alloc] init];
//    if (!_deck) _deck = [self createDeck];
//    return _deck;
//}

-(CardMatchingGame *)game{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[[self cardButtons] count] usingDeck:[self createDeck]];
    return _game;
}

-(Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {

//    if ([[sender currentTitle] length]){
//        [sender setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
//        [sender setTitle:@"" forState:UIControlStateNormal];
//    }else{
//        Card *randomCard = [[self deck] drawRandomCard];
//        if (randomCard){
//            [sender setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
//            [sender setTitle:[randomCard contents] forState:UIControlStateNormal];
//        }
//    }
//    self.flipCount ++;
    
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [sender setTitle:[[self.game cardAtIndex:chosenButtonIndex] contents] forState:UIControlStateNormal];
    [self updateUI];
    
}

-(void) updateUI{
    for (UIButton *cardButton in self.cardButtons){
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        NSString *title = [self titleForCard:card];
        [cardButton setTitle:title forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    
}

-(NSString *) titleForCard:(Card *)card{
    NSString *title = card.isChosen ? card.contents : @"";
    return title;
}

-(UIImage *) backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

//-(void)setFlipCount:(int)flipCount{
//    _flipCount = flipCount;
//    [[self flipsLabel] setText:[NSString stringWithFormat:@"Flips:%i",_flipCount]];
//}



@end
