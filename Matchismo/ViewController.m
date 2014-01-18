//
//  ViewController.m
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import "ViewController.h"
#import "CardMatchingGame.h"
#import "UIAlertView+Blocks.h"

#define ALERT_OK_BUTTON @"yes"
#define ALERT_CANCEL_BUTTON @"no"

#define TWO_CARD_MATCH_MODE_INDEX 0
#define THREE_CARD_MATCH_MODE_INDEX 1

#define CHOSEN_CARD_KEY @"chosenCard"
#define MATCHED_CARDS_KEY @"matchedCards"
#define STATUS_KEY @"status"
#define SCORE_KEY @"score"


@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
//@property (nonatomic) int flipCount;
//@property (strong,nonatomic) Deck *deck;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons; //contain all UIButtons in random order

@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *cardMatchModeSegControl;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong,nonatomic) NSMutableArray *gameHistory;
@property (strong,nonatomic) NSMutableSet *indexOfMatchedCards;
//@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@property (nonatomic) BOOL browseHistory;

-(void) updateMatchStatusType;

@end

@implementation ViewController

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"vc view did appear");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMatchStatusType)
                                                 name:MatchStatusTypeChangedNotification
                                               object:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MatchStatusTypeChangedNotification
                                                  object:nil];
}

-(CardMatchingGame *)game{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[[self cardButtons] count] usingDeck:[self createDeck]];
    return _game;
}

-(Deck *)createDeck{
//    return [[PlayingCardDeck alloc] init];
    return nil;
}

-(NSMutableSet *) indexOfMatchedCards{
    if (!_indexOfMatchedCards) _indexOfMatchedCards = [[NSMutableSet alloc] init];
    return _indexOfMatchedCards;
}

-(NSMutableArray *) gameHistory{
    if (!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
}

- (IBAction)startNewGame {

    [UIAlertView showWithTitle:@"Reset Game"
                       message:@"Are you sure?"
             cancelButtonTitle:ALERT_CANCEL_BUTTON otherButtonTitles:@[ALERT_OK_BUTTON]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:ALERT_OK_BUTTON]){

                              //reset game
                              _game = nil;
                              [self updateUI];
                              
                              //enable segmented control
//                              [[self cardMatchModeSegControl] setEnabled:YES];
//                              [[self cardMatchModeSegControl] setSelectedSegmentIndex:0];
                              //reset score label
                              self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",(int)self.game.score];
                              
                              //reset game history
                              self.gameHistory = nil;
                              self.indexOfMatchedCards = nil;
                              
//                              [self.gameHistorySlider setMaximumValue:0.0f];
//                              [self.gameHistorySlider setValue:0.0f];
                              
                          }
                 
                      }];
    
}

- (IBAction)cardMatchModeUpdate:(id)sender {
    NSInteger selectedSeg = [(UISegmentedControl*)sender selectedSegmentIndex];
    switch (selectedSeg) {
        case TWO_CARD_MATCH_MODE_INDEX:
            self.game.numberOfCardsMatchMode = 2;
            break;
        case THREE_CARD_MATCH_MODE_INDEX:
            self.game.numberOfCardsMatchMode = 3;
            break;
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    
//    [[self cardMatchModeSegControl] setEnabled:NO];
    
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
    //update game history
    if (self.game.matchStatus != MatchStatusTypePreviouslyMatched){
        [self.gameHistory addObject:@{CHOSEN_CARD_KEY:@(chosenButtonIndex),MATCHED_CARDS_KEY:[self.indexOfMatchedCards copy],STATUS_KEY:self.statusLabel.text, SCORE_KEY:@(self.game.score)}];
//        [self.gameHistorySlider setMaximumValue:(float) [self.gameHistory count]-1];
    }
//    [self.gameHistorySlider setValue:[self.gameHistorySlider maximumValue]];
}

-(void) updateUI{
    NSLog(@"update ui");
    for (UIButton *cardButton in self.cardButtons){
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        NSString *title = [self titleForCard:card];
        [cardButton setTitle:title forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        //add current index to array of matched cards index
        if (card.isMatched){
            [self.indexOfMatchedCards addObject:@(cardButtonIndex)];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",(int)self.game.score];
    [self updateMatchStatusType];
}

-(NSString *) titleForCard:(Card *)card{
    NSString *title = card.isChosen ? card.contents : @"";
    return title;
}

-(UIImage *) backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

-(void) updateMatchStatusType{
    
    switch (self.game.matchStatus) {
        case MatchStatusTypePreviouslyMatched:
            break;
        case MatchStatusTypeNoCardSelected:
            self.statusLabel.text = @"";
            break;
        case MatchStatusTypeNotEnoughMoves:
            self.statusLabel.text = @"";
            for (Card *card in self.game.chosenCards){
                self.statusLabel.text = [self.statusLabel.text stringByAppendingFormat:@"%@ ",card.contents];
            }
            break;
        case MatchStatusTypeMatchFound:
            self.statusLabel.text = [self.statusLabel.text stringByAppendingFormat:@" %@ match! for %li point(s)",[self.game.currentCard contents], (long)self.game.matchScore];
            break;
        case MatchStatusTypeMatchNotFound:
            self.statusLabel.text = [self.statusLabel.text stringByAppendingFormat:@" %@ doesn't match! %i point penalty!",[self.game.currentCard contents], MISMATCH_PENALTY];
            break;
        default:
            break;
    }
}


- (IBAction)viewGameHistory:(id)sender {
    if ([self.gameHistory count] == 0){
        return;
    }
    
    int value = (int)[(UISlider*)sender value];
//    NSLog(@"chosen card:%@",self.gameHistory[value][CHOSEN_CARD_KEY]);
//    NSLog(@"status:%@",self.gameHistory[value][STATUS_KEY]);
//    NSString *x = @"matched card:";
//    for (NSNumber *y in self.gameHistory[value][MATCHED_CARDS_KEY]){
//        x=[x stringByAppendingFormat:@" %@,",y];
//    }
//    NSLog(x);
    [(UISlider*)sender setValue:(float)value];
    [self updateUIWithHistory:(NSDictionary*)self.gameHistory[value]];

    
}

-(void) updateUIWithHistory:(NSDictionary*) historyData{
    //set matched cards, reset other cards
    for (UIButton *cardButton in self.cardButtons){
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        if ([(NSArray*)historyData[MATCHED_CARDS_KEY] containsObject:@(cardButtonIndex)]){
            [cardButton setTitle:[self.game cardAtIndex:cardButtonIndex].contents forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            cardButton.enabled = NO;
        }else{
            [cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [cardButton setTitle:@"" forState:UIControlStateNormal];
            cardButton.enabled = YES;
        }
    }
    
    //set chosen cards
    UIButton *cardButton = self.cardButtons[[(NSNumber*)historyData[CHOSEN_CARD_KEY] integerValue]];
    [cardButton setTitle:[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]].contents forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
    cardButton.enabled = YES;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li",(long)[(NSNumber*)historyData[SCORE_KEY] integerValue]];
    self.statusLabel.text = historyData[STATUS_KEY];
    
}

@end
