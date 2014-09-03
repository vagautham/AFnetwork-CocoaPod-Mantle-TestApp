//
//  CoffeeModel.h
//  Coffee
//
//  Created by VA Gautham  on 8/26/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *coffee_ID;
@property (nonatomic, copy) NSString *coffee_NAME;
@property (nonatomic, copy) NSString *coffee_DESC;
@property (nonatomic, copy) NSString *coffee_IMAGE_URL;

+ (NSArray *)deserializeCoffeeFromJSON:(NSArray *)appInfosJSON;
+ (NSArray *)deserializeCoffeeFromNSData:(NSData *)jsonFormatData;
+ (NSData *)serializeCoffeeToNSData:(NSArray *)appInfos;

@end
