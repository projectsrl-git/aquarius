IF RIBALTA2(DATADAL) > RIBALTA2(DATAAL)
   =MESSAGEBOX("Registrare correttamente "+CHR(13)+"dal  /  al",62,"ATTENZIONE")
   RETURN
ENDIF 

RELEASE FAT_RECNO 
PUBLIC FAT_RECNO 
FAT_RECNO   = SPACE(10)


DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

CREATE CURSOR FATT_PRT (PRT_RIGA C(132))

cSql = "select * from u_fat_tt where 1=0"
IF !ExecCommand(cSql,"CFAT_TT")
   RETURN .F.
ENDIF
SELECT CFAT_TT
GO TOP

=_ELAFAT("DATA",DATADAL,DATAAL,PUB_ANNO,SPACE(06),"  ",SPACE(10),SPACE(03))


IF SEL_NCR				&& SOLO NOTE CREDITO
   
   SELECT CFAT_TT
   GO TOP

   DO WHILE .T.
   
      IF EOF()
         EXIT
      ENDIF
      
	  IF DELETED()
 	     SKIP +1
	     LOOP
	  ENDIF
  
	  IF _VERYNC(ORD_CAUS)
	  ELSE
		 SELECT CFAT_TT
    	 DELETE
	     SKIP +1
		 LOOP
	  ENDIF  

 	  SELECT CFAT_TT
	  SKIP +1

   ENDDO

ENDIF


IF SEL_NONC				&& SOLO FATTURE

	SELECT CFAT_TT
	GO TOP
	
	DO WHILE .T.
	   
	   IF EOF()
	      EXIT
	   ENDIF

	   IF DELETED()
 	      SKIP +1
	      LOOP
	   ENDIF
  
	   IF !_VERYNC(ORD_CAUS)
 	   ELSE
	 	 SELECT CFAT_TT
         DELETE
	   	 SKIP +1
	     LOOP
	   ENDIF  

	   SELECT CFAT_TT
	   SKIP +1

   ENDDO
   
ENDIF


ON KEY LABEL ENTER DO CHK2
ON KEY LABEL F DO CHKR
ON KEY LABEL RIGHTMOUSE DO CHKR                                                                                                                                                                                                                                                                                        

SELECT CFAT_TT
GO TOP

IF SEL_FAT
   BROWSE FIELDS SELEZIONE:H='SELEZIONE',ORD_AGE:3:H='AGE',ORD_CODCLI:15:H='CODICE CLIENTE', ;
      ORD_RAGSOC:35:H='RAGIONE SOCIALE',ORD_DATORD:15:H='DATA FATTURA', ; 
      ORD_NUMORD:15:H='NUMERO FATTURA',ORD_VALORE:15:0:H='IMPORTO' NOMENU NOEDIT NODELETE WINDOW WSELESOC
   RELEASE WINDOWS WSELESOC
ENDIF

PUSH KEY CLEAR

SELECT CFAT_TT
GO TOP

CONTA = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
	  SELECT CFAT_TT
      SKIP +1
      LOOP
   ENDIF
  
   IF SEL_FAT
	  IF "=>" $ SELEZIONE
	  ELSE
	 	 SELECT CFAT_TT
	     SKIP +1
	     LOOP
	  ENDIF  
   ENDIF	

   TAGGA = TAGGANCIO   

   SCATTER MEMVAR MEMO
   WAIT WINDOW "Fattura : "+ORD_NUMORD+" Elaborata" NOWAIT

   DO STAMPA

   CONTA = CONTA +1
  
   SELECT CFAT_TT
   SKIP +1

ENDDO

IF CONTA <> 0
   IF PUB_STFAD
	  DO CREA_SPOOL WITH "FATT_PRT","FAT.DAL "+DATADAL+" AL "+DATAAL
	  =MESSAGEBOX("Fine elaborazione. Procedi con la stampa tramite lo spooler",62,"ATTENZIONE")
   ELSE
	  =MESSAGEBOX("Operazione conclusa",62,"ATTENZIONE")
   ENDIF
