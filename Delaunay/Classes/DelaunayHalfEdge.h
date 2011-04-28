//
//  DelaunayHalfEdge.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunayEdge, DelaunayOrientation, DelaunayVertex;

@interface DelaunayHalfEdge : NSObject {
    
}

@property (nonatomic, retain) DelaunayHalfEdge *edgeListLeftNeighbor;
@property (nonatomic, retain) DelaunayHalfEdge *edgeListRightNeighbor;
@property (nonatomic, retain) DelaunayHalfEdge *nextInPriorityQueue;

@property (nonatomic, retain) DelaunayEdge *edge;
@property (nonatomic, retain) DelaunayOrientation *orientation;
@property (nonatomic, retain) DelaunayVertex *vertex;

// The vertex's y-coordinate in the transformed Voronoi space
@property (nonatomic, assign) CGFloat ystar;

+ (DelaunayHalfEdge *) dummy;
+ (DelaunayHalfEdge *) halfEdgeWithEdge: (DelaunayEdge *)edge orientation: (DelaunayOrientation *) orientation;

- (BOOL) isRightOf: (CGPoint) p;



@end
