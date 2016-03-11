//
//  ViewController.m
//  BCOVJRadPlayerSample
//
//  Created by Joseph Radjavitch on 10/28/14.
//  Copyright (c) 2014 Joseph Radjavitch. All rights reserved.
//

#import "ViewController.h"
#import "BCOVPlayerSDK.h"
#import "UIView+AutoLayout.h"
#import "BCOVPlayPauseViewController.h"
#import "RACEXTScope.h"
#import "BCOVLogUtils.h"

#define kMETAPIToken @"6GQ2nigeQX73Ylq4whuG7eJDYcxLPTr6XypA2hylNN3Qk0FN9vD4UA.."
#define kMETFeaturedVideosPlaylistID @"3863118909001"

#define kVideoViewTag 10000

@interface ViewController () <BCOVPlaybackControllerDelegate, BCOVDelegatingSessionConsumerDelegate>

@property (nonatomic, strong) id<BCOVPlaybackController> playerController;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) NSLayoutConstraint* portraitAspectContraint;
@property (nonatomic, strong) NSLayoutConstraint* landscapeAspectContraint;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

//@property (nonatomic, strong) UIView* playBarView;
//@property (nonatomic, strong) UIButton* playPauseButton;
//@property (nonatomic, strong) UILabel* elapsedTimeLabel;
//@property (nonatomic, strong) UISlider* timeSlider;
//@property (nonatomic, strong) UILabel* totalTimeLabel;

@property (nonatomic, strong) BCOVPlayPauseViewController* bcovPlayPauseVC;

@property (nonatomic) BOOL isPlaying;
@property (weak, nonatomic) IBOutlet UIView *containerViewController;

@end

@implementation ViewController

//Blue gradient background
- (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor orangeColor]; //UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    UIColor *colorTwo = [UIColor darkGrayColor]; //UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    UIColor *colorThree = [UIColor darkGrayColor];    //[UIColor colorWithRed:47.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0];   //[UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    UIColor *colorFour = [UIColor blackColor];    //[UIColor colorWithRed:47.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    NSNumber *stopThree = [NSNumber numberWithFloat:.75];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isPlaying = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.view pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
    
    [self loadNavBar];
    [self loadPlaybar];
//    [self loadPlayer];
    //self.containerViewController
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return YES;
//}

- (void)loadNavBar
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UIImage* img =[UIImage imageNamed:@"brightcove"];
    imgView.image = img;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navItem.titleView = imgView;
}

- (void)loadPlayer
{
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    self.playerController = [manager createPlaybackControllerWithViewStrategy:[self viewStrategyWithFrame:self.containerViewController.bounds]];
    //self.playerController.delegate = self;
    
    self.playerController.view.backgroundColor = [UIColor yellowColor];
    [self.containerViewController addSubview:self.playerController.view];
    self.playerController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.containerViewController.backgroundColor = [UIColor purpleColor];
    [self.playerController.view pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0];
    NSLog(@"playerController subviews: %@", [self.playerController.view subviews]);
//    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.containerViewController
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationLessThanOrEqual
//                                                                    toItem:self.view
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                multiplier:0.5
//                                                                  constant:0.0f];
//    [self.containerViewController addConstraint:constraint];
    
//    [self.containerViewController insertSubview:self.playerController.view aboveSubview:self.bcovPlayPauseVC.view];
//    [self.view addSubview:self.playerController.view];

    //[self.playerController.view pinToSuperviewEdges:JRTViewPinLeftEdge|JRTViewPinRightEdge/*|JRTViewPinBottomEdge*/ inset:0];
//    [self.playerController.view centerInContainerOnAxis:NSLayoutAttributeCenterX];
//    [self.playerController.view centerInContainerOnAxis:NSLayoutAttributeCenterY];
    //[self.playerController.view pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.navBar];
    
//    double newY = self.navBar.bounds.origin.y + self.navBar.bounds.size.height;    
//    [self.playerController.view pinPointAtX:NSLayoutAttributeLeft Y:NSLayoutAttributeTop toPoint:CGPointMake(0, newY)];
    
//    double widthRatio = self.playerController.view.frame.size.width / self.view.frame.size.width;
//    double newHeight = self.playerController.view.frame.size.height * widthRatio;
//    [self.playerController.view constrainToSize:CGSizeMake(self.view.frame.size.width, newHeight)];
}

