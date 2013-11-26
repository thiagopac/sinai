//
//  User.h
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) NSInteger iduser;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *nome;
@property (strong, nonatomic) NSString *sobrenome;
@property (strong, nonatomic) NSString *erro;

@end
