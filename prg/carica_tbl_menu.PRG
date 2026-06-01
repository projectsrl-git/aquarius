PUB_ERRORE=MESSAGEBOX('Confermi il carico della tabella menù'+CHR(13)+;
                      'da tabella fox a tabella sql ?',292,'*** ATTENZIONE ***') 
IF PUB_ERRORE= 6  && RISPOSTA SI
ELSE
   THISFORM.REFRESH
   RETURN .T.
ENDIF

**=> ERASMO - INIZIO 16/01/2008
DO predisponi_tbl_menu  && PREPARA IL CURSORE TBL_MENU
**=> ERASMO - FINE 16/01/2008

IF !ExecCommand("delete from tbl_menu","_menu")
  return(.f.)
ENDIF

DO foxtosql WITH SYS(5)+SYS(2003)+"\tbl_menu"							&& CARICA IL MENU SQL DALLA TABELLA FOX


IF !ExecCommand("UPDATE TBL_MENU SET AUTORIZZAZIONE = 1","_menu")		&& AUTORIZZA ALL'USO TUTTE LE RIGHE DI MENU
  return(.f.)
ENDIF


 

=MESSAGEBOX("Caricamento tabella menù terminata",64,"*** INFORMAZIONE ***")
