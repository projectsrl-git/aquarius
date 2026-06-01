
*====DLL exports 2 functions. Use CDECL conventionDLLEXPORT char* data_matrix2file (int W, int H, char* text, char* format, char* path);DLLEXPORT int data_matrix2DC (int W, int H, char* text, int img_left,int img_top, int img_width, int img_height, HDC hdc);where 	W and H are width and height of barcode matrix and have predefined sizes	text    is the text for encoding	img*	are dimensions of result picture	format  action, see below	path    is a path to result barcode filedata_matrix2DC just draws DataMatrix barcode on declared canvas.data_matrix2file makes different things, depending on "format" variable. Don't forget to free data_matrix2file return, to avoid memory leaks	The following values of format are available:	i	returns info about barcode, not very useful, but...	t	returns DataMatrix barcode as a set of strings (H strings by W bytes length)	p	writes generated barcode as BMP to "path" file
SET STEP ON
DECLARE STRING EncodeImage IN DataMatrix.net.dll STRING text

LOCAL lcTEXT
lcTEXT = "Erasmo Masiello"


   Local oError as Exception
   Try
      _out = EncodeImage(lcTEXT)
   Catch to oError When .T.
      =messagebox("Errore!"+chr(13)+;
                  oError.Message+chr(13)+;
                  "Error #:"+Transform(oError.ErrorNo)+chr(13)+;
                  "Line #:"+Transform(oError.LineNo)+chr(13)+;
                  "Message #:"+Transform(oError.Message)+chr(13)+;
                  "Procedure #:"+Transform(oError.Procedure)+chr(13)+;
                  "Details #:"+Transform(oError.Details)+chr(13)+;
                  "StackLevel #:"+Transform(oError.StackLevel)+chr(13)+;
                  "LineContents #:"+Transform(oError.LineContents)+chr(13)+;
                  "UserValue #:"+Transform(oError.UserValue)+chr(13)+;
                  "Error #:"+Transform(oError.LineContents),48,"Error")
   Finally
      Wait clear
   EndTry

   If type('oError') = 'O' and !isnull(oError)
      Return oError.ErrorNo
   ENDIF
   
   

RETURN
