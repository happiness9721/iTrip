//
//  AddTripLogViewController.m
//  iTrip
//
//  Created by 江承諭 on 6/16/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "AddTripLogViewController.h"
#import "TripLog.h"
#import "TripTabBarViewController.h"
#import "DbAccessor.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyLocation.h"

@interface AddTripLogViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *actionBarSegmentedControl;
@property double latitude;
@property double longitude;

@end

@implementation AddTripLogViewController

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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    MKCoordinateRegion kaos_digital;
    self.latitude = locationManager.location.coordinate.latitude;
    self.longitude = locationManager.location.coordinate.longitude;
    
    kaos_digital.center.latitude = self.latitude;
    kaos_digital.center.longitude = self.longitude;
    // 設定縮放比例
    kaos_digital.span.latitudeDelta = 0.007;
    kaos_digital.span.longitudeDelta = 0.007;
    
    // 把region設定給MapView
    [self.mapView setRegion:kaos_digital];
    MyLocation *myLocation = [[MyLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    myLocation.title = @"iTrip";
    myLocation.subtitle = @"媽，我在這裡啦!";
    [self.mapView addAnnotation:myLocation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBarValueChanged:(id)sender
{
    [self.textTextField setHidden:YES];
    [self.imageView setHidden:YES];
    [self.mapView setHidden:YES];
    switch (self.actionBarSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            [self.textTextField setHidden:NO];
            break;
        case 1:
        {
            //宣告一個UIImagePickerController並設定代理
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            
            //設定開啓圖庫的類型(預設圖庫/全部/新拍攝)
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            //以動畫方式顯示圖庫
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            [self.imageView setHidden:NO];
            break;
        }
        case 2:
        {
            //建立一個ImagePickerController
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            //設定影像來源
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            //顯示Picker
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            [self.imageView setHidden:NO];
            break;
        }
        case 3:
        {
            [self.mapView setHidden:NO];
            break;
        }
        default:
            break;
    }
}

//使用代理之後才會出現的內建函式
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //取得影像
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.imageView setImage:image];
    
    //移除Picker
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"tripLogDoneIdentifier"]){
        TripTabBarViewController *tripTabBarViewControll = (TripTabBarViewController *)self.tabBarController;
        Trip* trip = tripTabBarViewControll.trip;
        TripLog * tripLog = [[TripLog alloc] init];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        if(self.imageView.image)
        {
            tripLog.tid = trip.tid;
            tripLog.type = TYPE_IMAGE;
            tripLog.image = self.imageView.image;
            tripLog.text = self.textTextField.text;
            tripLog.time = [NSDate date];
            [delegate addTripLog: tripLog];
        }
    }
}


@end
