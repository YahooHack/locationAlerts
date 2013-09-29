//
//  RegisterViewController.m
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This view controller class is used for allow user to register.

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    //if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        // self.edgesForExtendedLayout = UIRectEdgeTop;

    
    CommunicationManager *oCommunicationManager = [CommunicationManager sharedCommunicationManager]; // create communication manager instance
    [oCommunicationManager sendFetchYahooNews:@"Syria"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add this method
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
