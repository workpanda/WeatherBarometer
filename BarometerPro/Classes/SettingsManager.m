//
//  SettingsManager.m
//  nochoffen
//
//  Created by Andrew Tarasenko on 6/19/13.
//  Copyright (c) 2013 happy bits. All rights reserved.
//

#define SETTINGS_USER_PUSH_TOKEN @"settings.user_push_token"
#define SETTINGS_SHOW_INTRODUCTION_SCREEN @"settings.show_introduction_screen"
#define SETTINGS_TEMPERATURE_UNIT @"settings.temperature_unit"
#define APP_GROUP_ID @"group.de.estivo.BarometerPro"

#import "SettingsManager.h"

@interface SettingsManager()

@property(nonatomic, strong) NSString *weatherDataPath;
@property(nonatomic, strong) NSString *weatherDataLocalizedPath;
@property(nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation SettingsManager


+ (id)sharedInstance {
    static SettingsManager *__instance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        __instance = [[SettingsManager alloc] init];
    });
    
    return __instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *documentsDirectory = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        _weatherDataPath = [documentsDirectory stringByAppendingPathComponent:@"weatherData.dat"];
        _weatherDataLocalizedPath = [documentsDirectory stringByAppendingPathComponent:@"weatherDataLocalized.dat"];
        NSLog(@"Saving data in %@", _weatherDataPath);

        // Shared user defaults
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP_ID];
    }
    
    return self;
}

- (WeatherData *)weatherData {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:_weatherDataPath];
}

- (void)setWeatherData:(WeatherData *)weatherData {
    [NSKeyedArchiver archiveRootObject:weatherData toFile:_weatherDataPath];
}


- (WeatherData *)weatherDataLocalized {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:_weatherDataLocalizedPath];
}

- (void)setWeatherDataLocalized:(WeatherData *)weatherDataLocalized {
    [NSKeyedArchiver archiveRootObject:weatherDataLocalized toFile:_weatherDataLocalizedPath];
}

- (BOOL)showIntroductionScreen {
    NSNumber *value = [self.userDefaults valueForKey:SETTINGS_SHOW_INTRODUCTION_SCREEN];
    if (!value) {
        value = @(YES);
        [self.userDefaults setObject:value forKey:SETTINGS_SHOW_INTRODUCTION_SCREEN];
    }
    
    return [value boolValue];
}

- (void)setShowIntroductionScreen:(BOOL)showIntroductionScreen {
    [self.userDefaults setObject:@(showIntroductionScreen) forKey:SETTINGS_SHOW_INTRODUCTION_SCREEN];
    [self.userDefaults synchronize];
}

- (NSString *)temperatureUnit {
    NSString *value = [self.userDefaults valueForKey:SETTINGS_TEMPERATURE_UNIT];
    if (!value) {
        NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
        if ([localeIdentifier isEqualToString:@"en_US"]) {
            value = @"F";
        } else {
            value = @"C";
        }
        [self.userDefaults setObject:value forKey:SETTINGS_TEMPERATURE_UNIT];
    }
    
    return value;
}


- (void)setTemperatureUnit:(NSString *)temperatureUnit {
    [self.userDefaults setObject:temperatureUnit forKey:SETTINGS_TEMPERATURE_UNIT];
    [self.userDefaults synchronize];
}

@end
