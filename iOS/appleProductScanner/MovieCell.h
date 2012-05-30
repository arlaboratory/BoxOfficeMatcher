//
//  MovieCell.h
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface MovieCell : UITableViewCell
{
    UILabel* _ratingLable;
}

@property (strong, nonatomic) DLStarRatingControl* stars;
@property (assign, nonatomic) int rating;

@end
