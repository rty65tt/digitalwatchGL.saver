//
//  DigitalWatchGLView.h
//  DigitalWatchGL
//
//  Created by u1 on 24.10.2023.
//

#import <Foundation/Foundation.h>

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
    int   cx;
    
    float grey;
    
    float space;
    float step;
    int   cy;
    
    int     glitchfx;
    int     gfx_vol;
    float   fps_vol;
    
    IBOutlet id configureSheet;

    IBOutlet id IBDefaults;
    IBOutlet id IBCancel;
    IBOutlet id IBSave;

    IBOutlet id IBgfxvol;
    IBOutlet id IBfpsvol;
    
}

- (void)setUpOpenGL;
- (void)setFrameSize:(NSSize)newSize;


- (IBAction) configureSheet_save:(id) sender;
- (IBAction) configureSheet_cancel:(id) sender;
- (IBAction) configureSheet_defaults:(id) sender;

@end
