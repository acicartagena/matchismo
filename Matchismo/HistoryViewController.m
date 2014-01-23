//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Aci Cartagena on 1/20/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "HistoryViewController.h"
#import "ViewController.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyView;
@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSMutableAttributedString *temp;
    
    for (NSDictionary *move in self.history){
        if ([move[STATUS_KEY] isKindOfClass:[NSString class]]){
            self.historyView.text = [self.historyView.text stringByAppendingFormat:@"%@ \n",move[STATUS_KEY]];
        }else{
            temp = [self.historyView.attributedText mutableCopy];
            [temp appendAttributedString:move[STATUS_KEY]];
            [temp appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" ]];
            self.historyView.attributedText = temp;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
