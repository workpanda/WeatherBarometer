//
//  TodayViewController.m
//  Weather Widget
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "TodayViewController.h"
#import "WeatherDataManager.h"
#import "SettingsManager.h"
#import <CoreMotion/CoreMotion.h>
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) CMAltimeter *altimeterManager;
@property (nonatomic, strong) WeatherData *weatherData;
@property (nonatomic, strong) WeatherData *weatherDataLocalized;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 80);
    
    UITapGestureRecognizer *tapRecognizerLaunchApp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchApp)];
    UITapGestureRecognizer *tapRecognizerChangeTemperatureUnit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTemperatureUnit)];
    [self.touchView addGestureRecognizer:tapRecognizerLaunchApp];
    [self.temperatureLabel addGestureRecognizer:tapRecognizerChangeTemperatureUnit];
    
    if([CMAltimeter isRelativeAltitudeAvailable]){
        self.altimeterManager = [[CMAltimeter alloc]init];
    } else {
        NSLog(@"Altimeter not available");
    }
    
    [self updateLabelsWithWeatherData];
    [[WeatherDataManager sharedInstance] getWeatherData:^(WeatherData *weatherData, WeatherData *weatherDataLocalized, NSError *error) {
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
            if(weatherData != nil){
                self.weatherData = weatherData;
                self.weatherDataLocalized = weatherDataLocalized;
                [self updateLabelsWithWeatherData];
            }else{
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
            }
        }
    }];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)updateLabelsWithWeatherData {
    if (self.weatherData && self.weatherDataLocalized) {
        self.weatherIcon.image = [UIImage imageNamed:self.weatherData.weatherSymbolImageName];
        self.pressureTrend.text = self.weatherData.pressureTrendSymbol;
        self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", self.weatherData.pressure];
        self.pressureTrendText.text = self.weatherDataLocalized.pressureChangeText;
        self.weatherDescription.text = self.weatherDataLocalized.weatherDescription;
        self.temperatureLabel.text = self.weatherData.temperature;
        self.humidityLabel.text = [NSString stringWithFormat:@"%lu %%", (unsigned long)self.weatherData.humidity];
        
        if (self.altimeterManager) {
            [self.altimeterManager startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
                float currentPressure = altitudeData.pressure.floatValue * 10;
                self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", currentPressure];
                self.weatherData.pressure = currentPressure;
                self.weatherIcon.image = [UIImage imageNamed:self.weatherData.weatherSymbolImageName];
                if (abs(self.weatherData.pressure - currentPressure) > 1) {
                    NSLog(@"Saving new pressure");
                    [[SettingsManager sharedInstance] setWeatherData:self.weatherData];
                }
            }];
            NSLog(@"Started altimeter");
        }
    }else if(self.weatherData){
        self.weatherIcon.image = [UIImage imageNamed:self.weatherData.weatherSymbolImageName];
        self.pressureTrend.text = self.weatherData.pressureTrendSymbol;
        self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", self.weatherData.pressure];
        self.pressureTrendText.text = self.weatherData.pressureChangeText;
        self.weatherDescription.text = self.weatherData.weatherDescription;
        self.temperatureLabel.text = self.weatherData.temperature;
        self.humidityLabel.text = [NSString stringWithFormat:@"%lu %%", (unsigned long)self.weatherData.humidity];
        
        if (self.altimeterManager) {
            [self.altimeterManager startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
                float currentPressure = altitudeData.pressure.floatValue * 10;
                self.pressureLabel.text = [NSString stringWithFormat:@"%.1f hpA", currentPressure];
                self.weatherData.pressure = currentPressure;
                self.weatherIcon.image = [UIImage imageNamed:self.weatherData.weatherSymbolImageName];
                if (abs(self.weatherData.pressure - currentPressure) > 1) {
                    NSLog(@"Saving new pressure");
                    [[SettingsManager sharedInstance] setWeatherData:self.weatherData];
                }
            }];
            NSLog(@"Started altimeter");
        }
        
        
    }
    else {
        self.pressureTrend.text = @"\uf04d";
        self.pressureTrendText.text = @"";
        self.pressureLabel.text = @"---- hpA";
        self.temperatureLabel.text = @"---";
        self.humidityLabel.text = @"---";
    }
    
}

- (void)changeTemperatureUnit {
    if (self.weatherData) {
        if ([[[SettingsManager sharedInstance] temperatureUnit] isEqualToString:@"C"]) {
            [[SettingsManager sharedInstance] setTemperatureUnit:@"F"];
            
        } else {
            [[SettingsManager sharedInstance] setTemperatureUnit:@"C"];
        }
        
        [self updateLabelsWithWeatherData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    [self updateLabelsWithWeatherData];
    
    completionHandler(NCUpdateResultNewData);
}


- (void)launchApp {
    NSURL *url = [NSURL URLWithString:@"barometerpro://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

@end
