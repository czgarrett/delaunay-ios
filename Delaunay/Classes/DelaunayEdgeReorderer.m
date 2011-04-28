//
//  DelaunayEdgeReorderer.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayEdgeReorderer.h"
#import "DelaunayEdge.h"
#import "DelaunayOrientation.h"
#import "DelaunayCoordinate.h"
#import "DelaunayVertex.h"
#import "DelaunaySite.h"

@implementation DelaunayEdgeReorderer

@synthesize edges, edgeOrientations;

- (id) initWithEdges: (NSArray *) originalEdges criterion: (Class) klass {
   if ((self = [super init])) {
      self.edges = [NSMutableArray array];
      self.edgeOrientations = [NSMutableArray array];
      if ([originalEdges count] > 0) {
         self.edges = [self reorderEdges: originalEdges criterion: klass];
      }
   } 
   return self;
   
}

- (NSMutableArray *) reorderEdges: (NSArray *) originalEdges criterion: (Class) criterion {
   NSInteger i=0;
   NSInteger n = [originalEdges count];
   DelaunayEdge *edge;
   NSMutableArray *doneItems = [NSMutableArray array];
   for (int k=0; k<n; k++) {
      [doneItems addObject: [NSNumber numberWithBool: NO]];
   }
   NSInteger nDone = 0;
   NSMutableArray *newEdges = [NSMutableArray array];
   edge = [originalEdges objectAtIndex: i];
   [newEdges addObject: edge];
   [edgeOrientations addObject: [DelaunayOrientation left]];
   id <DelaunayCoordinate> firstPoint;
   id <DelaunayCoordinate> lastPoint;
   if (criterion == [DelaunayVertex class]) {
      firstPoint = edge.leftVertex;
      lastPoint = edge.rightVertex;
   } else {
      firstPoint = edge.leftSite;
      lastPoint = edge.rightSite;
   }
   if (![firstPoint isReal] || ![lastPoint isReal]) {
      return [NSMutableArray array];
   }
   [doneItems replaceObjectAtIndex: i withObject: [NSNumber numberWithBool: YES]];
   nDone++;
   while (nDone < n)
   {
      for (i = 1; i < n; ++i)
      {
         if ([[doneItems objectAtIndex: i] boolValue])
         {
            continue;
         }
         edge = [originalEdges objectAtIndex: i];
         
         id <DelaunayCoordinate> leftPoint;
         id <DelaunayCoordinate> rightPoint;
         if (criterion == [DelaunayVertex class]) {
            leftPoint = edge.leftVertex;
            rightPoint = edge.rightVertex;
         } else { // Site
            leftPoint = edge.leftSite;
            rightPoint = edge.rightSite;
         }
         if (![leftPoint isReal] || ![rightPoint isReal])
         {
            return [NSMutableArray array];
         }
         if (leftPoint == lastPoint)
         {
            lastPoint = rightPoint;
            [edgeOrientations addObject: [DelaunayOrientation left]];
            [newEdges addObject: edge];
            [doneItems replaceObjectAtIndex: i withObject: [NSNumber numberWithBool: YES]];
         }
         else if (rightPoint == firstPoint)
         {
            firstPoint = leftPoint;
            [edgeOrientations insertObject: [DelaunayOrientation left] atIndex: 0];
            [newEdges insertObject: edge atIndex: 0];
            [doneItems replaceObjectAtIndex: i withObject: [NSNumber numberWithBool: YES]];
         }
         else if (leftPoint == firstPoint)
         {
            firstPoint = rightPoint;
            [edgeOrientations insertObject: [DelaunayOrientation right] atIndex: 0];
            [newEdges insertObject: edge atIndex: 0];
            [doneItems replaceObjectAtIndex: i withObject: [NSNumber numberWithBool: YES]];
         }
         else if (rightPoint == lastPoint)
         {
            lastPoint = leftPoint;
            [edgeOrientations addObject: [DelaunayOrientation right]];
            [newEdges addObject: edge];
            [doneItems replaceObjectAtIndex: i withObject: [NSNumber numberWithBool: YES]];
         }
         if ([[doneItems objectAtIndex: i] boolValue])
         {
            nDone++;
         }
      }
   }
   return newEdges;
}

- (void) dealloc {
   [edges release];
   [edgeOrientations release];
   [super dealloc];
}

@end

