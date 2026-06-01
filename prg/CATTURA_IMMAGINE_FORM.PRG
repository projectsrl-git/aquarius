
PARAMETERS _par_opzcopy,_par_Left,_par_Top,_par_Width,_par_Height,_par_nomefile

IF PCOUNT() < 1
	_par_opzcopy = "CLIPBOARD"
ENDIF
IF PCOUNT() < 2
	_par_Left = 0
ENDIF
IF PCOUNT() < 3
	_par_Top = 0
ENDIF
IF PCOUNT() < 4
	_par_Width = 0
ENDIF
IF PCOUNT() < 5
	_par_Height = 0
ENDIF
IF PCOUNT() < 6
	_par_nomefile = SYS(5) + SYS(2003) + "\clipboard" + SYS(2015) + ".bmp"
ENDIF

DO DeclareFunctions

DO CASE

   CASE _par_opzcopy == "CLIPBOARD" 
      DO CopyToClipBoard
      
   CASE _par_opzcopy == "FILE" 
      DO CopyToFile
      
ENDCASE

RETURN


FUNCTION num2dword 

  LPARAMETERS lnValue 

  #DEFINE m0       256 
  #DEFINE m1     65536 
  #DEFINE m2  16777216 

  LOCAL b0, b1, b2, b3 

  b3 = INT(lnValue/m2) 
  b2 = INT((lnValue - b3*m2)/m1) 
  b1 = INT((lnValue - b3*m2 - b2*m1)/m0) 
  b0 = MOD(lnValue, m0) 

  RETURN(CHR(b0)+CHR(b1)+CHR(b2)+CHR(b3)) 
  
ENDFUNC


PROCEDURE declarefunctions 

  DECLARE INTEGER CombineRgn in "gdi32" integer hDestRgn, integer hRgn1, integer hRgn2, integer nMode 
  DECLARE INTEGER CreateRectRgn in "gdi32" integer X1, integer Y1, integer X2, integer Y2 
  DECLARE INTEGER SetWindowRgn in "user32" integer hwnd, integer hRgn, integer nRedraw 

  DECLARE INTEGER SelectObject IN gdi32 integer hdc, integer hObject 
  DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc  
  DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc 
  DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject 
  DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc 
  DECLARE INTEGER CloseClipboard IN user32  
  DECLARE INTEGER GetFocus IN user32  
  DECLARE INTEGER EmptyClipboard IN user32  
  DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd  
  DECLARE INTEGER OpenClipboard IN user32 INTEGER hwnd  
  DECLARE INTEGER SetClipboardData IN user32 INTEGER wFormat, INTEGER hMem 
  DECLARE INTEGER CreateCompatibleBitmap IN gdi32; 
        INTEGER hdc, INTEGER nWidth, INTEGER nHeight 
  DECLARE INTEGER BitBlt IN gdi32; 
        INTEGER hDestDC, INTEGER x, INTEGER y,; 
        INTEGER nWidth, INTEGER nHeight, INTEGER hSrcDC,; 
        INTEGER xSrc, INTEGER ySrc, INTEGER dwRop 

  DECLARE INTEGER GetActiveWindow IN user32 
  DECLARE INTEGER GetClipboardData IN user32 INTEGER uFormat 
  DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER wFlags, INTEGER dwBytes  
  DECLARE INTEGER GlobalFree IN kernel32 INTEGER hMem 

  DECLARE INTEGER GetObject IN gdi32 AS GetObjectA; 
      INTEGER hgdiobj, INTEGER cbBuffer, STRING @lpvObject 

  DECLARE INTEGER GetObjectType IN gdi32 INTEGER h 

  DECLARE RtlZeroMemory IN kernel32 As ZeroMemory; 
      INTEGER dest, INTEGER numBytes 

  DECLARE INTEGER GetDIBits IN gdi32; 
      INTEGER hdc, INTEGER hbmp, INTEGER uStartScan,; 
      INTEGER cScanLines, INTEGER lpvBits, STRING @lpbi,; 
      INTEGER uUsage 

  DECLARE INTEGER CreateFile IN kernel32; 
      STRING lpFileName, INTEGER dwDesiredAccess,; 
      INTEGER dwShareMode, INTEGER lpSecurityAttr,; 
      INTEGER dwCreationDisp, INTEGER dwFlagsAndAttrs,; 
      INTEGER hTemplateFile 

  DECLARE INTEGER CloseHandle IN kernel32 INTEGER hObject 

  DECLARE Sleep IN kernel32 INTEGER dwMilliseconds 

