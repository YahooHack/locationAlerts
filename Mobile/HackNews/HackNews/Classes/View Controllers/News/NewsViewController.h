//
//  NewsViewController.h
//  HackNews
//
//  Created by Furqan Kamani on 9/29/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This view controller class is used for showing news to users.

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // UI Componenet Variable
    UITableView *_oNewsTableView; // this is used for shwoing news
    UIButton *_oBackButton; // this is used for showing back button
    
    // public variables
    NSMutableArray *_arrNews; // this is used for storing news array
}

@property (nonatomic, retain) IBOutlet UITableView *oNewsTableView;
@property (nonatomic, retain) IBOutlet UIButton *oBackButton;

@property (nonatomic, retain) NSMutableArray *arrNews;

#pragma mark IBAction Fucntion
- (IBAction) backButtonPressed; // this function execute when back button pressed

@end
