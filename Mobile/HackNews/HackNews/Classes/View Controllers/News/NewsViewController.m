//
//  NewsViewController.m
//  HackNews
//
//  Created by Furqan Kamani on 9/29/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This view controller class is used for showing news to users.

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize oNewsTableView = _oNewsTableView;
@synthesize oBackButton = _oBackButton;

@synthesize arrNews = _arrNews;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_oNewsTableView release];
    [_oBackButton release];
    
    [_arrNews release];
    
    [super dealloc];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction Fucntion
// this function execute when back button pressed
- (IBAction) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
