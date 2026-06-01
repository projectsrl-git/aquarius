Do lesdeclarations

Private hMemDC, hMemBmp, lnWidth, lnHeight, lnBitsPerPixel,;
    lnBytesPerScan, lcBFileHdr, lcBIHdr, lpBitsArray, lnBitsSize,;
    lcRgbQuad, lnRgbQuadSize, lcBInfo, lnFileSize

Store "" To lcBIHdr, lcBInfo, lcRgbQuad
Store 0 To hMemDC, hMemBmp, lnWidth, lnHeight, lnFileSize,;
    lnBitsPerPixel, lnBytesPerScan, lnRgbQuadSize, lpBitsArray, lnBitsSize

= MakeSnapshot()
= InitBitmapInfo()
= InitBitsArray()

#Define DIB_RGB_COLORS   0
= GetDIBits (hMemDC, hMemBmp, 0, lnHeight, lpBitsArray,;
    @lcBInfo, DIB_RGB_COLORS)

Local lcFilename
lcFilename = "c:\Temp\myfile.bmp"  && Le dossier Temp doit exister

If bmp2file (lcFilename)
    ShellExecute(0,"Print","c:\Temp\myfile.bmp","","",0)
&& An Alternative might be to view the bitmap using:
&& ShellExecute(0,"Open","c:\Temp\myfile.bmp","","",1)
Endif

= GlobalFree (lpBitsArray)
= DeleteObject (hMemBmp)
= DeleteDC (hMemDC)
Return  && principal

Procedure  InitBitmapInfo()
#Define BI_RGB  0
#Define RGBQUAD_SIZE     4  && RGBQUAD
#Define BHDR_SIZE       40  && BITMAPINFOHEADER

* forcer le format 24 bit
lnBitsPerPixel = 24
lnBytesPerScan = lnWidth * 3

* Largeur de la ligne devait être DWORD-aligné (4 bytes) 
*Important pour les palettes de couleur 16 et 24 bits
If Mod(lnBytesPerScan, 4) <> 0
    lnBytesPerScan = lnBytesPerScan + 4 - Mod(lnBytesPerScan, 4)
Endif

* initialiser la structure BitmapInfoHeader 
lcBIHdr = num2dword(BHDR_SIZE) + num2dword(lnWidth) +;
    num2dword(lnHeight) + num2word(1) + num2word(lnBitsPerPixel) +;
    num2dword(BI_RGB) + num2dword(0) + num2dword(0) + num2dword(0) +;
    num2dword(0) + num2dword(0)

* créer un buffer pour la table de couleur
If lnBitsPerPixel <= 8
    lnRgbQuadSize = (2^lnBitsPerPixel) * RGBQUAD_SIZE
    lcRgbQuad = Repli(Chr(0), lnRgbQuadSize)
Else
    lnRgbQuadSize = 0
    lcRgbQuad = ""
Endif

* amener les deux portions ensemble
lcBInfo = lcBIHdr + lcRgbQuad
Return

Procedure  InitBitsArray()
#Define GMEM_FIXED   0
lnBitsSize = lnHeight * lnBytesPerScan
lpBitsArray = GlobalAlloc (GMEM_FIXED, lnBitsSize)
= ZeroMemory (lpBitsArray, lnBitsSize)

Function  bmp2file (lcTargetFile)
* enrigister tous les composants sur disque
#Define GENERIC_WRITE          1073741824  && 0x40000000
#Define FILE_SHARE_WRITE                2
#Define CREATE_ALWAYS                   2
#Define FILE_ATTRIBUTE_NORMAL         128
#Define INVALID_HANDLE_VALUE           -1
#Define BFHDR_SIZE      14  && BITMAPFILEHEADER

Local hFile, lnOffBits

* dimension du bitmap 
lnFileSize = BFHDR_SIZE + BHDR_SIZE + lnRgbQuadSize + lnBitsSize

* offset du bitmap bits
lnOffBits = BFHDR_SIZE + BHDR_SIZE + lnRgbQuadSize

* Entete du bitmap 
lcBFileHdr = "BM" + num2dword(lnFileSize) +;
    num2dword(0) + num2dword(lnOffBits)

* le handle du fichier destination
hFile = CreateFile (lcTargetFile,;
    GENERIC_WRITE,;
    FILE_SHARE_WRITE, 0,;
    CREATE_ALWAYS,;
    FILE_ATTRIBUTE_NORMAL, 0)

If hFile <> INVALID_HANDLE_VALUE
* Un procédé pour stocker block apres block

    = String2File (hFile, @lcBFileHdr)           && BitmapFileHeader
    = String2File (hFile, @lcBInfo)              && BitmapInfo
    = Ptr2File (hFile, lpBitsArray, lnBitsSize)  && bitmap data
    = CloseHandle (hFile)
    Return .T.
Else
    Return .F.
Endif

Procedure  String2File (hFile, lcBuffer)
* Amender la filière avec le buffer
Declare Integer WriteFile In kernel32;
    INTEGER hFile, String @lpBuffer, Integer nBt2Write,;
    INTEGER @lpBtWritten, Integer lpOverlapped

