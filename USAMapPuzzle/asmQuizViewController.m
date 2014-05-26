//
//  asmQuizViewController.m
//  AirSkull
//
//  Created by Jonathan Headen on 13/02/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import "asmQuizViewController.h"
#import "airskullCountry.h"

@interface asmQuizViewController ()

@property (strong, nonatomic) airskullCountry *mainland;//mainland
@property (weak, nonatomic) IBOutlet UIImageView *token;
@property (weak, nonatomic) IBOutlet UIImageView *markerView;
@property (weak, nonatomic) IBOutlet UIImageView *answerA;
@property (weak, nonatomic) IBOutlet UIImageView *answerB;
@property (weak, nonatomic) IBOutlet UIImageView *answerC;
@property (weak, nonatomic) IBOutlet UIImageView *answerD;
@property (weak, nonatomic) IBOutlet UIImageView *completedStatesView;
@property (weak, nonatomic) IBOutlet UIImageView *completedStateLabelsView;
@property (weak, nonatomic) IBOutlet UIImageView *mapOutline;
@property (weak, nonatomic) IBOutlet UIImageView *scoreTens;
@property (weak, nonatomic) IBOutlet UIImageView *scoreUnits;
@property (weak, nonatomic) IBOutlet UIView *homeNav;
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
@property (nonatomic) BOOL inPlay;

@property int correctAnswerPos;
@property (weak, nonatomic) IBOutlet UIImageView *tensNumAskedQuestionsImage;
@property (weak, nonatomic) IBOutlet UIImageView *unitsNumAskedQuestionsImage;
@property (nonatomic) BOOL answeringQuestion;
@property (weak, nonatomic) IBOutlet UIImageView *mapView;
@property (readonly) float Scale;
@property (readonly) float PositionalOffset;
@property (nonatomic) int rndStartingColor;
@end

@implementation asmQuizViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    [self.view addGestureRecognizer:tap ];
    self.hintsOnOff = NO;
    self.homeNav.hidden = NO;
    [self loadQuestion];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    float mapX = ((self.view.bounds.size.width * self.PositionalOffset ) - (self.mapOutline.frame.size.width /2));
    float mapY = ((self.view.bounds.size.height / 2 ) - (self.mapOutline.frame.size.height /2));
    CGRect mapRect = CGRectMake(mapX, mapY, self.mapOutline.frame.size.width, self.mapOutline.frame.size.height);
    [self.mapOutline setFrame:mapRect];
    [self.markerView setFrame:mapRect];
    [self.completedStatesView setFrame:mapRect];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskAll ;
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(airskullCountry *)mainland
{
    if (!_mainland) {
        _mainland = [[airskullCountry alloc] init];
        _mainland.quizCategories = self.quizCategories;
    }
    return _mainland;
}

-(float)Scale
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 1.0;
    } else {
        return 0.458;
    }
}

-(int)rndStartingColor
{
    if (!_rndStartingColor) _rndStartingColor = arc4random() % 2;
    return _rndStartingColor;
}

-(float)PositionalOffset
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 0.45;
    } else {
        return 0.5;
    }
}

#pragma mark logic etc

