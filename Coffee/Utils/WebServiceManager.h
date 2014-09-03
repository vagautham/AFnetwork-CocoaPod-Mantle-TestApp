//
//  WebServiceManager.h
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoffeeModel.h"

@interface WebServiceManager : NSObject

typedef void (^ResponseBlock)(NSData*, BOOL);

+ (WebServiceManager*)sharedWebServiceManager;

-(void)getAllCoffeeDetails;
-(void)getDetailsforCoffeeType:(NSString *)coffeeType;
-(void)createNewCoffeeType:(NSMutableDictionary *)coffeeDictionary;
-(void)updateCoffeeType:(NSMutableDictionary *)coffeeDictionary;
-(void)resetAllData;

- (BOOL)isConnectedToInternet;
- (id)getJSONOutputForData:(NSData*)jsonSourceData;

-(void)saveAllCoffee:(NSArray *)allCoffee;
-(NSArray *)getAllSavedCoffee;

-(void)saveCoffee:(CoffeeModel *)coffeeMod;

-(NSString *) generateIDForCoffee;

@end
