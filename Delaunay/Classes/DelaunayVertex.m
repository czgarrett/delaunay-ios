//
//  DelaunayVertex.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayVertex.h"
#import "DelaunayHalfEdge.h"
#import "DelaunayEdge.h"
#import "DelaunayVoronoi.h"
#import "DelaunaySite.h"
#import "DelaunayOrientation.h"

@implementation DelaunayVertex

DelaunayVertex *vertexAtInfinity;

@synthesize coordinates;

+ (DelaunayVertex *) vertexWithX: (CGFloat) x y: (CGFloat) y {
   DelaunayVertex *vertex = [[[DelaunayVertex alloc] init] autorelease];
   vertex.coordinates = CGPointMake(x, y);
   return vertex;
}
+ (DelaunayVertex *) vertexAtInfinity {
   if(!vertexAtInfinity) {
      vertexAtInfinity = [self vertexWithX: NAN y: NAN];
      [vertexAtInfinity retain];
   }
   return vertexAtInfinity;
}

+ (DelaunayVertex *) intersect: (DelaunayHalfEdge *) halfEdge0 with: (DelaunayHalfEdge *) halfEdge1 {
   NSLog(@"Intersecting \n%@ \nwith \n%@", halfEdge0, halfEdge1);
   DelaunayEdge *edge0, *edge1, *edge;
   DelaunayHalfEdge *halfEdge;
   CGFloat determinant, intersectionX, intersectionY;
   BOOL rightOfSite;
   
   edge0 = halfEdge0.edge;
   edge1 = halfEdge1.edge;
   if (edge0 == nil || edge1 == nil)
   {
      return nil;
   }
   if (edge0.rightSite == edge1.rightSite)
   {
      return nil;
   }
   
   determinant = edge0.a * edge1.b - edge0.b * edge1.a;
   if (-1.0e-10 < determinant && determinant < 1.0e-10)
   {
      // the edges are parallel
      return nil;
   }
   
   intersectionX = (edge0.c * edge1.b - edge1.c * edge0.b)/determinant;
   intersectionY = (edge1.c * edge0.a - edge0.c * edge1.a)/determinant;
   
   if ([DelaunayVoronoi compareByYThenXWithSite: edge0.rightSite point: edge1.rightSite.coordinates] == NSOrderedAscending)
   {
      halfEdge = halfEdge0; 
      edge = edge0;
   }
   else
   {
      halfEdge = halfEdge1; 
      edge = edge1;
   }
   rightOfSite = intersectionX >= edge.rightSite.x;
   if ((rightOfSite && [halfEdge.orientation isLeft])
       ||  (!rightOfSite && [halfEdge.orientation isRight]))
   {
      return nil;
   }
   
   return [DelaunayVertex vertexWithX: intersectionX y: intersectionY];
}

- (NSString *) description {
   return [NSString stringWithFormat: @"(%f, %f)", coordinates.x, coordinates.y];
}



- (CGFloat) x {
   return coordinates.x;
}

- (void) setX: (CGFloat) x {
   coordinates.x = x;
}

- (CGFloat) y {
   return coordinates.y;
}

- (void) setY: (CGFloat) y {
   coordinates.y = y;
}

@end
