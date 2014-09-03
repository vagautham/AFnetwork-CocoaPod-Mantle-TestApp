//
//  CoffeDetailViewController.h
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"

@interface CoffeDetailViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>
{
    UITextField *txt_CoffeeName;
    UITextView *txt_CoffeeDescritpion;
    UIImageView *img_CoffeeImage;
    
    CoffeeModel *thisCoffee;
    UIAlertView *loadingAlert;
}

@property(nonatomic, strong) CoffeeModel *thisCoffee;

@end
