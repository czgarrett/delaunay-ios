//
//  DelaunayVoronoi.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayVoronoi.h"
#import "Delaunay.h"
#import "DelaunaySiteList.h"
#import "DelaunaySite.h"
#import "DelaunayVertex.h"
#import "DelaunayOrientation.h"
#import "DelaunayHalfEdge.h"
#import "DelaunayHalfEdgePriorityQueue.h"
#import "DelaunayEdgeList.h"
#import "DelaunayEdge.h"

@implementation DelaunayVoronoi

@synthesize siteList, sitesIndexedByLocation, triangles, edges;
@synthesize plotBounds;

- (void) dealloc {
   [siteList release];
   [sitesIndexedByLocation release];
   [triangles release];
   [edges release];
   [super dealloc];
}

+ (DelaunayVoronoi *) voronoiWithPoints: (NSArray *) points plotBounds: (CGRect) plotBounds {
   DelaunayVoronoi *voronoi = [[[DelaunayVoronoi alloc] init] autorelease];
   voronoi.siteList = [DelaunaySiteList siteList];
   voronoi.sitesIndexedByLocation = [NSMutableDictionary dictionary];
   [voronoi addSites: points];
   voronoi.plotBounds = plotBounds;
   voronoi.triangles = [NSMutableArray array];
   voronoi.edges = [NSMutableArray array];
   [voronoi fortunesAlgorithm];
   return voronoi;
}

+ (NSComparisonResult) compareByYThenXWithSite: (DelaunaySite *) s1 point: (CGPoint)s2 {
   if (s1.y < s2.y) return NSOrderedAscending;
   if (s1.y > s2.y) return NSOrderedDescending;
   if (s1.x < s2.x) return NSOrderedAscending;
   if (s1.x > s2.x) return NSOrderedDescending;
   return NSOrderedSame;
}

- (NSString *) description {
   return [NSString stringWithFormat: @"Voronoi (\nplotBounds: (%f,%f,%f,%f) \nsiteList: %@ \nedges: %@)", plotBounds.origin.x, plotBounds.origin.y, plotBounds.size.width, plotBounds.size.height, siteList, edges];
}

- (NSArray *) regions {
   return [siteList regions: plotBounds];
}

- (void) addSites: (NSArray *) points {
   NSInteger index = 0;
   for (NSValue *pointValue in points) {
      [self addSite: pointValue index: index];
      index++;
   }
}

- (void) addSite: (NSValue *) pointValue index: (NSInteger) index{
   CGFloat weight = (CGFloat)random() / RANDOM_MAX;
   DelaunaySite *site = [DelaunaySite siteWithPoint: [pointValue CGPointValue] index: index weight: weight];
   [self.siteList addSite: site];
   [self.sitesIndexedByLocation setObject: site forKey: pointValue];
}

