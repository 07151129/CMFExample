//
//  DetailViewController.h
//  CMFExample
//
//  Created by Pb on 31/07/14.
//  Copyright (c) 2014 Pb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationsFilter.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
