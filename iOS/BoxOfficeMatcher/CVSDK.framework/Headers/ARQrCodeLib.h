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
-(void)qrCodesFound:(NSArray*)codes;

@end

@interface ARQrCodeLib : UIViewController

- (NSArray*) processFrame:(CGImageRef)image;
- (NSString*)processFrame:(CGImageRef)image inRec:(CGRect)rect;

- (void)start;
- (void)stop;

- (BOOL)addRoi:(Roi*)roi;
- (BOOL)removeRoi:(Roi*)roi;
- (void)removeAllRois;

@property (assign, nonatomic) id<ARQrCodeLibProtocol> delegate;
@property (nonatomic,strong,readonly) NSMutableArray* roiArray;

@end
