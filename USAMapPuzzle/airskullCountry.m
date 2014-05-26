//
//  airskullCountry.m
//  AirSkull
//
//  Created by Jonathan Headen on 28/01/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import "airskullCountry.h"
@interface airskullCountry  ()
@property (strong,nonatomic) NSArray *stateNames;
@property (strong, nonatomic) NSDictionary *stateMarkers;
@property (strong, nonatomic) NSDictionary *mapColours;
@property (nonatomic) BOOL showHints;
@property (strong, nonatomic) NSMutableArray *matchingPairsIndex;
@property (strong, nonatomic) NSMutableArray *matchedItems;
@property (strong, nonatomic) NSDictionary *stateAndCapitalList;
@property (strong, nonatomic) NSMutableDictionary *matchingAnswersStaging;
@property (nonatomic) int matchLoopCount;
@property (strong, nonatomic) NSDictionary *stateFacts;
@end
@implementation airskullCountry

-(id)init
{
    [self setMapColours];
    return self;
}
-(NSString *) stateCapitalforState:(NSString *)state
{
    return  [[self.stateMarkers objectForKey:state] objectAtIndex:5];
}
-(int) matchLoopCount
{
    if (!_matchLoopCount) _matchLoopCount = 0;
    return _matchLoopCount;
}
-(NSNumber *)matchingClicks
{
    if (!_matchingClicks)_matchingClicks = [NSNumber numberWithInt:0];
    return _matchingClicks;
}

-(NSMutableDictionary *) matchingAnswersStaging
{
    if (!_matchingAnswersStaging) _matchingAnswersStaging = [[NSMutableDictionary alloc] init];
    return _matchingAnswersStaging;
}
-(NSMutableArray *)matchedItems
{
    if (!_matchedItems)_matchedItems = [[NSMutableArray alloc]init];
    return _matchedItems;
}
-(NSDictionary *)matchingAnswers
{
    return [self.matchingAnswersStaging copy];
}
-(NSNumber *)numAskedQuestions
{
    if (!_numAskedQuestions) _numAskedQuestions = [NSNumber numberWithInt:0];
    return _numAskedQuestions;
}

-(NSDictionary *)stateAndCapitalList
{
    if (!_stateAndCapitalList) _stateAndCapitalList = [self stateCapitalsList];
    return _stateAndCapitalList;
}

- (NSMutableArray *)matchingPairsIndex
{
    if (!_matchingPairsIndex)
    {
        _matchingPairsIndex = [[NSMutableArray alloc] init];
        int numberOfCells =  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? NUMBER_OF_CELLS_FOR_IPAD_MATCHING : NUMBER_OF_CELLS_FOR_IPHONE_MATCHING;
        for (int i = 0; i < numberOfCells; i++) {
            [_matchingPairsIndex addObject:[NSNumber numberWithInt:i]];
        }
    }
    return _matchingPairsIndex;
    
}
-(NSString *)targetColour
{
    return [self.mapColours objectForKey:self.targetName];
}

-(NSNumber *)quizScore
{
    if (!_quizScore) _quizScore = [NSNumber numberWithInt:0];
    return _quizScore;
}
-(NSDictionary *)allQuestions
{
    if (!_allQuestions) _allQuestions = [self getListOfQuestions];
    return _allQuestions;
}
-(NSArray *)stateNames
{
    return [self.mapColours allKeys];
}
-(NSMutableArray *)unPlacedTargets
{
    if (!_unPlacedTargets) _unPlacedTargets = [self getListOfTargets];
    for (NSString *county in self.placedTargets) {
        if ([_unPlacedTargets containsObject:county]) {
            [_unPlacedTargets removeObjectIdenticalTo:county];
        }
    }
    return _unPlacedTargets;
}
-(NSMutableArray *)placedTargets
{
    if(!_placedTargets)_placedTargets = [[NSMutableArray alloc]init];
    return _placedTargets;
}
-(NSMutableArray *)targetMarkerHints
{
    if (!_targetMarkerHints) _targetMarkerHints = [[NSMutableArray alloc]init];
    return _targetMarkerHints;
    
}

-(NSDictionary *)targetMarkers
{
    return [self.stateMarkers copy];
      
}

