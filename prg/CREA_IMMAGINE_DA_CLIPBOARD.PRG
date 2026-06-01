
LPARAMETERS tcArchivo
#DEFINE CF_BITMAP 2
#DEFINE OBJ_BITMAP 7
DO decl
LOCAL hClipBmp, lcTargetFile
lcTargetFile = tcArchivo
= OpenClipboard (0)
hClipBmp = GetClipboardData (CF_BITMAP)
= CloseClipboard()
IF hClipBmp = 0 Or GetObjectType(hClipBmp) <> OBJ_BITMAP
  = MessageBox("No se encontro imagen bitmap en el Portapapeles.",;
    64, "Clipboard to BMP")
  RETURN .F.
ENDIF

= bitmap2file (hClipBmp, lcTargetFile)
= DeleteObject (hClipBmp)
***
* crear las referencias para los arreglos
* external array laAspecto, lavalor, laporci,;
* lavalor1, lavalor2, lavalor3, lavalor4
* Código original
*!* CREATE CURSOR GRAFICO (GRAFICA G)
*!* APPEND BLANK
*!* APPEND GENERAL GRAFICO.GRAFICA FROM "c:\clipboard.bmp"
*!* REPORT FORM GRAFICA preview
*!* USE IN grafico
*!* RETURN

WAIT CLEAR

RETURN
***********************************************
* InitBitsArray()
***********************************************
PROCEDURE InitBitsArray()
  #DEFINE GMEM_FIXED 0
  LOCAL lnPtr
  pnBitsSize = pnHeight * pnBytesPerScan
  lnPtr = GlobalAlloc (GMEM_FIXED, pnBitsSize)
  = ZeroMemory (lnPtr, pnBitsSize)
  RETURN lnPtr
ENDPROC

***********************************************
* String2file
***********************************************
PROCEDURE String2File (hFile, lcBuffer)
  DECLARE INTEGER WriteFile IN kernel32;
    INTEGER hFile, STRING @lpBuffer, INTEGER nBt2Write,;
    INTEGER @lpBtWritten, INTEGER lpOverlapped
  = WriteFile (hFile, @lcBuffer, Len(lcBuffer), 0, 0)
  RETURN
ENDPROC

***********************************************
* Bitmap2file
***********************************************
PROCEDURE Bitmap2file (hBitmap, lcTargetFile)
  #DEFINE DIB_RGB_COLORS 0
  PRIVATE pnWidth, pnHeight, pnBitsSize, pnRgbQuadSize, pnBytesPerScan
  STORE 0 TO pnWidth, pnHeight, pnBytesPerScan, pnBitsSize, pnRgbQuadSize
  = GetBitmapDimensions(hBitmap, @pnWidth, @pnHeight)
  LOCAL lpBitsArray, lcBInfo
  lcBInfo = InitBitmapInfo()
  lpBitsArray = InitBitsArray()
  LOCAL hwnd, hdc, hMemDC
  hwnd = GetActiveWindow()
  hdc = GetWindowDC(hwnd)
  hMemDC = CreateCompatibleDC (hdc)
  = ReleaseDC (hwnd, hdc)
  = GetDIBits (hMemDC, hBitmap, 0, pnHeight, lpBitsArray,;
    @lcBInfo, DIB_RGB_COLORS)
  #DEFINE BFHDR_SIZE 14 && BITMAPFILEHEADER
  #DEFINE BHDR_SIZE 40 && BITMAPINFOHEADER
  LOCAL hFile, lnFileSize, lnOffBits, lcBFileHdr
  lnFileSize = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize + pnBitsSize
  lnOffBits = BFHDR_SIZE + BHDR_SIZE + pnRgbQuadSize
  lcBFileHdr = "BM" + num2dword(lnFileSize) +;
    num2dword(0) + num2dword(lnOffBits)
  #DEFINE GENERIC_WRITE 1073741824 && 0x40000000
  #DEFINE FILE_SHARE_WRITE 2
  #DEFINE CREATE_ALWAYS 2
  #DEFINE FILE_ATTRIBUTE_NORMAL 128
  #DEFINE INVALID_HANDLE_VALUE -1
  hFile = CreateFile (lcTargetFile,;
    GENERIC_WRITE,;
    FILE_SHARE_WRITE, 0,;
    CREATE_ALWAYS,;
    FILE_ATTRIBUTE_NORMAL, 0)
  IF hFile <> INVALID_HANDLE_VALUE
    WAIT WINDOW "Elaborazione in corso..." NOWAIT
    = String2File (hFile, @lcBFileHdr)
    = String2File (hFile, @lcBInfo)
    = Ptr2File (hFile, lpBitsArray, pnBitsSize)
    = CloseHandle (hFile)
  ELSE
    = MessageBox("Unable to create file: " + lcTargetFile)
  ENDIF
  = GlobalFree(lpBitsArray)
  = DeleteDC (hMemDC)
  RETURN
