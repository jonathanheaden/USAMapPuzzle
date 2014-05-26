//
//  asmMatchingViewController.m
//  USAPuzzle
//
//  Created by Jonathan Headen on 16/08/13.
//  Copyright (c) 2013 airskull. All rights reserved.
//

#import "asmMatchingViewController.h"
#import "Cell.h"
#import "airskullCountry.h"
@interface asmMatchingViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) airskullCountry *mainland; //mainland our model
@property (strong, nonatomic) NSNumber *selection;
@property (nonatomic) BOOL selectionMade;
@property (nonatomic, weak) IBOutlet UIView *homeNav;
@property (nonatomic, weak) IBOutlet UIImageView *mainLabel;
@property (nonatomic, weak) IBOutlet UIImageView *clicksUnits;
@property (nonatomic, weak) IBOutlet UIImageView *clicksTens;
@property (weak, nonatomic) IBOutlet UIImageView *overLay;
@property (readonly) float Scale;
@property (nonatomic) BOOL animatingMatchResult;
@end

@implementation asmMatchingViewController
NSString *kCellID = @"matchCell"; 

-(void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        self.mainLabel.hidden = YES;
    }
    else
    {
        self.mainLabel.hidden = NO;
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView reloadData];
    UITapGestureRecognizer *tapout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapOut:)];
    [self.homeNav addGestureRecognizer:tapout ];
}
-(void)viewDidAppear:(BOOL)animated {
    [self hideOverlayWithDelay:2.0];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll ;
}

-(float)Scale
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 1.0;
    } else {
        return 0.458;
    }
}
-(airskullCountry *)mainland
{
    if (!_mainland) {
        _mainland = [[airskullCountry alloc] init];
    }
    return _mainland;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *selectedCell = (Cell  *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (selectedCell.isPlayable  && !self.animatingMatchResult)
    {
        [self.mainland matchingClick:YES];
        if (self.selectionMade)
        {
            self.animatingMatchResult = YES;
            Cell *lastSelectionCell = (Cell  *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.selection intValue] inSection:0]];
            //check if this selection matches the previously selected object
            // if so flash up correct! animation
            // if not then flash up incorrect animation and deselect both
            if ([[[[self.mainland matchingAnswers] objectForKey:self.selection] objectAtIndex:0] isEqualToString:[[[self.mainland matchingAnswers] objectForKey:[NSNumber numberWithInt:indexPath.row ]] objectAtIndex:1]])
            {
                UIView *answerResponseLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correct.png"]];
                [self flashLabel:answerResponseLabel];
                
                selectedCell.isPlayable = NO;
                lastSelectionCell.isPlayable = NO; 
                [self.mainland addMatch:[NSNumber numberWithInt:indexPath.row]];
                [self.mainland addMatch:self.selection];
                if ([self.mainland isPuzzleComplete]) {
                    NSString *Title = [NSString stringWithFormat:@"Matching Puzzle Completed"];
                    NSString *messageString = [NSString stringWithFormat:@"You completed the puzzle with %@ clicks!",self.mainland.matchingClicks];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                                    message:messageString
                                                                   delegate:self
                                                          cancelButtonTitle: @"Play Again"
                                                          otherButtonTitles: @"Back to Main Menu", @"OK", nil ];
                    [alert show];
                }
            } else
            {
                UIView *answerResponseLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"incorrect.png"]];
                [self flashLabel:answerResponseLabel];
                selectedCell.highlight.alpha = 1.0;
                selectedCell.baseColour.alpha = 0.7;
                lastSelectionCell.highlight.alpha = 1.0;
                lastSelectionCell.baseColour.alpha = 0.7;
            }
            //deselect the cells
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.selection intValue] inSection:0] animated:NO];
            self.selectionMade = NO;
        } else
        {
            selectedCell.highlight.alpha = 0;
            selectedCell.baseColour.alpha = 1.0;
            self.selection = [NSNumber numberWithInt:indexPath.row];
            self.selectionMade = YES;
        }
    } else
    {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    [self drawClicks];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Cell *selectedCell = (Cell  *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (selectedCell.isPlayable)
    {
        [self.mainland matchingClick:NO];
        selectedCell.highlight.alpha = 1.0;
        selectedCell.baseColour.alpha = 0.7;
        self.selectionMade = NO;
    }
    [self drawClicks];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? NUMBER_OF_CELLS_FOR_IPAD_MATCHING : NUMBER_OF_CELLS_FOR_IPHONE_MATCHING;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *ds = [self.mainland getNextStateCapitalPair];
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if ([[ds lastObject] isEqualToString:@"State"])
    {
        cell.baseColour.image = [UIImage imageNamed:@"green.png"];
    } else
    {
        cell.baseColour.image = [UIImage imageNamed:@"yellow.png"];
    }
    cell.highlight.image = [UIImage imageNamed:@"highlight.png"];
    cell.tokenImage.image = [UIImage imageNamed:[[ds objectAtIndex:0] stringByAppendingString:@".png"]];
    return cell;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ((fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        self.mainLabel.hidden = NO;
    } else
    {
        self.mainLabel.hidden = YES;
    }
}

-(void) TapOut:(UIGestureRecognizer *)gesture
{
    if ([self.mainland isPuzzleComplete]) {
        // exit point
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    } else
    { NSString *Title = [NSString stringWithFormat:@"Matching Puzzle not Finished"];
        NSString *messageString = [NSString stringWithFormat:@"Are you sure you want to Quit & Return to Home Screen?"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                        message:messageString
                                                       delegate:self
                                              cancelButtonTitle:@"Start Over"
                                              otherButtonTitles:@"Yes", @"No", nil ];
        [alert show];
    }
}


-(void)flashLabel:(UIView *)answerResponseLabel
{
    float flashX = (self.view.bounds.size.width / 2 );
    float flashY = ((self.homeNav.frame.origin.y) + 50 * self.Scale);
    answerResponseLabel.center  = CGPointMake(flashX, flashY);
    [self.view addSubview:answerResponseLabel];
    
    answerResponseLabel.transform = CGAffineTransformScale(answerResponseLabel.transform, 0.01, 0.01);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform answerTrans = CGAffineTransformScale(answerResponseLabel.transform, 100 * self.Scale, 100 * self.Scale);
                         answerResponseLabel.transform = answerTrans;
                     }
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              CGAffineTransform viewTrans = CGAffineTransformScale(answerResponseLabel.transform, 0.05 * self.Scale, 0.05 * self.Scale);
                                              answerResponseLabel.transform = viewTrans;
                                              answerResponseLabel.alpha = 0.1;
                                          }
                                          completion:^(BOOL finished){
                                              if (finished) {
                                                  [answerResponseLabel removeFromSuperview];
                                                  self.animatingMatchResult = NO;
                                              }
                                          }];
                     }];    
}

