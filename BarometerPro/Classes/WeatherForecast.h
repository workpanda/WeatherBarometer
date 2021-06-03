//
//  WeatherForecast.h
//  BarometerPro
//
//  Created by Andrew Teil on 18/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecast : NSObject

@property (nonatomic, copy) NSArray *forcastItems;


- (WeatherForecast *)initWithDictionary:(NSDictionary *)dictionary;

@end
