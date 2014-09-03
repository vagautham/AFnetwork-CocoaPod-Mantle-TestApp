//
//  AllCoffeeViewController.m
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "AllCoffeeViewController.h"

#define NAME_FONT_SIZE 16.0f
#define DESC_FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface AllCoffeeViewController ()

@end

@implementation AllCoffeeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.navigationItem setHidesBackButton:TRUE];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    UIBarButtonItem* leftbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onReset)];
    [leftbarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftbarButton;

    UIBarButtonItem* rightbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddCoffee)];
    [rightbarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightbarButton;

    
    }

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;

    CoffeeTable = [self makeTableView];
    [CoffeeTable registerClass:[CoffeeTableCell class] forCellReuseIdentifier:@"newCoffeeCell"];
    [self.view addSubview:CoffeeTable];
    [CoffeeTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CoffeeTable reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetSuccess)
                                                 name:NOTIFICATION_RESET_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetFailed)
                                                 name:NOTIFICATION_RESET_FAILED
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCoffeeFailed)
                                                 name:NOTIFICATION_GET_ALL_COFFEE_FAILED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCoffeeSuccess)
                                                 name:NOTIFICATION_GET_ALL_COFFEE_SUCCESS
                                               object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma UITextView methods
-(void)resetFailed
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Unable to reset data. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [noDataAlert show];
}

-(void)resetSuccess
{
    [[WebServiceManager sharedWebServiceManager] getAllCoffeeDetails];
}

-(void)getCoffeeFailed
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Unable to reset data. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [noDataAlert show];
}

-(void)getCoffeeSuccess
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];

    UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Data successfully reset" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [noDataAlert show];
    
    [CoffeeTable reloadData];
}

#pragma mark -
#pragma Navigation button methods
-(void)onReset
{
    if (!loadingAlert)
    {
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Reloading Data.." message:@"Please Wait!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    }
    [loadingAlert show];
    [[WebServiceManager sharedWebServiceManager] resetAllData];
}

-(void)onAddCoffee
{
    CoffeeModel *newCoffee = [[CoffeeModel alloc] init];
    newCoffee.coffee_ID = [[WebServiceManager sharedWebServiceManager] generateIDForCoffee];
    newCoffee.coffee_IMAGE_URL = @"";
    
    CoffeDetailViewController *mCDVC = [[CoffeDetailViewController alloc] init];
    
    if (!mCDVC.thisCoffee)
        mCDVC.thisCoffee = [[CoffeeModel alloc] init];
    mCDVC.thisCoffee = newCoffee;
    
    [self.navigationController pushViewController:mCDVC animated:FALSE];
}

#pragma mark -
#pragma UITableView methods
-(UITableView *)makeTableView
{
    CGRect tableFrame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 50);
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 45;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[WebServiceManager sharedWebServiceManager] getAllSavedCoffee] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self getHeightforIndexPath:indexPath];
}

-(CGFloat)getHeightforIndexPath:(NSIndexPath *)indexPath
{
    CoffeeModel *currentCoffee = [[[WebServiceManager sharedWebServiceManager] getAllSavedCoffee] objectAtIndex:indexPath.row];
    NSString *text = currentCoffee.coffee_NAME;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:NAME_FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, 44.0f);
    
    
    text = currentCoffee.coffee_DESC;
    constraint = CGSizeMake(height + CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    size = [text sizeWithFont:[UIFont systemFontOfSize:DESC_FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    height = MAX(height + size.height, 44.0f);
    
    if (currentCoffee.coffee_IMAGE_URL && ![currentCoffee.coffee_IMAGE_URL isEqualToString:@""])
        height = height + 160;
    else
        height = height - 25;
    
    // return the height, with a bit of extra padding in
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newCoffeeCell";
    CoffeeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[CoffeeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CoffeeModel *currentCoffee = [[[WebServiceManager sharedWebServiceManager] getAllSavedCoffee] objectAtIndex:indexPath.row];
    cell.lbl_coffeeName.text = currentCoffee.coffee_NAME;
    [cell.lbl_coffeeName setFrame:CGRectMake(10, 2, 280, 20)];
    [cell addSubview:cell.lbl_coffeeName];
    
    cell.lbl_coffeeDesc.text = currentCoffee.coffee_DESC;
    [cell.lbl_coffeeDesc setFrame:CGRectMake(10, 16, 280, 40)];
    [cell addSubview:cell.lbl_coffeeDesc];
    
    if (currentCoffee.coffee_IMAGE_URL && ![currentCoffee.coffee_IMAGE_URL isEqualToString:@""])
    {
        NSURL* url = [NSURL URLWithString:currentCoffee.coffee_IMAGE_URL];
        [cell.imgView_coffeeImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imageView_Placeholder.png"]];
        [cell.imgView_coffeeImage setFrame:CGRectMake(10, 60, 280, 160)];
        [cell addSubview:cell.imgView_coffeeImage];
    }
    else
    {
        [cell.imgView_coffeeImage removeFromSuperview];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoffeeModel *currentCoffee = [[[WebServiceManager sharedWebServiceManager] getAllSavedCoffee] objectAtIndex:indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    CoffeDetailViewController *mCDVC = [[CoffeDetailViewController alloc] init];
    
    if (!mCDVC.thisCoffee)
        mCDVC.thisCoffee = [[CoffeeModel alloc] init];
    mCDVC.thisCoffee = currentCoffee;
    
    [self.navigationController pushViewController:mCDVC animated:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return FALSE;
}

@end
