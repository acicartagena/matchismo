//
//  ViewController.m
//  Matchismo
//
//  Created by it_admin on 1/15/14.
//  Copyright (c) 2014 hello. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertView+Blocks.h"
#import "HistoryViewController.h"

#import "PlayingCardView.h"
#import "PlayingCard.h"



@interface ViewController ()

@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;//contain all UIButtons in random order
@property (strong, nonatomic) NSMutableArray *activeCardViews;

@property (strong, readwrite, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *cardMatchModeSegControl;



@property (strong, readwrite, nonatomic) NSMutableArray *gameHistory;
@property (strong, readwrite, nonatomic) NSMutableSet *indexOfMatchedCards;
//@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@property (nonatomic) BOOL browseHistory;

@property (nonatomic, getter = isGameEnded) BOOL gameEnded;
@property (nonatomic, getter = isGameAlreadySaved) BOOL gameAlreadySaved;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic) NSTimeInterval gameTime;

-(void) updateMatchStatusType;

@end

@implementation ViewController

#pragma mark - lifecyle

-(void) viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    //set delegate
    for (CardView *cardView in self.cardViews){
        cardView.delegate = self;
    }
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

#pragma mark - lazy loading

- (CardMatchingGame *)game
{
    if (!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:[[self cardViews] count] usingDeck:[self createDeck]];
    }
    return _game;
}

- (NSMutableSet *)indexOfMatchedCards
{
    if (!_indexOfMatchedCards){
        _indexOfMatchedCards = [[NSMutableSet alloc] init];
    }
    return _indexOfMatchedCards;
}

- (NSMutableArray *)gameHistory
{
    if (!_gameHistory){
        _gameHistory = [[NSMutableArray alloc] init];
    }
    return _gameHistory;
}

- (NSMutableArray *)activeCardViews
{
    if (!_activeCardViews){
        _activeCardViews = [[NSMutableArray alloc] init];
    }
    return _activeCardViews;
}

#pragma mark - Game Control

-(Deck *)createDeck{
//    return [[PlayingCardDeck alloc] init];
    return nil;
}

- (IBAction)startNewGame {
    
    void (^tapBlock)(UIAlertView *alertView, NSInteger buttonIndex)=^void(UIAlertView *alertView, NSInteger buttonIndex){
        
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:ALERT_OK_BUTTON]){
        
            //end timer and save game details
            if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput){
                self.gameName = [[alertView textFieldAtIndex:0] text];
            }
            [self saveGameStatistics];
            
            //reset game
            _game = nil;
            
            //start new game
            [self updateUI];
            [self setGameAlreadySaved:NO];
            [self setGameEnded:NO];
            
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
    };
    
    NSString *title = @"New Game";
    NSString *message = @"this will start a NEW game?";
    NSString *placholder = @"enter your name.";
    
    if (self.isGameAlreadySaved){
        [UIAlertView showWithTitle:title
                           message:message
                 cancelButtonTitle:ALERT_CANCEL_BUTTON
                 otherButtonTitles:@[ALERT_OK_BUTTON]
                          tapBlock:tapBlock];
    }else{
        [UIAlertView showWithTitle:title
                           message:message
              textFieldPlaceholder:placholder
                 cancelButtonTitle:ALERT_CANCEL_BUTTON
                 otherButtonTitles:@[ALERT_OK_BUTTON]
                          tapBlock:tapBlock];
    }
}

- (IBAction)endCurrentGame:(id)sender {
    
    [UIAlertView showWithTitle:@"End Game"
                       message:@"This will end your current game?"
          textFieldPlaceholder:@"Enter your name."
             cancelButtonTitle:ALERT_CANCEL_BUTTON otherButtonTitles:@[ALERT_OK_BUTTON]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:ALERT_OK_BUTTON]){
                              
                              self.gameName = [[alertView textFieldAtIndex:0] text];
                              [self saveGameStatistics];
                              [self setGameEnded:YES];
                              
                          }
                          
                      }];
}

