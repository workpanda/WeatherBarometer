//
//  IntroductionViewController.m
//  BarometerPro
//
//  Created by Andrew Teil on 17/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "IntroductionViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![CMAltimeter isRelativeAltitudeAvailable]){
        self.altimeterAvailableLable.text = @"";
    }
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
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
