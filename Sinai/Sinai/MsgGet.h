//
//  MsgGet.h
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgGet : NSObject

@property (assign, nonatomic) NSInteger idmsg;
@property (strong, nonatomic) NSString *descricao;
@property (strong, nonatomic) NSNumber *oracoes;

@end
