//
//  DelaunayEdge.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunaySite, DelaunayVertex, DelaunayLineSegment, DelaunayOrientation;

@interface DelaunayEdge : NSObject {
    
}

@property (nonatomic, retain) DelaunaySite *leftSite;
@property (nonatomic, retain) DelaunaySite *rightSite;
@property (nonatomic, retain) DelaunayVertex *leftVertex;
@property (nonatomic, retain) DelaunayVertex *rightVertex;

@property (nonatomic, assign) CGPoint leftClippedPoint;
@property (nonatomic, assign) CGPoint rightClippedPoint;

// the equation of the edge: ax + by = c
@property (nonatomic, assign) CGFloat a;
@property (nonatomic, assign) CGFloat b;
@property (nonatomic, assign) CGFloat c;
@property (nonatomic, assign) BOOL visible;

+ (DelaunayEdge *) deletedEdge;
+ (DelaunayEdge *) edgeBisectingSite: (DelaunaySite *) site1 and: (DelaunaySite *) site2;

- (DelaunayLineSegment *) delaunayLine;
- (CGPoint) clippedPoint: (DelaunayOrientation *) orientation;

- (DelaunayVertex *) vertexWithOrientation: (DelaunayOrientation *) orientation;
- (void) setVertex: (DelaunayVertex *) vertex withOrientation: (DelaunayOrientation *) orientation;

- (void) setSite: (DelaunaySite *) site withOrientation: (DelaunayOrientation *) orientation;
- (DelaunaySite *) siteWithOrientation: (DelaunayOrientation *) orientation;
- (void) clipVertices: (CGRect) bounds;


- (BOOL) isPartOfConvexHull;
- (CGFloat) sitesDistance;
- (NSComparisonResult) compareSitesLonger: (DelaunayEdge *) other;
- (NSComparisonResult) compareSitesShorter: (DelaunayEdge *) other;


@end
