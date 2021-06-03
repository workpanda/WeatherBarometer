//
//  LocationManager.h
//  NochOffen
//
//  Created by Andrew Tarasenko on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol LocationManagerDelegate <NSObject>
@optional
- (void)didStartUpdatingLocation;

- (void)didStopUpdatingLocation;

- (void)didSuccessUpdatingLocation:(CLLocation *)location;

- (void)didFailureUpdatingLocationWithError:(NSError *)error;

@end


@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager *)sharedInstance;

- (void)start;

- (void)stop;

- (void)checkLocationServicesTurnedOn;

- (void)checkApplicationHasLocationServicesPermission;

- (void)getCurrentLocation:(void (^)(CLLocation *location, NSError *error))completion;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, readonly) BOOL locationKnown;
@property(nonatomic, retain) CLLocation *currentLocation;
@property(nonatomic, weak) id <LocationManagerDelegate> delegate;

@end
