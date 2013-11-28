//
//  MinhaMsgCell.h
//  Sinai
//
//  Created by Thiago Castro on 27/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinhaMsgCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *lblMsg;
@property (strong, nonatomic) IBOutlet UILabel *lblCriacao;
@property (strong, nonatomic) IBOutlet UILabel *lblOracoes;
@property (strong, nonatomic) IBOutlet UILabel *lblPublicacao;

@end
