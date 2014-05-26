//
//  asmViewController.h
//  IrelandMaps
//
//  Created by Jonathan Headen on 17/02/13.
//  Copyright (c) 2013 AirSkull. All rights reserved.
//

#import <UIKit/UIKit.h>
@class asmViewController;
@protocol asmViewControllerDelegate <NSObject>
@optional
- (void)asmViewController:(asmViewController *)sender
           puzzleComplete:(BOOL)completed;
-(void)asmViewController:(asmViewController *)sender
     didFlickHintsSwitch:(BOOL)toggleOnOff;
-(void)launchTheQuiz;
@end
@interface asmViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) id <asmViewControllerDelegate> delegate;
@property (nonatomic) BOOL landscapeOn;
@property (strong, nonatomic) NSString *mapData; //which map is being loaded
@property (strong, nonatomic) NSString *mapSections; //which types are we showing
@property (nonatomic) BOOL hintsOnOff;  //show the hints or not (controlled by switch)
@property (nonatomic, strong) NSArray *quizCategories;//which sections are included in quiz last entry is the number of questions


@end