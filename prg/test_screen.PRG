*!*	The following example demonstrates the use of _SCREEN to customize the main Visual FoxPro window.

* Local variables to store current settings
Local oldScreenLeft
Local oldScreenTop
Local oldScreenHeight
Local oldScreenWidth
Local oldScreenColor
WITH _Screen
 oldScreenLeft=.Left       		&& Save current position and size
 oldScreenTop=.Top
 oldScreenHeight=.Height
 oldScreenWidth=.Width
 oldScreenColor = .Backcolor
 .LockScreen=.T.       			&& Disable screen redraw
 .BackColor=rgb(192,192,192)   	&& Change the background to grey
 .BorderStyle=2        			&& Change the border to double
 .Closable=.T.         			&& Remove window control buttons
 .ControlBox=.F.
 .MaxButton=.F.
 .MinButton=.T.
 .Movable=.T.
 .Height=710					&&285
 .Width=450						&&550
 .Caption="Custom Screen"    	&& Set a caption
 .LockScreen=.F.       			&& Enable screen redraw
ENDWITH
=MESSAGEBOX("Icomandi successivi riportano le impostazioni iniziali",48,WTITLE())
With _Screen
 .Left = oldScreenLeft     		&& Reset original 
 .Top = oldScreenTop       		&& position and size
 .Height = oldScreenHeight
 .Width  = oldScreenWidth
 .BackColor=oldScreenColor     	&& Change background to white
 .LockScreen=.T.       			&& Disable screen redraw
 .BorderStyle=3        			&& Change border to sizeable
 .Closable=.T.         			&& Reset window control buttons
 .ControlBox=.T.
 .MaxButton=.T.
 .MinButton=.T.
 .Movable=.T.
 .Caption="Microsoft Visual FoxPro"  && Reset the caption
 .LockScreen=.F.       			&& Enable screen redraw
Endwith
