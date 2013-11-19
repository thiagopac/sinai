//
//  Msg.h
//  Sinai
//
//  Created by Thiago Castro on 18/11/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgPost : NSObject

@property (strong, nonatomic) NSString *descricao;
@property (strong, nonatomic) NSNumber *validade;
@property (strong, nonatomic) NSString *idioma;
@property (strong, nonatomic) NSNumber *iduser;

@end