-(NSDictionary *)stateMarkers
{
    //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 state name, 5 capital name, 6 type = state
    NSMutableDictionary * result = [[NSMutableDictionary alloc]init];
    
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:557],[NSNumber numberWithInt:116],[NSNumber numberWithInt:557],[NSNumber numberWithInt:116],@"connecticut",@"hartford",@"State",nil] forKey:@"connecticut"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:379],[NSNumber numberWithInt:100],[NSNumber numberWithInt:379],[NSNumber numberWithInt:100],@"wisconsin",@"madison",@"State",nil] forKey:@"wisconsin"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:360],[NSNumber numberWithInt:296],[NSNumber numberWithInt:360],[NSNumber numberWithInt:296],@"louisiana",@"batonrouge",@"State",nil] forKey:@"louisiana"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:507],[NSNumber numberWithInt:138],[NSNumber numberWithInt:507],[NSNumber numberWithInt:138],@"pennsylvania",@"harrisburg",@"State",nil] forKey:@"pennsylvania"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:546],[NSNumber numberWithInt:139],[NSNumber numberWithInt:546],[NSNumber numberWithInt:139],@"newjersey",@"trenton",@"State",nil] forKey:@"newjersey"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:529],[NSNumber numberWithInt:103],[NSNumber numberWithInt:529],[NSNumber numberWithInt:103],@"newyork",@"albany",@"State",nil] forKey:@"newyork"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:431],[NSNumber numberWithInt:110],[NSNumber numberWithInt:431],[NSNumber numberWithInt:110],@"michigan",@"lansing",@"State",nil] forKey:@"michigan"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:456],[NSNumber numberWithInt:154],[NSNumber numberWithInt:456],[NSNumber numberWithInt:154],@"ohio",@"columbus",@"State",nil] forKey:@"ohio"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:391],[NSNumber numberWithInt:273],[NSNumber numberWithInt:391],[NSNumber numberWithInt:273],@"mississippi",@"jackson",@"State",nil] forKey:@"mississippi"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:94],[NSNumber numberWithInt:144],[NSNumber numberWithInt:94],[NSNumber numberWithInt:144],@"nevada",@"carsoncity",@"State",nil] forKey:@"nevada"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:424],[NSNumber numberWithInt:264],[NSNumber numberWithInt:424],[NSNumber numberWithInt:264],@"alabama",@"montgomery",@"State",nil] forKey:@"alabama"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:495],[NSNumber numberWithInt:322],[NSNumber numberWithInt:495],[NSNumber numberWithInt:322],@"florida",@"tallahassee",@"State",nil] forKey:@"florida"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:48],[NSNumber numberWithInt:168],[NSNumber numberWithInt:48],[NSNumber numberWithInt:168],@"california",@"sacramento",@"State",nil] forKey:@"california"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:85],[NSNumber numberWithInt:34],[NSNumber numberWithInt:85],[NSNumber numberWithInt:34],@"washington",@"olympia",@"State",nil] forKey:@"washington"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:199],[NSNumber numberWithInt:241],[NSNumber numberWithInt:199],[NSNumber numberWithInt:241],@"newmexico",@"santafe",@"State",nil] forKey:@"newmexico"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:430],[NSNumber numberWithInt:224],[NSNumber numberWithInt:430],[NSNumber numberWithInt:224],@"tennessee",@"nashville",@"State",nil] forKey:@"tennessee"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:447],[NSNumber numberWithInt:193],[NSNumber numberWithInt:447],[NSNumber numberWithInt:193],@"kentucky",@"frankfort",@"State",nil] forKey:@"kentucky"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:184],[NSNumber numberWithInt:60],[NSNumber numberWithInt:184],[NSNumber numberWithInt:60],@"montana",@"helena",@"State",nil] forKey:@"montana"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:278],[NSNumber numberWithInt:144],[NSNumber numberWithInt:278],[NSNumber numberWithInt:144],@"nebraska",@"lincoln",@"State",nil] forKey:@"nebraska"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:355],[NSNumber numberWithInt:191],[NSNumber numberWithInt:355],[NSNumber numberWithInt:191],@"missouri",@"jeffersoncity",@"State",nil] forKey:@"missouri"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:579],[NSNumber numberWithInt:53],[NSNumber numberWithInt:579],[NSNumber numberWithInt:53],@"maine",@"augusta",@"State",nil] forKey:@"maine"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:222],[NSNumber numberWithInt:365],[NSNumber numberWithInt:222],[NSNumber numberWithInt:365],@"hawaii",@"honolulu",@"State",nil] forKey:@"hawaii"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:277],[NSNumber numberWithInt:57],[NSNumber numberWithInt:277],[NSNumber numberWithInt:57],@"northdakota",@"bismarck",@"State",nil] forKey:@"northdakota"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:347],[NSNumber numberWithInt:139],[NSNumber numberWithInt:347],[NSNumber numberWithInt:139],@"iowa",@"desmoines",@"State",nil] forKey:@"iowa"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:510],[NSNumber numberWithInt:184],[NSNumber numberWithInt:510],[NSNumber numberWithInt:184],@"virginia",@"richmond",@"State",nil] forKey:@"virginia"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:563],[NSNumber numberWithInt:88],[NSNumber numberWithInt:563],[NSNumber numberWithInt:88],@"newhampshire",@"concord",@"State",nil] forKey:@"newhampshire"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:422],[NSNumber numberWithInt:161],[NSNumber numberWithInt:422],[NSNumber numberWithInt:161],@"indiana",@"indianapolis",@"State",nil] forKey:@"indiana"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:306],[NSNumber numberWithInt:232],[NSNumber numberWithInt:306],[NSNumber numberWithInt:232],@"oklahoma",@"oklahomacity",@"State",nil] forKey:@"oklahoma"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:482],[NSNumber numberWithInt:176],[NSNumber numberWithInt:482],[NSNumber numberWithInt:176],@"westvirginia",@"charleston",@"State",nil] forKey:@"westvirginia"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:391],[NSNumber numberWithInt:162],[NSNumber numberWithInt:391],[NSNumber numberWithInt:162],@"illinois",@"springfield",@"State",nil] forKey:@"illinois"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:291],[NSNumber numberWithInt:187],[NSNumber numberWithInt:291],[NSNumber numberWithInt:187],@"kansas",@"topeka",@"State",nil] forKey:@"kansas"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:138],[NSNumber numberWithInt:229],[NSNumber numberWithInt:138],[NSNumber numberWithInt:229],@"arizona",@"phoenix",@"State",nil] forKey:@"arizona"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:572],[NSNumber numberWithInt:114],[NSNumber numberWithInt:572],[NSNumber numberWithInt:114],@"rhodeisland",@"providence",@"State",nil] forKey:@"rhodeisland"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:279],[NSNumber numberWithInt:286],[NSNumber numberWithInt:279],[NSNumber numberWithInt:286],@"texas",@"austin",@"State",nil] forKey:@"texas"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:336],[NSNumber numberWithInt:83],[NSNumber numberWithInt:336],[NSNumber numberWithInt:83],@"minnesota",@"saintpaul",@"State",nil] forKey:@"minnesota"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:197],[NSNumber numberWithInt:118],[NSNumber numberWithInt:197],[NSNumber numberWithInt:118],@"wyoming",@"cheyenne",@"State",nil] forKey:@"wyoming"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:88],[NSNumber numberWithInt:310],[NSNumber numberWithInt:88],[NSNumber numberWithInt:310],@"alaska",@"juneau",@"State",nil] forKey:@"alaska"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:210],[NSNumber numberWithInt:183],[NSNumber numberWithInt:210],[NSNumber numberWithInt:183],@"colorado",@"denver",@"State",nil] forKey:@"colorado"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:550],[NSNumber numberWithInt:82],[NSNumber numberWithInt:550],[NSNumber numberWithInt:82],@"vermont",@"montpelier",@"State",nil] forKey:@"vermont"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:542],[NSNumber numberWithInt:163],[NSNumber numberWithInt:542],[NSNumber numberWithInt:163],@"delaware",@"dover",@"State",nil] forKey:@"delaware"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:569],[NSNumber numberWithInt:104],[NSNumber numberWithInt:569],[NSNumber numberWithInt:104],@"massachusetts",@"boston",@"State",nil] forKey:@"massachusetts"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:70],[NSNumber numberWithInt:83],[NSNumber numberWithInt:70],[NSNumber numberWithInt:83],@"oregon",@"salem",@"State",nil] forKey:@"oregon"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:528],[NSNumber numberWithInt:155],[NSNumber numberWithInt:528],[NSNumber numberWithInt:155],@"maryland",@"annapolis",@"State",nil] forKey:@"maryland"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:269],[NSNumber numberWithInt:104],[NSNumber numberWithInt:269],[NSNumber numberWithInt:104],@"southdakota",@"pierre",@"State",nil] forKey:@"southdakota"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:493],[NSNumber numberWithInt:239],[NSNumber numberWithInt:493],[NSNumber numberWithInt:239],@"southcarolina",@"columbia",@"State",nil] forKey:@"southcarolina"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:127],[NSNumber numberWithInt:94],[NSNumber numberWithInt:127],[NSNumber numberWithInt:94],@"idaho",@"boise",@"State",nil] forKey:@"idaho"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:516],[NSNumber numberWithInt:216],[NSNumber numberWithInt:516],[NSNumber numberWithInt:216],@"northcarolina",@"raleigh",@"State",nil] forKey:@"northcarolina"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:154],[NSNumber numberWithInt:169],[NSNumber numberWithInt:154],[NSNumber numberWithInt:169],@"utah",@"saltlakecity",@"State",nil] forKey:@"utah"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:467],[NSNumber numberWithInt:264],[NSNumber numberWithInt:467],[NSNumber numberWithInt:264],@"georgia",@"atlanta",@"State",nil] forKey:@"georgia"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:357],[NSNumber numberWithInt:240],[NSNumber numberWithInt:357],[NSNumber numberWithInt:240],@"arkansas",@"littlerock",@"State",nil] forKey:@"arkansas"];

    return result;
}


