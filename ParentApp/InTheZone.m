//
//  inTheZone.m
//  ParentApp
//
//  Created by amir sankar on 4/22/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import "InTheZone.h"

@interface InTheZone ()
-(IBAction)theButton:(id)sender;

@end

@implementation InTheZone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)theButton:(id)sender{
    [self performSegueWithIdentifier:@"returnToMainView" sender:self];
}

@end
