//
//  MainViewController.h
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#define xStartProgress 30.0f
#define yStartProgress 60.0f
#define WidthProgress 225.0f
#define HeightProgress 90.0f

#define xStartLabel1 135.0f
#define yStartLabel1 67.0f
#define WidthLabel1 50.0f
#define HeightLabel1 40.0f

#define xStartImage 200.0f
#define yStartImage 5.0f
#define WidthImage 100.0f
#define HeightImage 50.0f

#define SizeLabel 12.0f

#import <UIKit/UIKit.h>
#import "moviesDataHandler.h"

@interface MainViewController : UITabBarController
{
    NSDate* currentDate;
    float stepProgress;
    int image;
    int totalImages;
}

@property (strong, nonatomic) moviesDataHandler* moviesHandler;
@property (nonatomic, strong)IBOutlet UIProgressView *myProgressView;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic) bool updateMovies;

/**
 *
 *Remove the alert which contains the UIProgressView.
 *
 */
-(void)removeAlert:(NSNotification*)notification;

@end
