//
//  ForecastViewCell.h
//  BarometerPro
//
//  Created by Andrew Teil on 18/11/14.
//  Copyright (c) 2014 estivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayName;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMax;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMin;

@end
