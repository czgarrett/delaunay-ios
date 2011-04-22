//
//  DelaunayEdgeReorderer.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelaunayEdgeReorderer : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray *edges; 
@property (nonatomic, retain) NSMutableArray *edgeOrientations;

- (id) initWithEdges: (NSArray *) originalEdges criterion: (Class) klass;
- (NSMutableArray *) reorderEdges: (NSArray *) originalEdges criterion: (Class) criterion;


@end
