Declare Long FindWindow in Win32API String ClassName, String WindowName

_SCREEN.AddProperty("System", NEWOBJECT("xfcSystem", LOCFILE("system.vcx","vcx"))) 

WITH _SCREEN.System.Drawing

LOCAL loCaptureBmp as xfcBitmap


* To Capture the Windows Desktop

_Screen.Hide
_Screen.WindowState = 1 && Minimized
INKEY(.1)

* Minimize all active Windows
DECLARE LONG keybd_event IN "user32";
   INTEGER bVk,;
   INTEGER bScan,;
   LONG dwFlags,;
   LONG dwExtraInfo
   
KEYEVENTF_KEYUP = 2
VK_LWIN = 91

=keybd_event(VK_LWIN, 0, 0, 0)  
=keybd_event(77, 0, 0, 0)  
=keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0)

* To capture the whole screen no parameter is needed
loCaptureBmp = .Bitmap.FromScreen()
loCaptureBmp.Save("C:\MyDeskTop.Jpg", .Imaging.ImageFormat.Jpeg)
RUN /N explorer.exe C:\MyDeskTop.Jpg
_Screen.Visible = .T. 
_Screen.WindowState = 2 && Maximized
INKEY(.1)



* To Capture only the Systray
wnd = FindWindow("Shell_TrayWnd", NULL)
loCaptureBmp = .Bitmap.FromScreen(wnd)
loCaptureBmp.Save("C:\ShellTrayWnd.Jpg", .Imaging.ImageFormat.Jpeg)
RUN /N explorer.exe C:\ShellTrayWnd.Jpg
INKEY(.1)

* To Capture the VFP Screen
wnd = FindWindow(NULL, "Microsoft Visual FoxPro")
loCaptureBmp = .Bitmap.FromScreen(wnd)
loCaptureBmp.Save("C:\VFP_Screen.Jpg", .Imaging.ImageFormat.Jpeg)
RUN /N explorer.exe C:\VFP_Screen.Jpg


ENDWITH