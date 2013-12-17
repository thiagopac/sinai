//
//  LoginViewController.h
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin:(UIButton *)sender;
- (IBAction)btnCancelar:(UIButton *)sender;
- (IBAction)btnEsqueciSenha:(UIButton *)sender;
- (IBAction)btnNotUserYet:(UIButton *)sender;

@end