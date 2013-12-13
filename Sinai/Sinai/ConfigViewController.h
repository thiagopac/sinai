//
//  ConfigViewController.h
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ConfigViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnLoginOutlet;
@property (strong, nonatomic) IBOutlet UIButton *btnMeusPedidos;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
- (IBAction)btnLoginLogout:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *containerShadow;

@end
