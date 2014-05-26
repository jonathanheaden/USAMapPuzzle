//
//  airSkullMainMenuViewController.m
//  AirSkull
//
//  Created by Jonathan Headen on 3/02/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import "airSkullMainMenuViewController.h"
#import "asmViewController.h"
#import "airskullCountry.h"

@interface airSkullMainMenuViewController () <asmViewControllerDelegate>
@property (strong, nonatomic) NSString *map;
@property (strong, nonatomic) NSString *mapSections;
@property (nonatomic) BOOL hintsOnOff;
@property (nonatomic) int maxQuestions;
@property (nonatomic, strong) NSMutableArray *quizSections;
//the Main Menu Icons
@property (weak, nonatomic) IBOutlet UIImageView *mapCountiesIcon;
@property (weak, nonatomic) IBOutlet UIImageView *quizQuestions10;
@property (weak, nonatomic) IBOutlet UIImageView *quizQuestions20;
@property (weak, nonatomic) IBOutlet UIImageView *quizQuestions35;
@property (weak, nonatomic) IBOutlet UIImageView *matchingPuzzle;

@end

@implementation airSkullMainMenuViewController


-(NSMutableArray *)quizSections
{
    if (!_quizSections) _quizSections = [[NSMutableArray alloc]init];
    return _quizSections;
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    [self.view addGestureRecognizer:tap ];
    self.hintsOnOff = YES;
    self.maxQuestions = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark logic
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll ;
}

#pragma mark actions
-(void) Tap:(UIGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (CGRectContainsPoint(self.mapCountiesIcon.frame, touchPoint)) {
        [self performSegueWithIdentifier:@"Show Map" sender:self];
    }
    
    if (CGRectContainsPoint(self.matchingPuzzle.frame, touchPoint)) {
        [self performSegueWithIdentifier:@"show matching" sender:self];
    }
    if (CGRectContainsPoint(self.quizQuestions20.frame, touchPoint)) {
        [self prepareForQuizwithQuestions:20];
    }

    if (CGRectContainsPoint(self.quizQuestions10.frame, touchPoint)) {
        [self prepareForQuizwithQuestions:10];
    }
    
    if (CGRectContainsPoint(self.quizQuestions35.frame, touchPoint)) {
        [self prepareForQuizwithQuestions:35];
    }
}
-(void)prepareForQuizwithQuestions:(int)numberOfQuestions
{
    [self.quizSections addObject:@"States"];
    self.maxQuestions += 27;
    [self.quizSections addObject:@"Capitals"];
    self.maxQuestions += 27;

    if (self.maxQuestions == 0) {
        NSString *Title = [NSString stringWithFormat:@"Quiz Sections Needed"];
        NSString *messageString = [NSString stringWithFormat:@"No Quiz Sections Selected! Press on one or more of the switches to select categories"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Title message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        if (self.maxQuestions < numberOfQuestions) {
            [self.quizSections addObject:[NSNumber numberWithInt:self.maxQuestions]];
            [self performSegueWithIdentifier:@"Show Quiz" sender:self];
        }
        else
        {
            [self.quizSections addObject:[NSNumber numberWithInt:numberOfQuestions]]; 
            [self performSegueWithIdentifier:@"Show Quiz" sender:self];
        }
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma protocol implemetation

-(void)asmViewController:(asmViewController *)sender puzzleComplete:(BOOL)completed
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[asmViewController class]]) {
        asmViewController *puzzle = (asmViewController *)segue.destinationViewController;
        if (UIInterfaceOrientationIsLandscape(UIInterfaceOrientationLandscapeLeft)){puzzle.landscapeOn = YES;}
        puzzle.quizCategories = self.quizSections;
        puzzle.hintsOnOff = self.hintsOnOff;
        puzzle.delegate = self;
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
