//
//  BasketDetails.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "BasketDetails.h"

@implementation BasketDetails


-(NSString*)description{

    return [NSString stringWithFormat:@"HAS CHILDREN: %d PARENT ID: (%@) ID: (%@) TITLE: (%@) ",[_isChildren intValue], _parentId,_pageId,_pageTitle];
}


@end
