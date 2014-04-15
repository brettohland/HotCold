//
//  ASWSeekViewController.m
//  HotCold
//
//  Created by brett ohland on 2014-04-13.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWSeekViewController.h"

@interface ASWSeekViewController ()
@property (weak, nonatomic) IBOutlet UILabel *howClose;

@end

@implementation ASWSeekViewController

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

@end
