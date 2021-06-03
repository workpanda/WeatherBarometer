//
//  DayForcast.h
//  BarometerPro
//
//  Created by Andrew Teil on 18/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayForcast : NSObject

@property(nonatomic, copy) NSString *dayName;
@property(nonatomic) NSInteger dayNumber;
@property(nonatomic) NSInteger temperatureMinC;
@property(nonatomic) NSInteger temperatureMaxC;
@property(nonatomic) NSInteger temperatureMinF;
@property(nonatomic) NSInteger temperatureMaxF;
@property(nonatomic, copy) NSString *iconName;

- (DayForcast *)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)temperatureMin;
- (NSString *)temperatureMax;

@end
