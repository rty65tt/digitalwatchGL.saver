//
//  DigitalWatchGLView.m
//  DigitalWatchGL
//
//  Created by u1 on 24.10.2023.
//

//#include <stdlib.h>
#import "DigitalWatchGLView.h"

@implementation DigitalWatchGLView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        
        space = 2.0f / CIRCLES_NUM;
        step = space * 0.4f;
        cy = 1.0f / space;
        
        grey = 0.05;
        
        scale = SCALE;
        scale_vec = 0.01f;
        vec_range = 0.1f;

        NSOpenGLPixelFormatAttribute attributes[] = {
            NSOpenGLPFAAccelerated,
            NSOpenGLPFABackingStore,
            NSOpenGLPFADoubleBuffer,
            0 };
        
        NSOpenGLPixelFormat *format =
            [[NSOpenGLPixelFormat alloc] initWithAttributes: attributes];
                
        glView = [[NSOpenGLView alloc] initWithFrame: NSZeroRect
                                         pixelFormat: format];
        

        [self addSubview:glView];
        [self setUpOpenGL];
        
        [self setAnimationTimeInterval:1/FPS];
    }
    return self;
}

- (void)setUpOpenGL
{
    [[glView openGLContext] makeCurrentContext];
    
    glClearColor( 0.f, 0.f, 0.f, 1.0f );

    glDepthFunc( GL_LEQUAL );
    glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );

}

- (void)setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    [glView setFrameSize:newSize];
    
    width = (GLsizei)newSize.width;
    height = (GLsizei)newSize.height;
    
}

- (void)drawingSquareFill:(float)ix iy:(float)iy {
    glPushMatrix();
    
    glTranslatef((float)ix, (float)iy, 0);
    glScalef(step, step, 1);
    
    float x=1;
    glBegin(GL_TRIANGLE_FAN);
    glVertex2f(-x, x);
    glVertex2f(x, x);
    glVertex2f(x, -x);
    glVertex2f(-x, -x);
    glEnd();
    
    glPopMatrix();
}

- (bool)rnd_grey_color:(int)m  {
    if(m != 8)
    {
        int r = rand()%10000;//RAND_MAX;
        if(r < 50)
        {
            grey = 25 + r;
            glColor3ub(grey, grey, grey);
            return FALSE;
        }
    }
    return TRUE;
}

- (void)draw_symbol:( int)m x:(int)x y:(int)y cel:(int)cel  row:(int)row p_matrix:(char *)p_matrix {
    int bm_x = 0;
    int bm_y = 0;
    int counter;
    char *p_2char = &p_matrix[cel * row * m];
    char *p_bm = p_2char;

    glColor3ubv(colors);
    BOOL a = [self rnd_grey_color:m];

    while (1)
    {
        counter = 0;
        do
        {
            if (p_bm[counter] != 48)
            {
                if(rand()%1000<2)
                {
                    break;
                }
                float ix = (x + bm_x) * space;
                float iy = (y + bm_y) * -space;
                [self rnd_grey_color:m];
                [self drawingSquareFill:ix iy:iy];
                if(a)
                {
                    glColor3ubv(colors);
                }
            }
            bm_x += 1;
            ++counter;
        }
        while (counter < cel);
        if (!--row)
            break;
        bm_y += 1;
        p_bm += cel;
        bm_x = 0;
        counter = 0;
    }
    glColor3ubv(colors);
}


