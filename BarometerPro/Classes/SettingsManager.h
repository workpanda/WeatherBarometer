//
//  SettingsManager.h
//  nochoffen
//
//  Created by Andrew Tarasenko on 6/19/13.
//  Copyright (c) 2013 happy bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface SettingsManager : NSObject

+ (SettingsManager *) sharedInstance;

@property (nonatomic, copy) WeatherData *weatherData;
@property (nonatomic, copy) WeatherData *weatherDataLocalized;

@property(nonatomic) BOOL showIntroductionScreen;

@property(nonatomic, copy) NSString *temperatureUnit;

@end
