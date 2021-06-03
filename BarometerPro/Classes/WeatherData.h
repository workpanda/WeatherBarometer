//
//  WeatherData.h
//  BarometerPro
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherData : NSObject <NSCoding>

@property(nonatomic) NSInteger temperatureC;
@property(nonatomic) NSInteger temperatureF;
@property(nonatomic) NSInteger humidity;
@property(nonatomic) NSInteger precipitation;
@property(nonatomic) float pressure;
@property(nonatomic) float pressureChange;
@property(nonatomic, copy) NSString *pressureChangeText;
@property(nonatomic, copy) NSString *weatherDescription;
@property(nonatomic, copy) NSString *placeName;
@property(nonatomic, copy) NSDate *sunrise;
@property(nonatomic, copy) NSDate *sunset;
@property(nonatomic, copy) NSDate *updatedAt;
@property(nonatomic,retain) NSString * iconName;

- (WeatherData *)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)weatherSymbol;
- (NSString *)weatherSymbolImageName;
- (NSString *)pressureTrendSymbol;
- (NSString *)temperature;

@end
