//
//  NSArray+Delaunay.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSArray+Delaunay.h"
#import "DelaunayEdge.h"

@implementation NSArray (Delaunay)

- (NSArray *) delaunayLinesForEdges {
   NSMutableArray *result = [NSMutableArray array];
   for (DelaunayEdge *edge in self) {
      [result addObject: [edge delaunayLine]];
   }
   return result;
}

- (NSMutableArray *) reverse {
   NSMutableArray *reverse = [NSMutableArray array];
   for (id obj in self) {
      [reverse insertObject: obj atIndex: 0];
   }
   return reverse;
}

- (CGPoint) pointAtIndex: (NSInteger) index {
   return [[self objectAtIndex: index] CGPointValue];
}

@end
