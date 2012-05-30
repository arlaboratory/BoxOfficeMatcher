//
//  Roi.h
//  ARBarReader
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * This class defindes the ROI object (region of interest).
 * When matching QR codes the user will be able to define up to four ROIs to read up to four codes a time.
 *
 */

@interface Roi : NSObject

/**
 * CGRect that defines de ROI.
 */
@property (assign, nonatomic) CGRect roiRect;

/**
 * (Optional). String associated to the ROI.
 * Can be used to identify the ROI in the callback. 
 * By default each ROI will be identified by its CGRect.
 */
@property (strong, nonatomic) NSString* qrString;


/**
 * @brief Init ROI CGRect
 *
 * @param CGRect that defindes de ROI.
 * @return id.
 */
-(id)initWithRect:(CGRect)rect;

@end
