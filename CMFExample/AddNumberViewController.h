//
//  AddNumberViewController.h
//  CMFExample
//
//  Created by Pb on 31/07/14.
//  Copyright (c) 2014 Pb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationsFilter.h"

@protocol AddNumberDelegate <NSObject>

-(void)addNumber:(NSString *)number;

@end

@interface AddNumberViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource>{
    
    id <AddNumberDelegate> _delegate;
}

@property id delegate;

- (IBAction)didSaveNumber:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberField;

@end
