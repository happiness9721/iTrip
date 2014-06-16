//
//  AddTripViewController.m
//  iTrip
//
//  Created by 楊凱霖 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "AddTripViewController.h"
#import "SelectDateViewController.h"
#import "SelectCoordinateViewController.h"
#import "AppDelegate.h"
#import "Trip.h"

@interface AddTripViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (weak, nonatomic) IBOutlet UITextField *budget;
@property (weak, nonatomic) IBOutlet UIButton *date;
@property NSDate *selectDate;
@property double latitude;
@property double longitude;

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
    self.selectDate =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.date setTitle:[dateFormatter stringFromDate:self.selectDate] forState:UIControlStateNormal];
    [self.date sizeToFit];
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
    if([segue.identifier isEqual:@"unwindToTripList"])
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Trip *newTrip = [[Trip alloc] init];
        newTrip.name = self.name.text;
        newTrip.location = self.location.text;
        newTrip.detail = self.detail.text;
        newTrip.budget = (int)self.budget.text;
        newTrip.latitude = self.latitude;
        newTrip.longitude = self.longitude;
        newTrip.date = self.selectDate;
        [delegate addTrip:newTrip];
    }
}

- (IBAction)unwindAddTripView:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqual:@"unwindFromDate"])
    {
        SelectDateViewController *sourceViewController = unwindSegue.sourceViewController;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [self.date setTitle:[dateFormatter stringFromDate:sourceViewController.datePicker.date] forState:UIControlStateNormal];
        [self.date sizeToFit];
        self.selectDate = sourceViewController.datePicker.date;
    }
    else if ([unwindSegue.identifier isEqual:@"unwindFromMap"])
    {
        SelectCoordinateViewController *sourceViewController = unwindSegue.sourceViewController;
        self.location.text = sourceViewController.location;
        self.latitude = sourceViewController.latitude;
        self.longitude = sourceViewController.longitude;
    }
}


@end
