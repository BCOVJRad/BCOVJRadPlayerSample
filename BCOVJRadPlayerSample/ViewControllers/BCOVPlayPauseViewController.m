//
//  BCOVPlayPauseViewController.m
//  BCOVJRadPlayerSample
//
//  Created by Joseph Radjavitch on 10/31/14.
//  Copyright (c) 2014 Joseph Radjavitch. All rights reserved.
//

#import "BCOVPlayPauseViewController.h"
#import "BCOVLogUtils.h"
#import "RACEXTScope.h"

#define kMaxDuration 20 * 60  //1 * 60 * 60

@interface BCOVPlayPauseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) id<BCOVPlaybackController> playbackController;
@property (nonatomic, weak) id<BCOVPlaybackSession> playbackSession;
@property (nonatomic, assign) NSTimeInterval sliderDuration;
@property (nonatomic, assign) BOOL isSeeking;

- (IBAction)playPauseButtonPressed:(UIButton *)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)sliderDragEnter:(id)sender;
- (IBAction)sliderDragExit:(id)sender;
@end

@implementation BCOVPlayPauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.playPauseButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateSelected];
    
    // Only notified of last value changed when dragging
    [self.timeSlider setContinuous:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton*)playBarButton
{
    return self.playPauseButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)configureConstraintsForContainerView:(UIView*)containerView andPlayerView:(UIView*)playerView
{
    NSDictionary* views = @{ @"controlsView":self.view, @"playerView":playerView };
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray *horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[controlsView]|"
                                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                   metrics:nil
                                                                                     views:views];
    [containerView addConstraints:horizontalLayoutConstraints];
    
//    NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[controlsView]|"
//                                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                                 metrics:nil
//                                                                                   views:views];
//    [containerView addConstraints:verticalLayoutConstraints];
//    NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playerView]-0-[controlsView]|"
//                                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                                 metrics:nil
//                                                                                   views:views];
//    [containerView addConstraints:verticalLayoutConstraints];
}

- (void)setElapsedTime:(NSString*)time
{
    self.elapsedTimeLabel.text = time;
}

- (void)setDuration:(NSString*)duration
{
    self.totalTimeLabel.text = duration;
}

- (void)setSliderValue:(float)currentValue
{
    self.timeSlider.value = currentValue;
}

#pragma mark - BCOVPlaybackSessionConsumer

- (void)consumeSession:(id<BCOVPlaybackSession>)session
{
    LogBlue(@"consumeSession:%@", session);
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    LogBlue(@"playbackSession:didReceiveLifecycleEvent:%@", lifecycleEvent.eventType);
}