#pragma mark actions

-(void)setMapColours
{
    NSMutableDictionary *stateNeighbors = [[NSMutableDictionary alloc] init];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"mississippi", @"tennessee", @"florida", @"georgia", nil] forKey:@"alabama"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"hawaii", nil] forKey:@"alaska"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"california",@"nevada", @"utah",@"newmexico", nil] forKey:@"arizona"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"louisiana",@"texas",@"oklahoma", @"missouri",@"tennessee",@"mississippi", nil] forKey:@"arkansas"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"arizona",@"nevada",@"oregon", nil] forKey:@"california"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"wyoming", @"nebraska",@"kansas",@"oklahoma",@"newmexico",@"utah", nil] forKey:@"colorado"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newyork",@"rhodeisland",@"massachusetts", nil] forKey:@"connecticut"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newjersey",@"pennsylvania",@"maryland", nil] forKey:@"delaware"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"alabama",@"georgia", nil] forKey:@"florida"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"florida",@"alabama",@"tennessee",@"northcarolina",@"southcarolina", nil] forKey:@"georgia"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"alaska", nil] forKey:@"hawaii"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"washington",@"oregon", @"nevada",@"utah",@"wyoming",@"montana", nil] forKey:@"idaho"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"wisconsin",@"iowa",@"missouri",@"kentucky",@"indiana", nil] forKey:@"illinois"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"kentucky",@"illinois",@"michigan",@"ohio", nil] forKey:@"indiana"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"minnesota",@"southdakota",@"nebraska",@"missouri",@"illinois",@"wisconsin", nil] forKey:@"iowa"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"nebraska",@"colorado",@"oklahoma",@"missouri", nil] forKey:@"kansas"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"ohio",@"indiana",@"illinois",@"missouri",@"tennessee",@"virginia",@"westvirginia", nil] forKey:@"kentucky"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"texas",@"arkansas",@"mississippi", nil] forKey:@"louisiana"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newhampshire", nil] forKey:@"maine"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"virginia",@"westvirginia",@"delaware",@"pennsylvania", nil] forKey:@"maryland"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newyork", @"newhampshire",@"vermont",@"connecticut",@"rhodeisland", nil] forKey:@"massachusetts"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"ohio",@"indiana",@"wisconsin",@"minnesota", nil] forKey:@"michigan"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"northdakota",@"southdakota",@"iowa",@"wisconsin",@"michigan", nil] forKey:@"minnesota"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"louisiana",@"arkansas",@"tennessee",@"alabama" , nil] forKey:@"mississippi"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"iowa",@"nebraska",@"kansas",@"oklahoma",@"arkansas"@"tennessee",@"kentucky",@"illinois", nil] forKey:@"missouri"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"idaho",@"wyoming",@"northdakota",@"southdakota", nil] forKey:@"montana"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"southdakota",@"wyoming",@"colorado",@"kansas",@"missouri",@"iowa", nil] forKey:@"nebraska"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"california",@"arizona",@"utah",@"idaho",@"oregon", nil] forKey:@"nevada"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"vermont",@"massachusetts",@"maine", nil] forKey:@"newhampshire"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newyork",@"pennsylvania",@"delaware", nil] forKey:@"newjersey"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"texas",@"arizona",@"colorado",@"oklahoma", nil] forKey:@"newmexico"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"pennsylvania",@"newjersey",@"connecticut",@"massachusetts", @"vermont", nil] forKey:@"newyork"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"southcarolina",@"georgia",@"tennessee", @"virginia", nil] forKey:@"northcarolina"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"montana",@"southdakota",@"minnesota", nil] forKey:@"northdakota"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"westvirginia",@"kentucky",@"indiana",@"michigan",@"pennsylvania", nil] forKey:@"ohio"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"texas",@"newmexico",@"colorado",@"kansas",@"missouri",@"arkansas", nil] forKey:@"oklahoma"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"washington",@"idaho",@"nevada",@"california", nil] forKey:@"oregon"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newyork",@"newjersey",@"delaware",@"maryland",@"westvirginia",@"ohio", nil] forKey:@"pennsylvania"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"connecticut",@"massachusetts", nil] forKey:@"rhodeisland"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"georgia",@"northcarolina", nil] forKey:@"southcarolina"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"nebraska",@"wyoming",@"montana",@"northdakota",@"minnesota",@"iowa", nil] forKey:@"southdakota"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"kentucky",@"virginia",@"northcarolina",@"georgia",@"alabama",@"mississippi",@"arkansas",@"missouri", nil] forKey:@"tennessee"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"newmexico",@"oklahoma",@"arkansas",@"louisiana", nil] forKey:@"texas"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"colorado",@"arizona",@"nevada",@"idaho",@"wyoming", nil] forKey:@"utah"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"massachusetts",@"newhampshire",@"newyork", nil] forKey:@"vermont"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"westvirginia",@"kentucky",@"maryland",@"tennessee",@"northcarolina", nil] forKey:@"virginia"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"idaho",@"oregon", nil] forKey:@"washington"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"virginia",@"kentucky",@"maryland",@"ohio",@"pennsylvania", nil] forKey:@"westvirginia"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"illinois",@"minnesota",@"michigan",@"iowa", nil] forKey:@"wisconsin"];
    [stateNeighbors setValue:[NSArray arrayWithObjects:@"nebraska",@"colorado",@"utah",@"idaho",@"montana",@"southdakota", nil] forKey:@"wyoming"];

    NSMutableDictionary *stateColours = [[NSMutableDictionary alloc]init];
    for (NSString *state in [stateNeighbors allKeys]) {
        NSMutableArray *availColours = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"green",@"red",@"blue",@"yellow", nil]];
        NSMutableArray *nColours = [[NSMutableArray alloc] init];
        
        for (NSString *neighbor in [stateNeighbors objectForKey:state]) {
            if ([[stateColours allKeys] containsObject:neighbor]) {
                [nColours addObject:[stateColours objectForKey:neighbor]];
            }
        }
        
        if ([nColours count] > 0) {
            for (NSString *colour in nColours) {
                [availColours removeObjectIdenticalTo:colour];
            }
            if ([availColours count] == 0) {
                if ([nColours containsObject:@"purple"]) {
                    [availColours addObject:@"lavender"];
                } else {
                    [availColours addObject:@"purple"];
                }
            }
        }
        int x = (arc4random() % [availColours count]);
        [stateColours setObject:[availColours objectAtIndex:x] forKey:state];

    }

    self.mapColours = [[NSDictionary alloc] initWithDictionary:stateColours];
}
     
