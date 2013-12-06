//
//  RelembrarSenhaViewController.h
//  Sinai
//
//  Created by Thiago Castro on 02/12/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelembrarSenhaViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnEnviar:(UIButton *)sender;
- (IBAction)btnCancelar:(UIButton *)sender;

@end
