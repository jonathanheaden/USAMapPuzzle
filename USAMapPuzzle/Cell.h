//
//  Cell.h
//  IndiaPuzzle
//
//  Created by Jonathan Headen on 17/08/13.
//  Copyright (c) 2013 fadhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *baseColour;
@property (strong, nonatomic) IBOutlet UIImageView *tokenImage;
@property (strong, nonatomic) IBOutlet UIImageView *highlight;
@property (strong, nonatomic) NSNumber *Playable;
@property (nonatomic) BOOL isPlayable;





@end
