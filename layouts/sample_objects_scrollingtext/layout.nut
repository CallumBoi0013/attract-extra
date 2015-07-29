fe.load_module("objects/scrollingtext");

ScrollingText.debug = false;
local text1 = fe.add_text("HORIZONTAL_LEFT", 25, 25, 300, 25 );
local scroller1 = ScrollingText.add( "[Title]", 25, 50, fe.layout.width - 25, 75, ScrollType.HORIZONTAL_LEFT );
    //wrapper bg and rgb functions can be used to set bg and rgb colors
    scroller1.set_bg_rgb(0, 220, 0, 150);
    scroller1.set_rgb( 200, 200, 200 );
    //you can access the surface object directly
    //scroller1.surface;
    //you can access the text object directly
    scroller1.text.charsize = 18;
    //scroller1.set_pos( 300, 50, 600, 20 );

local text2 = fe.add_text("HORIZONTAL_RIGHT", 25, 150, 300, 25 );
ScrollingText.add( "[DisplayName] / [FilterName]", 25, 175, fe.layout.width - 25, 75, ScrollType.HORIZONTAL_RIGHT );

local text3 = fe.add_text("HORIZONTAL_BOUNCE", 25, 250, 300, 25 );
ScrollingText.add( "[Year] / [Category]", 25, 275, fe.layout.width - 25, 75, ScrollType.HORIZONTAL_BOUNCE );

local text4 = fe.add_text("VERTICAL_UP", 25, 350, 300, 25 );
ScrollingText.add( "[PlayedTime] / Played [PlayedCount] times", 25, 375, fe.layout.width - 25, 75, ScrollType.VERTICAL_UP );

local text5 = fe.add_text("VERTICAL_DOWN", 25, 450, 300, 25 );
ScrollingText.add( "[CloneOf] / [Manufacturer]", 25, 475, fe.layout.width - 25, 75, ScrollType.VERTICAL_DOWN );

local text6 = fe.add_text("VERTICAL_BOUNCE", 25, 550, 300, 25 );
ScrollingText.add( "[Status] / [Players]", 25, 575, fe.layout.width - 25, 75, ScrollType.VERTICAL_BOUNCE );

text1.align = text2.align = text3.align = text4.align = text5.align = text6.align = Align.Left;