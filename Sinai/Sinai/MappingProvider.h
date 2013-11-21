//
//  MappingProvider.h
//  restExample
//
//  Created by Thiago Castro on 14/10/13.
//  Copyright (c) 2013 Thiago Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/restkit.h>

@interface MappingProvider : NSObject

+ (RKMapping *)userMapping;
+ (RKMapping *)loginMapping;
+ (RKMapping *)msgPostMapping;
+ (RKMapping *)msgGetMapping;
+ (RKMapping *)outputMapping;

@end
