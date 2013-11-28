//
//  MinhasMsgsTableViewController.h
//  Sinai
//
//  Created by Thiago Castro on 27/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinhasMsgsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *lblDateCriacao;
@property (strong, nonatomic) IBOutlet UITextView *lblMsg;
@property (strong, nonatomic) IBOutlet UILabel *lblOracoes;
@property (strong, nonatomic) IBOutlet UILabel *lblPublicacao;

@end
