//
//  AddTripViewController.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "AddTripViewController.h"
#import "AppDelegate.h"
#import "Trip.h"

@interface AddTripViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (weak, nonatomic) IBOutlet UITextField *budget;
@property (weak, nonatomic) IBOutlet UIButton *date;

@end

@implementation AddTripViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Trip *newTrip = [[Trip alloc] init];
    newTrip.name = self.name.text;
    newTrip.location = self.location.text;
    newTrip.detail = self.detail.text;
    newTrip.budget = (int)self.budget.text;
    newTrip.latitude = 23.55;
    newTrip.longitude = 123.5555;
    newTrip.date = [NSDate date];
    [delegate addTrip:newTrip];

    NSLog(@"AddTrip %@", segue.identifier);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
