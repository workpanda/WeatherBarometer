//
//  WeatherForecast.m
//  BarometerPro
//
//  Created by Andrew Teil on 18/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "WeatherForecast.h"
#import "DayForcast.h"

@implementation WeatherForecast

- (WeatherForecast *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *data = dictionary[@"DFData"];
        NSMutableArray *forecastItems = [NSMutableArray array];
        
        for (NSDictionary *forecastDict in data) {
            DayForcast *forecast = [[DayForcast alloc] initWithDictionary:forecastDict];
            [forecastItems addObject:forecast];
        }
        self.forcastItems = forecastItems;
    }
    
    return self;
}

- (NSString *)description {
    return @"Weather forcast";
}

@end
