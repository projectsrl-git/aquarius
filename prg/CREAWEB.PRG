* Nel seguente esempio viene utilizzato il comando MKDIR per creare una 
* nuova directory chiamata prova, quindi viene utilizzato il comando 
* CHDIR per passare alla nuova directory. Per visualizzare la struttura 
* della directory, viene utilizzata la funzione GETDIR( ), quindi per 
* rimuovere la directory appena creata viene utilizzato il comando RMDIR. 
* Per visualizzare di nuovo la struttura della directory, viene utilizzata la 
* funzione GETDIR( ).

ON ERROR DO errhand WITH ;
	ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )


**==> RICEZIONE

V_LEN1 = LEN(ALLTRIM(PUB_DIR))
V_LEN2 = LEN(ALLTRIM(M.CLI_RCXDIR))

IF SUBSTR(PUB_DIR,1,V_LEN1) = SUBSTR(M.CLI_RCXDIR,1,V_LEN1)
   V_IND1 = V_LEN1 + 2
ELSE
   V_IND1 = 2
ENDIF

V_DIR = ""

DO WHILE .T.

   IF V_IND1 > V_LEN2
      EXIT
   ENDIF
   
   IF SUBSTR(M.CLI_RCXDIR,V_IND1,1) = '\'
      MKDIR &V_DIR
      CHDIR &V_DIR
      V_DIR = ""
   ELSE
      V_DIR = V_DIR + SUBSTR(M.CLI_RCXDIR,V_IND1,1)         
   ENDIF
   
   V_IND1 = V_IND1 + 1
   
ENDDO


IF SUBSTR(M.CLI_RCXDIR,V_LEN2) = '\'
ELSE
   MKDIR &V_DIR
ENDIF

CHDIR &V_DIR
V_DIR = 'STORICO'
MKDIR &V_DIR

SET DEFA TO &PUB_DIR   
    
**==> TRASMISSIONE

V_LEN1 = LEN(ALLTRIM(PUB_DIR))
V_LEN2 = LEN(ALLTRIM(M.CLI_TRXDIR))

IF SUBSTR(PUB_DIR,1,V_LEN1) = SUBSTR(M.CLI_TRXDIR,1,V_LEN1)
   V_IND1 = V_LEN1 + 2
ELSE
   V_IND1 = 2
ENDIF

V_DIR = ""

DO WHILE .T.

   IF V_IND1 > V_LEN2
      EXIT
   ENDIF
   
   IF SUBSTR(M.CLI_TRXDIR,V_IND1,1) = '\'
      MKDIR &V_DIR
      CHDIR &V_DIR
      V_DIR = ""
   ELSE
      V_DIR = V_DIR + SUBSTR(M.CLI_TRXDIR,V_IND1,1)         
   ENDIF
   
   V_IND1 = V_IND1 + 1
   
ENDDO


IF SUBSTR(M.CLI_TRXDIR,V_LEN2) = '\'
ELSE
   MKDIR &V_DIR
ENDIF

CHDIR &V_DIR
V_DIR = 'STORICO'
MKDIR &V_DIR

SET DEFA TO &PUB_DIR   
    

ON ERROR  && Ripristina il gestore degli errori di sistema

PUB_ERRORE=MESSAGEBOX('DIRECTORY WEB CREATA'+CHR(13)+"CORRETTAMENTE",64,'*** ATTENZIONE ***') 

RETURN


*CHDIR prova  && Passa alla nuova directory
*= GETDIR( )  && Visualizza la finestra di dialogo Seleziona directory
*SET DEFAULT TO HOME( )  && Ripristina la directory di Visual FoxPro
*RMDIR prova  && Rimuove la nuova directory
*= GETDIR( )  && Visualizza la finestra di dialogo Seleziona directory


PROCEDURE errhand
PARAMETER merror, mess, mess1, mprog, mlineno
*CLEAR
*? 'Numero di errore: ' + LTRIM(STR(merror))
*? 'Messaggio di errore: ' + mess
*? 'Riga di codice con errore: ' + mess1
*? 'Numero di riga errore: ' + LTRIM(STR(mlineno))
*? 'Programma con errore: ' + mprog
*WAIT
return
