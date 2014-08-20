//
//  bitcows_parser.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "bitcows_parser.h"
#import "DDXMLDocument.h"

@implementation bitcows_parser

-(NSDictionary*)parseData:(NSData*)data orSource:(NSString*)source{

    NSError *error = nil;
    DDXMLDocument *theDocument = [[DDXMLDocument alloc] initWithXMLString:source options:0 error:&error];
    
    NSArray *results = [theDocument nodesForXPath:@"<body>" error:&error];
    
    for (DDXMLElement *book in results) {
        
        NSLog(@"-----------");
        
        NSString *category = [[book attributeForName:@"nav"] stringValue];
        
        NSLog(@"category:%@",category);
        
        for (int i = 0; i < [book childCount]; i++) {
            DDXMLNode *node = [book childAtIndex:i];
            NSString *name = [node name];
            NSString *value = [node stringValue];
            NSLog(@"%@:%@",name,value);
        }
    }
    
    return  nil;
}

@end
