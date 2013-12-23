//
//  CadastrarViewController.h
//  Sinai
//
//  Created by Thiago Castro on 24/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface CadastrarViewController : GAITrackedViewController
@property (strong, nonatomic) IBOutlet UITextField *txtPrimeiroNome;
@property (strong, nonatomic) IBOutlet UITextField *txtUltimoNome;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword2;
- (IBAction)btnRegistrar:(UIButton *)sender;
- (IBAction)btnCancelar:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnRegistrarOutlet;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelarOutlet;

@end