= WriteFile (hFile, @lcBuffer, Len(lcBuffer), 0, 0)
Return

Procedure  Ptr2File (hFile, lnPointer, lnBt2Write)
* Amender le block de mémoire à la filière

Declare Integer WriteFile In kernel32;
    INTEGER hFile, Integer lpBuffer, Integer nBt2Write,;
    INTEGER @lpBtWritten, Integer lpOverlapped

= WriteFile (hFile, lnPointer, lnBt2Write, 0, 0)
Return

Procedure  MakeSnapshot()
#Define SRCCOPY        13369376
Local HWnd, hdc, hSavedBitmap

HWnd = GetFocus()
hdc = GetWindowDC(HWnd)
= GetWinRect(HWnd, @lnWidth, @lnHeight)

hMemDC = CreateCompatibleDC (hdc)
hMemBmp = CreateCompatibleBitmap (hdc, lnWidth, lnHeight)

hSavedBitmap = SelectObject (hMemDC, hMemBmp)
= BitBlt (hMemDC, 0,0, lnWidth,lnHeight, hdc, 0,0, SRCCOPY)
= SelectObject (hMemDC, hSavedBitmap)
= ReleaseDC (HWnd, hdc)
Return

Procedure  GetWinRect(HWnd, lnWidth, lnHeight)
#Define MAX_DWORD  4294967295  && 0xffffffff
Local lpRect, lnLeft, lnTop, lnRight, lnBottom
lpRect = Repli(Chr(0), 16)
= GetWindowRect (HWnd, @lpRect)

lnLeft   = buf2dword(Substr(lpRect,  1,4))
lnTop    = buf2dword(Substr(lpRect,  5,4))
lnRight  = buf2dword(Substr(lpRect,  9,4))
lnBottom = buf2dword(Substr(lpRect, 13,4))

If lnLeft > lnRight
    lnLeft = lnLeft - MAX_DWORD
Endif
If lnTop > lnBottom
    lnTop = lnTop - MAX_DWORD
Endif

lnWidth  = lnRight - lnLeft
lnHeight = lnBottom - lnTop
Return

Function  num2dword (lnValue)
#Define m0       256
#Define m1     65536
#Define m2  16777216
Local b0, b1, b2, b3
b3 = Int(lnValue/m2)
b2 = Int((lnValue - b3*m2)/m1)
b1 = Int((lnValue - b3*m2 - b2*m1)/m0)
b0 = Mod(lnValue, m0)
Return Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)

Function  num2word (lnValue)
Return Chr(Mod(m.lnValue,256)) + Chr(Int(m.lnValue/256))

Function  buf2dword (lcBuffer)
Return Asc(Substr(lcBuffer, 1,1)) + ;
    Asc(Substr(lcBuffer, 2,1)) * 256 +;
    Asc(Substr(lcBuffer, 3,1)) * 65536 +;
    Asc(Substr(lcBuffer, 4,1)) * 16777216

Function  buf2word (lcBuffer)
Return Asc(Substr(lcBuffer, 1,1)) + ;
    Asc(Substr(lcBuffer, 2,1)) * 256

Procedure  lesdeclarations
Declare Integer GetDIBits In gdi32;
    INTEGER hdc, Integer hbmp, Integer uStartScan,;
    INTEGER cScanLines, Integer lpvBits, String @lpbi,;
    INTEGER uUsage

Declare Integer GlobalAlloc In kernel32 Integer wFlags, Integer dwBytes
Declare Integer GetWindowRect In user32 Integer HWnd, String @lpRect
Declare Integer SelectObject In gdi32 Integer hdc, Integer hObject
Declare Integer ReleaseDC In user32 Integer HWnd, Integer hdc
Declare Integer DeleteDC In gdi32 Integer hdc
Declare Integer GetFocus In user32
Declare Integer GetWindowDC In user32 Integer HWnd
Declare Integer GlobalFree In kernel32 Integer Hmem
Declare Integer DeleteObject In gdi32 Integer hObject
Declare Integer CreateCompatibleDC In gdi32 Integer hdc
Declare Integer CloseHandle In kernel32 Integer hObject

Declare RtlZeroMemory In kernel32 As ZeroMemory;
    INTEGER Dest, Integer numBytes

Declare Integer CreateCompatibleBitmap In gdi32;
    INTEGER hdc, Integer nWidth, Integer nHeight

Declare Integer BitBlt In gdi32;
    INTEGER hDestDC, Integer x, Integer Y,;
    INTEGER nWidth, Integer nHeight, Integer hSrcDC,;
    INTEGER xSrc, Integer ySrc, Integer dwRop

Declare Integer CreateFile In kernel32;
    STRING lpFileName, Integer dwDesiredAccess,;
    INTEGER dwShareMode, Integer lpSecurityAttr,;
    INTEGER dwCreationDisp, Integer dwFlagsAndAttrs,;
    INTEGER hTemplateFile
Declare Integer ShellExecute In shell32;
    INTEGER HWnd,;
    STRING  lpOperation,;
    STRING  lpFile,;
    STRING  lpParameters,;
    STRING  lpDirectory,;
    INTEGER nShowCmd