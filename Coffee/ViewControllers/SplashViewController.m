//
//  SplashViewController.m
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "SplashViewController.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proceedNextView)
                                                 name:NOTIFICATION_GET_ALL_COFFEE_FAILED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proceedNextView)
                                                 name:NOTIFICATION_GET_ALL_COFFEE_SUCCESS
                                               object:nil];
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    img_logo = [[UIImageView alloc] initWithFrame:self.view.frame];
    [img_logo setImage:[UIImage imageNamed:@"splash-568h.png"]];
    [self.view addSubview:img_logo];
}

#pragma mark -
#pragma Notification methods
-(void)proceedNextView
{
    AllCoffeeViewController *ACVC = [[AllCoffeeViewController alloc] init];
    [self.navigationController pushViewController:ACVC animated:FALSE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //[[WebServiceManager sharedWebServiceManager] getDetailsforCoffeeType:@"3"];
    //[[WebServiceManager sharedWebServiceManager] resetAllData];
    //[[WebServiceManager sharedWebServiceManager] createNewCoffeeType:[[NSMutableDictionary alloc] init]];
    //[[WebServiceManager sharedWebServiceManager] updateCoffeeType:[[NSMutableDictionary alloc] init]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //[self setupConstraint];
     
    if ([[WebServiceManager sharedWebServiceManager] isConnectedToInternet])
    {
        [[WebServiceManager sharedWebServiceManager] getAllCoffeeDetails];
    }
    else
    {
        NSArray *allCoffee = [[WebServiceManager sharedWebServiceManager] getAllSavedCoffee];
        
        if (!allCoffee || [allCoffee count] == 0)
        {
            UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Local data found to populate. Please connect to the internet and relaunch the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [noDataAlert show];
        }
        else
        {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self proceedNextView];
            });
        }
    }
    
}


-(BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
