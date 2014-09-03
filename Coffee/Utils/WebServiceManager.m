//
//  WebServiceManager.m
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "WebServiceManager.h"

#define WEBSERVICEMANAGER_KEY @"WuVbkuUsCXHPx3hsQzus4SE"
#define SERVICE_URL @"https://coffeeapi.percolate.com"

#define ALL_COFFEE_ARRAY @"all_coffee_array"

@implementation WebServiceManager

#pragma mark -
#pragma Singleton methods
+ (WebServiceManager*)sharedWebServiceManager
{
    static id webServiceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webServiceManager = [[self alloc] init];
    });
    
    return webServiceManager;
}

#pragma mark -
#pragma Reachability methods
- (BOOL)isConnectedToInternet
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) // && [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable
        return NO;
    
    return YES;
}

- (id)getJSONOutputForData:(NSData*)jsonSourceData
{
    Class class = [NSJSONSerialization class];
    NSError* parsingError = nil;
    id jsonDict = nil;
    if (class) {
        jsonDict = [NSJSONSerialization JSONObjectWithData:jsonSourceData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&parsingError];
    }
    return jsonDict;
}

#pragma mark -
#pragma Webservice methods
-(void)getAllCoffeeDetails
{
    //https://coffeeapi.percolate.com/api/coffee/?api_key=your_api_key
    NSString* URLString = [NSString stringWithFormat:@"%@/api/coffee/?api_key=%@", SERVICE_URL, WEBSERVICEMANAGER_KEY];
    //localisationName is a arbitrary string here
    NSString* webStringURL = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept"
                           value:@"application/json"];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString * responseString = [operation responseString];
        NSArray* responseArray = [self getJSONOutputForData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Success: %@", responseArray);
        [self saveAllCoffee:responseArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_ALL_COFFEE_SUCCESS object:responseString];
        
        
    }
                                     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_ALL_COFFEE_FAILED object:nil];
                                         
                                     }];
    
    [operation start];
}

-(void)getDetailsforCoffeeType:(NSString *)coffeeType
{
    //https://coffeeapi.percolate.com/api/coffee/coldbrew/?api_key=your_api_key
    NSString* URLString = [NSString stringWithFormat:@"%@/api/coffee/%@/?api_key=%@", SERVICE_URL, coffeeType, WEBSERVICEMANAGER_KEY];
    //localisationName is a arbitrary string here
    NSString* webStringURL = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept"
                           value:@"application/json"];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString * responseString = [operation responseString];
        NSArray* responseArray = [self getJSONOutputForData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Success: %@", responseArray);
        
    }
                                     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                         NSLog(@"Error: %@ , status code :%ld", error, (long)[operation.response statusCode]);
                                         
                                     }];
    
    [operation start];
    
}

-(void)createNewCoffeeType:(NSMutableDictionary *)coffeeDictionary
{
    //https://coffeeapi.percolate.com/api/coffee/?api_key=your_api_key
    NSString* URLString = [NSString stringWithFormat:@"%@/api/coffee/?api_key=%@", SERVICE_URL, WEBSERVICEMANAGER_KEY];
    //localisationName is a arbitrary string here
    NSString* webStringURL = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept"
                           value:@"application/json"];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST"
                                                            path:nil
                                                      parameters:coffeeDictionary];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString * responseString = [operation responseString];
        NSArray* responseArray = [self getJSONOutputForData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Success: %@", responseArray);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SAVE_SUCCESS object:nil];

        
        
    }
                                     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                         NSLog(@"Error: %@ , status code :%ld", error, (long)[operation.response statusCode]);
                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SAVE_SUCCESS object:nil];
                                     }];
    
    [operation start];
}

