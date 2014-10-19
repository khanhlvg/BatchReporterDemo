//
//  ViewController.m
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>
#import "KBLogReporterService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *screenIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendLogButtonPust:(id)sender {
    NSDate *now = [NSDate date];
    NSString *screenID = [NSString stringWithFormat:@"%c-%d",
                          arc4random_uniform(8) + 65,
                          arc4random_uniform(30)];
    
    KBLogEntity *entity = [[KBLogEntity alloc] init];
    entity.timeStamp = now;
    entity.screenID = screenID;
    
    self.screenIDLabel.text = screenID;
    self.timeStampLabel.text = now.description;
    
    KBLogReporterService *logReporter = [KBLogReporterService sharedInstance];
    [logReporter sendLog:entity];
}

@end
