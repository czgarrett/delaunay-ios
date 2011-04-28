//
//  DelaunayEdgeList.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayEdgeList.h"
#import "DelaunayHalfEdge.h"
#import "DelaunayEdge.h"

@implementation DelaunayEdgeList

@synthesize leftEnd, rightEnd;

+ (DelaunayEdgeList *) edgeListWithMinX: (CGFloat) _minX deltaX: (CGFloat) _deltaX sqrtNumSites: (NSInteger) _sqrtNumSites {
   return [[[DelaunayEdgeList alloc] initWithMinX: _minX deltaX: _deltaX sqrtNumSites: _sqrtNumSites] autorelease];
}

- (id) initWithMinX: (CGFloat) _minX deltaX: (CGFloat) _deltaX sqrtNumSites: (NSInteger) _sqrtNumSites {
   if ((self = [super init])) {
      minX = _minX;
      deltaX = _deltaX;
      hashSize = 2*_sqrtNumSites;
      hash = [[NSMutableArray alloc] initWithCapacity: hashSize];
      for (int i=0; i< hashSize; i++) {
         [hash addObject: [NSNull null]];
      }
      self.leftEnd = [DelaunayHalfEdge dummy];
      self.rightEnd = [DelaunayHalfEdge dummy];
      leftEnd.edgeListRightNeighbor = rightEnd;
      rightEnd.edgeListLeftNeighbor = leftEnd;
      [hash replaceObjectAtIndex: 0 withObject: leftEnd];
      [hash replaceObjectAtIndex: hashSize-1 withObject: rightEnd];
   }
   return self;
}

- (NSString *) description {
   return [NSString stringWithFormat: @"EdgeList (minX: %f deltaX: %f leftEnd: %@ rightEnd: %@ hash: %@)", minX, deltaX, leftEnd, rightEnd, hash];
}

// Insert newHalfedge to the right of lb 
- (void) toRightOf: (DelaunayHalfEdge *) lb insert: (DelaunayHalfEdge *) newHalfEdge {
   newHalfEdge.edgeListLeftNeighbor = lb;
   newHalfEdge.edgeListRightNeighbor = lb.edgeListRightNeighbor;
   lb.edgeListRightNeighbor.edgeListLeftNeighbor = newHalfEdge;
   lb.edgeListRightNeighbor = newHalfEdge;
}

// This function only removes the Halfedge from the left-right list.
//We cannot dispose it yet because we are still using it. 

- (void) remove: (DelaunayHalfEdge *) halfEdge {
   halfEdge.edgeListLeftNeighbor.edgeListRightNeighbor = halfEdge.edgeListRightNeighbor;
   halfEdge.edgeListRightNeighbor.edgeListLeftNeighbor = halfEdge.edgeListLeftNeighbor;
   halfEdge.edge = [DelaunayEdge deletedEdge];
   halfEdge.edgeListLeftNeighbor = halfEdge.edgeListRightNeighbor = nil;
}

// Get entry from hash table, pruning any deleted nodes
- (DelaunayHalfEdge *) hashForBucket: (NSInteger) b {
   DelaunayHalfEdge *halfEdge;
   DelaunayHalfEdge *nullEdge = (DelaunayHalfEdge *) [NSNull null];
   
   if (b < 0 || b >= hashSize)
   {
      return nil;
   }
   halfEdge = [hash objectAtIndex: b];
   if (halfEdge != nullEdge && halfEdge.edge == [DelaunayEdge deletedEdge])
   {
      /* Hash table points to deleted halfedge.  Patch as necessary. */
      [hash replaceObjectAtIndex: b withObject: [NSNull null]];
      // still can't dispose halfEdge yet!
      return nil;
   }
   else
   {
      if (halfEdge == nullEdge) {
         return nil;
      } else {
         return halfEdge;
      }
   }
}


// Find the rightmost Halfedge that is still left of p 
- (DelaunayHalfEdge *) edgeListLeftNeighbor: (CGPoint) p {
   NSInteger i, bucket;
   DelaunayHalfEdge *halfEdge;
   DelaunayHalfEdge *nullEdge = (DelaunayHalfEdge *) [NSNull null];
   
   /* Use hash table to get close to desired halfedge */
   bucket = (p.x - minX)/deltaX * hashSize;
   if (bucket < 0)
   {
      bucket = 0;
   }
   if (bucket >= hashSize)
   {
      bucket = hashSize - 1;
   }
   halfEdge = [self hashForBucket: bucket];
   if (halfEdge == nil)
   {
      for (i = 1; true ; ++i)
      {
         if ((halfEdge = [self hashForBucket: bucket - i]) != nil) break;
         if ((halfEdge = [self hashForBucket: bucket + i]) != nil) break;
      }
   }
   /* Now search linear list of halfedges for the correct one */
   if (halfEdge == leftEnd  || (halfEdge != rightEnd && [halfEdge isRightOf: p]))
   {
      do
      {
         halfEdge = halfEdge.edgeListRightNeighbor;
      }
      while (halfEdge != rightEnd && [halfEdge isRightOf: p]);
      halfEdge = halfEdge.edgeListLeftNeighbor;
   }
   else
   {
      do
      {
         halfEdge = halfEdge.edgeListLeftNeighbor;
      }
      while (halfEdge != leftEnd && ![halfEdge isRightOf: p]);
   }
   
   /* Update hash table and reference counts */
   if (bucket > 0 && bucket <hashSize - 1)
   {
      if (halfEdge == nil) halfEdge = nullEdge;
      [hash replaceObjectAtIndex: bucket withObject: halfEdge];
   }
   if (halfEdge == nullEdge) halfEdge = nil;
   return halfEdge;
}

- (void) dealloc {
   [hash release];
   [leftEnd release];
   [rightEnd release];
   [super dealloc];
}

@end
