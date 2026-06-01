FancyToolTip Control - Pseudo documentation
===========================================

Now is really fancy!!

This control displays tooltips on more than one line. It also knows to put the tooltip text in "think" bubbles or "speak" pointed rectangle like in the comics.

Just drop it on a form and see what happens. You don't have to change anything in your forms. Everything is handled by the FancyToolTip Control. Of course, you need to have some tooltips in your form. :)

It supports 3 styles: Think, Speak, Normal.
Think - "Think" bubbles that points to the owner object;
Speak - "Speak" rectangle that points to the owner object;
Normal - Just multiline normal tooltip.

It is made of one container with: one timer that handles almost anything, one shape for the text's background, two shapes for "think" bubbles and one label for the text.

By default, this control displays the tooltip using the same color and font as the standard tooltips, in the "Think" style. If there's not enough space to display the "Think" fancy style, it switches automatically to "speak" style. If it still doesn't have enough space, it switches to "normal" style.

To turn on/off the FancyToolTip control, set the lShowTips to .t. or .f. This property has the same meaning and functionality as the form's ShowTips property. Thanks to Thomas Borgmann for the idea to have this property.

Use the cToolTipTextSourceProperty property of the control to specify a different source for the tooltip texts. For example, set it to "StatusBarText" if you want to use the StatusBarText value as tooltip text. You can also use your own property, etc. If the specified property does not exist for a control or it is empty, the default ToolTipText value is used. This allows you to have tooltips as long as you want! No more limitations to 52, 127, 256, etc!
Thanks to Petras Virzintas for this idea.

Warning (old warning): I changed the name of the shpRectangle to shpBackground. Sorry for this. I'm almost sure it's the last change of this type, so, you can use your own FancyToolTip subclass without changes in the future.

Here are some useful places to modify its look:
Border color: The BorderColor of the shpBackground shape.
Back color: The BackColor of the shpBackground shape.
Fore color: The ForeColor of the lblToolTip label.
The font, font size, etc: The font properties of the lblToolTip label.
The maximum width: nMaximumWidth of the container. Default: 200.
The distance between text and border: nDistanceFromBorder of the container. Default: 5.
The fancy type/style: cType of the container: Think, Speak or Normal. Default: Think.
Add or remove the shadow: lHasShadow of the container. Default: True.
The shadow "width": nShadowWidth of the container. Default: 5.

Warning: If you want to modify this control, please subclass it and use your class instead of this one. This will enable you to use any further version of this control without changes to your code.

Enjoy it!

Many thanks to Benn Kjaer for the idea of writing such a control.

Please send me any suggestions, bug reports, etc by email.

Copyright and warranty
----------------------
This control is delivered as is and with no warranty.
This control is public domain. So, you may copy and distribute it as you want, as long as you distribute the original zip file. You may not distribute only the class files, without this ReadMe file. Thank you!

Paul-Vlad Tatavu
vladt@poboxes.com