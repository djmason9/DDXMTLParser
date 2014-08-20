//
//  bitcows_parser.h
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bitcows_parser : NSObject<NSXMLParserDelegate>

-(NSDictionary*)parseData:(NSData*)data orSource:(NSString*)source orURL:(NSString*)url;

@end