ENDPROC

***********************************************
* Ptr2File
***********************************************
PROCEDURE Ptr2File (hFile, lnPointer, lnBt2Write)
  DECLARE INTEGER WriteFile IN kernel32;
    INTEGER hFile, INTEGER lpBuffer, INTEGER nBt2Write,;
    INTEGER @lpBtWritten, INTEGER lpOverlapped
  = WriteFile (hFile, lnPointer, lnBt2Write, 0, 0)
  RETURN
ENDPROC

***********************************************
* InitBitmapInfo
***********************************************
PROCEDURE InitBitmapInfo(lcBIHdr)
  #DEFINE BI_RGB 0
  #DEFINE RGBQUAD_SIZE 4
  #DEFINE BHDR_SIZE2 40
  LOCAL lnBitsPerPixel, lcBIHdr, lcRgbQuad
  lnBitsPerPixel = 24
  pnBytesPerScan = Int((pnWidth * lnBitsPerPixel)/8)
  IF Mod(pnBytesPerScan, 4) <> 0
    pnBytesPerScan = pnBytesPerScan + 4 - Mod(pnBytesPerScan, 4)
  ENDIF
  lcBIHdr = num2dword(BHDR_SIZE2) + num2dword(pnWidth) +;
  num2dword(pnHeight) + num2word(1) + num2word(lnBitsPerPixel) +;
  num2dword(BI_RGB) + Repli(Chr(0), 20)
  IF lnBitsPerPixel <= 8
    pnRgbQuadSize = (2^lnBitsPerPixel) * RGBQUAD_SIZE
    lcRgbQuad = Repli(Chr(0), pnRgbQuadSize)
  ELSE
    lcRgbQuad = ""
  ENDIF
  RETURN lcBIHdr + lcRgbQuad
ENDPROC

***********************************************
* num2dword
***********************************************
FUNCTION num2dword (lnValue)
  #DEFINE m0 256
  #DEFINE m1 65536
  #DEFINE m2 16777216
  LOCAL b0, b1, b2, b3
  b3 = Int(lnValue/m2)
  b2 = Int((lnValue - b3*m2)/m1)
  b1 = Int((lnValue - b3*m2 - b2*m1)/m0)
  b0 = Mod(lnValue, m0)
  RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)
ENDFUNC

***********************************************
* GetBitmapDimensions
***********************************************
PROCEDURE GetBitmapDimensions(hBitmap, lnWidth, lnHeight)
  #DEFINE BITMAP_STRU_SIZE 24
  LOCAL lcBuffer
  lcBuffer = Repli(Chr(0), BITMAP_STRU_SIZE)
  IF GetObjectA (hBitmap, BITMAP_STRU_SIZE, @lcBuffer) <> 0
    lnWidth = buf2dword (SUBSTR(lcBuffer, 5,4))
    lnHeight = buf2dword (SUBSTR(lcBuffer, 9,4))
  ENDIF
  RETURN
ENDPROC

***********************************************
* buf2dword
***********************************************
FUNCTION buf2dword (lcBuffer)
  RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
    Asc(SUBSTR(lcBuffer, 2,1)) * 256 +;
    Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +;
    Asc(SUBSTR(lcBuffer, 4,1)) * 16777216
ENDFUNC

***********************************************
* num2word
***********************************************
FUNCTION num2word (lnValue)
  RETURN Chr(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256))
ENDFUNC

***********************************************
* decl
***********************************************
PROCEDURE decl
  DECLARE INTEGER GetActiveWindow IN user32
  DECLARE INTEGER GetClipboardData IN user32 INTEGER uFormat
  DECLARE INTEGER OpenClipboard IN user32 INTEGER hwnd
  DECLARE INTEGER CloseClipboard IN user32
  DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject
  DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd
  DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc
  DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc
  DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc
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
ENDPROC

***********************************************