-(void) hideOverlayWithDelay:(float)delay
{
    
    self.overLay.transform = CGAffineTransformScale(self.overLay.transform, 1.0, 1.0);
    
    [UIView animateWithDuration:1.0 delay:delay options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.overLay.alpha = 0.0;
                         CGAffineTransform finaltrans = CGAffineTransformScale(self.overLay.transform, 1.0, 1.0);
                         self.overLay.transform =   finaltrans;
                     }
                     completion:^(BOOL completed){if (completed) [self.overLay removeFromSuperview];}];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        //do Nothing
    }
    if (buttonIndex == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }
    if (buttonIndex == 0) {
        [self resetPuzzle];
    }
    
}

-(void)resetPuzzle
{
    self.mainland = nil;
    for (int i=0; i < 16; i++) {
        Cell *thisCell = (Cell  *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        thisCell.isPlayable = YES;
        thisCell.highlight.alpha = 1;
    }
    [self.collectionView reloadData];
    [self drawClicks];
}
-(void)drawClicks
{
    int scorelabel = [self.mainland.matchingClicks intValue];
    int unitScore = (scorelabel % 10);
    int tensScore = ((scorelabel - unitScore) / 10);
    NSString *unitsImage = [NSString stringWithFormat:@"%d.png",unitScore];
    NSString *tensImage = [NSString stringWithFormat:@"%d.png",tensScore];
    self.clicksUnits.image = [UIImage imageNamed:unitsImage];
    self.clicksTens.image = [UIImage imageNamed:tensImage];
}
@end