ENDPROC 

PROCEDURE CopyToClipBoard 

     =Sleep(100) 

     #DEFINE CF_BITMAP   2 
     #DEFINE SRCCOPY      13369376 
      
     lnLeft = SYSMETRIC(3) + IIF(_par_Left > 0, _par_Left, 0)
     lnTop = SYSMETRIC(4)+(SYSMETRIC(20)-SYSMETRIC(11)) + IIF(_par_Top > 0, _par_Top, 0)
     
     lnWidth = IIF(_par_Width > 0, _par_Width, _SCREEN.ActiveForm.Width)
     lnHeight = IIF(_par_Height > 0, _par_Height, _SCREEN.ActiveForm.Height-1)

     hwnd = GetFocus()
     hdc = GetWindowDC(hwnd)
     
     hVdc = CreateCompatibleDC(hdc) 
     hBitmap = CreateCompatibleBitmap(hdc, lnWidth, lnHeight) 

     = SelectObject(hVdc, hBitmap) 
     = BitBlt(hVdc, 0, 0, lnWidth, lnHeight, hdc, lnLeft, lnTop, SRCCOPY)
     = OpenClipboard(hwnd)
     = EmptyClipboard() 
     = SetClipboardData(CF_BITMAP, hBitmap) 
     = CloseClipboard() 
     = DeleteObject(hBitmap) 
     = DeleteDC(hVdc)
     = ReleaseDC(hwnd, hdc)
   
ENDPROC 
    
PROCEDURE CopyToFile 

  #DEFINE CF_BITMAP   2 
  #DEFINE SRCCOPY     13369376 
  #DEFINE OBJ_BITMAP    7 
  #DEFINE DIB_RGB_COLORS   0 
  #DEFINE BFHDR_SIZE      14 
  #DEFINE BHDR_SIZE       40 
  #DEFINE GENERIC_WRITE          1073741824 
  #DEFINE FILE_SHARE_WRITE                2 
  #DEFINE CREATE_ALWAYS                   2 
  #DEFINE FILE_ATTRIBUTE_NORMAL         128 
  #DEFINE INVALID_HANDLE_VALUE           -1 
  #DEFINE BITMAP_STRU_SIZE   24 
  #DEFINE BI_RGB         0 
  #DEFINE RGBQUAD_SIZE   4 
  #DEFINE BHDR_SIZE     40 
  #DEFINE GMEM_FIXED   0 

  LOCAL cDefault, cNameFile, hClipBmp 
  LOCAL pnWidth, pnHeight, pnBitsSize, pnRgbQuadSize, pnBytesPerScan 
  LOCAL hFile, lnFileSize, lnOffBits, lcBFileHdr 
  LOCAL lnBitsPerPixel, lcBIHdr, lcRgbQuad 
  LOCAL lpBitsArray, lcBInfo 
  LOCAL hdc, hMemDC, lcBuffer 

