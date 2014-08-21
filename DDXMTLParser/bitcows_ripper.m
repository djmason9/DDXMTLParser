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
        

         i++;
    }
    else {
        return NO;
    }
    
    return YES;
}

-(void)ripCustomBasketPagesIntoList:(NSArray*)childrens parentId:(NSString*)parentId {
    
}

/**
 This method would be called recursively to convert the tree of generic data into the list of models
 @param NSArray, childrens is a array of data from the tree of generic data
 @param NSString, parentId is a root id of the branch.
 */
-(void)ripPagesIntoList:(id)childrens parentId:(NSString*)parentId
{
    
    
    static NSInteger uniqueId = 0;
    
    if([childrens isKindOfClass:[NSArray class]]){
    
        [self ripPagesIntoList:childrens[uniqueId] parentId:parentId];
    }
    
    for (NSDictionary *dic in childrens)
    {
        if(![dic isKindOfClass:[NSString class]]) {
            [self ripPagesIntoList:dic parentId:parentId];
        }
        
        if ([childrens[dic] isKindOfClass:[NSDictionary class]])
        {
            
            id children = childrens[dic][NCX_PARENT];
            BOOL isChildren = NO;
            if(children) {
                isChildren = YES;
            }
            
            NSMutableDictionary *ncxContent = childrens[dic];
            NSString *rootId = @"root";
            
            if((ncxContent) && ([ncxContent isKindOfClass:[NSDictionary class]]))
            {
                if(!ncxContent[NCX_ID])
                {
                    [ncxContent setValue:[NSString stringWithFormat:@"root_%d",uniqueId] forKey:NCX_ID];
                    ++uniqueId;
                }
                
                if(![self parsePageDetails:ncxContent withParentId:parentId childrenFound:isChildren]) {
                    int size = [[ncxContent description] length] > 150? 150 : [[ncxContent description]length];
                    NSLog(@"wrong data type (%@)..., moving on...",[[ncxContent description] substringToIndex:size]);
                }
                
                rootId = (ncxContent[NCX_ID] != nil) ? ncxContent[NCX_ID] : @"root";
            }
            
            if(isChildren)
            {
                
                
                NSArray *items = children[NCX_CHILDREN];
                if(![items isKindOfClass:[NSArray class]]) {
                    items = @[items];
                }
                
                [self ripPagesIntoList:items parentId:rootId];
            }
        }

    }
    
}

/**
 This method would be called recursively to convert the tree of generic data into the list of models
 @param NSArray, childrens is a array of data from the tree of generic data
 @param NSString, parentId is a root id of the branch.
 */
-(void)ripPagesIntoBasketList:(id)childrens parentId:(NSString*)parentId
{
    
    
    static NSInteger uniqueId = 0;
    
    for (NSDictionary *dic in childrens)
    {
        if ([childrens[dic] isKindOfClass:[NSDictionary class]])
        {
            
            id children = childrens[dic][NCX_PARENT];
            BOOL isChildren = NO;
            if(children) {
                isChildren = YES;
            }
            
            NSMutableDictionary *ncxContent = childrens[dic];
            NSString *rootId = @"root";
            
            if((ncxContent) && ([ncxContent isKindOfClass:[NSDictionary class]]))
            {
                if(!ncxContent[NCX_ID])
                {
                    [ncxContent setValue:[NSString stringWithFormat:@"root_%d",uniqueId] forKey:NCX_ID];
                    ++uniqueId;
                }
                
                if(![self parsePageDetails:ncxContent withParentId:parentId childrenFound:isChildren]) {
                    NSLog(@"wrong data type (%@) moving on...",[ncxContent description]);
                }
                
                rootId = (ncxContent[NCX_ID] != nil) ? ncxContent[NCX_ID] : @"root";
            }
            
            if(isChildren)
            {
                
                
                NSArray *items = children[NCX_CHILDREN];
                if(![items isKindOfClass:[NSArray class]]) {
                    items = @[items];
                }
                
                [self ripPagesIntoBasketList:items parentId:rootId];
            }
        }
//        else
//        {
//            if([dic isKindOfClass:[NSArray class]])
//            {
//                for (id object in dic) {
//                    [self ripPagesIntoBasketList:object parentId:@"root"];
//                }
//            }
//        }
    }
    
}

@end
