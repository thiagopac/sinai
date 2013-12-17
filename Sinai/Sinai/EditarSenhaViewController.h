//
//  EditarSenhaViewController.h
//  Sinai
//
//  Created by Thiago Castro on 16/12/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "ViewController.h"

@interface EditarSenhaViewController : ViewController
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtSenhaAtual;
@property (strong, nonatomic) IBOutlet UITextField *txtNovaSenha;
- (IBAction)btnEnviar:(UIButton *)sender;
- (IBAction)btnCancelar:(UIButton *)sender;

@end
