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

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // add GPS location updated notification observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsSuccessfullyFetchNotificationReceived:) name:[Event newsSuccessfullyFetchNotification] object:nil];
    }
    return self;
}

#pragma mark - Memory Management
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // remove all notification observer
    
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    //if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        // self.edgesForExtendedLayout = UIRectEdgeTop;

    
    //CommunicationManager *oCommunicationManager = [CommunicationManager sharedCommunicationManager]; // create communication manager instance
    //[oCommunicationManager sendFetchYahooNews:@"Syria"];
    
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

#pragma mark - Notification Function
// this function execute when new fetch notification received
-(void) newsSuccessfullyFetchNotificationReceived:(NSNotification *)notification
{
    if (notification.userInfo)
    {
        NSArray *arrNews =notification.userInfo;
        NSLog(@"");
        NewsViewController *oNewViewController = [[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil] autorelease];
        if (oNewViewController)
        {
            [oNewViewController.arrNews setArray:notification.userInfo];
            [self.navigationController presentModalViewController:oNewViewController animated:YES];
        }
    }
}

@end
