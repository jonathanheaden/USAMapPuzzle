//
//  airskullCountry.h
//  AirSkull
//
//  Created by Jonathan Headen on 28/01/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface airskullCountry : NSObject
#define CORRECTSCORE @"CorrectScore"
//#define COUNT_OF_COUNTIES_PLACED @"CountiesPlaced"
#define HINT_DELAY_TIMER 1.0 //hint timer interval
#define HINT_DELAY 5.0 //number of seconds before the hint is shown
#define HINT_ANIMATION_DURATION 2.0
#define NUMBER_OF_CELLS_FOR_IPHONE_MATCHING 16
#define NUMBER_OF_CELLS_FOR_IPAD_MATCHING 20
#define MAPWIDTH_FOR_IPAD_LANDSCAPE 799
#define MAPWIDTH_FOR_IPAD 610
#define MAPHEIGHT_FOR_IPAD_LANDSCAPE 511
#define MAPHEIGHT_FOR_IPAD 390
#define MAP_SCALING_FOR_IPAD_LANDSCAPE 1.31145

@property  BOOL isTokenInCounty; // is the token in the hotspot or not?
//@property (strong,nonatomic) NSMutableDictionary *answers;
@property (strong, nonatomic) NSDictionary *targetMarkers;
@property (strong, nonatomic) NSMutableArray *targetMarkerHints; //the list of nearby counties for which a marker should be drawn - is this needed ?
//consider if these two can be folded into one as it's now only the county on the token that could be shown
//@property (strong, nonatomic) NSString *tokenCounty; //the target name on the label & county map name recorded in countyMapsPlaced
@property (strong, nonatomic) NSString *targetName; //the token county name lowercase
@property (strong, nonatomic) NSString *targetColour; //the colour of the state on the map
@property (strong, nonatomic) NSMutableArray *placedTargets; // counties that have been placed
@property (strong, nonatomic) NSMutableArray *unPlacedTargets; // counties that have  not been placed
@property (strong, nonatomic) NSMutableDictionary *allQuestions; //quiz questions that haven't been asked yet
@property (strong, nonatomic) NSString *mapName; //what map are we using
@property (strong, nonatomic) NSString *mapSections; //which types should be shown
@property (nonatomic) BOOL isTokenInTarget;
@property (strong,nonatomic) NSArray *quizCategories; //last enty is number of questions
@property (strong,nonatomic) NSNumber *quizScore; //the score of the quiz
@property (strong,nonatomic) NSNumber *numAskedQuestions; // the number of questions asked
@property (nonatomic,strong) NSString * lastToken; //use this while programming to get the placement right for targets
@property (nonatomic, strong) NSDictionary *matchingAnswers; //the answers to the State/Capital matching
@property (nonatomic, strong) NSNumber *matchingClicks; //the number of clicks taken in the matching puzzle
-(void) getNextTarget;
//-(void) addMapForCounty; //register that the county map spot is placed

//-(BOOL) hasCountyMapBeenPlaced; //has the county name on the token been placed - don't need this anymore
-(BOOL) isMapComplete; //are we there yet?
-(BOOL) isQuizComplete; // huh? are we?
-(void) incrementQuizScore; //add a point
-(NSString *)stateCapitalforState:(NSString *)state;
-(NSString *)getFactForState:(NSString *)state;
//implement the quiz
//the airskullcountry should contain the list of questions: number questions = 20 intially
//can be a mix of counties , rivers, mountains , lakes , islands /headlands
//choose x questions from master array
 // 4 from each type then combine the remainder and choose at random
// question is @"what %@ is this?", target.type
//show 4 possible answers including the correct one. validate the correct one is only listed once and the other three choices are the same type
-(NSArray *) getNextQuestion; //the array from targetMarkers name position type etc.
-(NSArray *)answersForQuestion:(NSArray *)question ofType:(NSString *)capitalOrState; //get the 3 other choices for the question
//-(void) answerForQuestion:(NSString *)answer;

//matching logic
-(NSArray *)getNextStateCapitalPair;
-(NSDictionary *) stateCapitalsList;
-(BOOL)isPuzzleComplete;
-(void)addMatch:(NSNumber *)match;
-(void)matchingClick:(BOOL)up;

@end
