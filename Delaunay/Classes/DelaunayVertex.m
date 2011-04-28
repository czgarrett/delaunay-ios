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

@synthesize coordinates, index;

+ (DelaunayVertex *) vertexWithX: (CGFloat) x y: (CGFloat) y {
   if (x == NAN || y == NAN) {
      return [self vertexAtInfinity];
   } else {
      DelaunayVertex *vertex = [[[DelaunayVertex alloc] init] autorelease];
      vertex.coordinates = CGPointMake(x, y);
      vertex.index = -1;
      return vertex;
   }
}
+ (DelaunayVertex *) vertexAtInfinity {
   if(!vertexAtInfinity) {
      vertexAtInfinity = [self vertexWithX: NAN y: NAN];
      vertexAtInfinity.index = -1;
      [vertexAtInfinity retain];
   }
   return vertexAtInfinity;
}

+ (DelaunayVertex *) intersect: (DelaunayHalfEdge *) halfEdge0 with: (DelaunayHalfEdge *) halfEdge1 {
   DelaunayEdge *edge0, *edge1, *lowerEdge;
   DelaunayHalfEdge *lowerHalfEdge;
   CGFloat determinant, intersectionX, intersectionY;
   
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
   
   if ((edge0.rightSite.y < edge1.rightSite.y) || 
       (edge0.rightSite.y == edge1.rightSite.y && edge0.rightSite.x < edge1.rightSite.x)) 
   {
      lowerHalfEdge = halfEdge0; 
      lowerEdge = edge0;
   }
   else
   {
      lowerHalfEdge = halfEdge1; 
      lowerEdge = edge1;
   }
   BOOL rightOfSite;
   rightOfSite = intersectionX >= lowerEdge.rightSite.x;
   if ((rightOfSite && [lowerHalfEdge.orientation isLeft])
       ||  (!rightOfSite && [lowerHalfEdge.orientation isRight]))
   {
      return nil;
   }
   
   DelaunayVertex *v = [DelaunayVertex vertexWithX: intersectionX y: intersectionY];
   return v;
}

- (NSString *) description {
   return [NSString stringWithFormat: @"V%d: (%f, %f)", self.index, coordinates.x, coordinates.y];
}

- (BOOL) isReal {
   return self.index >= 0;
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
