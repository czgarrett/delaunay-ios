//
//  DelaunayEdge.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayEdge.h"
#import "DelaunaySite.h"
#import "DelaunayLineSegment.h"
#import "DelaunayVertex.h"
#import "DelaunayOrientation.h"
#import "Delaunay.h"

DelaunayEdge *deletedEdge;

@implementation DelaunayEdge

@synthesize leftSite, rightSite, leftVertex, rightVertex, leftClippedPoint, rightClippedPoint, a, b, c, visible;

+ (DelaunayEdge *) deletedEdge {
   if (!deletedEdge) {
      deletedEdge = [[DelaunayEdge alloc] init];
   }
   return deletedEdge;
}

+ (DelaunayEdge *) edgeBisectingSite: (DelaunaySite *) site0 and: (DelaunaySite *) site1 {
   float dx, dy, absdx, absdy;
   float a, b, c;
   
   dx = site1.x - site0.x;
   dy = site1.y - site0.y;
   absdx = dx > 0 ? dx : -dx;
   absdy = dy > 0 ? dy : -dy;
   c = site0.x * dx + site0.y * dy + (dx * dx + dy * dy) * 0.5;
   if (absdx > absdy)
   {
      a = 1.0; b = dy/dx; c /= dx;
   }
   else
   {
      b = 1.0; a = dx/dy; c /= dy;
   }
   
   DelaunayEdge *edge = [[[DelaunayEdge alloc] init] autorelease];
   
   edge.leftSite = site0;
   edge.rightSite = site1;
   [site0 addEdge: edge];
   [site1 addEdge: edge];
   
   edge.leftVertex = nil;
   edge.rightVertex = nil;
   
   edge.a = a; 
   edge.b = b; 
   edge.c = c;
   
   edge.visible = NO;
   return edge;
   
}

- (NSString *) description {
   NSString *siteDesc = @"";
   NSString *vertexDesc = @"";
   siteDesc =   [NSString stringWithFormat: @"S: %d-%d", leftSite == nil ? -1 : leftSite.index, rightSite == nil ? -1 : rightSite.index];
   vertexDesc = [NSString stringWithFormat: @"V: %d-%d", leftVertex == nil ? -1 : leftVertex.index, rightVertex == nil ? -1 : rightVertex.index];
   return [NSString stringWithFormat: @"E (%@ %@ a,b,c: %f,%f,%f)", siteDesc, vertexDesc, a, b, c];
}

- (CGPoint) clippedPoint: (DelaunayOrientation *) orientation {
   if (orientation == [DelaunayOrientation left]) {
      return self.leftClippedPoint;
   } else {
      return self.rightClippedPoint;
   }
}


- (DelaunayVertex *) vertexWithOrientation: (DelaunayOrientation *) orientation {
   if (orientation == [DelaunayOrientation left]) {
      return self.leftVertex;
   } else {
      return self.rightVertex;
   }
}
- (void) setVertex: (DelaunayVertex *) vertex withOrientation: (DelaunayOrientation *) orientation {
   if (orientation == [DelaunayOrientation left]) {
      self.leftVertex = vertex;
   } else {
      self.rightVertex = vertex;
   }
   if (self.leftVertex && self.rightVertex) {
      NSLog(@"%@", self);
   }
}

- (DelaunaySite *) siteWithOrientation: (DelaunayOrientation *) orientation {
   if (orientation == [DelaunayOrientation left]) {
      return self.leftSite;
   } else {
      return self.rightSite;
   }
}
- (void) setSite: (DelaunaySite *) site withOrientation: (DelaunayOrientation *) orientation {
   if (orientation == [DelaunayOrientation left]) {
      self.leftSite = site;
   } else {
      self.rightSite = site;
   }
}


- (DelaunayLineSegment *) delaunayLine {
   return [DelaunayLineSegment lineSegmentWithLeftCoordinate: self.leftSite.coordinates rightCoordinate: self.rightSite.coordinates];
}

- (BOOL) isPartOfConvexHull {
   return leftVertex == nil || rightVertex == nil;
}

