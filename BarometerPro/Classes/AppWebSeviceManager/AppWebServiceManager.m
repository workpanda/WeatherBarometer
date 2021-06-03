//
//  AppWebServiceManager.m
//  Game Day Swap
//
//  Created by Solafort Yong on 11/4/15.
//  Copyright © 2015 honeypanda. All rights reserved.
//

#import "AppWebServiceManager.h"

#import "WebServiceClient.h"
#import "Constants.h"

static AppWebServiceManager* appWebServiceManager = nil;

@implementation AppWebServiceManager

+(id)sharedAppWebServiceManager
{
    if(appWebServiceManager == nil)
    {
        appWebServiceManager = [[AppWebServiceManager alloc] init];
    }
    return appWebServiceManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        appWebServiceManager = self;
        
    }
    return self;
}

- (void )fetchWeatherDataForLocation:(CLLocation *)location completion:(void (^)(WeatherData *weatherData, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"http://dsx.weather.com/wxd/v2/MORecord/en_DE/%.2f,%.2f?api=%@", location.coordinate.latitude, location.coordinate.longitude,kAPIKey];
    NSDictionary *params = @{@"api": kAPIKey};

    [WebServiceClient getWithURL:urlString success:^(WebServiceClient *api, NSString *data) {
        
       // NSString* mainInfo = [data substringFromIndex:[data ]]
        
        NSData *jsonData =  [data dataUsingEncoding:NSUTF8StringEncoding];
        //colors is a NSArray property used as dataSource of TableView
        NSDictionary* dicInfo = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil];
        WeatherData *weatherData = [[WeatherData alloc] initWithDictionary:dicInfo];
        completion(weatherData, nil);

    } fail:^(WebServiceClient *api, NSError *error) {
        completion(nil,error);
    }];
    

}

- (void )fetchWeatherDataForLocationLocalized:(CLLocation *)location completion:(void (^)(WeatherData *weatherData, NSError *error))completion {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *languageCode = [NSString stringWithFormat:@"%@_%@", language, [language uppercaseString]];
    NSString *urlString = [NSString stringWithFormat:@"http://dsx.weather.com/wxd/v2/MORecord/%@/%.2f,%.2f?api=%@", languageCode, location.coordinate.latitude, location.coordinate.longitude,kAPIKey];
    NSDictionary *params = @{@"api": kAPIKey};

    [WebServiceClient getWithURL:urlString success:^(WebServiceClient *api, NSString *data) {
        NSData *jsonData =  [data dataUsingEncoding:NSUTF8StringEncoding];
        //colors is a NSArray property used as dataSource of TableView
        NSDictionary* dicInfo = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingAllowFragments
                                                        error:nil];
         WeatherData *weatherData = [[WeatherData alloc] initWithDictionary:dicInfo];
        completion(weatherData, nil);
        
    } fail:^(WebServiceClient *api, NSError *error) {
        completion(nil,error);
    }];

}

- (void )fetchWeatherForecastForLocation:(CLLocation *)location completion:(void (^)(WeatherForecast *weatherForecast, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"http://dsx.weather.com/wxd/v3/DFRecord/en_DE/%.2f,%.2f?api=%@", location.coordinate.latitude, location.coordinate.longitude,kAPIKey];
    NSDictionary *params = @{@"api": kAPIKey};

    [WebServiceClient getWithURL:urlString success:^(WebServiceClient *api, NSString *data) {
        NSData *jsonData =  [data dataUsingEncoding:NSUTF8StringEncoding];
        //colors is a NSArray property used as dataSource of TableView
        NSDictionary* dicInfo = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil];
        WeatherForecast *weatherForecast = [[WeatherForecast alloc] initWithDictionary:dicInfo];

        completion(weatherForecast, nil);
        
    } fail:^(WebServiceClient *api, NSError *error) {
        completion(nil,error);
    }];
}



@end
