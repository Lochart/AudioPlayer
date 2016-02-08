//
//  Track.m
//  PlayerAudio
//
//  Created by Nikolay on 23.10.15.
//  Copyright © 2015 Nikolay. All rights reserved.
//

#import "Track.h"

@implementation Track

- (NSString *)durationString
{
    if (!_durationString) {
        NSUInteger totalSeconds = (NSUInteger)floor(CMTimeGetSeconds(self.duration));
        NSUInteger minutes = totalSeconds / 60;
        NSUInteger seconds = totalSeconds % 60;
        _durationString = [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
    }
    return _durationString;
}

@end
