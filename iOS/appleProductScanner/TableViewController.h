//
//  TableViewController.h
//  boxOfficeMatcher
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#define ROW_iPhone 71
#define ROW_iPad 178

#define xStartTitle_iPhone 60
#define yStartTitle_iPhone 3
#define WidthTitle_iPhone 250
#define heigthTitle_iPhone 30

#define xStartImage_iPhone 5
#define WidthImage_iPhone 50
#define heigthImage_iPhone 71

#define xStartStar_iPhone 60
#define yStartStar_iPhone 35
#define WidthStar_iPhone 170
#define heigthStar_iPhone 20

#define xStartRating_iPhone 235
#define yStartRating_iPhone 33
#define WidthRating_iPhone 100
#define heigthRating_iPhone 30


#define xStartTitle_iPad 145
#define yStartTitle_iPad 3
#define WidthTitle_iPad 620
#define heigthTitle_iPad 78

#define xStartImage_iPad 20
#define WidthImage_iPad 120
#define heigthImage_iPad 179

#define xStartStar_iPad 145
#define yStartStar_iPad 80
#define WidthStar_iPad 350
#define heigthStar_iPad 70

#define xStartRating_iPad 500
#define yStartRating_iPad 78
#define WidthRating_iPad 200
#define heigthRating_iPad 80


#define SizeTitle_iPhone 20.0
#define SizeTitle_iPad 35.0

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface TableViewController : UITableViewController
{
    int indice;
};

@property (nonatomic, strong) NSArray* _moviesArray;

/**
 *
 *Initialize the table.
 *
 */
-(id)myInit;

@end