ELSE
   =MESSAGEBOX("Nessuna fattura / Nota credito stampata",62,"ATTENZIONE")
ENDIF

M.NUMERO  = ""
RIF_COPIE = 0

RETURN

***************
*FUNCTION INDATA
***************
*IF RIBALTA2(ORD_DATORD)>=RIBALTA2(DATADAL) .AND. RIBALTA2(ORD_DATORD)<=RIBALTA2(DATAAL)
*   OUT=.T.
*ELSE
*   OUT=.F.
*ENDIF

*RETURN(OUT)    

*****************
PROCEDURE STAMPA
*****************

*=> Acquisizione dell'indizzo e-mail del fornitore (Michela)
x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
cSql   = "select CLI_EMAIL from U_CLI_AN where " + x_cond
IF !ExecCommand(cSql,"CUR_EMAIL")
   return(.f.)
ENDIF
_EMAIL=CUR_EMAIL.CLI_EMAIL

IF !USED("cu_fat_dd")
ELSE
   SELECT cu_fat_dd
   USE
ENDIF

FAT_RECNO    = TAGGA
x_dagg = "daggancio = '" + TAGGA + "'"
cSql   = "select * from u_fat_dd where " + x_dagg + " order by daggancio,ord_sequen"
IF !ExecCommand(cSql,"CU_FAT_DD")
   return(.f.)
ENDIF

SELECT CU_FAT_DD
GO TOP
IF EOF()
   =MESSAGEBOX("Dettagli fattura inesistenti"+CHR(13)+"impossibile proseguire",62,"ATTENZIONE")
   RETURN
ENDIF

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP + 1
      LOOP
   ENDIF

   IF EMPTY(ALLTRIM(ORD_CODSYS))
      _V_CODSYS = SYS(2015) 
      REPLACE ORD_CODSYS WITH _V_CODSYS
   ENDIF

   IF EMPTY(ALLTRIM(ORD_NOTEBO))
      IF EMPTY(ALLTRIM(ORD_DES2))
         _NOTEBO = ALLTRIM(ORD_DSAPRD)
      ELSE
         _NOTEBO = ALLTRIM(ORD_DSAPRD) + CHR(13) + ;
                   ALLTRIM(ORD_DES2)
      ENDIF
      REPLACE ORD_NOTEBO WITH _NOTEBO
   ENDIF

*!*	   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
*!*	   =VERYSIN("CU_FAT_DD")

*!*	   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
*!*	      IF STAM_NOTE("FAT",ORD_CODICE)
*!*	         SELECT CU_FAT_DD
*!*	         DELETE				&& CANCELLA IL COMMENTO IN QUANTO DA NON STAMPARE
*!*	      ENDIF          	 
*!*	   ENDIF

   SELECT CU_FAT_DD
   SKIP + 1
  
ENDDO  

SELECT CFAT_TT

IF PUB_STFAT
   DO PRG\FATSTAMD						  && STAMPA IN FORMATO DOS
ELSE
   DO PRG\FATSTAM           			  && STAMPA IN FORMATO GRAFICO
ENDIF

*!*	IF PUB_STFAD
*!*	   DO PRG\FATSTAMD  WITH "RISTAMPA"	  && STAMPA IN FORMATO DOS
*!*	ELSE
*!*	   DO PRG\FATRSTAG					  && STAMPA GRAFICA
*!*	ENDIF

*=> Gestione stampa con e-mail (Michela)
IF XX_EMAIL=.T.
   DO FORM FORM\EMAIL WITH _Z_PDF,_EMAIL, "Distinti saluti " +CHR(13)+CHR(13)+ALLTRIM(PUB_NOMSOC),"Invio fattura cliente","CLI",M.ORD_CODCLI
ENDIF	

RETURN
