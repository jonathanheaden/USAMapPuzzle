//
//  asmViewController.m
//  USA Map Puzzle
//
//  Created by Jonathan Headen on 17/02/13.
//  Copyright (c) 2013 AirSkull. All rights reserved.
//


#import "asmViewController.h"
#import "airskullCountry.h"

@interface asmViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *markerView;
@property (weak, nonatomic) IBOutlet UIImageView *stateNameHint;
@property (weak, nonatomic) IBOutlet UIImageView *completedStatesView;
@property (weak, nonatomic) IBOutlet UIView *token;
@property (weak, nonatomic) IBOutlet UIImageView *tokenHighlight;
@property (weak, nonatomic) IBOutlet UIImageView *tokenbase;
@property (weak, nonatomic) IBOutlet UIImageView *theToken;
@property (weak, nonatomic) IBOutlet UIImageView *mapOutline;
@property (strong, nonatomic) airskullCountry *mainland;//mainland
@property (nonatomic, weak) NSTimer *hintTimer; //control when the hints get shown
@property (nonatomic) BOOL hintOnScreen; //is the hint being shown
@property (nonatomic) BOOL countyOnScreen; //is the county being shown
@property (nonatomic) BOOL isTimerOn; //is the Timer on?
@property (nonatomic,strong) NSNumber *hintDelayCounter; //number of seconds before the hint is shown
@property (strong, nonatomic) UIView * stateInView; //the county over which the token is hovering
@property (weak, nonatomic) IBOutlet UIImageView *overLay;
@property (weak, nonatomic) IBOutlet UIView *homeNav;
@property (weak, nonatomic) IBOutlet UILabel *factsLabel;
@property int colorSwitch;
@property (readonly) float Scale;




@end


@implementation asmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGestureRecognizerToPiece:self.token];
    
    self.stateInView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    [self.view addGestureRecognizer:tap ];
    self.homeNav.hidden= NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self hideOverlayWithDelay:2.0];
}

-(void) hideOverlayWithDelay:(float)delay
{

    self.overLay.transform = CGAffineTransformScale(self.overLay.transform, 1.0, 1.0);
    [UIView animateWithDuration:1.0 delay:delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.overLay.alpha = 0.0;
        CGAffineTransform finaltrans = CGAffineTransformScale(self.overLay.transform, 1.0, 1.0);
        self.overLay.transform =   finaltrans;} completion:^(BOOL completed){
        if (completed)
        {
            self.overLay.hidden = YES;
            //[self startTimer];
            UITapGestureRecognizer *tapout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapOut:)];
            [self.homeNav addGestureRecognizer:tapout ];
            [self animateNewToken];
        }
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark properties
-(airskullCountry *)mainland
{
    if (!_mainland) {
        _mainland = [[airskullCountry alloc] init];
        _mainland.mapName = self.mapData;
        _mainland.mapSections = self.mapSections;
    }
    return _mainland;
}

-(float)Scale
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //return 1.0;
        return MAP_SCALING_FOR_IPAD_LANDSCAPE;
    } else {
        //return 0.458;
        return 0.6412;
    }
}

#pragma mark mapLogic

-(void)hintDisplayCycle:(NSTimer *)timer
{
    if ([self.hintDelayCounter isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        self.hintDelayCounter = [NSNumber numberWithFloat:HINT_DELAY];
    }
    else if ([self.hintDelayCounter isEqualToNumber:[NSNumber numberWithFloat:2]])
    {
        if (self.hintsOnOff) [self showHint];
        self.hintDelayCounter = [NSNumber numberWithInt:1];
    }
    else {
        self.hintDelayCounter = [NSNumber numberWithInt:([self.hintDelayCounter floatValue] -1)];
    }
    
}
-(void)startTimer {
    if (!self.isTimerOn)
    {
        self.isTimerOn = YES;
        self.hintDelayCounter = [NSNumber numberWithInt:1];
        self.hintTimer = [NSTimer scheduledTimerWithTimeInterval:HINT_DELAY_TIMER
                                                          target:self
                                                        selector:@selector(hintDisplayCycle:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}
-(void)stopHintTimer
{
    self.isTimerOn = NO;
    [self.hintTimer invalidate];
    for (UIView *view in self.markerView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void)showHint
{
    float  x = [[[[self.mainland targetMarkers]objectForKey:self.mainland.targetName]objectAtIndex:2] floatValue] * self.Scale;
    float y = [[[[self.mainland targetMarkers]objectForKey:self.mainland.targetName]objectAtIndex:3] floatValue] * self.Scale;
    if ((self.hintsOnOff) && (!self.mainland.isMapComplete)) [self addMarkerAtFloatX:x andFloatY:y];
}

-(void)animateNewToken
{
    //clear all residue
    self.hintDelayCounter = [NSNumber numberWithFloat:HINT_DELAY];
    
    self.countyOnScreen = NO;
    // get the next state from the mainland data model
    if (![self.mainland isMapComplete])
    {
        [self.mainland getNextTarget];
        self.stateNameHint.image = [UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"_label.png"]];
        if (self.overLay.hidden)
        {
            [self startTimer];
        }
        self.theToken.image = [UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@".png"]];
        self.tokenbase.image = [UIImage imageNamed:[self.mainland.targetColour stringByAppendingString:@".png"]];
        if ([self.mainland.targetColour isEqualToString:@"lavender"]) {
            self.tokenbase.image = [UIImage imageNamed:@"purple.png"];
            self.tokenbase.alpha= 0.7;
        }
        self.tokenHighlight.image = [UIImage imageNamed:@"highlight.png"];
        self.tokenHighlight.alpha = 1.0;
        self.token.center = CGPointMake(self.view.bounds.size.width  * 0.68 , self.token.frame.size.width );
        self.token.hidden = NO;
        CGAffineTransform trans = CGAffineTransformScale(self.token.transform, 0.01, 0.01);
        self.token.transform = trans;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.token.transform =   CGAffineTransformScale(self.token.transform, 100.0 , 100.0 );
                         }
                         completion:nil];
        self.factsLabel.text = [self.mainland getFactForState:self.mainland.targetName];
    }
    else
    {
        self.factsLabel.text = @"";
        self.stateNameHint.image = [UIImage imageNamed:@"hidethis"];
        NSString *Title = [NSString stringWithFormat:@"Finished"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:@"Congratulations, you did it!"
                                                       delegate:self
                                              cancelButtonTitle:@"PlayAgain"
                                              otherButtonTitles:@"Back to Main Menu", @"OK", nil ];
        [alert show];
    }
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
        for (UIView *view in self.completedStatesView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.markerView.subviews) {
            [view removeFromSuperview];
        }
        [self stopHintTimer];
        self.mainland = nil;
        [self animateNewToken];
    }

}