-(void)incrementQuizScore
{
    int newScore = [self.quizScore intValue] + 1;
    self.quizScore = [NSNumber numberWithInt:newScore];
}
-(NSMutableArray *)getListOfTargets
{
    return [self.stateNames mutableCopy];
}

-(void) getNextTarget
{
    //pick a random state from those that have not yet been placed
    int x = (arc4random() % [self.unPlacedTargets count]);
    self.targetName = [self.unPlacedTargets objectAtIndex:x];
}

-(NSDictionary *) stateFacts
{
    NSDictionary *states = @{
        @"alabama": @[@"Became a state in 1819",@"Montgomery is the capital",@"Birmingham is the largest city in Alabama",@"Yellowhammer State"],
        @"alaska" : @[@"Became a state in 1959",@"Juneau is the capital",@"Alaska is the biggest state",@"Anchorage is the largest city",@"The Last Frontier",@"Land of the Midnight Sun"],
        @"arizona" : @[@"Became a state in 1912",@"Phoenix is the capital",@"The Grand Canyon is in Arizona",@"The Copper State"],
        @"arkansas" : @[@"Became a state in 1836",@"Little Rock is the capital",@"The Natural State"],
        @"california" : @[@"Became a state in 1850",@"Sacramento is the capital",@"The Golden State",@"The most populous state", @"Los Angeles is the biggest city"],
        @"colorado" : @[@"Became a state in 1876",@"Denver is the capital",@"The Centennial State",@"Named after the Colorado river"],
        @"connecticut" : @[@"Became a state in 1788",@"Hartford is the capital",@"The Constitution State", @"The Nutmeg State"],
        @"delaware" : @[@"Became a state in 1787",@"Dover is the capital",@"The First State", @"The Small Wonder"],
        @"florida" : @[@"Became a state in 1845",@"Tallahassee is the capital",@"The Sunshine State",@"Jacksonville is the largest city"],
        @"georgia" : @[@"Became a state in 1788",@"Atlanta is the capital",@"The Peach State", @"Empire State of the South",@"Named after King George II of England"],
        //@"georgia" : @[@"Named after King George II of England"],
        @"hawaii" : @[@"Became a state in 1959",@"Honolulu is the capital",@"The Aloha State"],
        @"idaho" : @[@"Became a state in 1890",@"Boise is the capital",@"The Gem State"],
        @"illinois" : @[@"Became a state in 1818",@"Springfield is the capital",@"Chicago is the largest city",@"The Land of Lincoln", @"The Prairie State"],
        @"indiana" : @[@"Became a state in 1816",@"Indianapolis is the capital",@"The Hoosier State"],
        @"iowa" : @[@"Became a state in 1846",@"Des Moines is the capital",@"The Hawkeye State"],
        @"kansas" : @[	@"Became a state in 1861",@"Topeka is the capital",@"Wichita is the largest city",@"The Sunflower State",@"The Wheat State"],
        @"kentucky" : @[@"Became a state in 1792",@"Frankfort is the capital",@"The Bluegrass State"],
        @"louisiana" : @[@"Became a state in 1812",@"Baton Rouge is the capital",@"The Pelican State",@"The Bayou State",@"The Sugar State",@"New Orleans is the largest city"],
        @"maine" : @[@"Became a state in 1820",@"Augusta is the capital",@"The Pine Tree State",@"Portland is the largest city"],
        @"maryland" : @[@"Became a state in 1788",@"Annapolis is the capital",@"The Free State", @"The Old Line State", @"America in Miniature",@"Baltimore is the largest city"],
        @"massachusetts" : @[@"Became a state in 1788",@"Boston is the capital",@"The Bay State"],
        @"michigan" : @[@"Became a state in 1837",@"Lansing is the capital",@"The Wolverine State",@"The Great Lakes State",@"The Automotives State",@"Detroit is the largest city"],
        @"minnesota" : @[@"Became a state in 1858",@"Saint Paul is the capital",@"Minneapolis is the largest city",@"The North Star State",@"The Land of 10,000 Lakes", @"The Gopher State"],
        @"mississippi" : @[@"Became a state in 1817",@"Jackson is the capital",@"The Magnolia State", @"The Hospitality State"],
        @"missouri" : @[@"Became a state in 1821",@"Jefferson City is the capital",@"The Show Me State",@"The largest city is Kansas City"],
        @"montana" : @[@"Became a state in 1889",@"Helena is the capital",@"The largest city is Billings",@"The Treasure State", @"Big Sky Country"],
        @"nebraska" : @[@"Became a state in 1867",@"Lincoln is the capital",@"The Cornhusker State",@"Omaha is the largest city"],
        @"nevada" : @[@"Became a state in 1864",@"Carson City is the capital",@"The Silver State", @"The Sagebrush State",@"The Battle Born State",@"Las Vegas is the largest city"],
        @"newhampshire" : @[@"Became a state in 1788",@"Concord is the capital",@"The Granite State",@"Manchester is the largest city"],
        @"newjersey" : @[@"Became a state in 1787",@"Trenton is the capital",@"The Garden State",@"Newark is the largest city"],
        @"newmexico" : @[@"Became a state in 1912",@"Santa Fe is the capital",@"Land of Enchantment",@"The largest city is Albuquerque"],
        @"newyork" : @[	@"Became a state in 1788",@"Albany is the capital",@"The Empire State",@"New York city is the largest city"],
        @"northcarolina" : @[@"Became a state in 1789",@"Raleigh is the capital",@"The Tar Heel State",@"The Old North State",@"The Goodliest Land",@"The Rip Van Winkle State",@"Charlotte is the largest city"],
        @"northdakota" : @[@"Became a state in 1889",@"Bismarck is the capital",@"The Peace Garden State",@"The Roughrider State", @"The Flickertail State",@"Fargo is the largest city"],
        @"ohio" : @[@"Became a state in 1803",@"Columbus is the capital",@"Cleveland is the largest city",@"The Buckeye State",@"Birthplace of Aviation"],
        @"oklahoma" : @[@"Became a state in 1907",@"Oklahoma City is the capital",@"The Sooner State"],
        @"oregon" : @[@"Became a state in 1859",@"Salem is the capital",@"The Beaver State",@"Wet-Foot State",@"Portland is the largest city"],
        @"pennsylvania" : @[@"Became a state in 1787",@"Harrisburg is the capital",@"The Keystone State",@"The Quaker State",@"The Coal State",@"The Oil State",@"Philadelphia is the largest city"],
       // @"pennsylvania" : @[@"Philadelphia is the largest city"],
        @"rhodeisland" : @[@"Became a state in 1790",@"Providence is the capital",@"The Ocean State", @"Little Rhody",@"Rhode Island is the smallest state"],
        @"southcarolina" : @[@"Became a state in 1788",@"Columbia is the capital",@"The Palmetto State"],
        @"southdakota" : @[@"Became a state in 1889",@"Pierre is the capital",@"The Mount Rushmore State",@"Sioux Falls is the largest city"],
        @"tennessee" : @[@"Became a state in 1796",@"Nashville is the capital",@"The Volunteer State",@"Memphis is the largest city"],
        @"texas" : @[@"Became a state in 1845",@"Austin is the capital",@"Texas is the second biggest state",@"Houston is the largest city in Texas",@"The Lone Star State"],
        @"utah" : @[@"Became a state in 1896",@"Salt Lake City is the capital",@"The Beehive State"],
        @"vermont" : @[@"Became a state in 1791",@"Montpelier is the capital",@"The Green Mountain State",@"Burlington is the largest city"],
        @"virginia" : @[@"Became a state in 1788",@"Richmond is the capital",@"Old Dominion", @"Mother of Presidents", @"Mother of States",@"The largest city is Virginia Beach"],
        @"washington" : @[@"Became a state in 1889",@"Olympia is the capital",@"The Evergreen State",@"Seattle is the largest city"],
        @"westvirginia" : @[@"Became a state in 1863",@"Charleston is the capital",@"The Mountain State"],
        @"wisconsin" : @[@"Became a state in 1848",@"Madison is the capital",@"The Badger State",@"America's Dairyland",@"Milwaukee is the largest city"],
        @"wyoming" : @[@"Became a state in 1890",@"Cheyenne is the capital",@"The Equality State",@"The Cowboy State",@"Big Wyoming"]
                             };
    
    

    return states;
}
-(NSString *)getFactForState:(NSString *)state
{
    NSArray *stateFactList = [self.stateFacts objectForKey:state];
    int index = arc4random() % [stateFactList count];
    return [stateFactList objectAtIndex:index];
    
}
-(NSArray *)getQuestionFromCategory:(NSString *)category
{
    NSMutableDictionary *section = [self getDicionaryForType:category];
    NSMutableDictionary *resultHeader = [[NSMutableDictionary alloc] init];
    int x = (arc4random() % [section count]);
    NSString *key = [[section allKeys] objectAtIndex:x];
    [resultHeader setObject:[section objectForKey:key] forKey:key];
    [section removeObjectForKey:key];
    
    NSArray *result = [NSArray arrayWithObjects:resultHeader, section, nil];
    return result;
}

