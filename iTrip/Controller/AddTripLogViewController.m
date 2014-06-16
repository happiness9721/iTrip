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

@interface AddTripLogViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *actionBarSegmentedControl;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBarValueChanged:(id)sender
{
    switch (self.actionBarSegmentedControl.selectedSegmentIndex)
    {
        case 0:
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
        }
            
        default:
            break;
    }
}

//按下按鈕時所觸發的函式
- (IBAction)getFromLibrary:(id)sender {
    
    
}

- (IBAction)onCameraButtonPress:(id)sender {
    
    
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
