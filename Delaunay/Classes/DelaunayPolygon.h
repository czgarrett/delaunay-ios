//
//  DelaunayPolygon.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/13/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
   DelaunayWindingNone = 0,
   DelaunayWindingClockwise,
   DelaunayWindingCounterClockwise
} DelaunayWinding;


@interface DelaunayPolygon : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray *vertices;

+ (DelaunayPolygon *) polygonWithVertices: (NSMutableArray *) vertices;

- (float) area;
- (DelaunayWinding) winding;
- (float) signedDoubleArea;

@end
