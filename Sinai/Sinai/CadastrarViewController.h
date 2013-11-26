//
//  CadastrarViewController.h
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CadastrarViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword2;
- (IBAction)btnRegistrar:(UIButton *)sender;
- (IBAction)btnCancelar:(UIButton *)sender;

@end
