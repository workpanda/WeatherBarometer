//
//  WeatherIconsManager.m
//  BarometerPro
//
//  Created by Andrew Teil on 04/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import "WeatherIconsManager.h"

@interface WeatherIconsManager()

@property(nonatomic, strong) NSArray *allItems;

@end

@implementation WeatherIconsManager

+ (WeatherIconsManager *) sharedInstance {
    static WeatherIconsManager *__instance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        __instance = [[WeatherIconsManager alloc] init];
    });
    
    return __instance;
}

- (NSArray *)allItems {
    if (!_allItems) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"weatherIcons" ofType:@"json"];
        if (filePath) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSError *error;
            _allItems = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if(error) {
                NSLog(@"Unable to parse json. Error: %@", error);
            }
        }
        else {
            NSLog(@"Unable to load weather icons");
        }
    }
    return _allItems;
}

- (NSString *)iconByName:(NSString *)name {
    for (NSDictionary *item in self.allItems) {
        if([name caseInsensitiveCompare:item[@"iconName"]] == NSOrderedSame ) {
            return item[@"iconCode"];
        }
    }
    return @"\uf013";
}

@end
