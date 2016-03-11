//
//  BCOVPlayerManager.m
//  BCOVJRadPlayerSample
//
//  Created by Joseph Radjavitch on 10/30/14.
//  Copyright (c) 2014 Brightcove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCOVPlayerManager.h"
//#import "BCOVPlayerSDKManager.h"

@interface BCOVPlayerManager()

//@property (nonatomic, strong) id<BCOVPlaybackController> playerController;
@property (nonatomic, weak) UIButton* playPauseButton;
@property (nonatomic, weak) UILabel* elapsedTimeLabel;
@property (nonatomic, weak) UISlider* timeSlider;
@property (nonatomic, weak) UILabel* totalTimeLabel;
@property (nonatomic) BOOL isPlaying;

@end

@implementation BCOVPlayerManager

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

@end
