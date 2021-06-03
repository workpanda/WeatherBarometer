//
//  DayForcast.m
//  BarometerPro
//
//  Created by Andrew Teil on 18/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "DayForcast.h"
#import "SettingsManager.h"


@implementation DayForcast


- (DayForcast *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.dayName = dictionary[@"dow"];
        self.dayNumber = [dictionary[@"dyNum"] integerValue];
        self.temperatureMinC = [dictionary[@"loTmpC"] integerValue];
        self.temperatureMaxC = [dictionary[@"hiTmpC"] integerValue];
        self.temperatureMinF = [dictionary[@"loTmpF"] integerValue];
        self.temperatureMaxF = [dictionary[@"hiTmpF"] integerValue];
        self.iconName = dictionary[@"snsblWx12_24"];
    }
    
    return self;
}

- (NSString *)temperatureMin {
    if ([[[SettingsManager sharedInstance] temperatureUnit] isEqualToString:@"C"]) {
        return [NSString stringWithFormat:@"%ld°", (long)self.temperatureMinC];
    } else {
        return [NSString stringWithFormat:@"%ld°", (long)self.temperatureMinF];
    }
}
- (NSString *)temperatureMax {
    if ([[[SettingsManager sharedInstance] temperatureUnit] isEqualToString:@"C"]) {
        return [NSString stringWithFormat:@"%ld°", (long)self.temperatureMaxC];
    } else {
        return [NSString stringWithFormat:@"%ld°", (long)self.temperatureMaxF];
    }
}

@end
