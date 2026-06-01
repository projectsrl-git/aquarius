
PARAMETERS _codicePuntoVendita

*CLEAR ALL
*CLOSE ALL

SET MULTILOCKS ON
PUBLIC pub_sqlhd,pub_datawh
pub_sqlhd  = 0
pub_datawh = ""

SET PROCEDURE TO prg\SQLLIB 	ADDITIVE
SET PROCEDURE TO prg\FTPLIB 	ADDITIVE

** Impostazione SET Iniziali
SET STATUS BAR OFF
SET AUTOSAVE ON
SET CENTURY ON
SET CLOCK STATUS

****** SET DATE TO GERMAN

SET DATE TO DMY

SET DELETED ON
SET ESCAPE OFF
SET EXACT ON
SET EXCLUSIVE OFF
SET HOURS TO 24
SET NEAR ON
SET REPROCESS TO AUTOMATIC
SET SAFETY OFF
SET TALK OFF
SET MARK TO "/"
SET DECIMAL TO 6  && GESTIONE EURO

_screen.Caption=ALLTRIM(_codicePuntoVendita)+"-Apollo"
_screen.WindowState= 1
*_screen.Visible=.f.

** Aggancio librerie di procedure esterne
*SET PROCEDURE TO TRALIB	ADDITIVE

 
DO WHILE .T.
   _filesem="APOLLO_"+ALLTRIM(_codicePuntoVendita)+".SEM"
   IF FILE(_filesem)
   	  ERASE &_filesem
      EXIT
   ENDIF
   
   DO PRG\APOLLO_data WITH ALLTRIM(_codicePuntoVendita)

   WAIT WINDOW "" TIMEOUT 2
ENDDO

CLOSE DATABASES ALL
CLOSE DATABASES
CLOSE DATA ALL
 
RETURN

