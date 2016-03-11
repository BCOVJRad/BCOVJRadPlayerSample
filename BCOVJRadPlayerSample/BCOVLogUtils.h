//
//  BCOVLogUtils.h
//  BCOVJRadPlayerSample
//
//  Created by Joseph Radjavitch on 1/14/15.
//  Copyright (c) 2015 Joseph Radjavitch. All rights reserved.
//

#ifndef BCOVJRadPlayerSample_BCOVLogUtils_h
#define BCOVJRadPlayerSample_BCOVLogUtils_h

// JLR - These definitions are used by the XCodeColors plugin, in order to show the log statements
//       dealing with ads in red to make them easier to see by QA
#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogDefault(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,0;" @"%s [Line %d] " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" @"%s [Line %d] " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" @"%s [Line %d] " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" @"%s [Line %d] " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#endif
