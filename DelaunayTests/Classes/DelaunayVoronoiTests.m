//
//  DelaunayVoronoiTests.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayVoronoiTests.h"
#import "DelaunayVoronoi.h"
#import "DelaunaySite.h"
#import "DelaunayPolygon.h"

@implementation DelaunayVoronoiTests

- (void)setUp {
   point0 = CGPointMake(0, 0);
   point1 = CGPointMake(5, 5);
   point2 = CGPointMake(0, 10);
   point3 = CGPointMake(-10, -10);
   points = [NSMutableArray arrayWithObjects: [NSValue valueWithCGPoint: point0],
                                              [NSValue valueWithCGPoint: point1],
                                              [NSValue valueWithCGPoint: point2],
                                              //[NSValue valueWithCGPoint: point3],
                                              nil];
   plotBounds = CGRectMake(-20, -20, 40, 40);
   voronoi = [DelaunayVoronoi voronoiWithPoints: points plotBounds: plotBounds];
   [voronoi retain];
   [points retain];
}

- (void) tearDown {
   [voronoi release];
   [points release];
}

/*
- (void) testCorrectNumberOfEdges {
   NSInteger expected = 3;
   NSInteger count = [voronoi.edges count];
   NSLog(@"%@", voronoi);
   STAssertTrue(count == expected, @"Incorrect number of voronoi edges.  Expected %d, got %d", expected, count);
}
 */

- (void) testRegionsHaveNoDuplicatedPoints {
   for (NSArray *region in [voronoi regions])   {
      NSMutableArray *sortedRegion = [NSMutableArray arrayWithArray: region];
      [sortedRegion sortUsingComparator: ^(id obj0, id obj1) {
         CGPoint p0 = [obj0 CGPointValue];
         CGPoint p1 = [obj1 CGPointValue];
         if (p0.y < p1.y) return NSOrderedAscending;
         if (p0.y > p1.y) return NSOrderedDescending;
         if (p0.x < p1.x) return NSOrderedAscending;
         if (p0.x > p1.x) return NSOrderedDescending;
         return NSOrderedSame;
      }];
       for (int i=1; i< [sortedRegion count]; i++) {
          CGPoint p0 = [[sortedRegion objectAtIndex:i] CGPointValue];
          CGPoint p1 = [[sortedRegion objectAtIndex: i - 1] CGPointValue];
          STAssertFalse(CGPointEqualToPoint(p0, p1), @"Found duplicate: p0 = %f, %f p1 = %f, %f", p0.x, p0.y, p1.x, p1.y);
      }
   }
}

- (void) testRegionsPointsAreInCounterclockwiseOrder
{
   for (NSMutableArray *region in [voronoi regions])
   {
      NSLog(@"Region: %@", region);
      DelaunayPolygon *polygon = [DelaunayPolygon polygonWithVertices: region];
      STAssertEquals([polygon winding], DelaunayWindingCounterClockwise, @"Incorrect winding");
   }
}



@end