- (BCOVPlaybackControllerViewStrategy)viewStrategyWithFrame:(CGRect)frame
{
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    
    //BCOVPlaybackControllerViewStrategy imaViewStrategy = [manager BCOVIMAAdViewStrategy];
    
    //  Create custom view strategy using BCCiOSControls
    //  Custom view strategy will exist of a hierarchy of video view, and playback controls
    
    // VIEW HIERARCHY:
    /*
     
     |           View Hierarchy Parent/Root
     |--|        IMA View Strategy
     |--|--      Playback Controller
     |--|--|--   Playback Controls
     |--|        IMA View Ad Controls
     
     */
    
    @weakify(self);
    BCOVPlaybackControllerViewStrategy composedViewStrategy = ^ UIView * (UIView *videoView, id<BCOVPlaybackController> playbackController) {
        @strongify(self);
        
//        UIView *parentContainerView = [UIView autoLayoutView];   //WithFrame:frame];
//        parentContainerView.backgroundColor = [UIColor greenColor];
        
//        double newHeight = frame.size.width / aspectRatio;    //videoView.frame.size.height * widthRatio;
//        CGRect videoRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight);
//        [videoView setFrame:videoRect];
//        
//        CGRect containerFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight + 50);
        UIView *containerView = [UIView autoLayoutView]; //WithFrame:containerFrame];
//        [parentContainerView addSubview:containerView];
        //[containerView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0];
        
        containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [containerView addSubview:videoView];
        videoView.translatesAutoresizingMaskIntoConstraints = NO;
        videoView.backgroundColor = [UIColor cyanColor];
        videoView.tag = kVideoViewTag;
        [videoView pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        NSLog(@"videoView subviews: %@", [videoView subviews]);
        
        float aspectRatio = 9.0/16.0;//videoView.frame.size.height / videoView.frame.size.width;
        float invertedAspectRatio = 9.0/16.0;//1.0/aspectRatio;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
            // orientation is landscape
            self.landscapeAspectContraint = [NSLayoutConstraint constraintWithItem:videoView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:videoView
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:aspectRatio
                                                                          constant:0.0f];

            self.portraitAspectContraint = [NSLayoutConstraint constraintWithItem:videoView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:videoView
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:aspectRatio
                                                                          constant:0.0f];
            
            [videoView addConstraint:self.landscapeAspectContraint];
        } else if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
            // orientation is portrait
            self.portraitAspectContraint = [NSLayoutConstraint constraintWithItem:videoView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:videoView
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:aspectRatio
                                                                          constant:0.0f];
            
            self.landscapeAspectContraint = [NSLayoutConstraint constraintWithItem:videoView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:videoView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:aspectRatio
                                                                         constant:0.0f];
            
            [videoView addConstraint:self.portraitAspectContraint];
        }
        
//        UIView* newView = [UIView autoLayoutView];
//        [newView setBackgroundColor:[UIColor redColor]];
//        [containerView addSubview:newView];
//        NSDictionary* views = @{ @"controlsView":newView, @"playerView":videoView };
//        NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playerView][controlsView(60)]|"
//                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                                     metrics:nil
//                                                                                       views:views];
//        [containerView addConstraints:verticalLayoutConstraints];

        
        // This provides delegate methods similar to the BCOVPlaybackSession delegate methods so that controls can interact with player and ads
        
        //BCOVDelegatingSessionConsumer *delegatingSessionConsumer = [[BCOVDelegatingSessionConsumer alloc] initWithDelegate:self.bcovPlayPauseVC];
        //BCOVDelegatingSessionConsumer *vcDelegatingSessionConsumer = [[BCOVDelegatingSessionConsumer alloc] initWithDelegate:self];
        [self.playerController addSessionConsumer:self.bcovPlayPauseVC];
        self.playerController.delegate = self.bcovPlayPauseVC;
        
        //[self.playerController addSessionConsumer:self];
        
        [self.bcovPlayPauseVC.view setUserInteractionEnabled:YES];
        [self.bcovPlayPauseVC view].autoresizingMask = /*UIViewAutoresizingFlexibleHeight |*/ UIViewAutoresizingFlexibleWidth;
        self.bcovPlayPauseVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        //[self.bcovPlayPauseVC willMoveToParentViewController:self];
        //[self addChildViewController:self.bcovPlayPauseVC];
        [containerView insertSubview:self.bcovPlayPauseVC.view atIndex:0];  //addSubview:self.bcovPlayPauseVC.view];
        //[self.bcovPlayPauseVC.view pinToSuperviewEdges:JRTViewPinBottomEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        
        NSDictionary* views = @{ @"controlsView":self.bcovPlayPauseVC.view, @"playerView":videoView };
        NSArray *verticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playerView]-0-[controlsView(45)]|"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:nil
                                                                                       views:views];
        [containerView addConstraints:verticalLayoutConstraints];
        NSArray *horizontalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[controlsView]|"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:nil
                                                                                       views:views];
        [containerView addConstraints:horizontalLayoutConstraints];
        //[self.bcovPlayPauseVC.view pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:videoView];
        //[videoView pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeBottom ofItem:self.bcovPlayPauseVC.view];
        //[containerView pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeBottom ofItem:self.bcovPlayPauseVC.view];
        
