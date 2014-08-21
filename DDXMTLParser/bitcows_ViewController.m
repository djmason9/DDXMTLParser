//
//  bitcows_ViewController.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "bitcows_ViewController.h"
#import "bitcows_parser.h"
#import "bitcows_ripper.h"

@interface bitcows_ViewController ()

@end

@implementation bitcows_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self parseMe];
}

-(void)parseMe{

    NSURLResponse* response;
    NSError* error;
    NSString *url =@"http://content.openclass.com/eps/pearson-reader/api/item/bed10748-e8e8-44e8-87fa-6c872d67d48f/100/file/hsus_pxe_basic/OPS/xhtml/toc.xhtml";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *source = [NSString stringWithUTF8String:[data bytes]];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       id resultDict = [[[bitcows_parser alloc] init] parseData:data orSource:source orURL: url];
                       
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                       NSString *documentsDirectory = [paths objectAtIndex:0];
                       NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myDictionary.plist"];
                       
                       [resultDict writeToFile:filePath atomically:YES];
                       
                       bitcows_ripper *ripper = [[bitcows_ripper alloc]init];
                       
                       [ripper ripPagesIntoBasketList:resultDict[@"nav"][0][@"learner-objects"] parentId:@"root"];
                       
                       [ripper ripPagesIntoList:resultDict[@"nav"][0][@"ol"] parentId:@"root"];
                       
                       
                   });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doAgain:(id)sender {
    [self parseMe];
}
@end
