//
//  CoffeDetailViewController.m
//  Coffee
//
//  Created by VA Gautham  on 8/14/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "CoffeDetailViewController.h"

@interface CoffeDetailViewController ()

@end

@implementation CoffeDetailViewController
@synthesize thisCoffee;

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
    [self setupView];
}

-(void)setupView
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.navigationItem setHidesBackButton:TRUE];
    
    UIBarButtonItem* leftbarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onBack)];
    [leftbarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    
    UIBarButtonItem* rightbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onShare)];
    [rightbarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightbarButton;
    
}

-(void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    CGRect CoffeeNameFrame = CGRectMake(20, 80, self.view.frame.size.width - 40, 36);
    txt_CoffeeName = [[UITextField alloc] init];
    [txt_CoffeeName setFont:[UIFont fontWithName:@"HelveticaNeue"
                                            size:32.0]];
    [txt_CoffeeName setTextColor:[UIColor darkGrayColor]];
    [txt_CoffeeName setFrame:CoffeeNameFrame];
    [self.view addSubview:txt_CoffeeName];
    txt_CoffeeName.delegate = self;
    txt_CoffeeName.returnKeyType = UIReturnKeyDone;
    txt_CoffeeName.placeholder = @"Enter Coffee Name";

    CGRect CoffeeDescriptionFrame = CGRectMake(20, 128, self.view.frame.size.width - 40, 64);
    txt_CoffeeDescritpion = [[UITextView alloc] init];
    [txt_CoffeeDescritpion setFont:[UIFont fontWithName:@"HelveticaNeue"
                                                   size:16.0f]];
    [txt_CoffeeDescritpion setFrame:CoffeeDescriptionFrame];
    
    [txt_CoffeeDescritpion setTextColor:[UIColor lightGrayColor]];
    [txt_CoffeeDescritpion showsVerticalScrollIndicator];
    [self.view addSubview:txt_CoffeeDescritpion];
    txt_CoffeeDescritpion.delegate = self;
    txt_CoffeeDescritpion.returnKeyType = UIReturnKeyDone;

    CGRect CoffeeImageFrame = CGRectMake(20, 224, self.view.frame.size.width - 40, self.view.frame.size.width - 40);
    img_CoffeeImage = [[UIImageView alloc] init];
    [img_CoffeeImage setFrame:CoffeeImageFrame];
    [self.view addSubview:img_CoffeeImage];
    [img_CoffeeImage setContentMode:UIViewContentModeScaleAspectFit];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    txt_CoffeeName.text = thisCoffee.coffee_NAME;
    if (thisCoffee.coffee_DESC.length == 0)
        txt_CoffeeDescritpion.text = @"Coffee Description";
    else
        txt_CoffeeDescritpion.text = thisCoffee.coffee_DESC;

    if (!thisCoffee.coffee_IMAGE_URL || [thisCoffee.coffee_IMAGE_URL isEqualToString:@""])
    {
        [img_CoffeeImage removeFromSuperview];
    }
    else
    {
        NSURL* url = [NSURL URLWithString:thisCoffee.coffee_IMAGE_URL];
        [img_CoffeeImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imageView_Placeholder.png"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saved)
                                                 name:NOTIFICATION_SAVE_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saved)
                                                 name:NOTIFICATION_SAVE_FAILED
                                               object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Notification methods
-(void)saved
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -
#pragma Navigation Button methods

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:FALSE];
}

-(void)onShare
{
    NSArray *activityItems = [NSArray arrayWithObjects:txt_CoffeeName.text, @"\n", txt_CoffeeDescritpion.text, @"\n", img_CoffeeImage.image, nil];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark -
#pragma UITextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![[WebServiceManager sharedWebServiceManager] isConnectedToInternet])
    {
        UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Cant save details without internet connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noDataAlert show];
        
        txt_CoffeeName.text = thisCoffee.coffee_NAME;
        txt_CoffeeDescritpion.text = thisCoffee.coffee_DESC;
    }
    else
    {
        if(txt_CoffeeName.text.length == 0 || txt_CoffeeDescritpion.text.length == 0)
        {
            UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"Fill all fields" message:@"Please fill all the fields and try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [noDataAlert show];
        }
        else
        {
            thisCoffee.coffee_NAME = txt_CoffeeName.text;
            thisCoffee.coffee_DESC = txt_CoffeeDescritpion.text;
            
            if (!loadingAlert)
            {
                loadingAlert = [[UIAlertView alloc] initWithTitle:@"Saving.." message:@"Please Wait!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            }
            [loadingAlert show];

            [[WebServiceManager sharedWebServiceManager] saveCoffee:thisCoffee];
        }
    }
    return YES;
}

#pragma mark -
#pragma UITextView methods

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if (![[WebServiceManager sharedWebServiceManager] isConnectedToInternet])
        {
            UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Cant save details without internet connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [noDataAlert show];
            
            txt_CoffeeName.text = thisCoffee.coffee_NAME;
            txt_CoffeeDescritpion.text = thisCoffee.coffee_DESC;
        }
        else
        {
            if(txt_CoffeeName.text.length == 0 || txt_CoffeeDescritpion.text.length == 0)
            {
                UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"Fill all fields" message:@"Please fill all the fields and try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [noDataAlert show];
                
            }
            else
            {
                thisCoffee.coffee_NAME = txt_CoffeeName.text;
                thisCoffee.coffee_DESC = txt_CoffeeDescritpion.text;
                
                if (!loadingAlert)
                {
                    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Saving.." message:@"Please Wait!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                }
                [loadingAlert show];

                [[WebServiceManager sharedWebServiceManager] saveCoffee:thisCoffee];
            }
        }
        
        return NO;
    }
    
    return YES;
}


@end
