//
//  DelaunayHalfEdgePriorityQueue.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunayHalfEdge, DelaunayVertex;

@interface DelaunayHalfEdgePriorityQueue : NSObject {
   NSMutableArray *hash;
   NSInteger count;
   NSInteger minBucket;
   NSInteger hashSize;
   CGFloat minY;
   CGFloat maxY;
   CGFloat deltaY;
    
}

+ (DelaunayHalfEdgePriorityQueue *) queueWithMinY: (CGFloat) minY deltaY: (CGFloat) deltaY sqrtNumSites: (NSInteger) sqrtNumSites;
- (id) initWithMinY: (CGFloat) _minY deltaY: (CGFloat) _deltaY sqrtNumSites: (CGFloat) _sqrtNumSites;

- (void) insert: (DelaunayHalfEdge *) halfEdge vertex: (DelaunayVertex *) v offset: (CGFloat) offset;
- (NSInteger) bucket: (DelaunayHalfEdge *) halfEdge;
- (void) remove: (DelaunayHalfEdge *) halfEdge;
- (BOOL) empty;
- (DelaunayHalfEdge *) extractMin;

- (CGPoint) min;

@end
