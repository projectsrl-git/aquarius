x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP
IF EOF()
   _ALRID  = "20"
   _ESENZI = .F.				&& CLIENTE NON IN ESENZIONE
ELSE
   _ALRID = CLI_ALRID
   IF !EMPTY(CLI_ALRID)
      _ESENZI = .T.			&& CLIENTE IN ESENZIONE
   ELSE
      _ALRID  = "20"
      _ESENZI = .F.			&& CLIENTE NON IN ESENZIONE
   ENDIF
ENDIF

M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
MATPUBX     = 0

x_cond = "daggancio = '" + M.TAGGANCIO + "'"
cSql="SELECT * FROM U_BOL_DD WHERE " + x_cond + " order by daggancio"
IF !ExecCommand(cSql,"CUR_DETT")
   return(.f.)
ENDIF
SELECT CUR_DETT
GO TOP
       
IVA1   = SPACE(03)
IVA2   = SPACE(03)
IVA3   = SPACE(03)
IVA4   = SPACE(03)
IVA5   = SPACE(03)
IMPO1  = 0
IMPO2  = 0
IMPO3  = 0
IMPO4  = 0
IMPO5  = 0
IMPOS1 = 0
IMPOS2 = 0
IMPOS3 = 0
IMPOS4 = 0
IMPOS5 = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT CUR_DETT
      SKIP +1
      LOOP
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)

   IF ORD_PUBBLI = "S"
      MATPUBX = MATPUBX + ORD_VALORE
   ENDIF

   v_seek	= 'IVA' + COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF  
  
   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

   IF ((IVA1 = SPACE(3)) .OR. (IVA1 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
      IVA1   = COD_IVA
      IMPO1  = IMPO1+IMPONIB
      IMPOS1 = IMPOS1 + IMPOSTA
   ELSE
      IF ((IVA2 = SPACE(3)) .OR. (IVA2 = COD_IVA))  .AND. (DES_ART <> ('*** COMMENTO ***'))
         IVA2   = COD_IVA
         IMPO2  = IMPO2+IMPONIB
         IMPOS2 = IMPOS2 + IMPOSTA
      ELSE
         IF ((IVA3 = SPACE(3)) .OR. (IVA3 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
            IVA3   = COD_IVA
            IMPO3  = IMPO3+IMPONIB
            IMPOS3 = IMPOS3 + IMPOSTA
         ELSE
            IF ((IVA4 = SPACE(3)) .OR. (IVA4 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
               IVA4   = COD_IVA
               IMPO4  = IMPO4+IMPONIB
               IMPOS4 = IMPOS4 + IMPOSTA
            ELSE
               IF ((IVA5 = SPACE(3)) .OR. (IVA5 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
                  IVA5   = COD_IVA
                  IMPO5  = IMPO5+IMPONIB
                  IMPOS5 = IMPOS5 + IMPOSTA
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   SELECT CUR_DETT
   SKIP +1

ENDDO

V_SPESE = M.ORD_SPBOLL + M.ORD_SPTRAS

PUB_ALIQ = CERCA_IVA_DEFAULT("U_BOL_DD","ALIQUOTA")  && ERASMO - 21/09/2011

IF !_ESENZI      					&& SOLO SE NON IN ESENZIONE
   *V_IMPSP = V_SPESE * (20/100)
   V_IMPSP = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011
ELSE
   V_IMPSP = 0		 				&& ESENTE
ENDIF

* -->> INSERISCO L'IVA DELLE SPESE(20%) SULLE IVE AL 20
FOR HF=1 TO 5
   _IMPO ="IMPO"+ALLTRIM(STR(HF))
   _IMPOS="IMPOS"+ALLTRIM(STR(HF))
   IF &_IMPO=0
  	  LOOP
   ENDIF	
   *IF ROUND((&_IMPOS/&_IMPO)*100,0)=VAL(PUB_IVA)
   IF ROUND((&_IMPOS/&_IMPO)*100,0)=PUB_ALIQ  && ERASMO - 21/09/2011
      &_IMPOS=&_IMPOS+V_IMPSP
      EXIT
   ENDIF
NEXT

IMPOS1 = ROUND((IMPOS1+.0000),2)
IMPOS2 = ROUND((IMPOS2+.0000),2)
IMPOS3 = ROUND((IMPOS3+.0000),2)
IMPOS4 = ROUND((IMPOS4+.0000),2)		
IMPOS5 = ROUND((IMPOS5+.0000),2)

M.T_IMPONIB = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5
M.T_IMPOSTA = IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5

M.T_IMPONIB = M.T_IMPONIB + V_SPESE
M.T_VALORE  = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX

IVA1   = ""
IVA2   = ""
IVA3   = ""
IVA4   = ""
IVA5   = ""
IMPO1  = 0
IMPO2  = 0
IMPO3  = 0
IMPO4  = 0
IMPO5  = 0
IMPOS1 = 0
IMPOS2 = 0
IMPOS3 = 0
IMPOS4 = 0
IMPOS5 = 0

RETURN