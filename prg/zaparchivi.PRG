 
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
