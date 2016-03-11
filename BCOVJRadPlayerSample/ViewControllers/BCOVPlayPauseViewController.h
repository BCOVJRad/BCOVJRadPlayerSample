//
//  BCOVPlayPauseViewController.h
//  BCOVJRadPlayerSample
//
//  Created by Joseph Radjavitch on 10/31/14.
//  Copyright (c) 2014 Joseph Radjavitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Brightcove-Player-SDK/BCOVPlayerSDK.h>

@interface BCOVPlayPauseViewController : UIViewController  <BCOVPlaybackSessionConsumer, BCOVPlaybackControllerDelegate>

- (void)configureConstraintsForContainerView:(UIView*)containerView andPlayerView:(UIView*)playerView;
- (UIButton*)playBarButton;

- (void)setElapsedTime:(NSString*)time;
- (void)setDuration:(NSString*)duration;
- (void)setSliderValue:(float)currentValue;

@end
