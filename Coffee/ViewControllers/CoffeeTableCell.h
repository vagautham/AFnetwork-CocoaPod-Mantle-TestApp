//
//  CoffeeTableCell.h
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeTableCell : UITableViewCell
{
    UILabel *lbl_coffeeName;
    UILabel *lbl_coffeeDesc;
    UIImageView *imgView_coffeeImage;
}

@property (nonatomic, retain) UILabel *lbl_coffeeName;
@property (nonatomic, retain) UILabel *lbl_coffeeDesc;
@property (nonatomic, retain) UIImageView *imgView_coffeeImage;
@end
