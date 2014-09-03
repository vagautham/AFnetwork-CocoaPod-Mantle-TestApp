//
//  CoffeeModel.m
//  Coffee
//
//  Created by VA Gautham  on 8/26/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "CoffeeModel.h"

@implementation CoffeeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"coffee_ID": @"id",
             @"coffee_IMAGE_URL": @"image_url",
             @"coffee_NAME": @"name",
             @"coffee_DESC": @"desc",
             };
}

+ (NSValueTransformer *)appURLSchemeJSONTransformer {
    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
    // you can write your own transformers
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)appActionsJSONTransformer
{
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CoffeeModel class]];
}

+ (NSArray *)deserializeCoffeeFromJSON:(NSArray *)appInfosJSON
{
    NSError *error;
    NSArray *appInfos = [MTLJSONAdapter modelsOfClass:[CoffeeModel class] fromJSONArray:appInfosJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert app infos JSON to ChoosyAppInfo models: %@", error);
        return nil;
    }
    
    return appInfos;
}

+ (NSArray *)deserializeCoffeeFromNSData:(NSData *)jsonFormatData
{
    NSError *error;
    NSArray *appInfosJSON = [NSJSONSerialization JSONObjectWithData:jsonFormatData options:0 error:&error];
    if (error) {
        NSLog(@"Couldn't deserealize app info data into JSON from NSData: %@", error);
        return nil;
    }
    
    return [CoffeeModel deserializeCoffeeFromJSON:appInfosJSON];
}

+ (NSData *)serializeCoffeeToNSData:(NSArray *)appInfos
{
    NSArray *appInfosJSON = [MTLJSONAdapter JSONArrayFromModels:appInfos];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:appInfosJSON options:0 error:&error];
    if (error) {
        NSLog(@"Couldn't turn app info JSON into NSData. JSON: %@, \n\n Error: %@", appInfosJSON, error);
        return nil;
    }
    
    return jsonData;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil)
        return nil;
    
    return self;
}

@end
