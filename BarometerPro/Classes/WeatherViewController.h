//
//  WeatherViewController.h
//  BarometerPro
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *barometer;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *pressureTrend;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureIcon;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureCircle;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainFrostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barometerArrow;
@property (weak, nonatomic) IBOutlet UIImageView *barometerArrowLast;

@end
