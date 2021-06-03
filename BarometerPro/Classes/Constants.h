//
//  Constants.h
//  GeoBuddy
//
//  Created by Andrew Tarasenko on 27/01/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAPIBaseUrl;

extern NSString * const kAPIKey;

extern NSString * const kAPIDateFormat;

extern NSString * const kCellForecast;


/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )