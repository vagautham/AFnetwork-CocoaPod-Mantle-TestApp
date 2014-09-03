//
//  AllCoffeeViewController.h
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "CoffeeTableCell.h"
#import "CoffeDetailViewController.h"

@interface AllCoffeeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *CoffeeTable;
    UIAlertView *loadingAlert;
}

@end
