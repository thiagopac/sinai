//
//  Msg.h
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgPost : NSObject

@property (assign, nonatomic) NSInteger idmsg;
@property (strong, nonatomic) NSString *descricao;
@property (assign, nonatomic) float validade;
@property (strong, nonatomic) NSString *idioma;
@property (assign, nonatomic) NSInteger iduser;

@end