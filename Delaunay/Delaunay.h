//
//  Delaunay.h
//  Delaunay
//
//  Created by Christopher Garrett on 4/14/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//


#define SQUARED(x) ((x)*(x))
#define DISTANCE(p1, p2) (sqrtf(SQUARED(p1.x - p2.x) + SQUARED(p1.y - p2.y)))

// (2**31)-1, see man random
#define RANDOM_MAX (2147483647)
