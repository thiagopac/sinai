//
//  MsgPostViewController.h
//  Sinai
//
//  Created by Thiago Castro on 20/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgPostViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *lblMsgPost;
@property (strong, nonatomic) IBOutlet UISlider *btnValidade;
- (IBAction)btnIdioma:(UISegmentedControl *)sender;
- (IBAction)btnValidade:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblDiasValidade;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIView *viewBloqueio;
- (IBAction)btnLogin:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblIdiomaEscolhido;

@end
