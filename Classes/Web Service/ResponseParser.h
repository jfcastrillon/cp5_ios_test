//
//  ResponseParser.h
//  StockApp
//
//  Created by John Cannon on 5/7/10.
//  Copyright 2010 Louisiana State University-Shreveport. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ResponseParser

- (id) parseData:(NSData*) data;

@end
