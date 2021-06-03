//
//  LocationManager.h
//  NochOffen
//
//  Created by Andrew Tarasenko on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>

@interface LocationManager () {
    BOOL _isLocationManagerStarted;
    dispatch_semaphore_t _semaphore;
}

@end

@implementation LocationManager

static LocationManager *sharedInstance;

+ (LocationManager *)sharedInstance {
    static LocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];

    });

    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _locationKnown = NO;
        _currentLocation = [[CLLocation alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.activityType = CLActivityTypeOther;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)start {
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    _isLocationManagerStarted = YES;
    [self.delegate didStartUpdatingLocation];
    NSLog(@"Start updating location");
}

- (void)stop {
    [_locationManager stopUpdatingLocation];
    _isLocationManagerStarted = NO;
    if ([self.delegate respondsToSelector:@selector(didStopUpdatingLocation)]) {
        [self.delegate didStopUpdatingLocation];
    }

    NSLog(@"Stop updating location");
}

- (void)checkLocationServicesTurnedOn {
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"'Location Services' need to be on");
    }
}

- (void)checkApplicationHasLocationServicesPermission {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"'Location Services' need to be on");
    }
}

- (void)getCurrentLocation:(void (^)(CLLocation *location, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        if (!_isLocationManagerStarted) {
            [self start];
        }
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        if (_isLocationManagerStarted) {
            [self stop];
        }
        if (self.locationKnown) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (completion) {
                    
                    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
                    [geoCoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                        if (error)
                        {
                        
                        }
                        else
                        {
                            for (CLPlacemark * placemark in placemarks)
                            {
                                
                                NSLog(@"place: %@, %@",placemark.locality, placemark.country);
                                
                                NSString* city= placemark.locality;
                                NSString* country = placemark.country;
                                
                                [[NSUserDefaults standardUserDefaults] setValue:country forKey:@"country"];
                                [[NSUserDefaults standardUserDefaults] setValue:city forKey:@"city"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            
                                
                            }
                            
                            
                        }
                        
                       
                    }];
                    
                    completion(self.currentLocation, nil);
                   
                }
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(completion) {
                    completion(nil, nil);
                }
            });
        }
    });
}

#pragma mark CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self locationUpdated:[locations lastObject]];
}

- (void)locationUpdated:(CLLocation *)newLocation {
    self.currentLocation = newLocation;
    NSDate *eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0) {
        // If the event is recent, do something with it.
        NSLog(@"Location updated: latitude %+.6f, longitude %+.6f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

        if ([self.delegate respondsToSelector:@selector(didSuccessUpdatingLocation:)]) {
            [self.delegate didSuccessUpdatingLocation:self.currentLocation];
        }
        dispatch_semaphore_signal(_semaphore);
    }

    if (!_locationKnown) {
        NSLog(@"Location is now known");
        _locationKnown = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unable to determine location. %@", error.description);
    if ([self.delegate respondsToSelector:@selector(didFailureUpdatingLocationWithError:)]) {
        [self.delegate didFailureUpdatingLocationWithError:error];
    }
}

@end