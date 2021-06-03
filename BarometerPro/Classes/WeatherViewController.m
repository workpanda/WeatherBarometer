//
//  WeatherViewController.m
//  BarometerPro
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//


#import <CoreMotion/CoreMotion.h>
#import "WeatherViewController.h"
#import "WeatherDataManager.h"
#import "WeatherIconsManager.h"
#import "SettingsManager.h"
#import "ForecastViewCell.h"
#import "DayForcast.h"
#import "Constants.h"


@interface WeatherViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) CMAltimeter *altimeterManager;
@property (nonatomic, strong) WeatherData *lastWeatherData;
@property (nonatomic, strong) WeatherData *weatherData;
@property (nonatomic, strong) WeatherData *weatherDataLocalized;
@property (nonatomic, strong) WeatherForecast *weatherForecast;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircleTemp;
@property (weak, nonatomic) IBOutlet UIView *viewTemp;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.barometerArrowLast.hidden = YES;
    [self updateLastPressureArrow];
    
    if([CMAltimeter isRelativeAltitudeAvailable]){
        self.altimeterManager = [[CMAltimeter alloc]init];
    } else {
        NSLog(@"Altimeter not available");
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTemperatureUnit)];
    [self.temperatureLabel addGestureRecognizer:tapGesture];
    [self.temperatureCircle addGestureRecognizer:tapGesture];
    [self.viewTemp addGestureRecognizer:tapGesture];

    
    self.lastWeatherData = [[SettingsManager sharedInstance] weatherData];
    [self updateLabelsWithWeatherData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[SettingsManager sharedInstance] showIntroductionScreen]) {
        [self performSegueWithIdentifier:@"IntroductionSegue" sender:self];
        [[SettingsManager sharedInstance] setShowIntroductionScreen:NO];
    } else {
        [self updateLastPressureArrow];
        [[WeatherDataManager sharedInstance] getWeatherData:^(WeatherData *weatherData, WeatherData *weatherDataLocalized, NSError *error) {
            if (error) {
                

                
            } else {
                self.weatherData = weatherData;
                self.weatherDataLocalized = weatherDataLocalized;
                [self updateLabelsWithWeatherData];
                [self updateBarometerNightView];
                [self animateBarometerArrowWithStartPressure:960.0 endPressure:self.weatherData.pressure duration:2.0];
                
                if (self.altimeterManager) {
                    [self.altimeterManager startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
                        float currentPressure = altitudeData.pressure.floatValue * 10;
                        self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", currentPressure];
                        [self animateBarometerArrowWithStartPressure:self.weatherData.pressure endPressure:currentPressure duration:1.0];
                        self.weatherData.pressure = currentPressure;
                        if (abs(self.weatherData.pressure - currentPressure) > 1) {
                            NSLog(@"Saving new pressure");
                            [[SettingsManager sharedInstance] setWeatherData:self.weatherData];
                        }
                    }];
                    NSLog(@"Started altimeter");
                }
            }
            
            [[WeatherDataManager sharedInstance] getWeatherForecast:^(WeatherForecast *weatherForecast, NSError *error) {
                if (error) {
                    NSLog(@"ERROR: %@", error);
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                                        message: error.description
                                                                                 preferredStyle: UIAlertControllerStyleAlert];
                    
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                                          style: UIAlertActionStyleDestructive
                                                                        handler: ^(UIAlertAction *action) {
                                                                            NSLog(@"Dismiss button tapped!");
                                                                            [self dismissViewControllerAnimated:YES completion:^{
                                                                                
                                                                            }];
                                                                        }];
                    
                    [controller addAction: alertAction];
                    
                    [self presentViewController: controller animated: YES completion: nil];
                } else {
                    self.weatherForecast = weatherForecast;
                    [self.collectionView reloadData];
                }
            }];
            
        }];
        
      
    }
}

- (void)openApp {
    NSLog(@"Opening the App");
}

