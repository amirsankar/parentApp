//
//  ViewController.m
//  ParentApp
//
//  Created by amir sankar on 4/20/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import "ViewController.h"
#import "InTheZone.h"


@interface ViewController ()

@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createButton:(id)sender {
    NSString *newUsername = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.usernameTextField.text];
    
    NSURL *url = [NSURL URLWithString:newUsername];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session= [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *userDetails =
    @{@"username":self.usernameTextField.text,@"latitude":self.latitudeTextField.text,@"longitude":self.longitudeTextField.text,@"radius":self.radiusTextField.text};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                                         message:[error localizedDescription]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                return;
            }
            NSLog(@"Creation Complete");
        }];
        [uploadTask resume];
    }
}

- (IBAction)checkStatusButton:(id)sender {
    NSString *dataURL = [[NSString alloc]initWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.usernameTextField.text];
    NSURL *url = [NSURL URLWithString:dataURL];
    NSURLSessionDownloadTask *downloadTask =
    [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
         if(error) {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                                      message:[error localizedDescription]
                                                                               preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [alertController addAction:actionOk];
                 [self presentViewController:alertController animated:YES completion:nil];
             });
             
             return ;
         }
        
         NSDictionary *theDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:kNilOptions error:&error];
        
         self.longitude = [[theDictionary objectForKey:@"longitude"] doubleValue];
         self.latitude = [[theDictionary objectForKey:@"latitude"] doubleValue];
         self.childLongitude = [[theDictionary objectForKey:@"childLongitude"]doubleValue];
         self.childLatitude = [[theDictionary objectForKey:@"childLatitude"] doubleValue];
         
         CLLocation *parentLocation = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
         
         CLLocation *childLocation = [[CLLocation alloc]initWithLatitude:self.childLatitude longitude:self.childLongitude];
         
         NSString *radiusString = [theDictionary objectForKey:@"radius"];
         self.radiusLength = radiusString.doubleValue;
         
         
         CLLocationDistance distance = [parentLocation distanceFromLocation:childLocation];
         NSLog(@"%f",distance);
         CLLocationDistance kilometers = distance / 1000.0;
         NSLog(@"%f", kilometers);
         
         dispatch_async(dispatch_get_main_queue(), ^ {
                            if ([theDictionary objectForKey:@"childLatitude"] == nil) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                                                         message:@"Username Does Not Exist"
                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                [self presentViewController:alertController animated:YES completion:nil];
                            } else if (kilometers > self.radiusLength) {
                                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"outTheZone"] animated:YES completion:nil];
                            } else {
                                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"inTheZone"] animated:YES completion:nil];
                            };
                        });
     }];
    [downloadTask resume];
}


- (IBAction)updateButton:(id)sender {
    NSString *newUsername = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.usernameTextField.text];
    NSURL *url = [NSURL URLWithString:newUsername];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session= [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"PATCH";
    NSDictionary *userDetails =
    @{@"username":self.usernameTextField.text,@"latitude":self.latitudeTextField.text,@"longitude":self.longitudeTextField.text,@"radius":self.radiusTextField.text};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:kNilOptions error:&error];
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {    ////should be datataskwithrequest
            NSLog(@"Update Complete");
            if(error){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                                         message:[error localizedDescription]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                return ;
            }
        }];
        [uploadTask resume];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations {
    CLLocation *currentLocation = [locations lastObject];
    self.longitudeTextField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    self.latitudeTextField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    [self.locationManager stopUpdatingLocation];
}
@end
