//
//  MediaCollectionViewController.m
//  GoProControl
//
//  Created by bossa on 3/15/16.
//  Copyright © 2016 bossa. All rights reserved.
//

#import "MediaCollectionViewController.h"

@interface MediaCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *arrayOfImages;




@end

@implementation MediaCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfImages = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    // Do any additional setup after loading the view.
    
    //[self refershControlAction];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    
    // End Refreshing
    
    // 1
    NSString *string = [NSString stringWithFormat:@"http://10.5.5.9:8080/gp/gpMediaList"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         // 3
         //self.weather = (NSDictionary *)responseObject;
         //self.title = @"JSON Retrieved";
         //[self.tableView reloadData];
         NSLog(@"Responce Data%@", responseObject);
         NSArray *media = [responseObject objectForKey:@"media"];
         NSLog(@"%@", NSStringFromClass([media class]));
         NSLog(@"Media Node %@", media);
         
         [(UIRefreshControl *)sender endRefreshing];

         int i = 0;
         
         
         for (NSObject* med in media)
         {
             //i++
             NSDictionary *mediafiles = med;
             NSArray *fs = [mediafiles objectForKey:@"fs"];
             NSString *foldername = [mediafiles objectForKey:@"d"];
             
             for (NSObject* fi in fs)
             {
                 NSLog(@"FI: %@",fi);
                 NSMutableDictionary *m = [fi mutableCopy];
                 [m setValue:foldername forKey:@"dir"];
                 [self.arrayOfImages addObject:m];
             }
             
             
         }
         
         NSLog(@"self.arrayOfImages: %@",self.arrayOfImages);
         
         [self.collectionView reloadData];
         
         /*
          
          // TODO Itterate through all photos
          NSDictionary *mediafiles = [media objectAtIndex:0];
          NSLog(@"%@", NSStringFromClass([mediafiles class]));
          NSLog(@"Media Files Node %@", mediafiles);
          
          NSArray *fs = [mediafiles objectForKey:@"fs"];
          NSString *foldername = [mediafiles objectForKey:@"d"];
          
          NSLog(@"%@", NSStringFromClass([fs class]));
          NSLog(@"Media Files Node %@", fs);
          
          self.arrayOfImages = fs;
          [self.collectionView reloadData];
          
          for (NSObject* o in fs)
          {
          NSLog(@"%@",o);
          [o setValue:foldername forKey:@"dir"];
          [self.arrayOfImages addObject:o];
          }
          
          //NSDictionary *files = [media objectForKey:@"fs"];
          //NSLog(@"%@", NSStringFromClass([files class]));
          //NSLog(@"Files Node %@", files);
          
          NSLog(@"%@", NSStringFromClass([responseObject class]));
          NSData *returnedData = responseObject;
          NSLog(@"%@", NSStringFromClass([returnedData class]));
          
          */
         
         
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
    
    

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [self.arrayOfImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MediaCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"mediaCell"
                                    forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    
    NSDictionary *mediaObject = [self.arrayOfImages objectAtIndex:row];
    NSString *label = [mediaObject objectForKey:@"n"];
    NSString *filename = [mediaObject objectForKey:@"n"];
    NSString *dirname = [mediaObject objectForKey:@"dir"];

    NSString *subString = [[filename componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *fileType = [[filename componentsSeparatedByString:@"."] objectAtIndex:1];
    
    if([fileType isEqualToString:@"JPG"])
    {
        
    }
    else if ([fileType isEqualToString:@"MP4"])
    {
        filename = [NSString stringWithFormat:@"%@.THM", subString];
    }

    NSString *imageUrlString = [NSString stringWithFormat:@"http://10.5.5.9:8080/DCIM/%@/%@", dirname,filename];
    
    NSLog(@"%@",imageUrlString);
    
    myCell.nameLabel.text = label;
    
    NSURL *url = [NSURL URLWithString:imageUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder-square"];
    
    __weak MediaCollectionViewCell *weakCell = myCell;
    
    [myCell.mediaImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.mediaImage.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"fail");
                                       NSLog(@"%@",error);

                                   }    ];
    
    
    
    
    
    
    
    
    
    
    
    
    //UIImage *image;
    //long row = [indexPath row];
    
    //image = [UIImage imageNamed:_carImages[row]];
    
    //myCell.imageView.image = image;
    
    //myCell
    
    return myCell;
    
    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mediaCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    //return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
