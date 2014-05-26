//
//  Cell.m
//  USAPuzzle
//
//  Created by Jonathan Headen on 17/08/13.
//  Copyright (c) 2013 airskull. All rights reserved.
//

#import "Cell.h"


@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.baseColour.image=[UIImage imageNamed:@"green.png" ];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}

-(NSNumber *)Playable
{
    if (!_Playable) _Playable = [NSNumber numberWithBool:YES];
    return _Playable;
}

-(BOOL) isPlayable
{
    return [self.Playable boolValue];
}

-(void) setIsPlayable:(BOOL)isPlayable
{
    self.Playable = [NSNumber numberWithBool:isPlayable];
    //
    if (!isPlayable){
        self.baseColour.image = [UIImage imageNamed:@"red.png"];
        self.highlight.alpha = 0.0;
        self.baseColour.alpha = 0.4;
    } else
    {
        self.highlight.alpha = 1.0;
        self.baseColour.alpha = 0.7;
    }
}

@end
