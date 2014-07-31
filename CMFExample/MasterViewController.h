//
//  MasterViewController.h
//  CMFExample
//
//  Created by Pb on 31/07/14.
//  Copyright (c) 2014 Pb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationsFilter.h"
#include <dlfcn.h>
#include <objc/runtime.h>
#include <objc/message.h>
#import "AddNumberViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <AddNumberDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property NSMutableArray *blockList;
@property CommunicationsFilterBlockList *cfBlockList;

@end