-(void)addMarkerAtFloatX:(float)floatX andFloatY:(float)floatY
{
    UIView *marker;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipadmarker.png"]];
    }
    else {
        marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
    }
    [marker setCenter:(CGPointMake(floatX, floatY))];
    [self.markerView addSubview:marker];

    CGAffineTransform trans = CGAffineTransformScale(marker.transform, 0.01, 0.01);
    marker.transform = trans;
    
    //roll in the animation
    UIViewAnimationOptions hintAnimationOptions = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:hintAnimationOptions animations:^{
        marker.transform = CGAffineTransformRotate(CGAffineTransformScale(trans, 10.0 , 10.0 ), 2*M_PI/3);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:hintAnimationOptions animations:^{
                marker.transform = CGAffineTransformRotate(CGAffineTransformScale(trans, 65.0, 65.0 ), -2*M_PI/3);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:hintAnimationOptions animations:^{
                        marker.transform = CGAffineTransformScale(trans, 100.0 , 100.0 );
                    } completion:^(BOOL completed){
                        if (completed) {
                            for (UIView *view in self.markerView.subviews) {
                                CGAffineTransform transform = view.transform;
                                if (CGAffineTransformIsIdentity(transform)) {
                                    UIViewAnimationOptions hintAnimationOptions = UIViewAnimationOptionCurveLinear;
                                    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:hintAnimationOptions animations:^{
                                        view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7 , 0.7 ), 2*M_PI/3);
                                    } completion:^(BOOL finished) {
                                        if (finished) {
                                            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:hintAnimationOptions animations:^{
                                                view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4 , 0.4 ), -2*M_PI/3);
                                            } completion:^(BOOL finished) {
                                                if (finished) {
                                                    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:hintAnimationOptions animations:^{
                                                        view.transform = CGAffineTransformScale(transform, 0.1  , 0.1  );
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
                    }];
                }
            }];
        }
    }];

    
}

-(void)showState
{
    if (!self.countyOnScreen) {
        self.tokenbase.alpha = [self.mainland.targetColour isEqualToString:@"lavender"] ? 0.75 : 1.0;
        self.tokenHighlight.alpha = [self.mainland.targetColour isEqualToString:@"lavender"] ? 0.5 : 0.0;
        
        CGPoint tokenPosition = CGPointMake(self.token.center.x - 20, self.token.center.y - 50);
        [self.stateInView removeFromSuperview];
        self.stateInView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName  stringByAppendingString:@".png"]]];
        [self.stateInView setCenter:tokenPosition];
        self.stateInView.alpha = 0.01;
        self.countyOnScreen = YES;
        
    }
}

