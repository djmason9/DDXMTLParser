//
//  bitcows_ripper.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "bitcows_ripper.h"
#import "BasketDetails.h"

#define NCX_PARENT @"ol"
#define NCX_CHILDREN @"li"
#define NCX_ANCHOR @"a"
#define NCX_SRC @"href"
#define NCX_NAV_TITLE @"title"
#define NCX_LEARNER_OBJECTS @"learner-objects"
#define NCX_ID @"id"


@implementation bitcows_ripper


-(BOOL)parsePageDetails:(NSDictionary*)data withParentId:(NSString*)parentId childrenFound:(BOOL)isChildren
{

    static int i=0;
    
    if(data[@"li"]){
        return NO;
    }
    
    if(data[@"a"]){
        data = data[@"a"];
    }
    
    
    if(data[@"ol"]){
        return NO;
    }
    
    
    
    NSString *pageUrl = data[NCX_SRC];
    if(pageUrl)
    {
        
        NSString *pageTitle = data[NCX_NAV_TITLE];
        NSString *urlTag = @"";
        NSArray *urlCom = [pageUrl componentsSeparatedByString:@"#"];
        
        pageUrl = urlCom[0];
        if([urlCom count] > 1) {
            urlTag = urlCom[1];
        }
        
        BasketDetails *basketDetails = [[BasketDetails alloc]init];
        
        basketDetails.pageId =data[NCX_ID];
        basketDetails.pageNumber = [NSNumber numberWithInt:i];
        basketDetails.pageTitle = pageTitle;
        basketDetails.pageURL = pageUrl;
        basketDetails.parentId = parentId;
        basketDetails.urlTag = urlTag;
        basketDetails.isChildren = [NSNumber numberWithBool:isChildren];
        basketDetails.book = @"book1222";
        
        NSLog(@"CORE DATA: %@",[basketDetails description]);

         i++;
    }
    else {
        return NO;
    }
    
    return YES;
}

-(void)ripCustomBasketPagesIntoList:(id)childrens parentId:(NSString*)parentId {
    
    static BOOL hasChildren = NO;
    
    if([parentId isEqualToString:@"root"]){
        hasChildren = YES;
    }
    
    for (id key in childrens)
    {
        
        //dicts only
        if([childrens[key] isKindOfClass:[NSDictionary class]]){
            
            
            
            // 1. if list item grab the a
            // 2. if the list item is an array loop the array and grab the a
            // 3. if the list item has an OL call recursive and start over
            
            if(childrens[@"ol"] && [childrens[@"ol"][@"li"] isKindOfClass:[NSArray class]])
            {
                if(childrens[@"ol"][@"li"][0])
                    hasChildren = YES;
            }else if(childrens[@"ol"] && [childrens[@"ol"][@"li"] isKindOfClass:[NSDictionary class]])
            {
                if(childrens[@"ol"][@"li"])
                    hasChildren = YES;
            }
            
            if(childrens[key]){
                
                if ([childrens[key] isKindOfClass:[NSArray class]]) {
                    //loop all the kids
                    for (id kid in [childrens objectForKey:key]) {
                        if(![self parsePageDetails:kid withParentId:parentId childrenFound:hasChildren]) {
//                            int size = [[childrens[key] description] length] > 150? 150 : [[childrens[key] description]length];
//                            NSLog(@"1. wrong data type (%@)..., moving on...",[[childrens[key] description] substringToIndex:size]);
                        }
                        hasChildren = NO;
                    }
                    
                }else{
                    
                    if(![self parsePageDetails:childrens[key] withParentId:parentId childrenFound:hasChildren]) {
                        //int size = [[childrens[key] description] length] > 150? 150 : [[childrens[key] description]length];
                        //NSLog(@"2. wrong data type (%@)..., moving on...",[[childrens[key] description] substringToIndex:size])
                        if(childrens[@"id"])
                           parentId = childrens[@"id"];
                        
                        //NSLog(@"1. [%@] Dilling Down into %@",key,parentId);
                        [self ripCustomBasketPagesIntoList:childrens[key] parentId:parentId];
                    }
                    hasChildren = NO;
                    parentId = childrens[@"a"][@"id"];
                }
              
            }
        }else if([childrens[key] isKindOfClass:[NSArray class]]){
            //loop this and get out its goodies
            for (id kids in [childrens objectForKey:key]){
                //NSLog(@"3. [%@] Dilling Down into %@",key,parentId);
                [self ripCustomBasketPagesIntoList:kids parentId:parentId];
            }
            
        }
        
    }
}

/**
 This method would be called recursively to convert the tree of generic data into the list of models
 @param NSArray, childrens is a array of data from the tree of generic data
 @param NSString, parentId is a root id of the branch.
 */
-(void)ripPagesIntoList:(id)childrens parentId:(NSString*)parentId
{    
    BOOL isChildren = NO;
    BOOL hasChildren = NO;
    
    if(childrens[@"li"] && [childrens[@"li"] isKindOfClass:[NSDictionary class]]){
        id children = childrens[@"li"][NCX_PARENT];
        
        if(children) {
            isChildren = YES;
        }
    }
    
    if([parentId isEqualToString:@"root"]){
        hasChildren=YES;
    }
    
    for (id key in childrens)
    {
        
            //dicts only
            if([childrens[key] isKindOfClass:[NSDictionary class]]){
                
                
                
                // 1. if list item grab the a
                // 2. if the list item is an array loop the array and grab the a
                // 3. if the list item has an OL call recursive and start over
                
                if(childrens[key]){
                    
                    if ([childrens[key] isKindOfClass:[NSArray class]]) {
                        //loop all the kids
                        for (id kid in [childrens objectForKey:key]) {
                            
                            if([key isEqualToString:@"a"] && childrens[@"ol"] && childrens[@"ol"][@"li"]){
                                hasChildren = YES;
                            }
                            
                            if(![self parsePageDetails:kid withParentId:parentId childrenFound:hasChildren]) {
                                //int size = [[childrens[key] description] length] > 150? 150 : [[childrens[key] description]length];
                                //NSLog(@"1. wrong data type (%@)..., moving on...",[[childrens[key] description] substringToIndex:size]);
                            }
                        }
                        
                    }else{
                        
                        if([key isEqualToString:@"a"] && childrens[@"ol"] && childrens[@"ol"][@"li"]){
                            hasChildren = YES;
                        }
                       
                        if(![self parsePageDetails:childrens[key] withParentId:parentId childrenFound:hasChildren]) {
                            //int size = [[childrens[key] description] length] > 150? 150 : [[childrens[key] description]length];
                            //NSLog(@"2. wrong data type (%@)..., moving on...",[[childrens[key] description] substringToIndex:size]);
                            parentId = childrens[@"a"][@"id"];
                            [self ripPagesIntoList:childrens[key] parentId:parentId];
                        }
                    }
                    
                    
                    if(isChildren){
                         NSLog(@"1. Dilling Down into %@",childrens[key][@"id"]);
                        parentId = childrens[key][@"a"][@"id"];
                        [self ripPagesIntoList:childrens[key][@"ol"] parentId:parentId];
                    }
                }
            }else if([childrens[key] isKindOfClass:[NSArray class]]){
                //loop this and get out its goodies
                for (id kids in [childrens objectForKey:key]){
                    //NSLog(@"2. Dilling Down into %@",parentId);
                    [self ripPagesIntoList:kids parentId:parentId];
                }
            
            }
        
    }

    
}


@end