- (void)startAnimation
{
    [super startAnimation];
    [[glView openGLContext] makeCurrentContext];
    
    
    glLoadIdentity();
    glOrtho(-XYSCALE*scale, XYSCALE*scale, -XYSCALE*scale, XYSCALE*scale, -1, 1);
    
    koef = width > height ? (float)width / height: (float)height / width;
    glScalef( 1 / koef, 1, 1);
    
    cx = cy * koef;
    
    glClearColor( 0.f, 0.f, 0.f, 1.0f );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    
    for (int iy=-cy; iy <= cy; iy++)
    {
        for (int ix=-cx; ix <= cx; ix++)
        {
            GLubyte grey = rand()%25;
            glColor3ub(grey, grey, grey);
            
            [self drawingSquareFill:(ix * space) iy:(iy * space)];
        }
    }
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    [[glView openGLContext] makeCurrentContext];
    
    // Draw background
    float ix, iy;
    for (int i=0; i< CELLC; i++)
    {
        GLubyte rc = rand()%25;
        glColor3ub(rc, rc, rc);

        int lcx = -cx;
        ix = (int)(((float)arc4random()/0x100000000)*(cx-lcx)+lcx);
        int lcy = -cy;
        iy = (int)(((float)arc4random()/0x100000000)*(cy-lcy)+lcy);
        
        [self drawingSquareFill:(ix * space) iy:(iy * space)];

    }
    
    // Draw foreground
    // background font
    colors = def_bg_colors;
    [self draw_symbol:8 x:-19 y:-8 cel:5 row:9 p_matrix:digit_matrix]; //hh
    [self draw_symbol:8 x:-13 y:-8 cel:5 row:9 p_matrix:digit_matrix]; //hh
    [self draw_symbol:8 x:-5  y:-8 cel:5 row:9 p_matrix:digit_matrix]; //mm
    [self draw_symbol:8 x:1   y:-8 cel:5 row:9 p_matrix:digit_matrix]; //mm
    [self draw_symbol:8 x:9   y:-8 cel:5 row:9 p_matrix:digit_matrix]; //ss
    [self draw_symbol:8 x:15  y:-8 cel:5 row:9 p_matrix:digit_matrix]; //ss
    [self draw_symbol:2 x:-7  y:-8 cel:1 row:9 p_matrix:dots_matrix]; //::
    [self draw_symbol:2 x:7   y:-8 cel:1 row:9 p_matrix:dots_matrix]; //::

    // foreground font
    colors = def_hh_colors;

    CurTime st;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    st.hour =   (int)[calendar component:NSCalendarUnitHour      fromDate:now];
    st.minute = (int)[calendar component:NSCalendarUnitMinute    fromDate:now];
    st.second = (int)[calendar component:NSCalendarUnitSecond    fromDate:now];
    st.wday =   (int)[calendar component:NSCalendarUnitWeekday   fromDate:now];
    st.mday =   (int)[calendar component:NSCalendarUnitDay       fromDate:now];

    st.wday = (st.wday == 1) ? 7 : st.wday-1;
    
    [self draw_symbol:st.hour / 10     x:-19   y:-8 cel:5  row:9 p_matrix:digit_matrix];
    [self draw_symbol:st.hour % 10     x:-13   y:-8 cel:5  row:9 p_matrix:digit_matrix];
    [self draw_symbol:st.minute / 10   x:-5    y:-8 cel:5  row:9 p_matrix:digit_matrix];
    [self draw_symbol:st.minute % 10   x:1     y:-8 cel:5  row:9 p_matrix:digit_matrix];
    
    int cd = 0;
    int wwx = 5;
    int wlx = -17;
    int wdx = wlx - 2;
    // Draw Week Line
    for(int i=0; i < 7; i++) {
        colors = def_wd_colors;
        if (i > 4 ) {colors = def_ew_colors;}
#ifdef PREVIEW
        NSLog(@"Week Day %i", st.wday);
#endif /* PREVIEW */
        [self draw_symbol:0         x:wlx+(i*wwx)   y:2 cel:wwx  row:1 p_matrix:"01110"];
        if (st.wday == i+1 ) { // Select Curent Day
            cd = i;
            [self draw_symbol:0     x:wlx+(i*wwx)   y:3 cel:wwx  row:1 p_matrix:"01110"];
        }
    }

    // Draw Month Day
    colors = def_cd_colors;
    [self draw_symbol:st.mday / 10  x:wdx+(cd*wwx)    y:5 cel:4  row:7 p_matrix:m_deys_matrix];
    [self draw_symbol:st.mday % 10  x:wdx+(cd*wwx)+5  y:5 cel:4  row:7 p_matrix:m_deys_matrix];
    
    // Draw Seconds
    if (st.second % 2 == 1)
    {
        colors = def_hh_colors;
    }

    [self draw_symbol:st.second / 10   x:9     y:-8 cel:5  row:9 p_matrix:digit_matrix];
    [self draw_symbol:st.second % 10   x:15    y:-8 cel:5  row:9 p_matrix:digit_matrix];
    
    // Blink Dots
    int dc = st.second % 2;
    [self draw_symbol:dc x:-7  y:-8 cel:1 row:9 p_matrix:dots_matrix]; //::
    [self draw_symbol:dc x:7   y:-8 cel:1 row:9 p_matrix:dots_matrix]; //::
    
    
    [[glView openGLContext] flushBuffer];
    [self setNeedsDisplay:YES];
    
#ifdef PREVIEW
    if (st.second % 6 == 0 ) {
#else
    if (st.second == 59 ) {
#endif /* PREVIEW */

        if (scale_vec >= 5.0f)  {vec_range = -0.1f;}
        if (scale_vec <= -5.0f) {vec_range = 0.1f;}
        scale_vec = scale_vec + vec_range;
        scale = 0.80 + (0.2 * sin(scale_vec));
        [self startAnimation];
        [NSThread sleepForTimeInterval:0.025];
        
    }

    return;
}

//- (void)dealloc
//{
//    [glView removeFromSuperview];
//    [glView release];
//    [super dealloc];
//}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