//- (void)didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
//{
//    LogBlue(@"didAdvanceToPlaybackSession");
//}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress
{
    LogBlue(@"playbackSession:didProgressTo:%f", progress);
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didChangeDuration:(NSTimeInterval)duration {
    LogBlue(@"playbackSession:didChangeDuration:%f", duration);
}

#pragma mark - BCOVPlaybackControllerDelegate

//- (void)didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session {
//    LogBlue(@"didAdvanceToPlaybackSession");
//}

- (void)playbackController:(id<BCOVPlaybackController>)controller didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    if (self.playbackController == nil) {
        self.playbackController = controller;
    }
    
    if (self.playbackSession == nil) {
        self.playbackSession = session;
    }
    
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;

    [self setElapsedTime:[self formatTime:0]];
    [self setSliderValue:0.f];
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didChangeDuration:(NSTimeInterval)duration
{
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;
    
    if (self.playbackController == nil) {
        self.playbackController = controller;
    }
    
    if (self.playbackSession == nil) {
        self.playbackSession = session;
    }
    
    [self updateDurationWithSession:session andProgress:duration];
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress
{
    //LogBlue(@"playbackController:playbackSession:didProgressTo:%f", progress);
    
    if (!isfinite(progress)) {
        return;
    }
    
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;
    
    if (self.playbackController == nil) {
        self.playbackController = controller;
    }
    
    if (self.playbackSession == nil) {
        self.playbackSession = session;
    }
    
    if (self.isSeeking) {
        return;
    }
    
    [self updateDurationWithSession:session andProgress:progress];
    
    float percent = progress / self.sliderDuration;
    [self setSliderValue: isnan(percent) ? 0.0f : percent];
    [self setElapsedTime:[self formatTime:progress]];
}

- (void)updateDurationWithSession:(id<BCOVPlaybackSession>)session andProgress:(NSTimeInterval)progress
{
    if (self.sliderDuration == 0.0f || progress > self.sliderDuration) {
        if (progress * 2 > kMaxDuration) {
            self.sliderDuration = progress * 2;
        }
        else {
            self.sliderDuration = kMaxDuration;
        }
        
        NSTimeInterval durationInSeconds = CMTimeGetSeconds(session.player.currentItem.duration);
        if (!isnan(durationInSeconds)) {
            self.sliderDuration = durationInSeconds;
        }
        
        [self setDuration:[self formatTime:self.sliderDuration]];
    }
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didChangeExternalPlaybackActive:(BOOL)externalPlaybackActive
{
    LogBlue(@"playbackController:playbackSession:didChangeExternalPlaybackActive");
    
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;
    
    if (self.playbackSession == nil) {
        self.playbackSession = session;
    }
    
    if (self.playbackController == nil) {
        self.playbackController = controller;
    }
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didPassCuePoints:(NSDictionary *)cuePointInfo
{
    LogBlue(@"playbackController:playbackSession:didPassCuePoints");
    
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;
    
    if (self.playbackController == nil) {
        self.playbackController = controller;
    }
    
    if (self.playbackSession == nil) {
        self.playbackSession = session;
    }
    
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    //LogBlue(@"playbackController:playbackSession:didReceiveLifecycleEvent:%@", lifecycleEvent.eventType);
    
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;
    
    if (self.playbackController == nil) {
        self.playbackController = controller;
    }
    
    if (self.playbackSession == nil) {
        self.playbackSession = session;
    }
    
    if(lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlay){
        [self.playPauseButton setSelected:YES];
    }
    else if(lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPause){
        [self.playPauseButton setSelected:NO];
    }
//    //End, fail, or teminate playback remove from fullscreen if fullscreen is playing.
//    if((lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventEnd) ||
//       (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventFail) ||
//       (lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventFail)){
//        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
//            if(self.controls.isFullscreen){
//                [[NSNotificationCenter defaultCenter] postNotificationName:kBCCEventFullScreen object:nil];
//            }
//
//        }
//    }
//
//    // A loading overlay appears on top of the page while a new video is being loaded into
//    // the player. Once the content is ready to play, dismiss the overlay. This prevents
//    // users from tapping rapid fire on thumbnails and eventually crashing the app.
//    if(lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventReady) {
//        [self stopActivityIndicator];
//    }
}

#pragma mark Class Methods

- (NSString *)formatTime:(NSTimeInterval)timeInterval
{
    if (timeInterval == 0)
    {
        return @"00:00";
    }
    
    NSInteger hours = floor(timeInterval / 60.0f / 60.0f);
    NSInteger minutes = (NSInteger)(timeInterval / 60.0f) % 60;
    NSInteger seconds = (NSInteger)timeInterval % 60;
    
    NSString *ret = nil;
    if (hours > 0)
    {
        ret = [NSString stringWithFormat:@"%ld:%.2ld:%.2ld", (long)hours, (long)minutes, (long)seconds];
    }
    else
    {
        ret = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)minutes, (long)seconds];
    }
    
    return ret;
}

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    
    if ([self.playPauseButton isSelected]) {
        LogDefault(@"Pause pressed");
        [self.playbackController pause];
    }
    else {
        LogDefault(@"Play pressed");
        [self.playbackController play];
    }
}

- (IBAction)sliderChanged:(id)sender {
    LogGreen(@"sliderChanged:");
    
    BOOL tempPause = [self.playPauseButton isSelected];
    if (tempPause) {
        [self.playbackController pause];
    }
    
    
    NSTimeInterval progress = self.timeSlider.value * self.sliderDuration;
    
    if (self.timeSlider.value == 1.0) {
        progress = MAXFLOAT;
    }
    
    CMTime seekCMTime = CMTimeMakeWithSeconds(progress, 600);
    
    self.isSeeking = YES;
    
    @weakify(self);
    AVPlayer* currentPlayer = self.playbackSession.player;
    AVPlayerItem* currentItem = currentPlayer.currentItem;
    
//    for (CMTimeRange* timeRange in currentItem.seekableTimeRanges) {
//        
//    }
    LogRed(@"player seekableTimeSessions:%@", currentItem.seekableTimeRanges);
    LogRed(@"player currentTime:%lld", currentItem.currentTime.value/currentItem.currentTime.timescale);
    LogRed(@"player forwardPlaybackEndTime:%lld", currentItem.forwardPlaybackEndTime.value/currentItem.forwardPlaybackEndTime.timescale);
    LogRed(@"player reversePlaybackEndTime:%lld", currentItem.reversePlaybackEndTime.value/currentItem.reversePlaybackEndTime.timescale);
    LogRed(@"player loadedTimeRanges:%@", currentItem.loadedTimeRanges);
//    LogRed(@"player playbackStartDate:%@", self.playbackSession.player.currentItem.playbackStartDate);
//    LogRed(@"player playbackStartOffset:%@", self.playbackSession.player.currentItem.playbackStartOffset);
//    LogRed(@"player startupTime:%@", self.playbackSession.player.currentItem.startupTime);
    
    [self.playbackSession.player seekToTime:seekCMTime toleranceBefore:CMTimeMake(30, 60) toleranceAfter:CMTimeMake(30, 60) completionHandler:^(BOOL finished) {
        @strongify(self);
        
        self.isSeeking = NO;
        
        NSString* newTime = [self formatTime:progress];
        [self setElapsedTime:newTime];
        
        if (tempPause) {
            [self.playbackController play];
        }
    }];
}

- (IBAction)sliderDragEnter:(id)sender {
    LogGreen(@"sliderDragEnter:");
    if ([self.playPauseButton isSelected]) {
        [self.playbackController pause];
    }
}

- (IBAction)sliderDragExit:(id)sender {
    LogGreen(@"sliderDragExit:");
    if (![self.playPauseButton isSelected]) {
        [self.playbackController play];
    }
}

@end
