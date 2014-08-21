//
//  BasketDetails.h
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasketDetails : NSObject

@property (nonatomic, retain) NSNumber * isChildren;
@property (nonatomic, retain) NSString * pageId;
@property (nonatomic, retain) NSNumber * pageNumber;
@property (nonatomic, retain) NSString * pageTitle;
@property (nonatomic, retain) NSString * pageURL;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * urlTag;
@property (nonatomic, retain) NSString *book;

@end