- (void)updateLabelsWithWeatherData {
    
    NSString* country = [[NSUserDefaults standardUserDefaults] valueForKey:@"country"];
    NSString* city = [[NSUserDefaults standardUserDefaults] valueForKey:@"city"];
    
    NSString* domain = [NSString stringWithFormat:@"%@ %@",country,city];
    
    if (self.weatherData && self.weatherDataLocalized) {
        self.placeName.text = domain;
        if (self.weatherData.pressure > self.lastWeatherData.pressure) {
            self.pressureTrend.textColor = [UIColor redColor];
            self.pressureTrend.text = @"\uf044";
        } else if (self.weatherData.pressure < self.lastWeatherData.pressure) {
            self.pressureTrend.textColor = [UIColor colorWithRed:18.0/255.0 green:100.0/255.0 blue:18.0/255.0 alpha:1.0];
            self.pressureTrend.text = @"\uf058";
        } else {
            self.pressureTrend.textColor = [UIColor blackColor];
            self.pressureTrend.text = @"\uf04d";
        }
        self.weatherDescription.text = self.weatherDataLocalized.weatherDescription;
        self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", self.weatherData.pressure];
        self.humidityLabel.text = [NSString stringWithFormat:@"%lu %%", (unsigned long)self.weatherData.humidity];
        self.temperatureLabel.text = self.weatherData.temperature;

        
    } else if(self.weatherData) {
        
        self.placeName.text = domain;
        if (self.weatherData.pressure > self.lastWeatherData.pressure) {
            self.pressureTrend.textColor = [UIColor redColor];
            self.pressureTrend.text = @"\uf044";
        } else if (self.weatherData.pressure < self.lastWeatherData.pressure) {
            self.pressureTrend.textColor = [UIColor colorWithRed:18.0/255.0 green:100.0/255.0 blue:18.0/255.0 alpha:1.0];
            self.pressureTrend.text = @"\uf058";
        } else {
            self.pressureTrend.textColor = [UIColor blackColor];
            self.pressureTrend.text = @"\uf04d";
        }
        
        
        self.weatherDescription.text = self.weatherData.weatherDescription;
        
        self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", self.weatherData.pressure];
        self.temperatureLabel.text = self.weatherData.temperature;
        self.humidityLabel.text = [NSString stringWithFormat:@"%lu %%", (unsigned long)self.weatherData.humidity];
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0,0);;
        CGAffineTransform scale = CGAffineTransformMakeScale(1.0, 1.0);
        CGAffineTransform transform =  CGAffineTransformConcat(translate, scale);
        transform = CGAffineTransformRotate(transform, degreesToRadians(-135));
        self.barometerArrow.transform = transform;
    }
}

- (void)updateBarometerNightView {
    if (self.weatherData) {
        NSDate *now = [NSDate date];
        if (([self.weatherData.sunrise compare:now] == NSOrderedAscending) && ([self.weatherData.sunset compare:now] == NSOrderedDescending)) {
            self.barometer.image = [UIImage imageNamed:@"barometer"];
        } else {
            self.barometer.image = [UIImage imageNamed:@"barometer_night"];
        }
    }
}

- (void)updateLastPressureArrow {
    if (self.lastWeatherData) {
        self.barometerArrowLast.hidden = NO;
        self.barometerArrowLast.transform = CGAffineTransformMakeRotation(degreesToRadians([self hpAToDegree:self.lastWeatherData.pressure]));
    }
}

- (void)animateBarometerArrowWithStartPressure:(float)startPressure endPressure:(float)endPressure duration:(float)duration {
    if (startPressure < 960) {
        startPressure = 960;
    }
    if (endPressure < 960) {
        endPressure = 960;
    }
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:degreesToRadians([self hpAToDegree:startPressure])];
    spinAnimation.toValue = [NSNumber numberWithFloat:degreesToRadians([self hpAToDegree:endPressure])];
    spinAnimation.duration = duration;
    spinAnimation.removedOnCompletion = NO;
    spinAnimation.fillMode = kCAFillModeForwards;
    
    [self.barometerArrow.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

- (float)hpAToDegree:(float)hpA {
    float delta = hpA - 960;
    float degree = 2.7 * delta - 135;
    return degree;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTemperatureUnit {
    if (self.weatherData) {
        if ([[[SettingsManager sharedInstance] temperatureUnit] isEqualToString:@"C"]) {
            [[SettingsManager sharedInstance] setTemperatureUnit:@"F"];

        } else {
            [[SettingsManager sharedInstance] setTemperatureUnit:@"C"];
        }
        
        [self updateLabelsWithWeatherData];
        [self.collectionView reloadData];
    }
}

#pragma mark collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.weatherForecast) {
        return [self.weatherForecast.forcastItems count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ForecastViewCell *cell = (ForecastViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kCellForecast forIndexPath:indexPath];
    DayForcast *dayForecast = [self.weatherForecast.forcastItems objectAtIndex:indexPath.row];
    
    cell.dayName.text = [NSString stringWithFormat:@"%@.", [dayForecast.dayName substringToIndex:3]];
//    NSLog(@"Icon name: %@", dayForecast.iconName);
    cell.iconLabel.text = [[WeatherIconsManager sharedInstance] iconByName:dayForecast.iconName];
    cell.temperatureMax.text = dayForecast.temperatureMax;
    cell.temperatureMin.text = dayForecast.temperatureMin;
    
    return cell;
}

@end
