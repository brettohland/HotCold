//
//  ASWLobbyViewController.m
//  HotCold
//
//  Created by brett ohland on 2014-05-24.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWLobbyViewController.h"

@interface ASWLobbyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *WhoAmILabel;
@property (weak, nonatomic) IBOutlet UILabel *whoAreYouLabel;
@property (weak, nonatomic) IBOutlet UIButton *seekButton;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
- (IBAction)decisionButton:(UIButton *)sender;

@end

@implementation ASWLobbyViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)decisionButton:(UIButton *)sender {
}
@end