//        [self.bcovPlayPauseVC configureConstraintsForContainerView:containerView andPlayerView:videoView];
        //[self.bcovPlayPauseVC didMoveToParentViewController:self];
        NSLog(@"bcovPlayPauseView: %@",self.bcovPlayPauseVC.view);
        
        //[self.bcovPlayPauseVC didMoveToParentViewController:self];
        //[[self.bcovPlayPauseVC view] pinToSuperviewEdges:JRTViewPinBottomEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        //NSLog(@"we never set self.controls to controlsViewController");
        
//        UIView *viewWithAdsAndControls = imaViewStrategy(containerView, playbackController);
//        viewWithAdsAndControls.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [parentContainerView addSubview:viewWithAdsAndControls];
        
        // JLR - Uncomment to debug view issues
        //        [controlsViewController.view setBackgroundColor:[UIColor lightGrayColor]];
        //        [adControlsViewController.view setBackgroundColor:[UIColor cyanColor]];
        //        [viewWithAdsAndControls setBackgroundColor:[UIColor darkGrayColor]];
        //        [containerView setBackgroundColor:[UIColor magentaColor]];
        //        [parentContainerView setBackgroundColor:[UIColor purpleColor]];
        
        //containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //parentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //[parentContainerView addSubview:containerView];
        
        NSLog(@"containerView subviews: %@", [containerView subviews]);
        return containerView;
    };
    
    return [composedViewStrategy copy];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    BOOL transitionToWide = size.width > size.height;
    UIView* videoView = [self.view viewWithTag:kVideoViewTag];
    
    if (transitionToWide) {
        if ([videoView.constraints containsObject:self.portraitAspectContraint]) {
            [videoView removeConstraint:self.portraitAspectContraint];
            [videoView addConstraint:self.landscapeAspectContraint];
        }
    }
    else {
        if ([videoView.constraints containsObject:self.landscapeAspectContraint]) {
            [videoView removeConstraint:self.landscapeAspectContraint];
            [videoView addConstraint:self.portraitAspectContraint];
        }
    }
}

