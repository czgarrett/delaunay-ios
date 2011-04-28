//
//  DelaunayHalfEdge.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayHalfEdge.h"
#import "DelaunaySite.h"
#import "DelaunayVertex.h"
#import "DelaunayEdge.h"
#import "Delaunay.h"
#import "DelaunayOrientation.h"

@implementation DelaunayHalfEdge

@synthesize edgeListLeftNeighbor, edgeListRightNeighbor, nextInPriorityQueue, edge, orientation, vertex, ystar;


+ (DelaunayHalfEdge *) dummy {
   return [[[DelaunayHalfEdge alloc] init] autorelease];
}

+ (DelaunayHalfEdge *) halfEdgeWithEdge: (DelaunayEdge *)edge orientation: (DelaunayOrientation *) orientation {
   DelaunayHalfEdge *result = [[[DelaunayHalfEdge alloc] init] autorelease];
   result.edge = edge;
   result.orientation = orientation;
   return result;
}

- (NSString *) description {
   return [NSString stringWithFormat: @"HalfEdge (id: %p vertex: %d edge: %d - %d orientation: %@ leftNeighbor: %p rightNeighbor: %p nextInPriorityQueue: %p ystar: %f", 
           self, vertex == nil ? -100 : vertex.index, edge.leftSite ? edge.leftSite.index : -1, edge.rightSite ? edge.rightSite.index : -1, orientation, edgeListLeftNeighbor, edgeListRightNeighbor, nextInPriorityQueue, ystar];
}

- (BOOL) isRightOf: (CGPoint) p {
   DelaunaySite *topSite;
   
   BOOL rightOfSite, above, fast;
   CGFloat dxp, dyp, dxs, t1, t2, t3, yl;
   
   topSite = edge.rightSite;
   rightOfSite = p.x > topSite.x;
   if (rightOfSite && [self.orientation isLeft])
   {
      return YES;
   }
   if (!rightOfSite && [self.orientation isRight])
   {
      return NO;
   }
   
   if (edge.a == 1.0)
   {
      dyp = p.y - topSite.y;
      dxp = p.x - topSite.x;
      fast = NO;
      if ((!rightOfSite && edge.b < 0.0) || (rightOfSite && edge.b >= 0.0) )
      {
         above = dyp >= edge.b * dxp;	
         fast = above;
      }
      else 
      {
         above = p.x + p.y * edge.b > edge.c;
         if (edge.b < 0.0)
         {
            above = !above;
         }
         if (!above)
         {
            fast = YES;
         }
      }
      if (!fast)
      {
         dxs = topSite.x - edge.leftSite.x;
         above = edge.b * (dxp * dxp - dyp * dyp) <
         dxs * dyp * (1.0 + 2.0 * dxp/dxs + edge.b * edge.b);
         if (edge.b < 0.0)
         {
            above = !above;
         }
      }
   }
   else  /* edge.b == 1.0 */
   {
      yl = edge.c - edge.a * p.x;
      t1 = p.y - yl;
      t2 = p.x - topSite.x;
      t3 = yl - topSite.y;
      above = t1 * t1 > t2 * t2 + t3 * t3;
   }
   return [self.orientation isLeft] ? above : !above;
} 

@end
