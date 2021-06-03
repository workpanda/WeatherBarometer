//
//  WeatherDataManager.m
//  BarometerPro
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "WeatherDataManager.h"
#import "SettingsManager.h"
#import "AppWebServiceManager.h"
#import "LocationManager.h"

@implementation WeatherDataManager

+ (WeatherDataManager *)sharedInstance {
    static WeatherDataManager *__instance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        __instance = [[WeatherDataManager alloc] init];
    });
    
    return __instance;
}

- (void)getWeatherData:(void (^)(WeatherData *weatherData, WeatherData *weatherDataLocalized, NSError *error))completion {
    WeatherData *weatherData = [[SettingsManager sharedInstance] weatherData];
    WeatherData *weatherDataLocalized = [[SettingsManager sharedInstance] weatherDataLocalized];
    NSTimeInterval howRecent = abs([weatherData.updatedAt timeIntervalSinceNow]);
//    if (YES) {
    if (!weatherData || howRecent > 900) {
        [[LocationManager sharedInstance] getCurrentLocation:^(CLLocation *location, NSError *error) {
            if (error) {
                NSLog(@"No location");
            } else {

                [[AppWebServiceManager sharedAppWebServiceManager] fetchWeatherDataForLocation:location completion:^(WeatherData *weatherData, NSError *error) {
                    if (error) {
                        NSLog(@"ERROR: %@", error);
                        completion(nil, nil, error);
                    } else {
                        [[SettingsManager sharedInstance] setWeatherData:weatherData];
                      
                        [[AppWebServiceManager sharedAppWebServiceManager] fetchWeatherDataForLocationLocalized:location completion:^(WeatherData *weatherData, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"ERROR: %@", error);
                                                            completion([[SettingsManager sharedInstance] weatherData], nil, nil);
                                                        } else {
                                                            
                                                            [[SettingsManager sharedInstance] setWeatherDataLocalized:weatherData];
                                                            
                                                            completion([[SettingsManager sharedInstance] weatherData], [[SettingsManager sharedInstance] weatherDataLocalized], nil);
                                                        }
                        }];
                    }
                }];
            }
        }];
    } else {
        completion(weatherData, weatherDataLocalized, nil);
    }
}

- (void)getWeatherForecast:(void (^)(WeatherForecast *weatherForecast, NSError *error))completion {
    [[LocationManager sharedInstance] getCurrentLocation:^(CLLocation *location, NSError *error) {
        if (error) {
            NSLog(@"No location");
        } else {

            [[AppWebServiceManager sharedAppWebServiceManager] fetchWeatherForecastForLocation:location completion:^(WeatherForecast *weatherForecast, NSError *error) {
                if (error) {
                    NSLog(@"ERROR: %@", error);
                    completion(nil, error);
                } else {
                    completion(weatherForecast, nil);
                }
            }];
        }
    }];
}

@end