- (BCOVPlaybackControllerViewStrategy)viewStrategyWithFrame2:(CGRect)frame
{
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    
    //BCOVPlaybackControllerViewStrategy imaViewStrategy = [manager BCOVIMAAdViewStrategy];
    
    //  Create custom view strategy using BCCiOSControls
    //  Custom view strategy will exist of a hierarchy of video view, and playback controls
    
    // VIEW HIERARCHY:
    /*
     
     |           View Hierarchy Parent/Root
     |--|        IMA View Strategy
     |--|--      Playback Controller
     |--|--|--   Playback Controls
     |--|        IMA View Ad Controls
     
     */
    
    @weakify(self);
    BCOVPlaybackControllerViewStrategy composedViewStrategy = ^ UIView * (UIView *videoView, id<BCOVPlaybackController> playbackController) {
        @strongify(self);
        
        UIView *parentContainerView = [[UIView alloc] initWithFrame:frame];
        
        double aspectRatio = videoView.frame.size.width / videoView.frame.size.height;
        
        double newHeight = frame.size.width / aspectRatio;    //videoView.frame.size.height * widthRatio;
        CGRect videoRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight);
        [videoView setFrame:videoRect];
        
        CGRect containerFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight + 50);
        UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
        [parentContainerView addSubview:containerView];
        
        [containerView addSubview:videoView];
        
        // This provides delegate methods similar to the BCOVPlaybackSession delegate methods so that controls can interact with player and ads
        
        //BCOVDelegatingSessionConsumer *delegatingSessionConsumer = [[BCOVDelegatingSessionConsumer alloc] initWithDelegate:self.bcovPlayPauseVC];
        //BCOVDelegatingSessionConsumer *vcDelegatingSessionConsumer = [[BCOVDelegatingSessionConsumer alloc] initWithDelegate:self];
        [self.playerController addSessionConsumer:self.bcovPlayPauseVC];
        self.playerController.delegate = self.bcovPlayPauseVC;
        
        //[self.playerController addSessionConsumer:self];
        
        [self.bcovPlayPauseVC.view setUserInteractionEnabled:YES];
        [self.bcovPlayPauseVC view].autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.bcovPlayPauseVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addChildViewController:self.bcovPlayPauseVC];
        [containerView addSubview:self.bcovPlayPauseVC.view];
        [self.bcovPlayPauseVC configureConstraintsForContainerView:containerView andPlayerView:videoView];
        [self.bcovPlayPauseVC didMoveToParentViewController:self];
        //[[self.bcovPlayPauseVC view] pinToSuperviewEdges:JRTViewPinBottomEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        //NSLog(@"we never set self.controls to controlsViewController");
        
        //        UIView *viewWithAdsAndControls = imaViewStrategy(containerView, playbackController);
        //        viewWithAdsAndControls.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //        [parentContainerView addSubview:viewWithAdsAndControls];
        
        // JLR - Uncomment to debug view issues
        //        [controlsViewController.view setBackgroundColor:[UIColor lightGrayColor]];
        //        [adControlsViewController.view setBackgroundColor:[UIColor cyanColor]];
        //        [viewWithAdsAndControls setBackgroundColor:[UIColor darkGrayColor]];
        //        [containerView setBackgroundColor:[UIColor magentaColor]];
        //        [parentContainerView setBackgroundColor:[UIColor purpleColor]];
        
        containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        parentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [parentContainerView addSubview:containerView];
        
        return parentContainerView;
    };
    
    return [composedViewStrategy copy];
}

