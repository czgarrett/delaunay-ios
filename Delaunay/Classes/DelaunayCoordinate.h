//
//  DelaunayCoordinate.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DelaunayCoordinate <NSObject>

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
- (BOOL) isReal;

@end