-(void)updateCoffeeType:(NSMutableDictionary *)coffeeDictionary
{
    //https://coffeeapi.percolate.com/api/coffee/?api_key=your_api_key
    NSString* URLString = [NSString stringWithFormat:@"%@/api/coffee/?api_key=%@", SERVICE_URL, WEBSERVICEMANAGER_KEY];
    //localisationName is a arbitrary string here
    NSString* webStringURL = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept"
                           value:@"application/json"];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"PUT"
                                                            path:nil
                                                      parameters:coffeeDictionary];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString * responseString = [operation responseString];
        NSArray* responseArray = [self getJSONOutputForData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Success: %@", responseArray);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SAVE_SUCCESS object:nil];

    }
                                     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                         NSLog(@"Error: %@ , status code :%ld", error, (long)[operation.response statusCode]);
                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SAVE_SUCCESS object:nil];
                                     }];
    
    [operation start];
}

-(void)resetAllData
{
    //https://coffeeapi.percolate.com/reset/?api_key=your_api_key
    NSString* URLString = [NSString stringWithFormat:@"%@/reset/?api_key=%@", SERVICE_URL, WEBSERVICEMANAGER_KEY];
    //localisationName is a arbitrary string here
    NSString* webStringURL = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept"
                           value:@"application/json"];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString * responseString = [operation responseString];
        NSArray* responseArray = [self getJSONOutputForData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Success: %@", responseArray);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESET_SUCCESS object:responseString];

    }
                                     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                         NSLog(@"Error: %@ , status code :%ld", error, (long)[operation.response statusCode]);
                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESET_FAILED object:nil];
                                     }];
    
    [operation start];
}

#pragma mark -
#pragma Persistance methods
-(void)saveAllCoffee:(NSArray *)allCoffee
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:allCoffee forKey:ALL_COFFEE_ARRAY];
    [userDefaults synchronize];
}

-(NSArray *)getAllSavedCoffee
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *allCoffee = [userDefaults valueForKey:ALL_COFFEE_ARRAY];
    return [CoffeeModel deserializeCoffeeFromJSON:allCoffee];
}

-(void)saveCoffee:(CoffeeModel *)coffeeMod
{
    NSArray *allCoffee = [self getAllSavedCoffee];
    NSMutableArray *allCoffeeCopy =[NSMutableArray arrayWithArray:allCoffee];
    for (CoffeeModel *currentCoffee in allCoffee)
    {
        if([coffeeMod.coffee_ID isEqualToString:currentCoffee.coffee_ID])
        {
            [allCoffeeCopy removeObject:currentCoffee];
            [allCoffeeCopy addObject:coffeeMod];
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:coffeeMod.coffee_ID, @"id", coffeeMod.coffee_NAME, @"name", coffeeMod.coffee_DESC, @"desc", coffeeMod.coffee_IMAGE_URL, @"image_url", nil];
            [self createNewCoffeeType:updateDict];
            NSData *serializeData = [CoffeeModel serializeCoffeeToNSData:allCoffeeCopy];
            NSArray* serializeArray = [self getJSONOutputForData:serializeData];
            [self saveAllCoffee:serializeArray];
            return;
        }
    }
    
    [allCoffeeCopy addObject:coffeeMod];
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:coffeeMod.coffee_ID, @"id", coffeeMod.coffee_NAME, @"name", coffeeMod.coffee_DESC, @"desc", coffeeMod.coffee_IMAGE_URL, @"image_url", nil];
    [self createNewCoffeeType:updateDict];
    NSData *serializeData = [CoffeeModel serializeCoffeeToNSData:allCoffeeCopy];
    NSArray* serializeArray = [self getJSONOutputForData:serializeData];
    [self saveAllCoffee:serializeArray];
}

#pragma mark -
#pragma Util methods
-(NSString *) generateIDForCoffee
{
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 6];
    for (int i=0; i<6; i++)
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];

    NSArray *allCoffee = [self getAllSavedCoffee];
    for (CoffeeModel *currentCoffee in allCoffee)
    {
        if([randomString isEqualToString:currentCoffee.coffee_ID])
        {
            randomString = [NSMutableString stringWithString:[self generateIDForCoffee]];
            break;
        }
    }

    return randomString;
}

@end