- (void) fortunesAlgorithm {
   DelaunaySite *newSite;
   DelaunaySite *bottomSite;
   DelaunaySite *topSite;
   DelaunaySite *tempSite;
   DelaunayVertex *v;
   DelaunayVertex *vertex;
   CGPoint newintstar;
   DelaunayOrientation *orientation;
   DelaunayHalfEdge *lbnd;
   DelaunayHalfEdge *rbnd;
   DelaunayHalfEdge *llbnd;
   DelaunayHalfEdge *rrbnd;
   DelaunayHalfEdge *firstBisector;
   DelaunayHalfEdge *secondBisector;
   DelaunayHalfEdge *thirdBisector;
   DelaunayEdge *edge;
   CGRect dataBounds = [self.siteList sitesBounds];
   int sqrt_nsites = (int) sqrtf((float)[self.siteList count] + 4);
   DelaunayHalfEdgePriorityQueue *heap = [DelaunayHalfEdgePriorityQueue queueWithMinY: dataBounds.origin.y 
                                                                            deltaY: dataBounds.size.height 
                                                                      sqrtNumSites: sqrt_nsites];

   DelaunayEdgeList *edgeList = [DelaunayEdgeList edgeListWithMinX: dataBounds.origin.x 
                                                      deltaX: dataBounds.size.width 
                                               sqrtNumSites: sqrt_nsites];
   
   NSMutableArray *halfEdges = [NSMutableArray array];
   NSMutableArray *vertices = [NSMutableArray array];

   bottomMostSite = [self.siteList next];
   newSite = [self.siteList next];
   
   NSInteger loopCount = 0;
   while (true) {
      NSLog(@"\n*********************** LOOP %d ***************************\n", loopCount);
      NSLog(@"newSite: %@", newSite);
      loopCount++;
      //NSLog(@"heap = %@", heap);
      if ([heap empty] == NO) {
         newintstar = [heap min];
         NSLog(@"newintstar = %f, %f", newintstar.x, newintstar.y);
      }
      
      if ((newSite != nil) && ([heap empty] || [DelaunayVoronoi compareByYThenXWithSite: newSite point: newintstar] == NSOrderedAscending))
      {

         lbnd = [edgeList edgeListLeftNeighbor: newSite.coordinates];	// the Halfedge just to the left of newSite
         rbnd = [lbnd edgeListRightNeighbor];		// the Halfedge just to the right
         NSLog(@"lbnd: %@", lbnd);
         NSLog(@"rbnd: %@", rbnd);
         bottomSite = [self rightRegion: lbnd];		// this is the same as leftRegion(rbnd)
         // this Site determines the region containing the new site
         NSLog(@"bottomSite: %@", bottomSite);
         
         // Step 9:
         edge = [DelaunayEdge edgeBisectingSite: bottomSite and: newSite];
         NSLog(@"new edge: %@", edge);
         [self.edges addObject: edge];
         
         firstBisector = [DelaunayHalfEdge halfEdgeWithEdge: edge orientation: [DelaunayOrientation left]];
         NSLog(@"first bisector: %@", firstBisector);
         [halfEdges addObject: firstBisector];

         // inserting two Halfedges into edgeList constitutes Step 10:
         // insert bisector to the right of lbnd:
         [edgeList insert: firstBisector toRightOf: lbnd];
         
         // first half of Step 11:
         if ((vertex = [DelaunayVertex intersect: lbnd with: firstBisector]) != nil) 
         {
            [vertices addObject: vertex];
            [heap remove: lbnd];
            
            lbnd.vertex = vertex;
            lbnd.ystar = vertex.y + DISTANCE(newSite, vertex);
            [heap insert: lbnd];
         }
         
         lbnd = firstBisector;
         secondBisector = [DelaunayHalfEdge halfEdgeWithEdge: edge orientation: [DelaunayOrientation right]];
         NSLog(@"second bisector: %@", secondBisector);
         [halfEdges addObject: secondBisector];

         // second Halfedge for Step 10:
         // insert bisector to the right of lbnd:
         [edgeList insert: secondBisector toRightOf: lbnd];

         
         // second half of Step 11:
         if ((vertex = [DelaunayVertex intersect: secondBisector with: rbnd]) != nil)
         {
            [vertices addObject: vertex];

            secondBisector.vertex = vertex;
            secondBisector.ystar = vertex.y + DISTANCE(newSite, vertex);
            [heap insert: secondBisector];

         }
         
         newSite = [self.siteList next];
      } else if (![heap empty]) {
         /* intersection is smallest */
         lbnd = [heap extractMin];
         llbnd = lbnd.edgeListLeftNeighbor;
         rbnd = lbnd.edgeListRightNeighbor;
         rrbnd = rbnd.edgeListRightNeighbor;
         bottomSite = [self leftRegion: lbnd];
         topSite = [self rightRegion: rbnd];
         // these three sites define a Delaunay triangle
         // (not actually using these for anything...)
         //_triangles.push(new Triangle(bottomSite, topSite, rightRegion(lbnd)));
         
         v = lbnd.vertex;
         [lbnd.edge setVertex: v withOrientation: lbnd.orientation];
         [rbnd.edge setVertex: v withOrientation: rbnd.orientation];
         [edgeList remove: lbnd];
         [heap remove: rbnd];
         [edgeList remove: rbnd];
         orientation = [DelaunayOrientation left];

         if (bottomSite.y > topSite.y)
         {
            tempSite = bottomSite; 
            bottomSite = topSite; 
            topSite = tempSite; 
            orientation = [DelaunayOrientation right];
         }
         edge = [DelaunayEdge edgeBisectingSite: bottomSite and: topSite];
         [edges addObject: edge];
         thirdBisector = [DelaunayHalfEdge halfEdgeWithEdge: edge orientation: orientation];
         [halfEdges addObject: thirdBisector];
         [edgeList insert: thirdBisector toRightOf: llbnd];

         [edge setVertex: v withOrientation: [orientation opposite]];
         if ((vertex = [DelaunayVertex intersect: llbnd with: thirdBisector]) != nil)
         {
            [vertices addObject: vertex];
            [heap remove: llbnd];
            llbnd.vertex = vertex;
            llbnd.ystar = vertex.y + DISTANCE(bottomSite, vertex);
            [heap insert: llbnd];
         }
         if ((vertex = [DelaunayVertex intersect: thirdBisector with: rrbnd]) != nil)
         {
            [vertices addObject: vertex];
            thirdBisector.vertex = vertex;
            thirdBisector.ystar = vertex.y + DISTANCE(bottomSite, vertex);
            [heap insert: thirdBisector];
         }
      }
      else
      {
         break;
      }
   }
   [halfEdges removeAllObjects];
   // we need the vertices to clip the edges
   for (DelaunayEdge *edge in edges)
   {
      [edge clipVertices: plotBounds];
   }
   [vertices removeAllObjects];
}

-(DelaunaySite *) leftRegion: (DelaunayHalfEdge *) he {
   DelaunayEdge *edge = he.edge;
   if (edge == NULL)
   {
      return bottomMostSite;
   }
   return [edge siteWithOrientation: he.orientation];
}

-(DelaunaySite *) rightRegion: (DelaunayHalfEdge *) he {
   DelaunayEdge *edge = he.edge;
   if (edge == nil)
   {
      return bottomMostSite;
   }
   return [edge siteWithOrientation: [he.orientation opposite]];
}



@end