-(void)animateNewToken
{
    //leave this blank to stop the tokens getting animated in Quizmode
}
-(void)loadQuestion
{
    for (UIView *view in [self.completedStatesView subviews]) {
        [view removeFromSuperview];
    }
    for (UIView *view in [self.markerView subviews]){
        [view removeFromSuperview];
    }
    self.answerA.alpha = 0;
    self.answerB.alpha = 0;
    self.answerC.alpha = 0;
    self.answerD.alpha = 0;
    
    NSArray *question = [self.mainland getNextQuestion];
    if ([[question lastObject] isEqualToString:@"Complete"]) {
        //Quiz is Finished so let the user know...score etc.
        NSString *Title = [NSString stringWithFormat:@"Quiz Complete"];
        NSString *messageString = [NSString stringWithFormat:@"Your score was %@ out of %@",self.mainland.quizScore,[self.mainland.quizCategories lastObject]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:messageString delegate:self cancelButtonTitle: @"Play Again" otherButtonTitles:@"Back to Main Menu", nil ];
        [alert show];
    }
    else
    {
        
        [self drawQuestionsAsked];
        if ([[question lastObject] isEqualToString:@"State"]) {
            self.token.image = [UIImage imageNamed:@"Statequestion.png"];
        }
        if ([[question lastObject] isEqualToString:@"Capital"]) {
            self.token.image = [UIImage imageNamed:@"Capitalquestion.png"];
        }

        NSMutableArray *answers = [[self.mainland answersForQuestion:question ofType:[question lastObject]] mutableCopy];
        NSMutableArray *answerChoices = [[NSMutableArray alloc]init];
        int x = (arc4random() % 4);
        for (int i = 0; i < 4; i++) {
            if (i == x)
            {
                NSString *answerName = [question objectAtIndex:4];
                [answerChoices addObject:answerName];
                self.correctAnswerPos  = x;
                self.mainland.targetName=answerName;
            }
            else
            {
                [answerChoices addObject:[[answers lastObject]objectAtIndex:4]];
                [answers removeLastObject];
            }
        }
        if ([[question lastObject] isEqualToString:@"State"]) {
            self.answerA.image = [UIImage imageNamed:[[answerChoices objectAtIndex:0]stringByAppendingString:@"_label.png"]];
            self.answerB.image = [UIImage imageNamed:[[answerChoices objectAtIndex:1]stringByAppendingString:@"_label.png"]];
            self.answerC.image = [UIImage imageNamed:[[answerChoices objectAtIndex:2]stringByAppendingString:@"_label.png"]];
            self.answerD.image = [UIImage imageNamed:[[answerChoices objectAtIndex:3]stringByAppendingString:@"_label.png"]];
        } else {
            
            self.answerA.image = [UIImage imageNamed:[[self.mainland stateCapitalforState:[answerChoices objectAtIndex:0]]stringByAppendingString:@"_label.png"]];
            self.answerB.image = [UIImage imageNamed:[[self.mainland stateCapitalforState:[answerChoices objectAtIndex:1]]stringByAppendingString:@"_label.png"]];
            self.answerC.image = [UIImage imageNamed:[[self.mainland stateCapitalforState:[answerChoices objectAtIndex:2]]stringByAppendingString:@"_label.png"]];
            self.answerD.image = [UIImage imageNamed:[[self.mainland stateCapitalforState:[answerChoices objectAtIndex:3]]stringByAppendingString:@"_label.png"]];
        }
        [self animateNewAnswer:self.answerA];
        [self animateNewAnswer:self.answerB];
        [self animateNewAnswer:self.answerC];
        [self animateNewAnswer:self.answerD];
        [self dockState];
    }
}

-(void)drawScores
{
    //draw the scoreboard
    int scorelabel = [self.mainland.quizScore intValue];
    int unitScore = (scorelabel % 10);
    int tensScore = ((scorelabel - unitScore) / 10);
    NSString *unitsImage = [NSString stringWithFormat:@"%d.png",unitScore];
    NSString *tensImage = [NSString stringWithFormat:@"%d.png",tensScore];
    self.scoreUnits.image = [UIImage imageNamed:unitsImage];
    self.scoreTens.image = [UIImage imageNamed:tensImage];
}
-(void)drawQuestionsAsked
{
    //draw the number questions asked
    int numAskedLabel = [self.mainland.numAskedQuestions intValue];
    int unitasked = (numAskedLabel % 10);
    int tensasked = ((numAskedLabel - unitasked) / 10);
    if (tensasked > 0) {
        NSString *numAskedUnitsImage = [NSString stringWithFormat:@"%d.png",unitasked];
        NSString *numAskedTensImage = [NSString stringWithFormat:@"%d.png",tensasked];
        self.tensNumAskedQuestionsImage.image = [UIImage imageNamed:numAskedTensImage];
        self.unitsNumAskedQuestionsImage.image = [UIImage imageNamed:numAskedUnitsImage];
        self.unitsNumAskedQuestionsImage.hidden = NO;
    } else
    {
        NSString *numAskedUnitsImage = [NSString stringWithFormat:@"%d.png",unitasked];
        self.tensNumAskedQuestionsImage.image = [UIImage imageNamed:numAskedUnitsImage];
        self.unitsNumAskedQuestionsImage.hidden = YES;
    }
    
    
}
-(void)hideHint
{
    for (UIView *view in self.markerView.subviews) {
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)) {
            UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2*M_PI/3);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                        view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2*M_PI/3);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                                view.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                            } completion:^(BOOL finished) {
                                if (finished) [view removeFromSuperview];
                            }];
                        }
                    }];
                }
            }];
        }
        
    }
}