- (void)loadPlaybar
{
    self.bcovPlayPauseVC = [[BCOVPlayPauseViewController alloc] init];
//    [self addChildViewController:self.bcovPlayPauseVC];
//    //[self.containerViewController addSubview:self.bcovPlayPauseVC.view];
//    [self.containerViewController insertSubview:self.bcovPlayPauseVC.view belowSubview:self.playerController.view];
//    
//    [self.bcovPlayPauseVC configureConstraintsForContainerView:self.containerViewController
//                                                 andPlayerView:self.playerController.view];
//    [self.bcovPlayPauseVC didMoveToParentViewController:self];
    
//    [self.bcovPlayPauseVC.playBarButton addTarget:self
//                                           action:@selector(playPausePressed:)
//                                 forControlEvents:UIControlEventTouchUpInside];
    
//    self.playBarView = [UIView autoLayoutView];
//    self.playBarView.userInteractionEnabled = NO;
//    
//    [self loadPlayButton];
//    [self loadElapsedTime];
//    [self loadTotalTimeLabel];
//    [self loadTimeSlider];
//    
//    [self.playBarView sizeToFit];
//    [self.view addSubview:self.playBarView];
//    
//    [self.playBarView setBackgroundColor:[UIColor darkGrayColor]];
//    
//    [self.playBarView pinToSuperviewEdges:JRTViewPinLeftEdge|JRTViewPinRightEdge inset:0 usingLayoutGuidesFrom:self];
//    [self.playBarView centerInContainerOnAxis:NSLayoutAttributeCenterY];
//    //[self.playBarView pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.playerController.view];
}

//- (void)loadPlayButton
//{
//    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.playPauseButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
//    //[self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
//    self.playPauseButton.showsTouchWhenHighlighted = YES;
//    self.playPauseButton.reversesTitleShadowWhenHighlighted = YES;
//    
//    [self.playPauseButton addTarget:self
//                             action:@selector(playPausePressed:)
//                   forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.playBarView addSubview:self.playPauseButton];
////    [self.playPauseButton sizeToFit];
//    [self.playPauseButton pinToSuperviewEdges:JRTViewPinLeftEdge inset:10];
//    [self.playPauseButton pinAttribute:NSLayoutAttributeTop toSameAttributeOfItem:self.playBarView withConstant:5.0];
//    [self.playPauseButton pinAttribute:NSLayoutAttributeBottom toSameAttributeOfItem:self.playBarView withConstant:-5.0];
//    
//    [self.playPauseButton centerInContainerOnAxis:NSLayoutAttributeCenterY];
//}
//
//- (void)loadElapsedTime
//{
//    self.elapsedTimeLabel = [[UILabel alloc] init];
//    self.elapsedTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.elapsedTimeLabel.text = @"0:00.00";
//    self.elapsedTimeLabel.textColor = [UIColor yellowColor];
//    [self.elapsedTimeLabel sizeToFit];
//    
//    [self.playBarView addSubview:self.elapsedTimeLabel];
//    [self.elapsedTimeLabel pinAttribute:NSLayoutAttributeLeft
//                            toAttribute:NSLayoutAttributeRight
//                                 ofItem:self.playPauseButton
//                           withConstant:10.0];
////    [self.elapsedTimeLabel pinToSuperviewEdges:JRTViewPinLeftEdge inset:10];
//    [self.elapsedTimeLabel centerInContainerOnAxis:NSLayoutAttributeCenterY];
//}
//
//- (void)loadTimeSlider
//{
//    self.timeSlider = [[UISlider alloc] init];
//    self.timeSlider.translatesAutoresizingMaskIntoConstraints = NO;
//    self.timeSlider.minimumValue = 0;
//    self.timeSlider.maximumValue = 100;
//    self.timeSlider.minimumTrackTintColor = [UIColor cyanColor];
//    self.timeSlider.maximumTrackTintColor = [UIColor whiteColor];
//    self.timeSlider.value = 0;
//    
//    [self.playBarView addSubview:self.timeSlider];
//    [self.timeSlider pinAttribute:NSLayoutAttributeLeading
//                      toAttribute:NSLayoutAttributeTrailing
//                           ofItem:self.elapsedTimeLabel
//                     withConstant:10.0];
//    
//    [self.timeSlider pinAttribute:NSLayoutAttributeTrailing
//                      toAttribute:NSLayoutAttributeLeading
//                           ofItem:self.totalTimeLabel
//                     withConstant:-10.0];
//    
//    [self.timeSlider centerInContainerOnAxis:NSLayoutAttributeCenterY];
//    [self.timeSlider centerInContainerOnAxis:NSLayoutAttributeCenterX];
//}
//
//- (void)loadTotalTimeLabel
//{
//    self.totalTimeLabel = [[UILabel alloc] init];
//    self.totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.totalTimeLabel.text = @"0:00.00";
//    self.totalTimeLabel.textColor = [UIColor orangeColor];
//    [self.totalTimeLabel sizeToFit];
//    
//    [self.playBarView addSubview:self.totalTimeLabel];
//    [self.totalTimeLabel pinToSuperviewEdges:JRTViewPinRightEdge inset:10];
////    [self.totalTimeLabel pinAttribute:NSLayoutAttributeTrailing
////                          toAttribute:NSLayoutAttributeLeading
////                               ofItem:self.playPauseButton
////                         withConstant:10.0];
//    
//    [self.totalTimeLabel centerInContainerOnAxis:NSLayoutAttributeCenterY];
//}

