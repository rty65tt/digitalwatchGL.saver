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
    
    float   zoom;
    int     glitchfx;
    float     fps_var;
    
    IBOutlet id configureSheet;

    IBOutlet id IBDefaults;
    IBOutlet id IBCancel;
    IBOutlet id IBSave;

    
    IBOutlet id IBzoom;
    IBOutlet id IBglitchfx;
    IBOutlet id IBfpsvar;
    
}

- (void)setUpOpenGL;
- (void)setFrameSize:(NSSize)newSize;

- (IBAction) timeColorChanged:(id) NSColorWell;

- (IBAction) closeSheet_save:(id) sender;
- (IBAction) closeSheet_cancel:(id) sender;
- (IBAction) resetConfigureSheet:(id) sender;

@end