-(void)showTheRightAnswerWithResponseRight:(BOOL)correct
{
    [self hideHint];
    //show the label for self.mainland.targetname then remove it in load question
    NSArray *coordinates = [self.mainland.targetMarkers objectForKey:self.mainland.targetName];
    CGPoint targetLabelCenter = (CGPointMake([[coordinates objectAtIndex:2]floatValue], [[coordinates objectAtIndex:3]floatValue]));
    UIView *targetLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"token.png"]]];
    targetLabel.center = targetLabelCenter;
    [self.completedStateLabelsView addSubview:targetLabel];
    
    targetLabel.transform = CGAffineTransformScale(targetLabel.transform, 0.01, 0.01);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform labelTrans = CGAffineTransformScale(targetLabel.transform, 50, 50);
                         targetLabel.transform = labelTrans;
                     }
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              CGAffineTransform viewTrans = CGAffineTransformScale(targetLabel.transform, 0.01, 0.01);
                                              targetLabel.transform = viewTrans;
                                          }
                                          completion:^(BOOL finished){
                                              if (finished) {
                                                  [targetLabel removeFromSuperview];
                                              }
                                          }];
                     }];
    
    if (correct)
    {
        UIView *answerResponseLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correct.png"]];
        [self flashLabel:answerResponseLabel];
    } else
    {
        UIView *answerResponseLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"incorrect.png"]];
        [self flashLabel:answerResponseLabel];
    }
    self.answeringQuestion = NO;
}
-(void)flashLabel:(UIView *)answerResponseLabel
{
    float flashX = ((self.homeNav.frame.origin.x ) - (200 * self.Scale));
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
                                                  [self loadQuestion];
                                              }
                                          }];
                     }];
    switch (self.correctAnswerPos) {
        case 0:
            [self dissolveWrongAnswer:self.answerB];
            [self dissolveWrongAnswer:self.answerC];
            [self dissolveWrongAnswer:self.answerD];
            break;
        case 1:
            [self dissolveWrongAnswer:self.answerA];
            [self dissolveWrongAnswer:self.answerC];
            [self dissolveWrongAnswer:self.answerD];
            break;
        case 2:
            [self dissolveWrongAnswer:self.answerA];
            [self dissolveWrongAnswer:self.answerB];
            [self dissolveWrongAnswer:self.answerD];
            break;
        case 3:
            [self dissolveWrongAnswer:self.answerA];
            [self dissolveWrongAnswer:self.answerB];
            [self dissolveWrongAnswer:self.answerC];
            break;
        default:
            break;
    }
    
}
-(void)gotTheAnswerRight
{
    [self.mainland incrementQuizScore];
    [self drawScores];
    //animate the "show answer" & then move to next question
    [self showTheRightAnswerWithResponseRight:YES];
}
-(void)gotTheAnswerWrong
{
    //animate the "show answer" & then move to next question
    [self showTheRightAnswerWithResponseRight:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //clicked play again or "Start Over"
        self.mainland = nil;
        [self drawScores];
        [self loadQuestion];
        
        
    }
    if (buttonIndex == 1)
    {
        //clicked back to main
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }
    
}