-(NSDictionary *)getnumQuestions:(int)num ForCategory:(NSString *)category
{
    NSMutableDictionary *section = [self getDicionaryForType:category];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < num; i++) {
        int x = (arc4random() % [section count]);
        NSString *key = [[section allKeys] objectAtIndex:x];
        [result setObject:[section objectForKey:key] forKey:key];
        [section removeObjectForKey:key];
    }
    return result;
}

-(NSArray *)getFourCategoryQuestionsForCategory:(NSString *)category
{
    NSMutableDictionary *section = [self getDicionaryForType:category];
    NSMutableDictionary *resultHeader = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < 4; i++) {
        int x = (arc4random() % [section count]);
        NSString *key = [[section allKeys] objectAtIndex:x];
        [resultHeader setObject:[section objectForKey:key] forKey:key];
        [section removeObjectForKey:key];
    }
    NSArray *result = [NSArray arrayWithObjects:resultHeader, section, nil];
    return result;
}

-(NSArray *)getNextQuestion
{
    NSArray *result = [NSArray arrayWithObject:@"Complete"]; //let the caller know if we are finished
    if ([self.allQuestions count] > 0) {
     
        NSString *questionTarget = [[self.allQuestions allKeys] objectAtIndex:0];
        NSArray *question =  [self.allQuestions objectForKey:questionTarget];
        [self.allQuestions removeObjectForKey:questionTarget]; //addObject:questionTarget];
        //add 1 to the num Questions Asked
        int newNumQuestionsAsked = [self.numAskedQuestions intValue] + 1;
        self.numAskedQuestions = [NSNumber numberWithInt:newNumQuestionsAsked];
        
        return question;
    }
    return  result;
}


