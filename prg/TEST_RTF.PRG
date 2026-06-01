LOCAL lcStr  && Declarer un variable local 
lcstr = "Note that there is a limit of 32 characters total for the sum of text"+;
"before and text after for simple numbering. Multilevel numbering has a limit"+;
"of 64 characters total for the sum of all levels.NOTE: The file must have a"+;
       ".RTF extension to work properly." && Remplir la variable de texte.

CREATE CURSOR crsGen (mText M, gRTF G)
INSERT INTO crsGen (mText) VALUES (lcStr)

_rtfFile = ADDBS(GETENV("TEMP"))+SYS(2015)+".rtf"  && Creer un instance d’un fichier RTF

SET TEXTMERGE TO (_rtfFile) NOSHOW
SET TEXTMERGE ON
\\{\rtf1 <<ALLT(crsGen.mText)>>}
SET TEXTMERGE TO

APPEND GENERAL gRTF FROM (_rtfFile) CLASS "RICHTEXT.RICHTEXTCTRL.1"
*REPORT FORM Report1.frx PREVIEW
*COPY TO rtft_a.dbf 
BROWSE NORMAL
