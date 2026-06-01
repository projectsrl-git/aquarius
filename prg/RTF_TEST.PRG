#Define GDIPLUS_DETAIL_OBJCODE            4
#Define CRLF Chr(13)+Chr(10)
Local lcStr
Public lcReportPath,lcTmpReport
lcStr = "Note that there is a limit of 32 characters total for the sum of text"+CRLF +;
	"before and text after for simple numbering. Multilevel numbering has a limit"+CRLF +;
	"of 64 characters total for the sum of all levels.NOTE: The file must have a"+CRLF +;
	".RTF extension to work properly.Note that there is a limit of 32 characters total for the sum of text"+CRLF +;
	"before and text after for simple numbering. Multilevel numbering has a limit"+CRLF +;
	"of 64 characters total for the sum of all levels.NOTE: The file must have a"+CRLF +;
	".RTF extension to work properly.Note that there is a limit of 32 characters total for the sum of text"+CRLF +;
	"before and text after for simple numbering. Multilevel numbering has a limit"+CRLF +;
	"of 64 characters total for the sum of all levels.NOTE: The file must have a"+CRLF +;
	".RTF extension to work properly.Note that there is a limit of 32 characters total for the sum of text"+CRLF +;
	"before and text after for simple numbering. Multilevel numbering has a limit"+CRLF +;
	"of 64 characters total for the sum of all levels.NOTE: The file must have a"+CRLF +;
	".RTF extension to work properly.Note that there is a limit of 32 characters total for the sum of text"+CRLF +;
	"before and text after for simple numbering. Multilevel numbering has a limit"+CRLF +;
	"of 64 characters total for the sum of all levels.NOTE: The file must have a"+CRLF +;
	".RTF extension to work properly." && Fill the variable with Text.
lnCount =Alines(myrray,lcStr)
Create Cursor ctext (lctext m,gText g) &&Create a cursor .
Insert Into ctext (lctext) Values (lcStr) && insert the text in the memo field 
_rtfFile = "c:\"+Sys(3)+".rtf"  && Create a temporary rtf file 
Scan
	Set Textmerge To &_rtfFile Noshow
	Set Textmerge On
           \\{\rtf1 <<ALLT(cText.lcText)>>}
	Set Textmerge To
	Append General gText From &_rtfFile Class "RICHTEXT.RICHTEXTCTRL.1" &&Class RTF
endscan
loListener = Createobject("AdRTFListener")
lcReportPath='c:\rtfdemo'
lcTmpReport = sys(2023)+'\'+sys(3)+'.frx'
lcTmpReportfrt = sys(2023)+'\'+juststem(lcTmpReport)+'.frt'
copy file lcReportPath+'.frx' TO (lcTmpReport)
lcReportPath2 =  lcReportPath+'.frt' 
copy file (lcReportPath2) to (lcTmpReportfrt)
loListener.OutputType = -1  && Generate the correct size without showing the report 
&& So the resizing takes place.
loListener.Quietmode = .T.
Report Form (lcTmpReport) Object m.loListener
loListener.OutputType = 1 && Now we show the report resized 
loListener.Quietmode = .F. 
Report Form (lcTmpReport) Object m.loListener
Erase &_rtfFile 

Define Class AdRTFListener As _ReportListener Of ;
		home() + 'ffc\_ReportListener.vcx'
	oGDIGraphics = .Null.
   Function BeforeBand(tnBandObjCode, tnFRXRecNo)
	local lcAlias 
	lcAlias = alias()
  	With This
		If tnBandObjCode=GDIPLUS_DETAIL_OBJCODE
			Use (lcTmpReport) Shared Again In 0 alias DEMO 
			select DEMO 
			locate for DEMO.OBJTYPE = 17 and DEMO.OBJCODE = 0 
			REPLACE DEMO.HEIGHT with DEMO.HEIGHT*lnCount
			go tnFRXRecNo
			REPLACE DEMO.HEIGHT with DEMO.HEIGHT*lnCount
			use in select('demo') 
         select (lcAlias)
 		endif
		DoDefault(tnBandObjCode, tnFRXRecNo)
	Endwith
	endfunc
Enddefine