-(NSMutableDictionary *)getListOfQuestions
{
    //this needs rework because the key values collide:
    /*
     getfourquestions returns the 4 questions and the remainder to be added to allcats
     the choice from allcats then gets confused as both capitals and states use the same key value
     soln: randomise between picking 5 & 5 , 6 & 4 , 4 & 6 with an outside chance of a 7/3
     */
    int numQuestions = [[self.quizCategories lastObject] intValue];
    int x1 = 1 + (arc4random() % numQuestions);
    int x2 = 1 + (arc4random() % numQuestions);
    int x3 = 1 + (arc4random() % numQuestions);
    int x4 = 1 + (arc4random() % numQuestions);
    int y = (x1 + x2 + x3 + x4) * 0.25;
    int stateQuestionNum = numQuestions - y;
    int capQuestionNum = y;
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result addEntriesFromDictionary:[self getnumQuestions:stateQuestionNum ForCategory:@"State"]];
    [result addEntriesFromDictionary:[self getnumQuestions:capQuestionNum ForCategory:@"Capital"]];

    return result;
}
-(NSArray *)answersForQuestion:(NSArray *)question ofType:(NSString *)capitalOrState
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *answerToExclude = ([capitalOrState isEqualToString:@"State"]) ? [question objectAtIndex:4]: [question objectAtIndex:5] ;

    NSString *type = [question lastObject];
    NSMutableDictionary *allAnswers = [self getDicionaryForType:type];
    [allAnswers removeObjectForKey:answerToExclude];
    for (int i = 0 ; i < 3; i++) {
       int x = (arc4random() % [allAnswers count]);
        NSString *key = [[allAnswers allKeys] objectAtIndex:x];
        [result addObject:[allAnswers objectForKey:key]];
        [allAnswers removeObjectForKey:key];
    }
    return result;
    
}