//- (void)playPausePressed:(id)sender
//{
//    LogDefault(@"Prev pressed");
//    
//    if (self.isPlaying) {
//        [self.playerController pause];
////        [self.bcovPlayPauseVC.playBarButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
//        self.isPlaying = NO;
//    }
//    else {
//        [self.playerController play];
////        [self.bcovPlayPauseVC.playBarButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
//        self.isPlaying = YES;
//    }
//}

//- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
//    return UIBarPositionTopAttached;
//}
//
//- (void)updateViewConstraints
//{
//    [super updateViewConstraints];
//    
////    NSDictionary *viewsDictionary = @{ @"navBar":self.navBar, @"player":self.playerController.view };
////    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[navBar][player]|"
////                                                                      options: 0
////                                                                      metrics: nil
////                                                                        views: viewsDictionary]];
//    
//    // Obtain the view rect of the status bar frame in either portrait or landscape
//    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//    CGRect statusBarWindowRect = [self.view.window convertRect:statusBarFrame fromWindow: nil];
//    CGRect statusBarViewRect = [self.view convertRect:statusBarWindowRect fromView: nil];
//    
//    // Add Status Bar and Navigation Bar heights together
//    CGFloat height = self.navBar.frame.size.height + statusBarViewRect.size.height;
//    
//    double widthRatio = self.playerController.view.frame.size.width / self.view.frame.size.width;
//    double newHeight = self.playerController.view.frame.size.height * widthRatio;
//    double heightRatio = newHeight / self.view.frame.size.height;
//    
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.playerController.view
//                              attribute:NSLayoutAttributeWidth
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeWidth
//                              multiplier:1.0
//                              constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.playerController.view
//                              attribute:NSLayoutAttributeHeight
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeHeight
//                              multiplier:heightRatio
//                              constant:0]];
//
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.playerController.view
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1.0
//                              constant:height]];
//    
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.navBar
//                              attribute:NSLayoutAttributeWidth
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeWidth
//                              multiplier:1.0
//                              constant:0]];
//    
////    [self.view addConstraint:[NSLayoutConstraint
////                              constraintWithItem:self.playerController.view
////                              attribute:NSLayoutAttributeTop
////                              relatedBy:NSLayoutRelationEqual
////                              toItem:self.navBar
////                              attribute:NSLayoutAttributeBottom
////                              multiplier:1.0
////                              constant:0]];
//    
////    [self.view addConstraint:[NSLayoutConstraint
////                              constraintWithItem:self.playerController.view
////                              attribute:NSLayoutAttributeCenterX
////                              relatedBy:NSLayoutRelationEqual
////                              toItem:self.view
////                              attribute:NSLayoutAttributeCenterX
////                              multiplier:1.0
////                              constant:0.0]];
//    
////    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerController.view
////                                                          attribute:NSLayoutAttributeCenterY
////                                                          relatedBy:NSLayoutRelationEqual
////                                                             toItem:self.view
////                                                          attribute:NSLayoutAttributeCenterY
////                                                         multiplier:1.0
////                                                           constant:0]];
//    
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
////    CAGradientLayer *bgLayer = [self blueGradient];
////    bgLayer.frame = self.view.bounds;
////    [self.view.layer insertSublayer:bgLayer atIndex:0];
//}

