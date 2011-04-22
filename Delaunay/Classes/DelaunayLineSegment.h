//
//  DelaunayLineSegment.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelaunayLineSegment : NSObject {
    
}

@property (nonatomic, assign) CGPoint p0;
@property (nonatomic, assign) CGPoint p1;

+(DelaunayLineSegment *) lineSegmentWithLeftCoordinate: (CGPoint) left rightCoordinate: (CGPoint) right;


- (NSComparisonResult) compareLonger: (DelaunayLineSegment *) other;
- (NSComparisonResult) compareShorter: (DelaunayLineSegment *) other;
- (CGFloat) length;


@end
