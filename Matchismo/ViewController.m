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

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic, getter = isGameEnded) BOOL gameEnded;
@property (nonatomic, getter = isGameAlreadySaved) BOOL gameAlreadySaved;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic) NSTimeInterval gameTime;
@property (nonatomic) BOOL waitingForAnimationFinish;
@property (strong, nonatomic) Card *activeCard;


@end

@implementation ViewController

#pragma mark - lifecyle

- (void) viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
    
}

#pragma mark - lazy loading

- (CardMatchingGame *)game
{
    if (!_game){
        _game = [self createGame];
    }
    return _game;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews){
        _cardViews = [[NSMutableArray alloc] init];
    }
    return _cardViews;
}

- (Grid *)grid
{
    if (!_grid){
        _grid = [[Grid alloc] init];
    }
    return _grid;
}

#pragma mark - Game Control

- (IBAction)startNewGame
{
    
    void (^tapBlock)(UIAlertView *alertView, NSInteger buttonIndex)=^void(UIAlertView *alertView, NSInteger buttonIndex){
        
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:ALERT_OK_BUTTON]){
        
            //end timer and save game details
            if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput){
                self.gameName = [[alertView textFieldAtIndex:0] text];
            }
            [self saveGameStatistics];
            
            //reset game
            self.game = nil;
            [self game];
            
            //start new game
            //[self updateUI];
            [self setGameAlreadySaved:NO];
            [self setGameEnded:NO];
            
            self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",(int)self.game.score];
        }
    };
    
    NSString *title = @"New Game";
    NSString *message = @"this will END current game and start a NEW game?";
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

- (IBAction)endCurrentGame:(id)sender
{
    
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

- (void)saveGameStatistics
{
    
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

#pragma mark - Game UI
- (void)cardSelected:(id)sender
{
    
    if (self.isGameEnded){
        return;
    }
    
    if (self.waitingForAnimationFinish){
        return;
    }
    
    NSUInteger chosenButtonIndex = [self.cardViews indexOfObject:sender];
    self.activeCard =[self.game cardAtIndex:chosenButtonIndex];
    
    if (self.activeCard.matched){
        return;
    }
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    
   
    [self updateView:(CardView *)sender forCard:self.activeCard defaultEnable:YES];
    
    switch (self.game.matchStatus) {
        case MatchStatusTypeMatchFound:
        case MatchStatusTypeMatchNotFound:
            [self updateUI];
            break;
            
        default:
            break;
    }
}

- (void)updateUINewGame
{
    return;
}

- (void)updateUI
{
    self.waitingForAnimationFinish = YES;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i",(int)self.game.score];
    
    [self performSelector:@selector(updateCardsView) withObject:self afterDelay:1.0f];
}

- (void)updateCardsView
{
    self.waitingForAnimationFinish = NO;
    
    for (CardView *cardView in self.cardViews){
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        
        if (card == self.activeCard && !card.isMatched){
            self.activeCard.chosen = NO;
        }
        [self updateView:cardView forCard:card defaultEnable:NO];
    }
    self.activeCard = nil;
}

#pragma mark - methods to be overwritten

- (Deck *)createDeck
{
    return nil;
}

- (CardMatchingGame *)createGame
{
    return nil;
}

- (void)updateView:(CardView *)cardView forCard:(Card *)card
{
    return;
}

- (void)updateCardView:(CardView *)cardView forCard:(Card *)card
{
    return;
}


@end