-(void)dockState
{
    //Add State to array of completed States, and remove it from the possibilities for random selection
    //add the token name to the list of states that have been placed so it won't come up again
    [self.mainland.placedTargets addObject:self.mainland.targetName];
    self.mainland.lastToken = self.mainland.targetName;
    //animate the state docking into it's assigned spot
    //dockedstate is the completed image - capitalised with one of 4 colours
    NSString *completedStateName;
    if ([self.mainland.targetColour isEqualToString:@"lavender"]) {
        completedStateName = [NSString stringWithFormat:@"%@_purple_complete.png",self.mainland.targetName];
    } else {
       completedStateName = [NSString stringWithFormat:@"%@_%@_complete.png",self.mainland.targetName,self.mainland.targetColour];
        
    }
    UIView *dockedState = [[UIImageView alloc] initWithImage:[UIImage imageNamed:completedStateName]];
    if ([self.mainland.targetColour isEqualToString:@"lavender"]) dockedState.alpha = 0.3;
    dockedState.frame = CGRectMake(0, 0, 610  * self.Scale, 390 * self.Scale);
    dockedState.hidden = YES;
    dockedState.alpha = 0.01;
    [self.completedStatesView addSubview:dockedState];
    dockedState.transform = CGAffineTransformScale(dockedState.transform, 1.0, 1.0);
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         dockedState.hidden = NO;
                         dockedState.alpha = [self.mainland.targetColour isEqualToString:@"lavender"] ? 0.3 : 1.0;
                         CGAffineTransform finaltrans = CGAffineTransformScale(dockedState.transform, 1.0, 1.0);
                         dockedState.transform =   finaltrans;
                     }
                     completion:nil];
        [self stopHintTimer];
    self.hintDelayCounter = [NSNumber numberWithInt:3];
}

-(void)checkIfTokenInState
{
    float xOffset = self.markerView.frame.origin.x;
    float yOffset = self.markerView.frame.origin.y;
    NSString *county = self.mainland.targetName;
    NSArray *coordinates = [self.mainland.targetMarkers objectForKey:county];
    CGRect greaterCountyArea = CGRectMake(([[coordinates objectAtIndex:2]floatValue] - 100) * self.Scale + xOffset, ([[coordinates objectAtIndex:3]floatValue] - 100) * self.Scale + yOffset, 200 * self.Scale, 200 * self.Scale);
    BOOL inCounty = NO;
    
    if (CGRectContainsPoint(greaterCountyArea, self.token.center))
    {
        [self showState];
        inCounty = YES;
    }
    
    self.mainland.isTokenInTarget = inCounty;
    
}
#pragma mark gestures and UI

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    float mapX = ((self.view.bounds.size.width / 2 ) - (self.mapOutline.frame.size.width / 2));
    float mapY = ((self.view.bounds.size.height / 2 ) - (self.mapOutline.frame.size.height /2) - 5);
    CGRect mapRect = CGRectMake(mapX, mapY, MAPWIDTH_FOR_IPAD * self.Scale, MAPHEIGHT_FOR_IPAD * self.Scale);
  
    [self.mapOutline setFrame:mapRect];
    [self.markerView setFrame:mapRect];
    [self.overLay setFrame:mapRect];
    [self.completedStatesView setFrame:mapRect];
}

-(void) Tap:(UIGestureRecognizer *)gesture
{
    //use this for getting the coordinates whilst in development
    CGPoint touchPoint = [gesture locationInView:self.mapOutline];
    NSLog(@"[result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:%f],[NSNumber numberWithInt:%f],[NSNumber numberWithInt:%f],[NSNumber numberWithInt:%f],# %@ &,# Capital &,# state &,nil] forKey:# %@ &",touchPoint.x,touchPoint.y,touchPoint.x,touchPoint.y ,self.mainland.targetName,self.mainland.targetName);
  

}

-(void) TapOut:(UIGestureRecognizer *)gesture
{
    if (self.mainland.isMapComplete) {
        // exit point
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    } else
    { NSString *Title = [NSString stringWithFormat:@"Map not Finished"];
        NSString *messageString = [NSString stringWithFormat:@"Are you sure you want to Quit & Return to Home Screen?"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                        message:messageString
                                                       delegate:self
                                              cancelButtonTitle:@"Start Over"
                                              otherButtonTitles:@"Yes", @"No", nil ];
        [alert show];
    }        
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view]; //the token  being moved
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [self checkIfTokenInState];
        if (!self.mainland.isTokenInTarget)
        {
            self.stateInView.hidden = YES;
            self.countyOnScreen = NO;
            self.tokenHighlight.alpha = 1.0;
            self.tokenbase.alpha = [self.mainland.targetColour isEqualToString:@"lavender"] ? 0.7 : 0.9;
        }
        [self.stateInView setCenter:CGPointMake([self.stateInView center].x + translation.x, [self.stateInView center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        self.tokenHighlight.alpha = 1.0; 
        self.tokenbase.alpha = [self.mainland.targetColour isEqualToString:@"lavender"] ? 0.7 : 0.9 ;
        //handle the state docking & display new token (if state placed) or animate the token back to start (if not)
        if (self.mainland.isTokenInTarget)
        {
            [self dockState];
            self.token.hidden = YES;
            [self animateNewToken];
        }
        else {
            
            [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.token setCenter:CGPointMake(self.view.bounds.size.width  * 0.68, self.token.frame.size.width)];
                self.token.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            } completion:^(BOOL finished) {
                self.token.transform = CGAffineTransformIdentity;
            }];
            [self.stateInView removeFromSuperview];
            self.countyOnScreen = NO;
        }
    }
}

- (void)addGestureRecognizerToPiece:(UIView *)piece
{
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    
}

- (void)viewDidUnload {
    [self setHomeNav:nil];
    [self setOverLay:nil];
    [super viewDidUnload];
}
@end
