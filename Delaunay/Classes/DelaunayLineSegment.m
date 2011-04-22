//
//  DelaunayLineSegment.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayLineSegment.h"
#import "Delaunay.h"

@implementation DelaunayLineSegment

@synthesize  p0, p1;

+(DelaunayLineSegment *) lineSegmentWithLeftCoordinate: (CGPoint) left rightCoordinate: (CGPoint) right {
   DelaunayLineSegment *lx = [[[DelaunayLineSegment alloc] init] autorelease];
   lx.p0 = left;
   lx.p1 = right;
   return lx;
}

- (NSComparisonResult) compareLonger: (DelaunayLineSegment *) other {
   CGFloat length0 = [self length];
   CGFloat length1 = [other length];
   if (length0 < length1) {
      return NSOrderedAscending;
   } else if (length0 > length1) {
      return NSOrderedDescending;
   } else {
      return NSOrderedSame;
   }
}

- (NSComparisonResult) compareShorter:(DelaunayLineSegment *)other {
   return -[self compareLonger: other];
}

- (CGFloat) length {
   return sqrtf(SQUARED(p0.x - p1.x) + SQUARED(p0.y - p1.y));
}

@end
