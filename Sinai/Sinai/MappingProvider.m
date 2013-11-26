//
//  MappingProvider.m
//  restExample
//
//  Created by Thiago Castro on 14/10/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import "MappingProvider.h"
#import "User.h"
#import "Login.h"
#import "MsgPost.h"
#import "MsgGet.h"
#import "Output.h"


@implementation MappingProvider

+ (RKMapping *)userMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
    [mapping addAttributeMappingsFromArray:@[@"iduser", @"email", @"nome", @"sobrenome"]];
    return mapping;
}

+ (RKMapping *)loginMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Login class]];
    [mapping addAttributeMappingsFromArray:@[@"email", @"password"]];
    
    return mapping;
}

+ (RKMapping *)msgPostMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MsgPost class]];
    [mapping addAttributeMappingsFromArray:@[@"descricao", @"validade", @"idioma", @"iduser"]];
    
    return mapping;
}

+ (RKMapping *)msgGetMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MsgGet class]];
    [mapping addAttributeMappingsFromArray:@[@"idmsg", @"descricao", @"oracoes", @"nome", @"sobrenome"]];
    
    return mapping;
}

+ (RKMapping *)outputMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Output class]];
    [mapping addAttributeMappingsFromArray:@[@"output"]];
    
    return mapping;
}

@end