-(NSMutableDictionary *)getDicionaryForType:(NSString *)type
{
    NSMutableDictionary *result;
    if ([type isEqualToString:@"State"]) result = [self.stateMarkers mutableCopy];
    if ([type isEqualToString:@"Capital"]) {
        result = [[NSMutableDictionary alloc] init];
        for (NSString *questionKey in [self.stateMarkers allKeys]) {
            
            NSMutableArray *questionArray =[[self.stateMarkers objectForKey:questionKey] mutableCopy];
            NSString *capitalKey = [questionArray objectAtIndex:5];
            [questionArray setObject:@"Capital" atIndexedSubscript:6];
            [result setObject:questionArray forKey:capitalKey];
        }
        
    }
    return result;
}

-(NSDictionary *)stateCapitalsList
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    //pick the states & randomize them
    NSMutableArray *selectStates = [[NSMutableArray alloc] init];
    NSMutableArray *allStates = [NSMutableArray arrayWithArray:[self.stateMarkers allKeys]];
    int numberOfStateCapitalPairs = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? NUMBER_OF_CELLS_FOR_IPAD_MATCHING / 2: NUMBER_OF_CELLS_FOR_IPHONE_MATCHING / 2 ;
    for (int i = 0 ; i < numberOfStateCapitalPairs; i++) {
        int x = (arc4random() % [allStates count]);
        [selectStates addObject:[allStates objectAtIndex:x]];
        [allStates removeObjectAtIndex:x];
    }
    int j = 0;
    for (NSString *state in selectStates) {
        
        NSString   *capital = [[self.stateMarkers  objectForKey:state] objectAtIndex:5];
        [result setObject:[NSArray arrayWithObjects:state, capital, @"State", nil] forKey:[NSNumber numberWithInt:j++]];
        [result setObject:[NSArray arrayWithObjects:capital, state, @"Capital", nil] forKey:[NSNumber numberWithInt:j++]];
        
    }
    return result;
    
}