- (void)saveGameStatistics{
    
    if (self.isGameAlreadySaved){
        return;
    }
    [self setGameAlreadySaved:YES];
    self.gameTime = [self.game endGame];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data = [[defaults objectForKey:SAVE_KEY] mutableCopy];
    NSDictionary *gameData = @{SAVE_KEY_NAME:self.gameName,
                               SAVE_KEY_SCORE:[NSNumber numberWithInt:self.game.score],
                               SAVE_KEY_GAME_TYPE:self.gameType,
                               SAVE_KEY_TIME:[NSNumber numberWithInt:self.gameTime]};
    
    if (data == nil){
        data = [[NSMutableArray alloc] initWithArray:@[gameData]];
    }else{
        [data addObject:gameData];
    }
    
    [defaults setObject:data forKey:SAVE_KEY];
    
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

#pragma mark - Game UI
- (void)cardSelected:(id)sender{
    
    if (self.isGameEnded)
        return;
    //add view to active cardviews
    [self.activeCardViews addObject:sender];
    
    NSUInteger chosenButtonIndex = [self.cardViews indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateView:(CardView *)sender forCard:(Card*)[self.game cardAtIndex:chosenButtonIndex]];
    
    
    
    switch (self.game.matchStatus) {
        case MatchStatusTypeMatchFound:
        case MatchStatusTypeMatchNotFound:
        case MatchStatusTypePreviouslyMatched:
            [self updateUI];
            [self.activeCardViews removeAllObjects];
            break;
            
        default:
            break;
    }
    //update game history
//    [self updateGameHistoryWithChosenCard:chosenButtonIndex];

}

-(void) updateGameHistoryWithChosenCard:(NSUInteger) chosenButtonIndex{
    NSLog(@"status label text:%@",self.statusLabel.text);
    NSLog(@"status label attributed text:%@",self.statusLabel.attributedText);
    if (self.game.matchStatus != MatchStatusTypePreviouslyMatched){
        [self.gameHistory addObject:@{CHOSEN_CARD_KEY:@(chosenButtonIndex),MATCHED_CARDS_KEY:[self.indexOfMatchedCards copy],STATUS_KEY:self.statusLabel.text?self.statusLabel.text:self.statusLabel.attributedText, SCORE_KEY:@(self.game.score)}];
    }
}


- (void)updateUI{
//    //NSLog(@"update ui");
//    for (CardView *cardView in self.activeCardViews){
//        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
//        Card *card = [self.game cardAtIndex:cardViewIndex];
//        NSString *title = [self titleForCard:card];
//        
//        [self updateView:cardView forCard:card];
//        
//        //add current index to array of matched cards index
//        if (card.isMatched){
//            [self.indexOfMatchedCards addObject:@(cardViewIndex)];
//        }
//    }
    
    [self performSelector:@selector(updateCardsView) withObject:self afterDelay:1.5f];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",(int)self.game.score];
    [self updateMatchStatusType];
}

- (void)updateCardsView
{
    for (CardView *cardView in self.cardViews){
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        
        [self updateView:cardView forCard:card];
        
    }
}

- (void)updateView:(CardView *)cardView forCard:(Card *)card
{
    //implement in cardGameController sub class
    return;
}

- (NSAttributedString *)attributedTitleForCard:(Card *)card{
    return nil;
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
            
        case MatchStatusTypeNoCardSelected:{
            self.statusLabel.text = @"";
            self.statusLabel.attributedText = [[NSAttributedString alloc] init];
            break;
        }
            
        case MatchStatusTypeNotEnoughMoves:{
            self.statusLabel.text = @"";
            for (Card *card in self.game.chosenCards){
                if (card.contents){
                    self.statusLabel.text = [self.statusLabel.text stringByAppendingFormat:@" %@, ",card.contents];
                }
                if (card.contentsDictionary){
                    NSMutableAttributedString *mutableAttrString = [self.statusLabel.attributedText mutableCopy];
                    [mutableAttrString appendAttributedString:[self attributedTitleForCard:card]];
                    [mutableAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                    self.statusLabel.attributedText = mutableAttrString;
                }
            }
            break;
        }
            
        case MatchStatusTypeMatchFound:{
            if (self.game.currentCard.contents){
                self.statusLabel.text = [self.statusLabel.text
                                     stringByAppendingFormat:@" %@ match! for %li point(s)",[self.game.currentCard contents], (long)self.game.matchScore];
            }
            if (self.game.currentCard.contentsDictionary){
                 NSMutableAttributedString *mutableAttrString = [self.statusLabel.attributedText mutableCopy];
                [mutableAttrString appendAttributedString:[self attributedTitleForCard:self.game.currentCard]];
                [mutableAttrString appendAttributedString:[[NSAttributedString alloc]
                                                           initWithString:[NSString stringWithFormat:@" match! for %li point(s)",(long)self.game.matchScore]]];
                self.statusLabel.attributedText = mutableAttrString;
            }
            break;
        }
            
        case MatchStatusTypeMatchNotFound:{
            if (self.game.currentCard.contents){
                self.statusLabel.text = [self.statusLabel.text stringByAppendingFormat:@" %@ doesn't match! %i point penalty!",
                                     [self.game.currentCard contents], MISMATCH_PENALTY];
            }
            
            if (self.game.currentCard.contentsDictionary){
                NSMutableAttributedString *mutableAttrString = [self.statusLabel.attributedText mutableCopy];
                [mutableAttrString appendAttributedString:[self attributedTitleForCard:self.game.currentCard]];
                [mutableAttrString appendAttributedString:[[NSAttributedString alloc]
                                                           initWithString:[NSString stringWithFormat:@" doesn't match! %i point penalty!",MISMATCH_PENALTY]]];
                self.statusLabel.attributedText = mutableAttrString;
            }
            break;
        }
            
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
    for (CardView *cardView in self.cardViews){
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
        
        if ([(NSArray*)historyData[MATCHED_CARDS_KEY] containsObject:@(cardViewIndex)]){
//            [cardButton setTitle:[self.game cardAtIndex:cardButtonIndex].contents forState:UIControlStateNormal];
//            [cardButton setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
//            cardButton.enabled = NO;
        }
        else{
//            [cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
//            [cardButton setTitle:@"" forState:UIControlStateNormal];
//            cardButton.enabled = YES;
        }
    }
    
    //set chosen cards
    CardView *cardView = self.cardViews[[(NSNumber*)historyData[CHOSEN_CARD_KEY] integerValue]];
//    [cardView setTitle:[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]].contents forState:UIControlStateNormal];
//    [cardView setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
//    cardView.enabled = YES;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li",(long)[(NSNumber*)historyData[SCORE_KEY] integerValue]];
    self.statusLabel.text = historyData[STATUS_KEY];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"setToHistory"]|| [segue.identifier isEqualToString:@"playingToHistory"] ) {
        HistoryViewController *vc = (HistoryViewController *)segue.destinationViewController;
        [vc setHistory:self.gameHistory];
    }
}


@end
