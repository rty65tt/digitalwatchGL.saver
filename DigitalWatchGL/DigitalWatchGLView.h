//
//  DigitalWatchGLView.h
//  DigitalWatchGL
//
//  Created by u1 on 24.10.2023.
//

#import <AppKit/AppKit.h>

#import <ScreenSaver/ScreenSaver.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <Cocoa/Cocoa.h>

#import "defvar.h"


@interface DigitalWatchGLView : ScreenSaverView
{
    NSOpenGLView *glView;
    
    int width;
    int height;
    
    float scale;
    float scale_vec;
    float vec_range;
    
    float koef;
    int cx;
    
    float grey;
    
    float space;
    float step;
    int cy;
    
    
}

- (void)setUpOpenGL;

@end