#pragma mark UI actions
-(void) Tap:(UIGestureRecognizer *)gesture
{
    if (!self.inPlay) {
        CGPoint touchPoint = [gesture locationInView:self.view];
        if ((CGRectContainsPoint(self.answerA.frame, touchPoint))&&(!self.answeringQuestion)) {
            self.inPlay = YES;
            self.answeringQuestion = YES;
            //if this is the right answer mark it Correct
            if (self.correctAnswerPos == 0)
            {
                [self gotTheAnswerRight];
            }else
            {
                [self gotTheAnswerWrong];
            }
        }
        if ((CGRectContainsPoint(self.answerB.frame, touchPoint))&&(!self.answeringQuestion)) {
            self.inPlay = YES;
            self.answeringQuestion = YES;
            //if this is the right answer mark it Correct
            if (self.correctAnswerPos == 1)
            {
                [self gotTheAnswerRight];
            }else
            {
                [self gotTheAnswerWrong];
            }
            
        }
        if ((CGRectContainsPoint(self.answerC.frame, touchPoint))&&(!self.answeringQuestion)) {
            self.inPlay = YES;
            self.answeringQuestion = YES;
            //if this is the right answer mark it Correct
            if (self.correctAnswerPos == 2)
            {
                [self gotTheAnswerRight];
            }else
            {
                [self gotTheAnswerWrong];
            }
            
        }
        if ((CGRectContainsPoint(self.answerD.frame, touchPoint))&&(!self.answeringQuestion)) {
            self.inPlay = YES;
            self.answeringQuestion = YES;
            //if this is the right answer mark it Correct
            if (self.correctAnswerPos == 3)
            {
                [self gotTheAnswerRight];
            }else
            {
                [self gotTheAnswerWrong];
            }
        }
        if (CGRectContainsPoint(self.homeNav.frame, touchPoint)) {
            if ([self.mainland isQuizComplete]) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
            }
            else
            {
                NSString *Title = [NSString stringWithFormat:@"Quiz not Finished"];
                NSString *messageString = [NSString stringWithFormat:@"Are you sure you want to Quit the Quiz?"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:messageString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"Start Over", nil ];
                [alert show];
            }
        }
    }
}
-(void)dissolveWrongAnswer:(UIImageView *)answerImage
{
    answerImage.transform = CGAffineTransformScale(answerImage.transform, 1, 1);
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform viewTrans = CGAffineTransformScale(answerImage.transform, 1, 1);
                         answerImage.transform = viewTrans;
                         answerImage.alpha = 0.01;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             switch (self.correctAnswerPos) {
                                 case 0:
                                     self.answerA.alpha = 0;
                                     break;
                                 case 1:
                                     self.answerB.alpha = 0;
                                     break;
                                 case 2:
                                     self.answerC.alpha = 0;
                                     break;
                                 case 3:
                                     self.answerD.alpha = 0;
                                     break;
                                 default:
                                     break;
                             }
                         }
                     }];
}
-(void)animateNewAnswer:(UIImageView *)answerImage
{
    answerImage.transform = CGAffineTransformScale(answerImage.transform, 1, 1);
    [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform viewTrans = CGAffineTransformScale(answerImage.transform, 1, 1);
                         answerImage.transform = viewTrans;
                         answerImage.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.inPlay = NO;
                            }
                     }];
}

-(void)finish
{
    [self.presentingViewController  dismissViewControllerAnimated:YES completion:^{}];
}
-(void)dockState
{
    NSString *completedStateName;
    if ([self.mainland.numAskedQuestions intValue] % 2 == self.rndStartingColor) {
        completedStateName = [NSString stringWithFormat:@"%@_blue_complete.png",self.mainland.targetName];
    } else {
        completedStateName = [NSString stringWithFormat:@"%@_red_complete.png",self.mainland.targetName];
    }
    UIView *dockedState = [[UIImageView alloc] initWithImage:[UIImage imageNamed:completedStateName]];
    
    dockedState.frame = CGRectMake(0, 0, 610 * self.Scale, 390 * self.Scale);
    dockedState.hidden = YES;
    dockedState.alpha = 0.01;
    [self.completedStatesView addSubview:dockedState];
    dockedState.transform = CGAffineTransformScale(dockedState.transform, 1.0, 1.0);
    
    [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         dockedState.alpha = 1.0;
                         dockedState.hidden = NO;
                         CGAffineTransform finaltrans = CGAffineTransformScale(dockedState.transform, 1.0, 1.0);
                         dockedState.transform =   finaltrans;
                     }
                     completion:nil];
    
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    float mapX = ((self.view.bounds.size.width * self.PositionalOffset ) - (self.mapOutline.frame.size.width /2));
    float mapY = ((self.view.bounds.size.height / 2 ) - (self.mapOutline.frame.size.height /2));
    CGRect mapRect = CGRectMake(mapX, mapY, self.mapOutline.frame.size.width, self.mapOutline.frame.size.height);
    [self.mapOutline setFrame:mapRect];
    [self.markerView setFrame:mapRect];
    [self.completedStatesView setFrame:mapRect];
}

- (void)viewDidUnload {
    [self setScoreTens:nil];
    [self setScoreUnits:nil];
    [self setHomeNav:nil];
    [super viewDidUnload];
}
@end
