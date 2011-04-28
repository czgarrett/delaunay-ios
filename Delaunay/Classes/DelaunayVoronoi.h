//
//  DelaunayVoronoi.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunaySiteList, DelaunaySite, DelaunayHalfEdge;

@interface DelaunayVoronoi : NSObject {
   DelaunaySite *bottomMostSite;
}

@property (nonatomic, retain) DelaunaySiteList *siteList;
@property (nonatomic, retain) NSMutableDictionary *sitesIndexedByLocation;
@property (nonatomic, retain) NSMutableArray *triangles;
@property (nonatomic, retain) NSMutableArray *edges;

@property (nonatomic, assign) CGRect plotBounds;

+ (DelaunayVoronoi *) voronoiWithPoints: (NSArray *) points plotBounds: (CGRect) plotBounds;
+ (NSComparisonResult) compareByYThenXWithSite: (DelaunaySite *) s1 point: (CGPoint)s2;

- (void) addSites: (NSArray *) points;
- (void) addSite: (NSValue *) pointValue index: (NSInteger) index;
- (void) fortunesAlgorithm;
-(DelaunaySite *) leftRegion: (DelaunayHalfEdge *) he;
-(DelaunaySite *) rightRegion: (DelaunayHalfEdge *) he;
-(NSArray *) regionForPoint: (CGPoint) p;
- (NSArray *) regions;


@end
