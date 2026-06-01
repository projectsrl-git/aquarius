**********************************************************************************************
*                     		       *  AQUARIUS   * 					    					 *
*           																				 *
*          							 ZAP ARCHIVI	 										 *
*          					 		  GLOBALE 		 										 *
*           										  	            						 *
********************************************************************************************** 
PUB_PJPWD=.F.
PUB_MESS="Installazione archivi Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 

IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

PUB_ERRORE=MESSAGEBOX('Installazione archivi'+CHR(13)+'procedere',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Questa procedura azzera gli archivi'+CHR(13)+'procedere',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Ultimo avviso'+CHR(13)+'procedere',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

************************************************************************************

NDBF = ADIR(MADBF,'*.DBF')

FOR DBF = 1 TO NDBF
  
    NOMEFILE = MADBF[DBF,1]

    IF ALLTRIM(NOMEFILE) = "PARA.DBF"
       LOOP
    ENDIF  

    IF ALLTRIM(NOMEFILE) = "CONTI.DBF"
       LOOP
    ENDIF  

    IF ALLTRIM(NOMEFILE) = "CCOSTO.DBF"
       LOOP
    ENDIF  

    IF ALLTRIM(NOMEFILE) = "FOXUSER.DBF"
       LOOP
    ENDIF  

    IF ALLTRIM(NOMEFILE) = "MENUOLD.DBF"
       LOOP
    ENDIF  

    IF ALLTRIM(NOMEFILE) = "RES_MENU.DBF"
       LOOP
    ENDIF  

	PUB_ERRORE=MESSAGEBOX('ZAP del database '+NOMEFILE+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
	DO CASE
   	   CASE PUB_ERRORE= 6  && RISPOSTA SI
            cSql = "DELETE FROM ?NOMEFILE WHERE 1=1"
            IF !ExecCommand(cSql,"?NOMEFILE")
               RETURN .F.
            ENDIF
	   CASE PUB_ERRORE= 7  && RISPOSTA NO
	ENDCASE

ENDFOR

PUB_ERRORE=MESSAGEBOX('Azzero il database CCOSTO'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI     
        cSql = "select * from ccosto"
        IF !ExecRW(cSql,"CCOSTO","R")
           RETURN .F.
        ENDIF
        SELECT CCOSTO
        GO TOP   
	    DO WHILE .T.
	       IF EOF()
	          EXIT
	       ENDIF
  	       REPLACE CON_IMP_D WITH 0
	       REPLACE CON_DA01  WITH 0
	  	   REPLACE CON_DA02  WITH 0
	  	   REPLACE CON_DA03  WITH 0
	  	   REPLACE CON_DA04  WITH 0
	  	   REPLACE CON_DA05  WITH 0
	  	   REPLACE CON_DA06  WITH 0
	  	   REPLACE CON_DA07  WITH 0
	  	   REPLACE CON_DA08  WITH 0
	  	   REPLACE CON_DA09  WITH 0
	  	   REPLACE CON_DA10  WITH 0
	  	   REPLACE CON_DA11  WITH 0
  		   REPLACE CON_DA12  WITH 0
  		   SKIP +1
	    ENDDO
        IF !ExecRW(cSql,"CCOSTO","W")
           RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Azzero il database CONTI'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "select * from conti"
        IF !ExecRW(cSql,"CONTI","R")
           RETURN .F.
        ENDIF
        SELECT CONTI
        GO TOP   
  	    DO WHILE .T.
  	       IF EOF()
  	          EXIT
  	       ENDIF
  	       REPLACE CON_IMP_D WITH 0
	       REPLACE CON_IMP_A WITH 0
  		   REPLACE CON_DA01 WITH 0
	  	   REPLACE CON_AV01 WITH 0 
  		   REPLACE CON_DA02 WITH 0
	  	   REPLACE CON_AV02 WITH 0
           REPLACE CON_DA03 WITH 0
	  	   REPLACE CON_AV03 WITH 0
	  	   REPLACE CON_DA04 WITH 0
	  	   REPLACE CON_AV04 WITH 0 
	  	   REPLACE CON_DA05 WITH 0
	  	   REPLACE CON_AV05 WITH 0
  		   REPLACE CON_DA06 WITH 0
	  	   REPLACE CON_AV06 WITH 0
  		   REPLACE CON_DA07 WITH 0
	  	   REPLACE CON_AV07 WITH 0
	  	   REPLACE CON_DA08 WITH 0
	       REPLACE CON_AV08 WITH 0
  		   REPLACE CON_DA09 WITH 0
	  	   REPLACE CON_AV09 WITH 0 
	  	   REPLACE CON_DA10 WITH 0
	       REPLACE CON_AV10 WITH 0  
	  	   REPLACE CON_DA11 WITH 0
  		   REPLACE CON_AV11 WITH 0
  	  	   REPLACE CON_DA12 WITH 0
  		   REPLACE CON_AV12 WITH 0
 	  	   SKIP +1
	    ENDDO  
        IF !ExecRW(cSql,"CONTI","W")
           RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Operazione terminata'+CHR(13)+'Procedere con ricostruzione archivi',64,'*** ATTENZIONE ***')

* -->> SBLOCCO TUTTI GLI OPERATORI DOPO RICOSTRUZIONE ARCHIVI

CSQL="UPDATE RIC_ARC SET SIRIC = '0' WHERE 1=1"
IF !ExecCommand(CSQL,"RIC_ARC")
   RETURN (.f.)
ENDIF 

x_cond = "codice = '" + PUB_CODOPE + "'"
cSql = "select * from res_oper where " + x_cond
IF !ExecRW(cSql,"RES_OPER","R")
   RETURN .F.
ENDIF
SELECT RES_OPER
GO TOP   
IF !EOF()
   REPLACE IN_USO WITH .F.
ENDIF
IF !ExecRW(cSql,"RES_OPER","W")
   RETURN .F.
ENDIF

DO ADDLOG WITH "Congedato"

RETURN