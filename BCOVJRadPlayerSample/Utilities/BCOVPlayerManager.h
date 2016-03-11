//
//  BCOVPlayerManager.h
//  BCOVJRadPlayerSample
//
//  Created by Joseph Radjavitch on 10/30/14.
//  Copyright (c) 2014 Brightcove. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBCOVToken @"APIToken"
#define kBCOVPlalistID @"PlaylistID"
#define kBCOVPlayerDelegate @"PlayerDelegate"

#define kBCOVPlayerControl @"BCOVPlayer"
#define kBCOVButtonPlayPause @"PlayPauseButton"
#define kBCOVSliderTime @"TimeSlider"
#define kBCOVLabelElapsedTime @"ElapsedLabel"
#define kBCOVLabelTotalTime @"TotalTimeLabel"

@protocol BCOVPlayerManagerDelegate <NSObject>

@end

@interface BCOVPlayerManager : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