*!*	  cDefault = FULLPATH(SYS(5)) 
*!*	  cNameFile = GETPICT("BMP")
*!*	  SET DEFAULT TO (cDefault)
*!*	  IF EMPTY(cNameFile) 
*!*	     RETURN 
*!*	  ENDIF
  
  cNameFile = _par_nomefile
  IF EMPTY(cNameFile) 
     RETURN 
  ENDIF

  IF FILE(cNameFile) 
     *IF MESSAGEBOX("This forlder already contains a file called '"+PROPER(JUSTFNAME(cNameFile))+"'"+CHR(13)+"Overwrite the existing file ?",36+256,"Confirm overwriting") = 7 
     *   RETURN 
     *ENDIF
     ERASE (cNameFile) 
  ENDIF 
  
  DO CopyToClipBoard
      
  = OpenClipboard (0)  
  hClipBmp = GetClipboardData (CF_BITMAP) 
  = CloseClipboard() 

  IF hClipBmp = 0 Or GetObjectType(hClipBmp) # OBJ_BITMAP 
     =MESSAGEBOX("There is no image stored in the clipboard.",48,"Error creating file") 
     RETURN 
  ENDIF 
           
  STORE 0 TO pnWidth, pnHeight, pnBytesPerScan, pnBitsSize, pnRgbQuadSize 
  lcBuffer = REPLI(CHR(0), BITMAP_STRU_SIZE) 
  IF GetObjectA (hClipBmp, BITMAP_STRU_SIZE, @lcBuffer) # 0 
     pnWidth  = ASC(SUBSTR(lcBuffer, 5,1)) + ; 
                ASC(SUBSTR(lcBuffer, 6,1)) * 256 +; 
                ASC(SUBSTR(lcBuffer, 7,1)) * 65536 +; 
                ASC(SUBSTR(lcBuffer, 8,1)) * 16777216 
         
     pnHeight = ASC(SUBSTR(lcBuffer, 9,1)) + ; 
                ASC(SUBSTR(lcBuffer, 10,1)) * 256 +; 
                ASC(SUBSTR(lcBuffer, 11,1)) * 65536 +; 
                ASC(SUBSTR(lcBuffer, 12,1)) * 16777216 
  ENDIF 

  lnBitsPerPixel = 24 
  pnBytesPerScan = INT((pnWidth * lnBitsPerPixel)/8) 
  IF MOD(pnBytesPerScan, 4) # 0 
     pnBytesPerScan = pnBytesPerScan + 4 - MOD(pnBytesPerScan, 4) 
  ENDIF 

  lcBIHdr = num2dword(BHDR_SIZE) + num2dword(pnWidth) +; 
            num2dword(pnHeight) + (CHR(MOD(1,256))+CHR(INT(1/256))) + (CHR(MOD(lnBitsPerPixel,256))+CHR(INT(lnBitsPerPixel/256))) +; 
            num2dword(BI_RGB) + REPLI(CHR(0), 20) 

  IF lnBitsPerPixel <= 8 
     pnRgbQuadSize = (2^lnBitsPerPixel) * RGBQUAD_SIZE 
     lcRgbQuad = REPLI(CHR(0), pnRgbQuadSize) 
  ELSE 
     lcRgbQuad = "" 
  ENDIF 
  lcBInfo = lcBIHdr + lcRgbQuad 
  pnBitsSize = pnHeight * pnBytesPerScan 
  lpBitsArray = GlobalAlloc (GMEM_FIXED, pnBitsSize) 
  = ZeroMemory (lpBitsArray, pnBitsSize) 

  hwnd = GetActiveWindow() 
  hdc = GetWindowDC(hwnd) 
  hMemDC = CreateCompatibleDC (hdc) 
  = ReleaseDC (hwnd, hdc) 
  = GetDIBits (hMemDC, hClipBmp, 0, pnHeight, lpBitsArray, @lcBInfo, DIB_RGB_COLORS) 

  lnFileSize = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize + pnBitsSize 
  lnOffBits = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize 
  lcBFileHdr = "BM" + num2dword(lnFileSize) + num2dword(0) + num2dword(lnOffBits) 

  hFile = CreateFile (cNameFile, GENERIC_WRITE, FILE_SHARE_WRITE, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0) 

  IF hFile # INVALID_HANDLE_VALUE 
     DECLARE INTEGER WriteFile IN kernel32; 
        INTEGER hFile, STRING @lpBuffer, INTEGER nBt2Write,; 
        INTEGER @lpBtWritten, INTEGER lpOverlapped 
     = WriteFile (hFile, @lcBFileHdr, Len(lcBFileHdr), 0, 0) 
     = WriteFile (hFile, @lcBInfo, Len(lcBInfo), 0, 0) 

     DECLARE INTEGER WriteFile IN kernel32; 
        INTEGER hFile, INTEGER lpBuffer, INTEGER nBt2Write,; 
        INTEGER @lpBtWritten, INTEGER lpOverlapped 
     = WriteFile (hFile, lpBitsArray, pnBitsSize, 0, 0) 
     = CloseHandle (hFile) 
  ELSE 
     = MESSAGEBOX("Error creating file: " + cNameFile, "Operazione fallita") 
  ENDIF 

  = GlobalFree(lpBitsArray) 
  = DeleteDC (hMemDC) 
  = DeleteObject (hClipBmp)

ENDPROC 

