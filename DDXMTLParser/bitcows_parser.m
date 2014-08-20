//
//  bitcows_parser.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "bitcows_parser.h"



@implementation bitcows_parser

-(NSDictionary*)parseData:(NSData*)data orSource:(NSString*)source orURL:(NSString*)url{

    [self parseDocumentWithURL:[NSURL URLWithString:url]];


    
    return  nil;
}


-(BOOL)parseDocumentWithURL:(NSURL *)url {
    if (url == nil)
        return NO;
    
    // this is the parsing machine
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    // this class will handle the events
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];
    
    // now parse the document
    BOOL ok = [xmlparser parse];
    if (ok == NO)
        NSLog(@"error");
    else
        NSLog(@"OK");
    

    return ok;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"didStartDocument");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"didEndDocument");
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(![string isEqualToString:@""])
        NSLog(@"CONTENT: %@",string);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"html"] || [elementName isEqualToString:@"head"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"body"] || [elementName isEqualToString:@"meta"])
        return;
    
    NSLog(@"didStartElement: %@", elementName);
    
    if (namespaceURI != nil)
        NSLog(@"namespace: %@", namespaceURI);
    
    if (qName != nil)
        NSLog(@"qualifiedName: %@", qName);
    
    // print all attributes for this element
    NSEnumerator *attribs = [attributeDict keyEnumerator];
    NSString *key, *value;
    
    while((key = [attribs nextObject]) != nil) {
        value = [attributeDict objectForKey:key];
        NSLog(@"  attribute: %@ = %@", key, value);
    }
    
    // add code here to load any data members
    // that your custom class might have
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"html"] || [elementName isEqualToString:@"head"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"body"] || [elementName isEqualToString:@"meta"])
        return;
    NSLog(@"didEndElement: %@", elementName);
}

// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}

@end