- (CGFloat) sitesDistance {
   return DISTANCE(leftSite.coordinates, rightSite.coordinates);
}

- (NSComparisonResult) compareSitesLonger: (DelaunayEdge *) other {
   CGFloat myLength = [self sitesDistance];
   CGFloat otherLength = [other sitesDistance];
   if (myLength < otherLength) {
      return NSOrderedAscending;
   } if (myLength > otherLength) {
      return NSOrderedDescending;
   }
   return NSOrderedSame;
}

- (NSComparisonResult) compareSitesShorter: (DelaunayEdge *) other {
   return -[self compareSitesLonger: other];
}

// Set _clippedVertices to contain the two ends of the portion of the Voronoi edge that is visible
// within the bounds.  If no part of the Edge falls within the bounds, leave clippedVertices null. 

- (void) clipVertices: (CGRect) bounds {
   CGFloat xmin = bounds.origin.x;
   CGFloat ymin = bounds.origin.y;
   CGFloat xmax = bounds.origin.x + bounds.size.width;
   CGFloat ymax = bounds.origin.y + bounds.size.height;
   
   DelaunayVertex *vertex0;
   DelaunayVertex *vertex1;
   
   CGFloat x0, x1, y0, y1;

   
   if (a == 1.0 && b >= 0.0)
   {
      vertex0 = rightVertex;
      vertex1 = leftVertex;
   }
   else 
   {
      vertex0 = leftVertex;
      vertex1 = rightVertex;
   }
   
   if (a == 1.0)
   {
      y0 = ymin;
      if (vertex0 != nil && vertex0.y > ymin)
      {
         y0 = vertex0.y;
      }
      if (y0 > ymax)
      {
         return;
      }
      x0 = c - b * y0;
      
      y1 = ymax;
      if (vertex1 != nil && vertex1.y < ymax)
      {
         y1 = vertex1.y;
      }
      if (y1 < ymin)
      {
         return;
      }
      x1 = c - b * y1;
      
      if ((x0 > xmax && x1 > xmax) || (x0 < xmin && x1 < xmin))
      {
         return;
      }
      
      if (x0 > xmax)
      {
         x0 = xmax; y0 = (c - x0)/b;
      }
      else if (x0 < xmin)
      {
         x0 = xmin; y0 = (c - x0)/b;
      }
      
      if (x1 > xmax)
      {
         x1 = xmax; y1 = (c - x1)/b;
      }
      else if (x1 < xmin)
      {
         x1 = xmin; y1 = (c - x1)/b;
      }
   }
   else
   {
      x0 = xmin;
      if (vertex0 != nil && vertex0.x > xmin)
      {
         x0 = vertex0.x;
      }
      if (x0 > xmax)
      {
         return;
      }
      y0 = c - a * x0;
      
      x1 = xmax;
      if (vertex1 != nil && vertex1.x < xmax)
      {
         x1 = vertex1.x;
      }
      if (x1 < xmin)
      {
         return;
      }
      y1 = c - a * x1;
      
      if ((y0 > ymax && y1 > ymax) || (y0 < ymin && y1 < ymin))
      {
         return;
      }
      
      if (y0 > ymax)
      {
         y0 = ymax; x0 = (c - y0)/a;
      }
      else if (y0 < ymin)
      {
         y0 = ymin; x0 = (c - y0)/a;
      }
      
      if (y1 > ymax)
      {
         y1 = ymax; x1 = (c - y1)/a;
      }
      else if (y1 < ymin)
      {
         y1 = ymin; x1 = (c - y1)/a;
      }
   }
   
   if (vertex0 == leftVertex)
   {
      leftClippedPoint = CGPointMake(x0, y0);
      rightClippedPoint = CGPointMake(x1, y1);
      self.visible = YES;
   }
   else
   {
      rightClippedPoint = CGPointMake(x0, y0);
      leftClippedPoint = CGPointMake(x1, y1);
      self.visible = YES;
   }
}


- (void) dealloc {
   [leftSite release];
   [rightSite release];
   [leftVertex release];
   [rightVertex release];
   [super dealloc];
}

@end

