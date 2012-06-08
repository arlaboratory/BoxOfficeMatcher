//
//  ViewController.h
//  appleProductScanner
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//
#define tmdImageURL @"http://cf2.imgobject.com/t/p/w342"

#define API_KEY @"33UIqVTjawzALYJqP/nhApazE8xonJgE7QhpnyDUfw=="

#import <UIKit/UIKit.h>
#import <CVSDK/cvsdk.h>
#import "MainViewController.h"
#import "DLStarRatingControl.h"


@interface ViewController : UIViewController <matcherProtocol>
{
    cvSDK* _cvView;
    IBOutlet UIView *_matchView;
    NSArray* _moviesArray;
    
    IBOutlet UIView *_popupView;
    IBOutlet UILabel *_popupLable;
    IBOutlet UIImageView *_popupImg;
    IBOutlet UIView *_starsView;
    IBOutlet UILabel *_ratingLable;
    
    DLStarRatingControl* _stars;
    Movie* _currentMovie;
    MainViewController* mainController;
    UIAlertView *alert;
}

@property (nonatomic, strong) IBOutlet UIButton *updateBTN;
@property (nonatomic) BOOL first;

/**
 *
 *Show information about the movie.
 *
 */
- (IBAction)popupClicked:(id)sender;

/**
 *
 *Update the movies.
 *
 */
-(IBAction)updateMovies:(id)sender;

+(bool)getPopUpActive;
@end
