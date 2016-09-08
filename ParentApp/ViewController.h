//
//  ViewController.h
//  ParentApp
//
//  Created by amir sankar on 4/20/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate>

- (IBAction)createButton:(id)sender;
- (IBAction)checkStatusButton:(id)sender;
- (IBAction)updateButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property double longitude;
@property double latitude;
@property double childLongitude;
@property double childLatitude;
@property double radiusLength;


@end

