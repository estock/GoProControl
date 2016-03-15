//
//  MediaCollectionViewCell.h
//  GoProControl
//
//  Created by bossa on 3/15/16.
//  Copyright © 2016 bossa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mediaImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
