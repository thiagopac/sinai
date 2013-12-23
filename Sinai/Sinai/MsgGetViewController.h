//
//  MsgGetViewController.h
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GAITrackedViewController.h"

@interface MsgGetViewController : GAITrackedViewController
@property (strong, nonatomic) IBOutlet UITextView *lblMsgGet;
- (IBAction)btnAtualizar:(UIButton *)sender;
- (IBAction)btnOrei:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *containerShadow;
@property (strong, nonatomic) IBOutlet UIButton *btnOreiOutlet;
@property (strong, nonatomic) IBOutlet UIButton *btnAtualizarOutlet;

@end