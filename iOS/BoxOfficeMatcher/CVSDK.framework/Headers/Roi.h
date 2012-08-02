//
//  Roi.h
//  ARBarReader
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Roi : NSObject

@property (assign, nonatomic) CGRect roiRect;
@property (strong, nonatomic) NSString* qrString;

-(id)initWithRect:(CGRect)rect;

@end
