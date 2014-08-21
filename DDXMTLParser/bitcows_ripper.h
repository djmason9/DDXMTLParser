//
//  bitcows_ripper.h
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bitcows_ripper : NSObject

-(void)ripPagesIntoList:(NSArray*)childrens parentId:(NSString*)parentId;
-(void)ripPagesIntoBasketList:(NSArray*)childrens parentId:(NSString*)parentId;

@end
