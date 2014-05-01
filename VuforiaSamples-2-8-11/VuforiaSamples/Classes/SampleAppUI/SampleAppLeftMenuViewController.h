/*==============================================================================
 Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc.
 All Rights Reserved.
 ==============================================================================*/

#import <UIKit/UIKit.h>

@class SampleAppSlidingMenuController;

@interface SampleAppLeftMenuViewController : UIViewController {
    id observer;
}

@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,assign) SampleAppSlidingMenuController *slidingMenuViewController;

- (void) updateMenu;

@end
