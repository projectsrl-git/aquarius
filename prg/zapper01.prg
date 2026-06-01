********************************************************************************************
*                     			       *  AQUARIUS   * 					   				   *
*           																 			   *
*          								 ZAP ARCHIVI	 						 		   *
*           										  	             					   *
******************************************************************************************** 

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

PUB_ERRORE=MESSAGEBOX('Zappo il database MOV_CONT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM MOV_CONT WHERE 1=1"
        IF !ExecCommand(cSql,"MOV_CONT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database MOV_CCO'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM MOV_CCO WHERE 1=1"
        IF !ExecCommand(cSql,"MOV_CCO")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database INDICE'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM INDICE WHERE 1=1"
        IF !ExecCommand(cSql,"INDICE")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

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

PUB_ERRORE=MESSAGEBOX('Zappo il database PART_CLI'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM PART_CLI WHERE 1=1"
        IF !ExecCommand(cSql,"PART_CLI")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database PART_FOR'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM PART_FOR WHERE 1=1"
        IF !ExecCommand(cSql,"PART_FOR")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_CLI_PA'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_CLI_PA WHERE 1=1"
        IF !ExecCommand(cSql,"U_CLI_PA")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_CLI_OP'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_CLI_OP WHERE 1=1"
        IF !ExecCommand(cSql,"U_CLI_OP")
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

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORD_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORD_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORD_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORD_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORD_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORD_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_OFF_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_OFF_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_OFF_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_OFF_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_OFF_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_OFF_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_BOL_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_BOL_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_BOL_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_BOL_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_BOL_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_BOL_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_TVE_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_TVE_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_TVE_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_TVE_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_TVE_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_TVE_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_FAT_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_FAT_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_FAT_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_FAT_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_FAT_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_FAT_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORF_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORF_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORF_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORF_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORF_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORF_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_RIC_AN'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_RIC_AN WHERE 1=1"
        IF !ExecCommand(cSql,"U_RIC_AN")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_MAG_AN'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_MAG_AN WHERE 1=1"
        IF !ExecCommand(cSql,"U_MAG_AN")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_MAG_MO'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_MAG_MO WHERE 1=1"
        IF !ExecCommand(cSql,"U_MAG_MO")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_DIS_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_DIS_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_DIS_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_DIS_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_DIS_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_DIS_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_LIS_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_LIS_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_LIS_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORF_ST'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORF_ST WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORF_ST")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORF_SD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORF_SD WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORF_SD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_CLI_AN'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_CLI_AN WHERE 1=1"
        IF !ExecCommand(cSql,"U_CLI_AN")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_FOR_AN'+CHR(13)+'procedo',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_FOR_AN WHERE 1=1"
        IF !ExecCommand(cSql,"U_FOR_AN")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ART_PR'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ART_PR WHERE 1=1"
        IF !ExecCommand(cSql,"U_ART_PR")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_COM_ED'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_COM_ED WHERE 1=1"
        IF !ExecCommand(cSql,"U_COM_ED")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_COM_ET'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_COM_ET WHERE 1=1"
        IF !ExecCommand(cSql,"U_COM_ET")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_ORF_ED'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_ORF_ED WHERE 1=1"
        IF !ExecCommand(cSql,"U_ORF_ED")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database S_COM_ED'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM S_COM_ED WHERE 1=1"
        IF !ExecCommand(cSql,"S_COM_ED")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database S_COM_ET'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM S_COM_ET WHERE 1=1"
        IF !ExecCommand(cSql,"S_COM_ET")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database S_ORF_ED'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM S_ORF_ED WHERE 1=1"
        IF !ExecCommand(cSql,"S_ORF_ED")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_AVA_CO'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_AVA_CO WHERE 1=1"
        IF !ExecCommand(cSql,"U_AVA_CO")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_SYS_CO'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_SYS_CO WHERE 1=1"
        IF !ExecCommand(cSql,"U_SYS_CO")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_AVA_MQ'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_AVA_MQ WHERE 1=1"
        IF !ExecCommand(cSql,"U_AVA_MQ")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_COM_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_COM_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_COM_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_COM_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_COM_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_COM_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_VER_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_VER_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_VER_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_VER_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_VER_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_VER_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_CTL_TT'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_CTL_TT WHERE 1=1"
        IF !ExecCommand(cSql,"U_CTL_TT")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_CTL_DD'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_CTL_DD WHERE 1=1"
        IF !ExecCommand(cSql,"U_CTL_DD")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il database U_LOC_GI'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_LOC_GI WHERE 1=1"
        IF !ExecCommand(cSql,"U_LOC_GI")
            RETURN .F.
        ENDIF
   CASE PUB_ERRORE= 7  && RISPOSTA NO
ENDCASE

PUB_ERRORE=MESSAGEBOX('Zappo il databse U_LOC_MO'+CHR(13)+'procedo',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
        cSql = "DELETE FROM U_LOC_MO WHERE 1=1"
        IF !ExecCommand(cSql,"U_LOC_MO")
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