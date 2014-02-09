//
//  MsgPostViewController.h
//  Sinai
//
//  Created by Thiago Castro on 20/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "ActionSheetPicker.h"

@class AbstractActionSheetPicker;

@interface MsgPostViewController : GAITrackedViewController <UITextFieldDelegate>

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (strong, nonatomic) IBOutlet UITextView *lblMsgPost;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIView *viewBloqueio;
@property (strong, nonatomic) IBOutlet UIButton *btnEnviaMsgOutlet;
@property (strong, nonatomic) IBOutlet UITextField *txtIdiomaOutlet;
@property (strong, nonatomic) IBOutlet UITextField *txtValidadeOutlet;

- (IBAction)btnEnviaMsg:(UIButton *)sender;
- (IBAction)btnLogin:(UIButton *)sender;
- (IBAction)txtIdioma:(UITextField *)sender;
- (IBAction)txtValidade:(UITextField *)sender;

@end
