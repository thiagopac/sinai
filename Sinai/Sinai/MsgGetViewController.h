//
//  MsgGetViewController.h
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MsgGetViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *lblMsgGet;
- (IBAction)btnAtualizar:(UIButton *)sender;
- (IBAction)btnOrei:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *containerShadow;

@end
