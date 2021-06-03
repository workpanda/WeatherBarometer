//
//  AppWebServiceManager.h
//  Game Day Swap
//
//  Created by Solafort Yong on 11/4/15.
//  Copyright © 2015 honeypanda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import "WeatherData.h"
#import "WeatherForecast.h"

@protocol AppWebServiceDelegate <NSObject>



@end

@interface AppWebServiceManager : NSObject

@property(nonatomic,retain) id<AppWebServiceDelegate> delegate;

+(id)sharedAppWebServiceManager;

#pragma mark - Sevice Functions
- (void)fetchWeatherDataForLocation:(CLLocation *)location completion:(void (^)(WeatherData *weatherData, NSError *error))completion;
- (void)fetchWeatherDataForLocationLocalized:(CLLocation *)location completion:(void (^)(WeatherData *weatherData, NSError *error))completion;
- (void)fetchWeatherForecastForLocation:(CLLocation *)location completion:(void (^)(WeatherForecast *weatherForecast, NSError *error))completion;

@end