-(NSArray *)getNextStateCapitalPair
{
    int x = (arc4random() % [self.matchingPairsIndex count]);
    NSNumber *nextStateIndex = [self.matchingPairsIndex objectAtIndex:x];
    [self.matchingPairsIndex removeObjectAtIndex:x];
    [self.matchingAnswersStaging setObject:[self.stateAndCapitalList objectForKey:nextStateIndex] forKey:[NSNumber numberWithInt:self.matchLoopCount]];
    self.matchLoopCount++;
    return [self.stateAndCapitalList objectForKey:nextStateIndex];
}

-(void)matchingClick:(BOOL)up
{
    int currentVal = [self.matchingClicks intValue];
    self.matchingClicks = up ? [NSNumber numberWithInt:(currentVal + 1)] : [NSNumber numberWithInt:(currentVal - 1)];
}
#pragma mark tokencheckinglogic

-(BOOL) isMapComplete
{
    return !([self.unPlacedTargets count] > 0) ;
}

-(BOOL)isQuizComplete
{
    return !([self.allQuestions count]> 0) ;
}

-(void)addMatch:(NSNumber *)match
{
    [self.matchedItems addObject:match];
}
-(BOOL)isPuzzleComplete
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? ([self.matchedItems count] == NUMBER_OF_CELLS_FOR_IPAD_MATCHING) : ([self.matchedItems count] == NUMBER_OF_CELLS_FOR_IPHONE_MATCHING);
}

@end