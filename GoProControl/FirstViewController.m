//
//  FirstViewController.m
//  GoProControl
//
//  Created by bossa on 3/11/16.
//  Copyright © 2016 bossa. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSURL *starturl = [NSURL URLWithString:@"http://10.5.5.9:8080/gp/gpControl/execute?p1=gpStream&c1=start"];
    NSURLRequest *request = [NSURLRequest requestWithURL:starturl];
    
    NSURLResponse *response;
    NSError *error;
    //send it synchronous
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // check for an error. If there is a network error, you should handle it here.
    if(!error)
    {
        //log response
        NSLog(@"Response from server = %@", responseString);
        
        NSString *videoUrl = @"http://10.5.5.9:8080/live/amba.m3u8";
        NSURL *url = [NSURL URLWithString:videoUrl];
        
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [self.moviePlayer setControlStyle:MPMovieControlStyleDefault];
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        CGRect frame;
        if(self.interfaceOrientation ==UIInterfaceOrientationPortrait)
            frame = CGRectMake(20, 69, 280, 170);
        else if(self.interfaceOrientation ==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation ==UIInterfaceOrientationLandscapeRight)
            frame = CGRectMake(20, 61, 210, 170);
        [self.moviePlayer.view setFrame:frame];  // player's frame must match parent's
        [self.view addSubview: self.moviePlayer.view];
        [self.view bringSubviewToFront:self.moviePlayer.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];
        
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer play];
    }
    else
    {
        NSLog(@"Error from server = %@", error);

    }
    
}

-(void) moviePlayBackDidFinish:(NSNotification *)notification{
    NSLog(@"Player stopped for some reason");

    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
