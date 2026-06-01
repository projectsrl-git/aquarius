
PUB_PJPWD= .F.
PUB_MESS = "Installazione archivi Aquarius"+CHR(13)+;
           "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
           ""+CHR(13)+;
           "Digitare la password di accesso ....."  
DO FORM FORM\PJPWD LINKED 
IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF  

PUB_ERRORE=MESSAGEBOX('Installazione archivi'+CHR(13)+'procedere ?',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
  	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Questa procedura azzera gli archivi'+CHR(13)+'procedere ?',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Ultimo avviso'+CHR(13)+'Procedere ?',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

CSQL = "DELETE FROM ANAART"
IF !ExecCommand(CSQL,"ANAART")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM ANACLFO"
IF !ExecCommand(CSQL,"ANACLFO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM APEFOR"
IF !ExecCommand(CSQL,"APEFOR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM APERTE"
IF !ExecCommand(CSQL,"APERTE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM APPOGGIO"
IF !ExecCommand(CSQL,"APPOGGIO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM ART_TRA"
IF !ExecCommand(CSQL,"ART_TRA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM BILNEW"
IF !ExecCommand(CSQL,"BILNEW")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CCOSTX"
IF !ExecCommand(CSQL,"CCOSTX")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CHIUSURA"
IF !ExecCommand(CSQL,"CHIUSURA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CLIENTI"
IF !ExecCommand(CSQL,"CLIENTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTATTI"
IF !ExecCommand(CSQL,"CONTATTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTICA"
IF !ExecCommand(CSQL,"CONTICA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTIX"
IF !ExecCommand(CSQL,"CONTIX")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CORPO"
IF !ExecCommand(CSQL,"CORPO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CORPO2"
IF !ExecCommand(CSQL,"CORPO2")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM DATI"
IF !ExecCommand(CSQL,"DATI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM DISEGNI"
IF !ExecCommand(CSQL,"DISEGNI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM DOPPI"
IF !ExecCommand(CSQL,"DOPPI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM EUROLOG"
IF !ExecCommand(CSQL,"EUROLOG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM FPSMOVC"
IF !ExecCommand(CSQL,"FPSMOVC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM INDMACC"
IF !ExecCommand(CSQL,"INDMACC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM INDPROD"
IF !ExecCommand(CSQL,"INDPROD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM JOURNA_O"
IF !ExecCommand(CSQL,"JOURNA_O")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM JOURNA_R"
IF !ExecCommand(CSQL,"JOURNA_R")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM JOURNAL"
IF !ExecCommand(CSQL,"JOURNAL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM L_CMC_IM"
IF !ExecCommand(CSQL,"L_CMC_IM")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM L_CMC_IS"
IF !ExecCommand(CSQL,"L_CMC_IS")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM L_CMD_IM"
IF !ExecCommand(CSQL,"L_CMD_IM")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM L_CMD_IS"
IF !ExecCommand(CSQL,"L_CMD_IS")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM L_CMC_IM"
IF !ExecCommand(CSQL,"L_CMC_IM")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM M1999"
IF !ExecCommand(CSQL,"M1999")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MACCHINE"
IF !ExecCommand(CSQL,"MACCHINE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MAG_TRA"
IF !ExecCommand(CSQL,"MAG_TRA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MAGAZMP"
IF !ExecCommand(CSQL,"MAGAZMP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MAGAZPF"
IF !ExecCommand(CSQL,"MAGAZPF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM NOTE_COM"
IF !ExecCommand(CSQL,"NOTE_COM")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PIPPO"
IF !ExecCommand(CSQL,"PIPPO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PJ_CON_TR"
IF !ExecCommand(CSQL,"PJ_CON_TR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PJ_SPOOL"
IF !ExecCommand(CSQL,"PJ_SPOOL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PRODOTTI"
IF !ExecCommand(CSQL,"PRODOTTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PROV_STO"
IF !ExecCommand(CSQL,"PROV_STO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PROVA"
IF !ExecCommand(CSQL,"PROVA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PROVVI"
IF !ExecCommand(CSQL,"PROVVI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTI WHERE CON_ANNO = '2004'"
IF !ExecCommand(CSQL,"CONTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTI WHERE SUBSTRING(CON_CONTO,1,6) = '109090'"
IF !ExecCommand(CSQL,"CONTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTI WHERE SUBSTRING(CON_CONTO,1,6) = '220200'"
IF !ExecCommand(CSQL,"CONTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CCOSTO"
IF !ExecCommand(CSQL,"CCOSTO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM INDICE"
IF !ExecCommand(CSQL,"INDICE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MO_CONCA"
IF !ExecCommand(CSQL,"MO_CONCA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MOV_CCO"
IF !ExecCommand(CSQL,"MOV_CCO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MOV_CONT"
IF !ExecCommand(CSQL,"MOV_CONT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PART_CLI"
IF !ExecCommand(CSQL,"PART_CLI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PART_FOR"
IF !ExecCommand(CSQL,"PART_FOR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM LOG_AGE"
IF !ExecCommand(CSQL,"LOG_AGE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM LOG_CONT"
IF !ExecCommand(CSQL,"LOG_CONT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM LOG_REI"
IF !ExecCommand(CSQL,"LOG_REI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM LOG_RETE"
IF !ExecCommand(CSQL,"LOG_RETE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM LOGERROR"
IF !ExecCommand(CSQL,"LOGERROR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM S_COM_ED"
IF !ExecCommand(CSQL,"S_COM_ED")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM S_COM_ET"
IF !ExecCommand(CSQL,"S_COM_ET")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM S_ORF_ED"
IF !ExecCommand(CSQL,"S_ORF_ED")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SCADENZE"
IF !ExecCommand(CSQL,"SCADENZE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SCHE_CLI"
IF !ExecCommand(CSQL,"SCHE_CLI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SERGIO"
IF !ExecCommand(CSQL,"SERGIO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SDF"
IF !ExecCommand(CSQL,"SDF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SERG"
IF !ExecCommand(CSQL,"SERG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_CAUCONT"
IF !ExecCommand(CSQL,"TAB_CAUCONT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_CLIENTI"
IF !ExecCommand(CSQL,"TAB_CLIENTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_CONTI "
IF !ExecCommand(CSQL,"TAB_CONTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_FORNITORI"
IF !ExecCommand(CSQL,"TAB_FORNITORI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_PARTAPERTE"
IF !ExecCommand(CSQL,"TAB_PARTAPERTE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_PRIMANOTA"
IF !ExecCommand(CSQL,"TAB_PRIMANOTA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_SPEDRESI"
IF !ExecCommand(CSQL,"TAB_SPEDRESI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_TOPCONT"
IF !ExecCommand(CSQL,"TAB_TOPCONT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_VEN_FA"
IF !ExecCommand(CSQL,"TAB_VEN_FA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_VEN_FP"
IF !ExecCommand(CSQL,"TAB_VEN_FP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TAB_VEN_FPA"
IF !ExecCommand(CSQL,"TAB_VEN_FPA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TABULA"
IF !ExecCommand(CSQL,"TABULA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM TEMPO"
IF !ExecCommand(CSQL,"TEMPO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AGE_AN"
IF !ExecCommand(CSQL,"U_AGE_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ALT_DA"
IF !ExecCommand(CSQL,"U_ALT_DA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AMM_DD"
IF !ExecCommand(CSQL,"U_AMM_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AMM_TT"
IF !ExecCommand(CSQL,"U_AMM_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ART_LE"
IF !ExecCommand(CSQL,"U_ART_LE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ART_PR"
IF !ExecCommand(CSQL,"U_ART_PR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ASS_DD"
IF !ExecCommand(CSQL,"U_ASS_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ASS_TT"
IF !ExecCommand(CSQL,"U_ASS_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AST_AN"
IF !ExecCommand(CSQL,"U_AST_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AUT_AN"
IF !ExecCommand(CSQL,"U_AUT_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AVA_CO"
IF !ExecCommand(CSQL,"U_AVA_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AVA_MQ"
IF !ExecCommand(CSQL,"U_AVA_MQ")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BAN_AN"
IF !ExecCommand(CSQL,"U_BAN_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BFO_DD"
IF !ExecCommand(CSQL,"U_BFO_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BFO_TT"
IF !ExecCommand(CSQL,"U_BFO_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BFO_LE"
IF !ExecCommand(CSQL,"U_BFO_LE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BLI_DD"
IF !ExecCommand(CSQL,"U_BLI_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BLI_TT"
IF !ExecCommand(CSQL,"U_BLI_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BLU_DD"
IF !ExecCommand(CSQL,"U_BLU_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BLU_TT"
IF !ExecCommand(CSQL,"U_BLU_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BLU_RF"
IF !ExecCommand(CSQL,"U_BLU_EF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOF_DD"
IF !ExecCommand(CSQL,"U_BOF_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOF_TT"
IF !ExecCommand(CSQL,"U_BOF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOL_DD"
IF !ExecCommand(CSQL,"U_BOL_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOL_TT"
IF !ExecCommand(CSQL,"U_BOL_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOL_RE"
IF !ExecCommand(CSQL,"U_BOL_RE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOL_SD"
IF !ExecCommand(CSQL,"U_BOL_SD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BOL_ST"
IF !ExecCommand(CSQL,"U_BOL_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BUD_AN"
IF !ExecCommand(CSQL,"U_BUD_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CAL_AS"
IF !ExecCommand(CSQL,"U_CAL_AS")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CAL_CO"
IF !ExecCommand(CSQL,"U_CAL_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CAL_LA"
IF !ExecCommand(CSQL,"U_CAL_LA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CAN_CA"
IF !ExecCommand(CSQL,"U_CAN_CA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CAN_CO"
IF !ExecCommand(CSQL,"U_CAN_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CAR_AN"
IF !ExecCommand(CSQL,"U_CAR_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CCO_GR"
IF !ExecCommand(CSQL,"U_CCO_GR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CCO_LE"
IF !ExecCommand(CSQL,"U_CCO_LE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CEA_DD"
IF !ExecCommand(CSQL,"U_CEA_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CEA_TT"
IF !ExecCommand(CSQL,"U_CEA_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CEI_DD"
IF !ExecCommand(CSQL,"U_CEI_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CEI_TT"
IF !ExecCommand(CSQL,"U_CEI_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CER_AN"
IF !ExecCommand(CSQL,"U_CER_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CER_MO"
IF !ExecCommand(CSQL,"U_CER_MO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CIC_DD"
IF !ExecCommand(CSQL,"U_CIC_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CIC_TT"
IF !ExecCommand(CSQL,"U_CIC_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CLI_AG"
IF !ExecCommand(CSQL,"U_CLI_AG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CLI_AN"
IF !ExecCommand(CSQL,"U_CLI_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CLI_AS"
IF !ExecCommand(CSQL,"U_CLI_AS")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CLI_FI"
IF !ExecCommand(CSQL,"U_CLI_FI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CLI_OP"
IF !ExecCommand(CSQL,"U_CLI_OP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CLI_PA"
IF !ExecCommand(CSQL,"U_CLI_PA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CMC_AN"
IF !ExecCommand(CSQL,"U_CMC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CMD_AN"
IF !ExecCommand(CSQL,"U_CMD_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CNT_AN"
IF !ExecCommand(CSQL,"U_CNT_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_COM_AN"
IF !ExecCommand(CSQL,"U_COM_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_COM_DD"
IF !ExecCommand(CSQL,"U_COM_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_COM_TT"
IF !ExecCommand(CSQL,"U_COM_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_COM_ED"
IF !ExecCommand(CSQL,"U_COM_ED")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_COM_ET"
IF !ExecCommand(CSQL,"U_COM_ET")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CON_AN"
IF !ExecCommand(CSQL,"U_CON_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CON_DD"
IF !ExecCommand(CSQL,"U_CON_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CON_TT"
IF !ExecCommand(CSQL,"U_CON_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CON_PE"
IF !ExecCommand(CSQL,"U_CON_PE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CON_TR"
IF !ExecCommand(CSQL,"U_CON_TR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_COR_TT"
IF !ExecCommand(CSQL,"U_COR_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CTL_DD"
IF !ExecCommand(CSQL,"U_CTL_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CTL_TT"
IF !ExecCommand(CSQL,"U_CTL_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_DIS_DD"
IF !ExecCommand(CSQL,"U_DIS_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_DIS_TT"
IF !ExecCommand(CSQL,"U_DIS_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_DIS_AN"
IF !ExecCommand(CSQL,"U_DIS_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_DSB_AN"
IF !ExecCommand(CSQL,"U_DSB_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_EFF_DD"
IF !ExecCommand(CSQL,"U_EFF_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_EFF_TT"
IF !ExecCommand(CSQL,"U_EFF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_EFF_PA"
IF !ExecCommand(CSQL,"U_EFF_PA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ERR_RC"
IF !ExecCommand(CSQL,"U_ERR_RC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ERR_TR"
IF !ExecCommand(CSQL,"U_ERR_TR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_EXC_EL"
IF !ExecCommand(CSQL,"U_EXC_EL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAG_DD"
IF !ExecCommand(CSQL,"U_FAG_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAG_TT"
IF !ExecCommand(CSQL,"U_FAG_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAM_DD"
IF !ExecCommand(CSQL,"U_FAM_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAM_TT"
IF !ExecCommand(CSQL,"U_FAM_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAP_DD"
IF !ExecCommand(CSQL,"U_FAP_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAP_TT"
IF !ExecCommand(CSQL,"U_FAP_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAT_DD"
IF !ExecCommand(CSQL,"U_FAT_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAT_TT"
IF !ExecCommand(CSQL,"U_FAT_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAT_SD"
IF !ExecCommand(CSQL,"U_FAT_SD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FAT_ST"
IF !ExecCommand(CSQL,"U_FAT_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FID_DD"
IF !ExecCommand(CSQL,"U_FID_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FID_TT"
IF !ExecCommand(CSQL,"U_FID_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FIN_AN"
IF !ExecCommand(CSQL,"U_FIN_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FOR_DD"
IF !ExecCommand(CSQL,"U_FOR_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FOR_TT"
IF !ExecCommand(CSQL,"U_FOR_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FOR_AN"
IF !ExecCommand(CSQL,"U_FOR_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FOR_PR"
IF !ExecCommand(CSQL,"U_FOR_PR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_FTP_AN"
IF !ExecCommand(CSQL,"U_FTP_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_IMB_TB"
IF !ExecCommand(CSQL,"U_IMB_TB")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_INC_AN"
IF !ExecCommand(CSQL,"U_INC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_INS_AN"
IF !ExecCommand(CSQL,"U_INS_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_INT_AN"
IF !ExecCommand(CSQL,"U_INT_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_INT_TT"
IF !ExecCommand(CSQL,"U_INT_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_IVA_CL"
IF !ExecCommand(CSQL,"U_IVA_CL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_IVA_CO"
IF !ExecCommand(CSQL,"U_IVA_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_IVA_CR"
IF !ExecCommand(CSQL,"U_IVA_CR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_IVA_TO"
IF !ExecCommand(CSQL,"U_IVA_TO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_IVF_CL"
IF !ExecCommand(CSQL,"U_IVF_CL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LEA_DD"
IF !ExecCommand(CSQL,"U_LEA_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LEA_TT"
IF !ExecCommand(CSQL,"U_LEA_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LEG_DD"
IF !ExecCommand(CSQL,"U_LEG_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LEG_DO"
IF !ExecCommand(CSQL,"U_LEG_DO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIF_TT"
IF !ExecCommand(CSQL,"U_LIF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIS_AG"
IF !ExecCommand(CSQL,"U_LIS_AG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIS_LG"
IF !ExecCommand(CSQL,"U_LIS_LG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIS_LI"
IF !ExecCommand(CSQL,"U_LIS_LI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIS_PA"
IF !ExecCommand(CSQL,"U_LIS_PA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIS_TT"
IF !ExecCommand(CSQL,"U_LIS_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LIS_VE"
IF !ExecCommand(CSQL,"U_LIS_VE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LOC_AN"
IF !ExecCommand(CSQL,"U_LOC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LOC_GI"
IF !ExecCommand(CSQL,"U_LOC_GI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LOC_MO"
IF !ExecCommand(CSQL,"U_LOC_MO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LOG_TL"
IF !ExecCommand(CSQL,"U_LOG_TL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAC_AN"
IF !ExecCommand(CSQL,"U_MAC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAC_TT"
IF !ExecCommand(CSQL,"U_MAC_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAC_DD"
IF !ExecCommand(CSQL,"U_MAC_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAC_AN"
IF !ExecCommand(CSQL,"U_MAC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAC_ST"
IF !ExecCommand(CSQL,"U_MAC_ST")
   RETURN (.f.)
ENDIF 


CSQL = "DELETE FROM U_MAN_TT"
IF !ExecCommand(CSQL,"U_MAN_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAN_DD"
IF !ExecCommand(CSQL,"U_MAN_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAR_AN"
IF !ExecCommand(CSQL,"U_MAR_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MDC_AN"
IF !ExecCommand(CSQL,"U_MDC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MDC_ST"
IF !ExecCommand(CSQL,"U_MDC_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MEN_TT"
IF !ExecCommand(CSQL,"U_MEN_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MEN_DD"
IF !ExecCommand(CSQL,"U_MEN_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MON_CA"
IF !ExecCommand(CSQL,"U_MON_CA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MON_PE"
IF !ExecCommand(CSQL,"U_MON_PE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MRI_TT"
IF !ExecCommand(CSQL,"U_MRI_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MRI_DD"
IF !ExecCommand(CSQL,"U_MRI_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MSG_AU"
IF !ExecCommand(CSQL,"U_MSG_AU")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_NCR_TT"
IF !ExecCommand(CSQL,"U_NCR_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_NCR_DD"
IF !ExecCommand(CSQL,"U_NCR_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_OFF_TT"
IF !ExecCommand(CSQL,"U_OFF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_OFF_DD"
IF !ExecCommand(CSQL,"U_OFF_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_OFF_ST"
IF !ExecCommand(CSQL,"U_OFF_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_OFF_SD"
IF !ExecCommand(CSQL,"U_OFF_SD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_OPE_AN"
IF !ExecCommand(CSQL,"U_OPE_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORD_TT"
IF !ExecCommand(CSQL,"U_ORD_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORD_DD"
IF !ExecCommand(CSQL,"U_ORD_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORD_ST"
IF !ExecCommand(CSQL,"U_ORD_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORD_SD"
IF !ExecCommand(CSQL,"U_ORD_SD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORE_AN"
IF !ExecCommand(CSQL,"U_ORE_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_CO"
IF !ExecCommand(CSQL,"U_ORF_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_TT"
IF !ExecCommand(CSQL,"U_ORF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_DD"
IF !ExecCommand(CSQL,"U_ORF_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_ST"
IF !ExecCommand(CSQL,"U_ORF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_SD"
IF !ExecCommand(CSQL,"U_ORF_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_ED"
IF !ExecCommand(CSQL,"U_ORF_ED")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_PO"
IF !ExecCommand(CSQL,"U_ORF_PO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORF_DT"
IF !ExecCommand(CSQL,"U_ORF_DT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORM_TT"
IF !ExecCommand(CSQL,"U_ORM_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_ORM_DD"
IF !ExecCommand(CSQL,"U_ORM_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PAG_AN"
IF !ExecCommand(CSQL,"U_PAG_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PAL_AN"
IF !ExecCommand(CSQL,"U_PAL_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PAP_AN"
IF !ExecCommand(CSQL,"U_PAP_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_AN"
IF !ExecCommand(CSQL,"U_PDV_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_CA"
IF !ExecCommand(CSQL,"U_PDV_CA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_AU"
IF !ExecCommand(CSQL,"U_PDV_AU")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_CC"
IF !ExecCommand(CSQL,"U_PDV_CC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_CD"
IF !ExecCommand(CSQL,"U_PDV_CD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_CN"
IF !ExecCommand(CSQL,"U_PDV_CN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_IN"
IF !ExecCommand(CSQL,"U_PDV_IN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_OP"
IF !ExecCommand(CSQL,"U_PDV_OP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_PA"
IF !ExecCommand(CSQL,"U_PDV_PA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_SA"
IF !ExecCommand(CSQL,"U_PDV_SA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PDV_SC"
IF !ExecCommand(CSQL,"U_PDV_SC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PER_AN"
IF !ExecCommand(CSQL,"U_PER_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PER_CO"
IF !ExecCommand(CSQL,"U_PER_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PER_CP"
IF !ExecCommand(CSQL,"U_PER_CP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PER_PD"
IF !ExecCommand(CSQL,"U_PER_PD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PFO_TT"
IF !ExecCommand(CSQL,"U_PFO_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PFO_DD"
IF !ExecCommand(CSQL,"U_PFO_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PNC_BU"
IF !ExecCommand(CSQL,"U_PNC_BU")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PNC_SA"
IF !ExecCommand(CSQL,"U_PNC_SA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_POR_EF"
IF !ExecCommand(CSQL,"U_POR_EF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_POS_AN"
IF !ExecCommand(CSQL,"U_POS_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRB_TT"
IF !ExecCommand(CSQL,"U_PRB_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRB_DD"
IF !ExecCommand(CSQL,"U_PRB_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRE_AN"
IF !ExecCommand(CSQL,"U_PRE_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRF_TT"
IF !ExecCommand(CSQL,"U_PRF_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRF_DD"
IF !ExecCommand(CSQL,"U_PRF_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRO_AN"
IF !ExecCommand(CSQL,"U_PRO_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRO_TT"
IF !ExecCommand(CSQL,"U_PRO_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRO_DD"
IF !ExecCommand(CSQL,"U_PRO_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRO_OR"
IF !ExecCommand(CSQL,"U_PRO_OR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRO_PZ"
IF !ExecCommand(CSQL,"U_PRO_PZ")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRO_ST"
IF !ExecCommand(CSQL,"U_PRO_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRV_AN"
IF !ExecCommand(CSQL,"U_PRV_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRV_DD"
IF !ExecCommand(CSQL,"U_PRV_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_PRV_OR"
IF !ExecCommand(CSQL,"U_PRV_OR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RAA_TT"
IF !ExecCommand(CSQL,"U_RAA_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RAA_DD"
IF !ExecCommand(CSQL,"U_RAA_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RET_AN"
IF !ExecCommand(CSQL,"U_RET_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RET_CE"
IF !ExecCommand(CSQL,"U_RET_CE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIA_TT"
IF !ExecCommand(CSQL,"U_RIA_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIA_DD"
IF !ExecCommand(CSQL,"U_RIA_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIC_AN"
IF !ExecCommand(CSQL,"U_RIC_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIC_TT"
IF !ExecCommand(CSQL,"U_RIC_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIC_DD"
IF !ExecCommand(CSQL,"U_RIC_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIC_VA"
IF !ExecCommand(CSQL,"U_RIC_VA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RID_AN"
IF !ExecCommand(CSQL,"U_RID_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIM_TT"
IF !ExecCommand(CSQL,"U_RIM_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIM_DD"
IF !ExecCommand(CSQL,"U_RIM_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIN_AN"
IF !ExecCommand(CSQL,"U_RIN_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIN_TT"
IF !ExecCommand(CSQL,"U_RIN_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_RIN_DD"
IF !ExecCommand(CSQL,"U_RIN_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_SCA_AN"
IF !ExecCommand(CSQL,"U_SCA_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_SIC_PA"
IF !ExecCommand(CSQL,"U_SIC_PA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_SIT_AN"
IF !ExecCommand(CSQL,"U_SIT_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_SPE_TT"
IF !ExecCommand(CSQL,"U_SPE_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_SPE_DD"
IF !ExecCommand(CSQL,"U_SPE_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_SPI_AN"
IF !ExecCommand(CSQL,"U_SPI_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_STA_TT"
IF !ExecCommand(CSQL,"U_STA_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_STA_DD"
IF !ExecCommand(CSQL,"U_STA_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_STA_ST"
IF !ExecCommand(CSQL,"U_STA_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_STA_SD"
IF !ExecCommand(CSQL,"U_STA_SD")
   RETURN (.f.)
ENDIF 

*!*	CSQL = "DELETE FROM U_STC_AN"
*!*	IF !ExecCommand(CSQL,"U_STC_AN")
*!*	   RETURN (.f.)
*!*	ENDIF 

CSQL = "DELETE FROM U_SYS_CO"
IF !ExecCommand(CSQL,"U_SYS_CO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_TES_AN"
IF !ExecCommand(CSQL,"U_TES_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_TOP_TT"
IF !ExecCommand(CSQL,"U_TOP_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_TVE_TT"
IF !ExecCommand(CSQL,"U_TVE_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_TVE_DD"
IF !ExecCommand(CSQL,"U_TVE_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_TVE_ST"
IF !ExecCommand(CSQL,"U_TVE_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_TVE_SD"
IF !ExecCommand(CSQL,"U_TVE_SD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_VER_TT"
IF !ExecCommand(CSQL,"U_VER_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_VER_DD"
IF !ExecCommand(CSQL,"U_VER_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_VIS_AN"
IF !ExecCommand(CSQL,"U_VIS_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_WRK_TT"
IF !ExecCommand(CSQL,"U_WRK_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_WRK_DD"
IF !ExecCommand(CSQL,"U_WRK_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_WRK_ST"
IF !ExecCommand(CSQL,"U_WRK_ST")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_WRK_SD"
IF !ExecCommand(CSQL,"U_WRK_SD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_XLS_AN"
IF !ExecCommand(CSQL,"U_XLS_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_XLS_TT"
IF !ExecCommand(CSQL,"U_XLS_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_XLS_DD"
IF !ExecCommand(CSQL,"U_XLS_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_XLS_RP"
IF !ExecCommand(CSQL,"U_XLS_RP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SALDI_CLI"
IF !ExecCommand(CSQL,"SALDI_CLI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM SALDI_FOR"
IF !ExecCommand(CSQL,"SALDI_FOR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BFO_TT"
IF !ExecCommand(CSQL,"U_BFO_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_BFO_DD"
IF !ExecCommand(CSQL,"U_BFO_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LEG_DO"
IF !ExecCommand(CSQL,"U_LEG_DO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_LEG_DD"
IF !ExecCommand(CSQL,"U_LEG_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CNT_TT"
IF !ExecCommand(CSQL,"U_CNT_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CNT_DD"
IF !ExecCommand(CSQL,"U_CNT_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_CNT_PR"
IF !ExecCommand(CSQL,"U_CNT_PR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AGN_AN"
IF !ExecCommand(CSQL,"U_AGN_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CONTATTI"
IF !ExecCommand(CSQL,"CONTATTI")
   RETURN (.f.)
ENDIF 

 
 CSQL = "DELETE FROM CCOSTX"
IF !ExecCommand(CSQL,"CCOSTX")
   RETURN (.f.)
ENDIF 
 
  CSQL = "DELETE FROM COMMESSE"
IF !ExecCommand(CSQL,"COMMESSE")
   RETURN (.f.)
ENDIF 

  CSQL = "DELETE FROM CONTI"
IF !ExecCommand(CSQL,"CONTI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJ"
IF !ExecCommand(CSQL,"CPJ")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJBEBE"
IF !ExecCommand(CSQL,"CPJBEBE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJCAR"
IF !ExecCommand(CSQL,"CPJCAR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJCAR"
IF !ExecCommand(CSQL,"CPJCAR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJCLA"
IF !ExecCommand(CSQL,"CPJCLA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJCRI"
IF !ExecCommand(CSQL,"CPJCRI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJDAV"
IF !ExecCommand(CSQL,"CPJDAV")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJFAU"
IF !ExecCommand(CSQL,"CPJFAU")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJFLA"
IF !ExecCommand(CSQL,"CPJFLA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJMAX"
IF !ExecCommand(CSQL,"CPJMAX")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJMOR"
IF !ExecCommand(CSQL,"CPJMOR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJQ"
IF !ExecCommand(CSQL,"CPJQ")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM CPJSER"
IF !ExecCommand(CSQL,"CPJSER")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM D"
IF !ExecCommand(CSQL,"D")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM ELENTAR"
IF !ExecCommand(CSQL,"ELENTAR")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM INVENTARIO"
IF !ExecCommand(CSQL,"INVENTARIO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM LINGUE"
IF !ExecCommand(CSQL,"LINGUE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM LOG_USER"
IF !ExecCommand(CSQL,"LOG_USER")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MAILING"
IF !ExecCommand(CSQL,"MAILING")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MENUOLD"
IF !ExecCommand(CSQL,"MENUOLD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MKDUEPJ"
IF !ExecCommand(CSQL,"MKDUEPJ")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM MOVSTALL"
IF !ExecCommand(CSQL,"MOVSTALL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM NEW_PARA"
IF !ExecCommand(CSQL,"NEW_PARA")
   RETURN (.f.)
ENDIF 

*!*	CSQL = "DELETE FROM PARA"
*!*	IF !ExecCommand(CSQL,"PARA")
*!*	   RETURN (.f.)
*!*	ENDIF 

CSQL = "DELETE FROM PARA1"
IF !ExecCommand(CSQL,"PARA1")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PARACONF"
IF !ExecCommand(CSQL,"PARACONF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PARAX"
IF !ExecCommand(CSQL,"PARAX")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PARTFOR"
IF !ExecCommand(CSQL,"PARTFOR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PIANOP_DD"
IF !ExecCommand(CSQL,"PIANOP_DD")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PIANOP_TT"
IF !ExecCommand(CSQL,"PIANOP_TT")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PJDBPROC"
IF !ExecCommand(CSQL,"PJDBPROC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PJMAIL"
IF !ExecCommand(CSQL,"PJMAIL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PJMESSAG"
IF !ExecCommand(CSQL,"PJMESSAG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM PJTIPREP"
IF !ExecCommand(CSQL,"PJTIPREP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM RES_MENU"
IF !ExecCommand(CSQL,"RES_MENU")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM RES_PROC"
IF !ExecCommand(CSQL,"RES_PROC")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM RICE"
IF !ExecCommand(CSQL,"RICE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM scapos_for"
IF !ExecCommand(CSQL,"scapos_for")
   RETURN (.f.)
ENDIF 

*!*	CSQL = "DELETE FROM SETUP"
*!*	IF !ExecCommand(CSQL,"SETUP")
*!*	   RETURN (.f.)
*!*	ENDIF 

CSQL = "DELETE FROM STARTEUR"
IF !ExecCommand(CSQL,"STARTEUR")
   RETURN (.f.)
ENDIF 


CSQL = "DELETE FROM TOOLS"
IF !ExecCommand(CSQL,"TOOLS")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_AMM_PE"
IF !ExecCommand(CSQL,"U_AMM_PE")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM u_art_ko"
IF !ExecCommand(CSQL,"u_art_ko")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_ASC_DD"
IF !ExecCommand(CSQL,"U_ASC_DD")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_ASC_TT"
IF !ExecCommand(CSQL,"U_ASC_TT")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_AVA_RI"
IF !ExecCommand(CSQL,"U_AVA_RI")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_AVA_SM"
IF !ExecCommand(CSQL,"U_AVA_SM")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_AVA_SP"
IF !ExecCommand(CSQL,"U_AVA_SP")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_AVA_TG"
IF !ExecCommand(CSQL,"U_AVA_TG")
   RETURN (.f.)
ENDIF

*!*	CSQL = "DELETE FROM U_AZI_AN"
*!*	IF !ExecCommand(CSQL,"U_AZI_AN")
*!*	   RETURN (.f.)
*!*	ENDIF

*!*	CSQL = "DELETE FROM U_AZI_PA"
*!*	IF !ExecCommand(CSQL,"U_AZI_PA")
*!*	   RETURN (.f.)
*!*	ENDIF

CSQL = "DELETE FROM U_BEN_BE"
IF !ExecCommand(CSQL,"U_BEN_BE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_BFO_DL"
IF !ExecCommand(CSQL,"U_BFO_DL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_BOL_LE"
IF !ExecCommand(CSQL,"U_BOL_LE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_CAM_AN"
IF !ExecCommand(CSQL,"U_CAM_AN")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_CAN_RE"
IF !ExecCommand(CSQL,"U_CAN_RE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_CCO_DD"
IF !ExecCommand(CSQL,"U_CCO_DD")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_CCO_TT"
IF !ExecCommand(CSQL,"U_CCO_TT")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_COM_PE"
IF !ExecCommand(CSQL,"U_COM_PE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_ELA_AN"
IF !ExecCommand(CSQL,"U_ELA_AN")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_ELA_ER"
IF !ExecCommand(CSQL,"U_ELA_ER")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_FIN_DD"
IF !ExecCommand(CSQL,"U_FIN_DD")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_FIN_TT"
IF !ExecCommand(CSQL,"U_FIN_TT")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_GPE_AN"
IF !ExecCommand(CSQL,"U_GPE_AN")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_GPP_MO"
IF !ExecCommand(CSQL,"U_GPP_MO")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_LIC_AN"
IF !ExecCommand(CSQL,"U_LIC_AN")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_MPA_CQ"
IF !ExecCommand(CSQL,"U_MPA_CQ")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_MPF_CQ"
IF !ExecCommand(CSQL,"U_MPF_CQ")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_ORD_DL"
IF !ExecCommand(CSQL,"U_ORD_DL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_ORF_DL"
IF !ExecCommand(CSQL,"U_ORF_DL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PAR_CQ"
IF !ExecCommand(CSQL,"U_PAR_CQ")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PAR_FI"
IF !ExecCommand(CSQL,"U_PAR_FI")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PAR_MY"
IF !ExecCommand(CSQL,"U_PAR_MY")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PCK_DD"
IF !ExecCommand(CSQL,"U_PCK_DD")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PCK_LE"
IF !ExecCommand(CSQL,"U_PCK_LE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PCK_TT"
IF !ExecCommand(CSQL,"U_PCK_TT")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PDV_BA"
IF !ExecCommand(CSQL,"U_PDV_BA")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PED_PL"
IF !ExecCommand(CSQL,"U_PED_PL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_CL"
IF !ExecCommand(CSQL,"U_PRG_CL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_DL"
IF !ExecCommand(CSQL,"U_PRG_DL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_DO"
IF !ExecCommand(CSQL,"U_PRG_DO")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_LT"
IF !ExecCommand(CSQL,"U_PRG_LT")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_RA"
IF !ExecCommand(CSQL,"U_PRG_RA")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_RI"
IF !ExecCommand(CSQL,"U_PRG_RI")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_RR"
IF !ExecCommand(CSQL,"U_PRG_RR")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_RT"
IF !ExecCommand(CSQL,"U_PRG_RT")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_SM"
IF !ExecCommand(CSQL,"U_PRG_SM")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_SP"
IF !ExecCommand(CSQL,"U_PRG_SP")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRG_TG"
IF !ExecCommand(CSQL,"U_PRG_TG")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRO_AL"
IF !ExecCommand(CSQL,"U_PRO_AL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRO_CA"
IF !ExecCommand(CSQL,"U_PRO_CA")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRO_IM"
IF !ExecCommand(CSQL,"U_PRO_IM")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_PRO_MY"
IF !ExecCommand(CSQL,"U_PRO_MY")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_SLC_CQ"
IF !ExecCommand(CSQL,"U_SLC_CQ")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_VEN_CL"
IF !ExecCommand(CSQL,"U_VEN_CL")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_VVA_CH"
IF !ExecCommand(CSQL,"U_VVA_CH")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM UCLIAN"
IF !ExecCommand(CSQL,"UCLIAN")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM ZONET_VE"
IF !ExecCommand(CSQL,"ZONET_VE")
   RETURN (.f.)
ENDIF

CSQL = "DELETE FROM U_MAG_AN"
IF !ExecCommand(CSQL,"U_MAG_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_AR"
IF !ExecCommand(CSQL,"U_MAG_AR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_CA"
IF !ExecCommand(CSQL,"U_MAG_CA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_CL"
IF !ExecCommand(CSQL,"U_MAG_CL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_CP"
IF !ExecCommand(CSQL,"U_MAG_CP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_DA"
IF !ExecCommand(CSQL,"U_MAG_DA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_DF"
IF !ExecCommand(CSQL,"U_MAG_DF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_DM"
IF !ExecCommand(CSQL,"U_MAG_DM")
   RETURN (.f.)
ENDIF 


CSQL = "DELETE FROM U_MAG_FO"
IF !ExecCommand(CSQL,"U_MAG_FO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_GG"
IF !ExecCommand(CSQL,"U_MAG_GG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_IN"
IF !ExecCommand(CSQL,"U_MAG_IN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_MA"
IF !ExecCommand(CSQL,"U_MAG_MA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_MF"
IF !ExecCommand(CSQL,"U_MAG_MF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_MO"
IF !ExecCommand(CSQL,"U_MAG_MO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_PR"
IF !ExecCommand(CSQL,"U_MAG_PR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_RI"
IF !ExecCommand(CSQL,"U_MAG_RI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_SA"
IF !ExecCommand(CSQL,"U_MAG_SA")
   RETURN (.f.)
ENDIF 


PUB_ERRORE=MESSAGEBOX('Fine startup archivi Aquarius',64,'*** ATTENZIONE ***') 

RETURN
