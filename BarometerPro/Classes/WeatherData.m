//
//  WeatherData.m
//  BarometerPro
//
//  Created by Andrew Teil on 03/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "WeatherData.h"
#import "WeatherIconsManager.h"
#import "SettingsManager.h"


@implementation WeatherData

- (WeatherData *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *data = dictionary[@"MOData"];
        self.temperatureC = [data[@"tmpC"] integerValue];
        self.temperatureF = [data[@"tmpF"] integerValue];
        self.humidity = [data[@"rH"] integerValue];
        self.precipitation = [data[@"precipitation"] integerValue];
        self.pressure = [data[@"pres"] floatValue];
        self.pressureChange = [data[@"presChnge"] floatValue];
        self.pressureChangeText = data[@"baroTrndAsc"];
        self.weatherDescription = data[@"wx"];
        self.placeName = data[@"stnNm"];
        self.iconName = data[@"iconExt"];
        self.updatedAt = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        self.sunrise = [dateFormatter dateFromString:data[@"sunriseISO"]];
        self.sunset = [dateFormatter dateFromString:data[@"sunsetISO"]];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.temperatureC = [[aDecoder decodeObjectForKey:@"temperatureC"] integerValue];
        self.temperatureF = [[aDecoder decodeObjectForKey:@"temperatureF"] integerValue];
        self.humidity = [[aDecoder decodeObjectForKey:@"humidity"] integerValue];
        self.precipitation = [[aDecoder decodeObjectForKey:@"precipitation"] integerValue];
        self.pressure = [[aDecoder decodeObjectForKey:@"pressure"] floatValue];
        self.pressureChange = [[aDecoder decodeObjectForKey:@"pressureChange"] floatValue];
        self.pressureChangeText = [aDecoder decodeObjectForKey:@"pressureChangeText"];
        self.weatherDescription = [aDecoder decodeObjectForKey:@"iconName"];
        self.placeName = [aDecoder decodeObjectForKey:@"placeName"];
        self.sunrise = [aDecoder decodeObjectForKey:@"sunrise"];
        self.sunset = [aDecoder decodeObjectForKey:@"sunset"];
        self.updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.temperatureC] forKey:@"temperatureC"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.temperatureF] forKey:@"temperatureF"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.humidity] forKey:@"humidity"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.precipitation] forKey:@"precipitation"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.pressure] forKey:@"pressure"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.pressureChange] forKey:@"pressureChange"];
    [aCoder encodeObject:self.pressureChangeText forKey:@"pressureChangeText"];
    [aCoder encodeObject:self.weatherDescription forKey:@"iconName"];
    [aCoder encodeObject:self.placeName forKey:@"placeName"];
    [aCoder encodeObject:self.sunrise forKey:@"sunrise"];
    [aCoder encodeObject:self.sunset forKey:@"sunset"];
    [aCoder encodeObject:self.updatedAt forKey:@"updatedAt"];
}

- (NSString *)weatherSymbol {
    NSString *icon = [[WeatherIconsManager sharedInstance] iconByName:self.weatherDescription];
    return icon;
}

- (NSString *)weatherSymbolImageName {
    if (self.pressure < 995) {
        return @"rain";
    } else if (self.pressure > 1025) {
        return @"sunny";
    } else {
        return @"cloudy";
    }
}

- (NSString *)pressureTrendSymbol {
    if ([self.pressureChangeText isEqualToString:@"Rising"] || [self.pressureChangeText isEqualToString:@"Rising Rapidly"]) {
        return @"\uf058";
    } else if ([self.pressureChangeText isEqualToString:@"Falling"] || [self.pressureChangeText isEqualToString:@"Falling Rapidly"]) {
        return @"\uf044";
    } else {
        return @"\uf04d";
    }
}

- (NSString *)temperature {
    if ([[[SettingsManager sharedInstance] temperatureUnit] isEqualToString:@"C"]) {
        return [NSString stringWithFormat:@"%ld °C", (long)self.temperatureC];
    } else {
        return [NSString stringWithFormat:@"%ld °F", (long)self.temperatureF];
    }
}

@end
