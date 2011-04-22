//
//  Delaunay.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "Delaunay.h"


@implementation NSMutableArray (Delaunay)


- (void) addPoint: (CGPoint) point {
   [self addObject: [NSValue valueWithCGPoint: point]];
}

@end
