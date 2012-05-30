//
//  ARQrCodeLib.h
//  ARQrCodeLib
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Roi.h"

@protocol ARQrCodeLibProtocol <NSObject>

@optional
/**
 *  Optional callback: Called when a more than one QR or BAR codes found
 *  @param codes: Array of ROIs found each ROI has the CGRect defining the crop rectangle and the QR string representation
 */
-(void)qrCodesFound:(NSArray*)codes;

@end

@interface ARQrCodeLib : UIViewController

/**
 *  Process a frame and searches for a QR code in it.
 * 
 *  @param image to be processed
 */
- (NSArray*) processFrame:(CGImageRef)image;

/**
 *  Process a frame region and searches for a QR code in it.
 * 
 *  @param image to be processed
 *  @param rect: region within the frame to be processed.
 */
- (NSString*)processFrame:(CGImageRef)image inRec:(CGRect)rect;

/**
 *  Start the phone camera and start the QR processing.
 */
- (void)start;
/**
 *  Stop the phone camera and stop the QR processing.
 */
- (void)stop;
/**
 *  Add ROI (region of interest) to be processed
 *
 * @param ROI
 */
- (BOOL)addRoi:(Roi*)roi;
/**
 *  Remove ROI (region of interest).
 *
 * @param ROI
 */
- (BOOL)removeRoi:(Roi*)roi;
/**
 *  Remove all regions of interest.
 *
 */
- (void)removeAllRois;
/**
 *  Callback delegate.
 */
@property (assign, nonatomic) id<ARQrCodeLibProtocol> delegate;
/**
 *  Array of regions of interest. Four max per frame.
 */
@property (nonatomic,strong,readonly) NSMutableArray* roiArray;

@end
