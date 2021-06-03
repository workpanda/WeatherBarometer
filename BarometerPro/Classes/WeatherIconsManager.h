//
//  WeatherIconsManager.h
//  BarometerPro
//
//  Created by Andrew Teil on 04/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherIconsManager : NSObject

+ (WeatherIconsManager *) sharedInstance;

- (NSString *)iconByName:(NSString *)name;

@end
