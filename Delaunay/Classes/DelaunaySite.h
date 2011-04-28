//
//  DelaunaySite.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DelaunayCoordinate.h"

@class DelaunayEdge;

typedef enum {
   BoundsMaskNone = 0,
   BoundsMaskTop = 1,
   BoundsMaskBottom = 2,
   BoundsMaskLeft = 4,
   BoundsMaskRight = 8
} BoundsMask;


@interface DelaunaySite : NSObject <DelaunayCoordinate> {
    
}

+ (DelaunaySite *) siteWithPoint: (CGPoint) point index: (NSInteger) index weight: (float) weight; 

@property (nonatomic, assign) CGPoint coordinates;
@property (nonatomic, assign) float weight;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, retain) NSMutableArray *edges;
@property (nonatomic, retain) NSMutableArray *edgeOrientations;
@property (nonatomic, retain) NSMutableArray *region;


- (void) move:(CGPoint) point;
- (void) clear;
- (void) addEdge: (DelaunayEdge *) edge;
- (NSMutableArray *) region;
- (DelaunayEdge *) nearestEdge;
- (NSArray *) neighborSites;
- (NSMutableArray *) region: (CGRect) clippingBounds;
- (DelaunaySite *) neighborSite: (DelaunayEdge *) edge;
- (void) reorderEdges;
- (NSMutableArray *) clipToBounds: (CGRect) bounds;
- (NSInteger) boundsCheck: (CGPoint)point bounds: (CGRect) bounds;
- (void) connect: (NSMutableArray *) points atIndex: (NSInteger) j bounds: (CGRect) bounds closingUp: (BOOL) closingUp;
- (BOOL) closeEnough: (CGPoint) p0 to: (CGPoint) p1;

@end