- (void)viewDidAppear:(BOOL)animated
{
    LogDefault(@"%@", self.playerController.view);
    
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        LogDefault(@"%@", recognizer);
    }
    
    [self loadPlayer];
    
    //    NSString *token = kMETAPIToken;                         // (Brightcove Media API token with URL access)
    //    NSString *playlistID = kMETFeaturedVideosPlaylistID;    // (ID of the playlist you wish to use)
    //
    //    BCOVCatalogService *catalog = [[BCOVCatalogService alloc] initWithToken:token];
    //    [catalog findPlaylistWithPlaylistID:playlistID
    //                             parameters:nil
    //                             completion:^(BCOVPlaylist *playlist,
    //                                          NSDictionary *jsonResponse,
    //                                          NSError      *error) {
    //
    //                                 [self.playerController setVideos:playlist];
    //
    //                             }];
    
    //NSURL* url = [NSURL URLWithString:@"http://www.nasa.gov/multimedia/nasatv/NTV-Public-IPS.m3u8"];
    NSURL* url = [NSURL URLWithString:@"http://multiformatlive-f.akamaihd.net/i/demostream_1@2131/master.m3u8"];
    BCOVVideo* newVideo = [[BCOVVideo alloc] initWithSource:[[BCOVSource alloc] initWithURL:url
                                                                             deliveryMethod:@"HLS"
                                                                                 properties:nil]
                                                  cuePoints:nil
                                                 properties:nil];
    
    [self.playerController setVideos:@[newVideo]];
    [self.playerController play];
}

#pragma mark - BCOVPlaybackControllerDelegate

- (void)playbackConsumer:(id<BCOVPlaybackSessionConsumer>)consumer didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    LogDefault(@"playbackConsumer:playbackSession:didAdvanceToPlaybackSession:%@", session);
//    self.isPlaying = NO;
//    [self.bcovPlayPauseVC setElapsedTime:[self formatTime:0]];
//    [self.bcovPlayPauseVC setSliderValue:0.f];
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didChangeDuration:(NSTimeInterval)duration
{
    LogDefault(@"playbackController:playbackSession:didChangeDuration:%f", duration);
//    [self.bcovPlayPauseVC setDuration:[self formatTime:0]];
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress
{
//    LogDefault(@"playbackController:playbackSession:didProgressTo:%f", progress);
//    NSLog(@"playbackController:playbackSession:didProgressTo");
//    NSTimeInterval duration = CMTimeGetSeconds(session.player.currentItem.duration);
//    float percent = progress / duration;
//    [self.bcovPlayPauseVC setSliderValue: isnan(percent) ? 0.0f : percent];
}

- (void)playbackConsumer:(id<BCOVPlaybackSessionConsumer>)consumer playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress{
//    LogDefault(@"playbackConsumer:playbackSession:didProgressTo");
}

- (void)playbackConsumer:(id<BCOVPlaybackSessionConsumer>)consumer playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent{
    LogDefault(@"playbackConsumer:playbackSession:didReceiveLifecycleEvent:%@", lifecycleEvent.eventType);
    
//    if(lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPlay){
//        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
//            if(self.shouldPlayFullscreen){
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:kBCCEventFullScreen object:nil];
//                self.shouldPlayFullscreen = NO;
//                
//            }
//        }else{
//            [self iPhonePlayEvent];
//        }
//    }
//    if(lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventPause){
//        [self iPhonePauseEvent];
//    }
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

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc {
    
}

- (void)releaseResources
{
    self.playerController = nil;
}

@end
