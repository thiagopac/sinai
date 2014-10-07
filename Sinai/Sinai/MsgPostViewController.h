//
//  MsgPostViewController.h
//  Sinai
//
//  Created by Thiago Castro on 20/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GAI.h>
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@class AbstractActionSheetPicker;

@interface MsgPostViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnValidade;
@property (strong, nonatomic) IBOutlet UITextView *lblMsgPost;
@property (strong, nonatomic) IBOutlet UIButton *btnIdiomas;
@property (strong, nonatomic) IBOutlet UIButton *btnEnviaMsgOutlet;
@property (strong, nonatomic) NSString *strIdioma;
@property (strong, nonatomic) NSString *strValidade;

- (IBAction)btnIdiomas:(id)sender;

- (IBAction)btnEnviaMsg:(UIButton *)sender;
- (IBAction)btnValidade:(id)sender;

- (void)alert:(NSString *)msg :(NSString *)title;
-(void)showLoginView;

@end
