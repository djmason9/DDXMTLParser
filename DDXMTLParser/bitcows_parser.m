//
//  bitcows_parser.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "bitcows_parser.h"


NSString *const kXMLReaderTextNodeKey = @"title";



@implementation bitcows_parser{
    NSMutableArray *domElmArray;
    NSMutableDictionary *domElmDict;
    NSString *objectId;
}




-(id)parseData:(NSData*)data orSource:(NSString*)source orURL:(NSString*)url{

    domElmArray = [NSMutableArray array];
    domElmDict = [NSMutableDictionary dictionary];
    
    [domElmArray addObject:[NSMutableDictionary dictionary]];
    _theContent = [@""mutableCopy];
    
    [self parseDocumentWithURL:[NSURL URLWithString:url]];
 
    return  [domElmArray objectAtIndex:0];
}


-(BOOL)parseDocumentWithURL:(NSURL *)url {
    if (url == nil)
        return NO;
    _parentId = @"root";
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
//    NSLog(@"didStartDocument");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSLog(@"didEndDocument");
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSString *blankString = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[string length])];
    blankString = [blankString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    
    if(![blankString isEqualToString:@""]){
        [_theContent appendString:[NSString stringWithFormat:@" %@",blankString]];
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    
    if([elementName isEqualToString:@"h1"] ||[elementName isEqualToString:@"title"] || [elementName isEqualToString:@"header"] || [elementName isEqualToString:@"html"] || [elementName isEqualToString:@"head"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"body"] || [elementName isEqualToString:@"meta"]|| [elementName isEqualToString:@"span"])
        return;
    
    if ([elementName isEqualToString:@"nav"] && [[attributeDict objectForKey:@"id"] isEqualToString:@"learning-objectives"]) {
        elementName = @"learner-objects";
    }
    
    NSString *classname = [attributeDict objectForKey:@"class"];

    

    if([attributeDict objectForKey:@"id"]){
        objectId = [attributeDict objectForKey:@"id"];
    }

   
   
    
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [domElmArray lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]]) {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        if([elementName isEqualToString:@"nav"]){
            [childDict removeObjectForKey:@"id"];
        }
        [childDict removeObjectForKey:@"class"];
        [childDict removeObjectForKey:@"epub:type"];
        [childDict removeObjectForKey:@"hidden"];
        if([elementName isEqualToString:@"a"]){
            [childDict setObject:objectId forKey:@"id"];
        }
        
        if(([classname isEqualToString:@"tocentrylist"] || [classname isEqualToString:@"objective"]) && ![_theContent isEqualToString:@""]){
            [childDict setObject:[_theContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kXMLReaderTextNodeKey];
            _theContent = [@""mutableCopy];
            
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        if([elementName isEqualToString:@"nav"]){
            [childDict removeObjectForKey:@"id"];
        }
        [childDict removeObjectForKey:@"class"];
        [childDict removeObjectForKey:@"epub:type"];
        [childDict removeObjectForKey:@"hidden"];
        
        if([elementName isEqualToString:@"a"]){
            [childDict setObject:objectId forKey:@"id"];
        }
        
        if(([classname isEqualToString:@"tocentrylist"] || [classname isEqualToString:@"objective"]) && ![_theContent isEqualToString:@""]){
            [childDict setObject:[_theContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kXMLReaderTextNodeKey];
            _theContent = [@""mutableCopy];
            
        }
        
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [domElmArray addObject:childDict];
    
    
//    NSLog(@"didStartElement: %@", elementName);
//    if([elementName isEqualToString:@"li"]){
//        NSLog(@"******** parentId= %@ *********", _parentId);
//    }
    
//    if (namespaceURI != nil)
//        NSLog(@"namespace: %@", namespaceURI);
//    
//    if (qName != nil)
//        NSLog(@"qualifiedName: %@", qName);
    
    // print all attributes for this element
    NSEnumerator *attribs = [attributeDict keyEnumerator];
    NSString *key, *value;
    
    while((key = [attribs nextObject]) != nil) {
        value = [attributeDict objectForKey:key];
//        NSLog(@">>> attribute: %@ = %@", key, value);
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"h1"]||[elementName isEqualToString:@"title"])
        _theContent = [@""mutableCopy];
    
    if([elementName isEqualToString:@"h1"] ||[elementName isEqualToString:@"header"] ||[elementName isEqualToString:@"title"] ||[elementName isEqualToString:@"html"] || [elementName isEqualToString:@"head"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"body"] || [elementName isEqualToString:@"meta"] || [elementName isEqualToString:@"span"])
        return;

    
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [domElmArray lastObject];

//    NSLog(@"didEndElement: %@", elementName);
    
    if(![_theContent isEqualToString:@""] && ![elementName isEqualToString:@"h1"] && ![elementName isEqualToString:@"header"]){
       
        [dictInProgress setObject:[_theContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kXMLReaderTextNodeKey];
        
//        NSLog(@"CONTENT:%@", _theContent);
    }
    
    _theContent = [@""mutableCopy];

    // Pop the current dict
    [domElmArray removeLastObject];

}

// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}

@end
