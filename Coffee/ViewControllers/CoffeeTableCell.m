//
//  CoffeeTableCell.m
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "CoffeeTableCell.h"

@implementation CoffeeTableCell
@synthesize lbl_coffeeDesc, lbl_coffeeName, imgView_coffeeImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lbl_coffeeName = [[UILabel alloc] init];
        [lbl_coffeeName setFont:[UIFont fontWithName:@"HelveticaNeue"
                                                size:16.0f]];
        [lbl_coffeeName setTextColor:[UIColor darkGrayColor]];
        [self.contentView addSubview:lbl_coffeeName];

        self.lbl_coffeeDesc = [[UILabel alloc] init];
        [lbl_coffeeDesc setFont:[UIFont fontWithName:@"HelveticaNeue"
                                                size:12.0f]];
        [lbl_coffeeDesc setTextColor:[UIColor lightGrayColor]];
        
        [lbl_coffeeDesc setNumberOfLines:3];
        [self.contentView addSubview:lbl_coffeeDesc];

        self.imgView_coffeeImage = [[UIImageView alloc] init];
        
        // Initialization code
        }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
