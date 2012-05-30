//
//  MovieInfo.h
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "movie.h"
#import "DLStarRatingControl.h"
#import <QuartzCore/QuartzCore.h>

@interface MovieInfo : UIViewController
{
    DLStarRatingControl* _stars;
}
@property (strong, nonatomic) Movie* movie;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *poster;
@property (strong, nonatomic) IBOutlet UIView *starsView;
@property (strong, nonatomic) IBOutlet UILabel *tagline;
@property (strong, nonatomic) IBOutlet UITextView *overview;
@property (strong, nonatomic) IBOutlet UILabel *ratingLable;
@property (strong, nonatomic) IBOutlet UILabel *releaseDate;
@property (strong, nonatomic) IBOutlet UILabel *runtime;
@property (strong, nonatomic) IBOutlet UILabel *language;
@property (strong, nonatomic) IBOutlet UIButton *trailerLinkBTN;
@property (strong, nonatomic) IBOutlet UIButton *WebLinkBTN;

/**
 *
 *Go back.
 *
 */
-(IBAction)back_touch:(id)sender;

/**
 *
 *Launch an external web with the trailer of the selected movie.
 *
 */
-(IBAction)trailer_touch:(id)sender;

/**
 *
 *Launch an external web associated with the selected movie.
 *
 */
-(IBAction)link_touch:(id)sender;

/**
 *
 *Reduce the size of a image if the specified size is smaller than the original size of the image.
 *
 *@param [UIImage]imagename Image we want to reduce its size.
 *@param [float]value1 width of the reduced image.
 *@param [float]value2 height of the reduced image.
 *
 *@return image.
 *
 */
+(UIImage*)imagesmall:(UIImage*)imagename width:(float)value1 height:(float)value2;
@end
