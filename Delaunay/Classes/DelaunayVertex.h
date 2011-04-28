//
//  DelaunayVertex.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DelaunayCoordinate.h"

@class DelaunayHalfEdge;

@interface DelaunayVertex : NSObject <DelaunayCoordinate> {
    
}

@property (nonatomic, assign) CGPoint coordinates;
@property (nonatomic, assign) NSInteger index;

+ (DelaunayVertex *) vertexWithX: (CGFloat) x y: (CGFloat) y;
+ (DelaunayVertex *) vertexAtInfinity;
+ (DelaunayVertex *) intersect: (DelaunayHalfEdge *) halfedge0 with: (DelaunayHalfEdge *) halfedge1;


@end
