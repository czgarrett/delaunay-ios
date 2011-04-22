//
//  DelaunayHalfEdgePriorityQueue.m
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DelaunayHalfEdgePriorityQueue.h"
#import "DelaunayHalfEdge.h"
#import "DelaunayVertex.h"

@implementation DelaunayHalfEdgePriorityQueue

+ (DelaunayHalfEdgePriorityQueue *) queueWithMinY: (CGFloat) ymin deltaY: (CGFloat) deltaY sqrtNumSites: (NSInteger) sqrtNumSites {
   return [[[DelaunayHalfEdgePriorityQueue alloc] initWithMinY: ymin deltaY: deltaY sqrtNumSites: sqrtNumSites] autorelease];
}

- (id) initWithMinY: (CGFloat) _minY deltaY: (CGFloat) _deltaY sqrtNumSites: (CGFloat) _sqrtNumSites {
   if ((self = [super init])) {
      minY = _minY;
      deltaY = _deltaY;
      hashSize = 4*_sqrtNumSites;
      count = 0;
      minBucket = 0;
      hash = [[NSMutableArray alloc] init];
      for (int i=0; i< hashSize; i++) {
         DelaunayHalfEdge *dummy = [DelaunayHalfEdge dummy];
         [hash addObject: dummy];
      }
   }
   return self;
}

- (NSString *) description {
   return [NSString stringWithFormat: @"HalfEdgePriorityQueue (minY: %f deltaY: %f hashSize: %d count: %d minBucket: %d hash: %@", minY, deltaY, hashSize, count, minBucket, hash];
}

- (void) insert: (DelaunayHalfEdge *) halfEdge {
   DelaunayHalfEdge *previous, *next;
   NSInteger insertionBucket = [self bucket: halfEdge];
   if (insertionBucket < minBucket) {
      minBucket = insertionBucket;
   }
   previous = [hash objectAtIndex: insertionBucket];
   while ((next = [previous nextInPriorityQueue]) != nil && (halfEdge.ystar > next.ystar || (halfEdge.ystar == next.ystar && halfEdge.vertex.x > next.vertex.x))) {
      previous = next;
   }
   halfEdge.nextInPriorityQueue = previous.nextInPriorityQueue;
   previous.nextInPriorityQueue = halfEdge;
   count++;
}

- (void) remove: (DelaunayHalfEdge *) halfEdge {
   DelaunayHalfEdge *previous;
   NSInteger removalBucket = [self bucket: halfEdge];
   
   if (halfEdge.vertex != nil)
   {
      previous = [hash objectAtIndex: removalBucket];
      while (previous.nextInPriorityQueue != halfEdge)
      {
         previous = previous.nextInPriorityQueue;
      }
      previous.nextInPriorityQueue = halfEdge.nextInPriorityQueue;
      count--;
      halfEdge.vertex = nil;
      halfEdge.nextInPriorityQueue = nil;
   }
}

- (NSInteger) bucket: (DelaunayHalfEdge *) halfEdge {
   NSInteger bucket = (halfEdge.ystar - minY)/deltaY * hashSize;
   if (bucket < 0) bucket = 0;
   if (bucket >= hashSize) bucket = hashSize - 1;
   return bucket;
}

- (BOOL) empty {
   return count == 0;
}

- (BOOL) bucketIsEmpty: (NSInteger) bucket {
   return [[hash objectAtIndex: bucket] nextInPriorityQueue] == nil;
}

- (void) adjustMinBucket {
   while (minBucket < hashSize - 1 && [self bucketIsEmpty: minBucket]) {
      minBucket++;
   }
}

- (CGPoint) min {
   [self adjustMinBucket];
   DelaunayHalfEdge *result = [[hash objectAtIndex: minBucket] nextInPriorityQueue];
   return CGPointMake(result.vertex.x, result.ystar);
}

// remove and return the min Halfedge
- (DelaunayHalfEdge *) extractMin {
   DelaunayHalfEdge *result;
   // get the first real Halfedge in minBucket
   result = [[hash objectAtIndex: minBucket] nextInPriorityQueue];
   
   [[hash objectAtIndex: minBucket] setNextInPriorityQueue: result.nextInPriorityQueue];
   count--;
   result.nextInPriorityQueue = nil;
   return result;
}



- (void) dealloc {
   [hash release];
   [super dealloc];
}


@end
