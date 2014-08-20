//
//  bitcows_ViewController.m
//  DDXMTLParser
//
//  Created by Mason, Darren J on 8/20/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "bitcows_ViewController.h"
#import "bitcows_parser.h"

@interface bitcows_ViewController ()

@end

@implementation bitcows_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURLResponse* response;
    NSError* error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://content.openclass.com/eps/pearson-reader/api/item/bed10748-e8e8-44e8-87fa-6c872d67d48f/100/file/hsus_pxe_basic/OPS/xhtml/toc.xhtml"]];
    
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       id resultDict = [[[bitcows_parser alloc] init] parseData:data];
                       
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                       NSString *documentsDirectory = [paths objectAtIndex:0];
                       NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myDictionary.plist"];
                       
                       [resultDict writeToFile:filePath atomically:YES];

                       
                   });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
