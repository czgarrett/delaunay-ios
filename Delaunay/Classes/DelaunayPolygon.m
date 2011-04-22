//
//  DelaunayPolygon.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayPolygon.h"
#import "NSArray+Delaunay.h"

@implementation DelaunayPolygon

@synthesize vertices;

+ (DelaunayPolygon *) polygonWithVertices: (NSMutableArray *) vertices {
   DelaunayPolygon *result = [[[DelaunayPolygon alloc] init] autorelease];
   result.vertices = vertices;
   return result;
}


- (void) dealloc {
   [vertices release];
   [super dealloc];
}

- (float) area {
   return ABS([self signedDoubleArea] * 0.5);
}

- (DelaunayWinding) winding {
   float signedDoubleArea = [self signedDoubleArea];
   if (signedDoubleArea < 0.0) {
      return DelaunayWindingClockwise;
   } else if (signedDoubleArea > 0.0) {
      return DelaunayWindingCounterClockwise;
   } else {
      return DelaunayWindingNone;
   }
}

- (float) signedDoubleArea {
   NSUInteger index, nextIndex;
   NSUInteger n = [vertices count];
   CGPoint point, next;
   float result = 0.0;

   for (index = 0; index < n; index++)
   {
      nextIndex = (index + 1) % n;
      point = [vertices pointAtIndex: index];
      next = [vertices pointAtIndex: nextIndex];
      result += point.x * next.y - next.x * point.y;
   }
   return result;
}


@end
