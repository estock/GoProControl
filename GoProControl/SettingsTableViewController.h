//
//  SettingsTableViewController.h
//  GoProControl
//
//  Created by bossa on 3/11/16.
//  Copyright © 2016 bossa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Bohr/Bohr.h>
#import <XMLDictionary/XMLDictionary.h>
#import <AFNetworking/AFNetworking.h>
#import "XMLReader.h"



@interface SettingsTableViewController : BOTableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>

@end
