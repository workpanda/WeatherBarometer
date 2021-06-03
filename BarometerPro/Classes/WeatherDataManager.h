//
//  WeatherDataManager.h
//  BarometerPro
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"
#import "WeatherForecast.h"

@interface WeatherDataManager : NSObject

+ (WeatherDataManager *) sharedInstance;

- (void)getWeatherData:(void (^)(WeatherData *weatherData, WeatherData *weatherDataLocalized, NSError *error))completion;

- (void)getWeatherForecast:(void (^)(WeatherForecast *weatherForecast, NSError *error))completion;

@end
