//
//  SettingsTableViewController.m
//  GoProControl
//
//  Created by bossa on 3/11/16.
//  Copyright © 2016 bossa. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)setup {
    
    self.title = @"Bohr";
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Section 1" handler:^(BOTableViewSection *section) {
        
        BOSwitchTableViewCell *switchCell  = [BOSwitchTableViewCell cellWithTitle:@"Switch 1" key:@"bool_1" handler:nil];
        [switchCell.toggleSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

        [section addCell:switchCell];
        
        [section addCell:[BOSwitchTableViewCell cellWithTitle:@"Switch 2" key:@"bool_2" handler:^(BOSwitchTableViewCell *cell) {
            cell.visibilityKey = @"bool_1";
            cell.visibilityBlock = ^BOOL(id settingValue) {
                return [settingValue boolValue];
            };
            cell.onFooterTitle = @"Switch setting 2 is on";
            cell.offFooterTitle = @"Switch setting 2 is off";
        }]];
        
    }]];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Section 2" handler:^(BOTableViewSection *section) {
        
        [section addCell:[BOTextTableViewCell cellWithTitle:@"Text" key:@"text" handler:^(BOTextTableViewCell *cell) {
            cell.textField.placeholder = @"Enter text";
            cell.inputErrorBlock = ^(BOTextTableViewCell *cell, BOTextFieldInputError error) {
                [weakSelf showInputErrorAlert:error];
            };
        }]];
        
        [section addCell:[BONumberTableViewCell cellWithTitle:@"Number" key:@"number" handler:^(BONumberTableViewCell *cell) {
            cell.textField.placeholder = @"Enter number";
            cell.numberOfDecimals = 3;
            cell.inputErrorBlock = ^(BOTextTableViewCell *cell, BOTextFieldInputError error) {
                [weakSelf showInputErrorAlert:error];
            };
        }]];
        
        //[section addCell:[BODateTableViewCell cellWithTitle:@"Date" key:@"date" handler:nil]];
        
        /*
        [section addCell:[BOTimeTableViewCell cellWithTitle:@"Time" key:@"time" handler:^(BOTimeTableViewCell *cell) {
            cell.datePicker.minuteInterval = 5;
        }]];
         */
        
        [section addCell:[BOChoiceTableViewCell cellWithTitle:@"Choice" key:@"choice_1" handler:^(BOChoiceTableViewCell *cell) {
            cell.options = @[@"Option 1", @"Option 2", @"Option 3"];
            cell.footerTitles = @[@"Option 1", @"Option 2", @"Option 3"];
        }]];
        
        [section addCell:[BOChoiceTableViewCell cellWithTitle:@"Choice disclosure" key:@"choice_2" handler:^(BOChoiceTableViewCell *cell) {
            cell.options = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4"];
            //cell.destinationViewController = [OptionsTableViewController new];
        }]];
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Section 3" handler:^(BOTableViewSection *section) {
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Button" key:nil handler:^(BOButtonTableViewCell *cell) {
            cell.actionBlock = ^{
                [weakSelf showTappedButtonAlert];
            };
        }]];
        
        section.footerTitle = @"Static footer title";
    }]];
}

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setState:(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"ON" : @"OFF";
    NSLog(rez);
    
    NSURL *url;
    

    
    if(state == TRUE)
    {
        //url = [NSURL URLWithString:@"http://10.5.5.9:80/bacpac/PW?t=hardlypro&p=%01"];
        NSString *dev_ip = @"http://10.5.5.9:80/bacpac/PW?t=hardlypro&p=%01"; // Google.com
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dev_ip]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else{
        NSString *dev_ip = @"http://10.5.5.9:80/bacpac/PW?t=hardlypro&p=%00"; // Google.com
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dev_ip]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];        //url = [NSURL URLWithString:@"http://10.5.5.9:80/bacpac/PW?t=hardlypro&p=%00"];
        
    }
    
    
    /*
     
    NSURL *url = [NSURL URLWithString:@"http://10.5.5.9:80/bacpac/PW?t=hardlypro&p=%01"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        //return nil;
    }
    
    //return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
     
    
    //http://10.5.5.9:80/'+device+'/'+app+'?t='+document.getElementById('wifiPassword').value+'&p='+command
     
     */
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    switch ([(NSHTTPURLResponse *)response statusCode]) { // Edited this!
        case 200: {
            NSLog(@"Received connection response!");
            break;
        }
        default: {
            NSLog(@"Something bad happened!");
            break;
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error connecting. Error: %@", error);
}

- (void)showInputErrorAlert:(BOTextFieldInputError)error {
    NSString *message;
    
    switch (error) {
        case BOTextFieldInputTooShortError:
            message = @"The text is too short";
            break;
            
        case BOTextFieldInputNotNumericError:
            message = @"Please input a valid number";
            break;
            
        default:
            break;
    }
    
    if (message) {
        [self presentAlertControllerWithTitle:@"Error" message:message];
    }
}

- (void)showTappedButtonAlert {
    //[self presentAlertControllerWithTitle:@"Button tapped!" message:nil];
    
    
    // 1
    NSString *string = [NSString stringWithFormat:@"http://10.5.5.9:8080/gp/gpMediaList"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //self.weather = (NSDictionary *)responseObject;
        //self.title = @"JSON Retrieved";
        //[self.tableView reloadData];
        NSLog(@"Responce Data%@", responseObject);
        NSArray *media = [responseObject objectForKey:@"media"];
        NSLog(@"%@", NSStringFromClass([media class]));
        NSLog(@"Media Node %@", media);
        
        // TODO Itterate through all photos
        NSDictionary *mediafiles = [media objectAtIndex:0];
        NSLog(@"%@", NSStringFromClass([mediafiles class]));
        NSLog(@"Media Files Node %@", mediafiles);
        
        NSArray *fs = [mediafiles objectForKey:@"fs"];
        NSLog(@"%@", NSStringFromClass([fs class]));
        NSLog(@"Media Files Node %@", fs);
        
        for (NSObject* o in fs)
        {
            NSLog(@"%@",o);
        }

        
        

        
        
        //NSDictionary *files = [media objectForKey:@"fs"];
        //NSLog(@"%@", NSStringFromClass([files class]));
        //NSLog(@"Files Node %@", files);




        
        NSLog(@"%@", NSStringFromClass([responseObject class]));
        NSData *returnedData = responseObject;
        NSLog(@"%@", NSStringFromClass([returnedData class]));
        
        

        
        // probably check here that returnedData isn't nil; attempting
        // NSJSONSerialization with nil data raises an exception, and who
        // knows how your third-party library intends to react?
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
    
    
    
    /*
    NSString* theURL = [NSString stringWithFormat:@"http://10.5.5.9:8080/gp/gpMediaList"];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    NSURL*URL = [NSURL URLWithString:theURL];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];

    
    
    
    
    
    NSString *url = @"http://10.5.5.9:8080/DCIM/121GOPRO";
    NSURL *urlRequest = [NSURL URLWithString:url];
    
    NSError *err = nil;
    NSError *parseError = nil;
    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&err];
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:html error:&parseError];
     
     
    
    if(err)
    {
        //Handle
        NSLog(@"%@", err);
    }
    
    // Print the dictionary
    NSLog(@"%@", xmlDictionary);
    
    id someObject = [xmlDictionary valueForKey:@"html.body.div.div.div.table.tbody"];
     */

    
    //NSDictionary *level2Dict = [mainDictionary objectForKey:@"html"];
    //NSDictionary *level3Dict = [level2Dict objectForKey:@"body"];
//NSDictionary *level4Dict = [level3Dict objectForKey:@"div"];
    //NSDictionary *level5Dict = [level4Dict objectForKey:@"div"];
//NSDictionary *level6Dict = [level5Dict objectForKey:@"table"];
   // NSDictionary *level7Dict = [level6Dict objectForKey:@"tbody"];
    
    //NSLog(@"%@", someObject);



    
    /*
    
    NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:urlRequest];
    [parser setDelegate:self];
    BOOL result = [parser parse];
    // Invoke the parser and check the result
    [parser parse];
        
    // All done
    NSLog(@"Main Ended");
     
     
    */ 
   
    /*
    NSError *err = nil;
    
    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&err];
    
    if(err)
    {
        //Handle
        NSLog(@"%@", err);
    }
    
    NSLog(@"%@", html);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLFile:html];
    NSLog(@"%@", xmlDoc);
    NSString *foo = [xmlDoc valueForKeyPath:@"body"];
    NSLog(@"FOOOOOOOOOOOOOOOOOOO %@", foo);
     */
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"elementName %@", elementName);

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"Did end element");
    if ([elementName isEqualToString:@"root"])
    {
        NSLog(@"rootelement end");
    }
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *tagName = @"column";
    
    if([tagName isEqualToString:@"column"])
    {
        NSLog(@"Value %@",string);
    }
    
}





@end
