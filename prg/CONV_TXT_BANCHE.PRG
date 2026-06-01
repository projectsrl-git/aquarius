
RIT = MESSAGEBOX("Procedo con l'acquisizione dell'"+CHR(13)+"anagrafica banche da file di testo?",292,"Attenzione")
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",62,"Attenzione")
   RETURN
ENDIF

CREATE CURSOR TRANSITO (TRA_RECORD C(200))

SELECT TRANSITO  
gcTable = GETFILE("","","Converti",0,"Selezionare il file di anagrafica banche da convertire")
IF empty(gcTable) .or. gcTable = ""
   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF
APPEND FROM &gcTable SDF
GO TOP

V_CONTA_INS = 0
V_CONTA_AGG = 0
   
_WW_DESCR1 = ""
_WW_DESCR2 = ""
_XX_CODBAN = ""
_XX_DESBAN = ""
_XX_INDIR  = ""
_XX_CAP    = ""
_XX_LOCA   = ""
_XX_CODABI = ""
_XX_CODCAB = ""
_XX_PROVIN = ""
_XX_DATINS = ""
   
SELECT TRANSITO
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   WAIT WINDOWS "Lettura riga " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) NOWAIT   
   
   IF EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,1,2)))
      SKIP +1
      LOOP
   ENDIF 
   
   IF SUBSTR(TRA_RECORD,1,2) = "11" .OR. SUBSTR(TRA_RECORD,1,2) = "21" .OR. SUBSTR(TRA_RECORD,1,2) = "31"
   ELSE
      SKIP +1
      LOOP
   ENDIF    
   
   IF ALLTRIM(SUBSTR(TRA_RECORD,1,2)) = "11"
      _WW_DESCR1 = ""
      _WW_DESCR2 = ""
      _XX_CODBAN = ""
      _XX_DESBAN = ""
      _XX_INDIR  = ""
      _XX_CAP    = ""
      _XX_LOCA   = ""
      _XX_CODABI = ""
      _XX_CODCAB = ""
      _XX_PROVIN = ""
      _XX_DATINS = ""   
      _WW_DESCR1 = APITOSPA(SUBSTR(TRA_RECORD,14,40))
      _XX_CODABI = ALLTRIM(SUBSTR(TRA_RECORD,3,5))
      SELECT TRANSITO
      SKIP +1
      LOOP
   ENDIF
   
   IF ALLTRIM(SUBSTR(TRA_RECORD,1,2)) = "21"
      _XX_INDIR  = APITOSPA(ALLTRIM(SUBSTR(TRA_RECORD,21,50)))
      _XX_LOCA   = APITOSPA(ALLTRIM(SUBSTR(TRA_RECORD,141,30)))
      _XX_CAP    = APITOSPA(ALLTRIM(SUBSTR(TRA_RECORD,181,5)))
      _XX_PROVIN = APITOSPA(ALLTRIM(SUBSTR(TRA_RECORD,186,2)))
      _XX_CODCAB = ALLTRIM(SUBSTR(TRA_RECORD,8,5))
      SELECT TRANSITO
      SKIP +1
      LOOP
   ENDIF
   
   IF ALLTRIM(SUBSTR(TRA_RECORD,1,2)) = "31"
      _WW_DESCR2 = APITOSPA(SUBSTR(TRA_RECORD,13,40))
      _XX_DESBAN = ALLTRIM(_WW_DESCR1) + " - " + ALLTRIM(_WW_DESCR2)
      
      *** VERIFICA ESISTENZA BANCA
      x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
      x_cabi = "ban_codabi = '" + _XX_CODABI + "'"
      x_ccab = "ban_codcab = '" + _XX_CODCAB + "'"
      x_cond = x_soci + " and " + x_cabi + " and " + x_ccab
      cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codabi,ban_codcab"
      IF !ExecCommand(cSql,"CUR_BAN_AN")
         return(.f.)
      ENDIF
      SELECT CUR_BAN_AN
      GO TOP
      IF EOF()
         *** RICERCA NUOVO NUMERO BANCA
         _seek = 'NUMBAN'+PUB_CODSOC
         TEXT TO cSql NOSHOW
            SELECT *
            FROM para
            where codice = ?_seek
         ENDTEXT
         IF !ExecRW(cSql,"para","R")
            return(.f.)
         ENDIF
         SELECT PARA
         IF RECCOUNT() > 0
            S_NUM      = SUBSTR(LIBERA,1,10)
            N_NUM      = VAL(S_NUM)
            INC_NUM    = N_NUM + 1
            S_INC_NUM  = STR(INC_NUM,10,0)
            _XX_CODBAN = ALLTRIM(S_INC_NUM)
            _XX_CODBAN = TRC(5,ALLTRIM(_XX_CODBAN))
            REPLACE LIBERA WITH S_INC_NUM 
         ELSE
            MESSAGEBOX('Parametro << NUMBAN >> non trovato',16,'*** ATTENZIONE ***') 
            return(.f.)
         ENDIF
         IF !ExecRW(cSql,"para","W")
            return(.f.)
         ENDIF
         *** INSERIMENTO NUOVA BANCA
         _XX_DATINS = RIBALTA2(DTOC(DATE()))
         cSql = "select * from u_ban_an where 1=0"
         IF !ExecRW(cSql,"U_BAN_AN","R")
            return(.f.)
         ENDIF
         SELECT U_BAN_AN
         APPEND BLANK
         REPLACE BAN_CODSOC WITH PUB_CODSOC
         REPLACE BAN_CODBAN WITH _XX_CODBAN 
         REPLACE BAN_DESBAN WITH _XX_DESBAN 
         REPLACE BAN_INDIR  WITH _XX_INDIR  
         REPLACE BAN_CAP    WITH _XX_CAP    
         REPLACE BAN_LOCA   WITH _XX_LOCA   
         REPLACE BAN_CODABI WITH _XX_CODABI 
         REPLACE BAN_CODCAB WITH _XX_CODCAB 
         REPLACE BAN_PROVIN WITH _XX_PROVIN 
         REPLACE BAN_DATINS WITH _XX_DATINS                                                                                
         IF !ExecRW("","U_BAN_AN","W")
            return(.f.)
         ENDIF
         V_CONTA_INS = V_CONTA_INS + 1
      ELSE
         x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
         x_cabi = "ban_codabi = '" + _XX_CODABI + "'"
         x_ccab = "ban_codcab = '" + _XX_CODCAB + "'"
         x_cond = x_soci + " and " + x_cabi + " and " + x_ccab
         cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codabi,ban_codcab"
         IF !ExecRW(cSql,"U_BAN_AN","R")
            return(.f.)
         ENDIF
         SELECT U_BAN_AN
         GO TOP
         REPLACE BAN_DESBAN WITH _XX_DESBAN 
         REPLACE BAN_INDIR  WITH _XX_INDIR  
         REPLACE BAN_CAP    WITH _XX_CAP    
         REPLACE BAN_LOCA   WITH _XX_LOCA
         REPLACE BAN_PROVIN WITH _XX_PROVIN
         IF !ExecRW("","U_BAN_AN","W")
            return(.f.)
         ENDIF
         V_CONTA_AGG = V_CONTA_AGG + 1
      ENDIF
      SELECT TRANSITO
      SKIP +1
      LOOP      
   ENDIF   
   
ENDDO

WAIT CLEAR

IF V_CONTA_INS > 0 .OR. V_CONTA_AGG > 0
   MESSAGEBOX("Aggiornamento anagrafica banche concluso correttamente" + CHR(13) + CHR(13) + ;
              "Totale banche inserite : " + ALLTRIM(STR(V_CONTA_INS,10,0)) + CHR(13) + ;
              "Totale banche aggiornate : " + ALLTRIM(STR(V_CONTA_AGG,10,0)),64,"Informazione")
ELSE
   MESSAGEBOX("Nessun Aggiornamento/Inserimento in anagrafica banche effettuato" + CHR(13) + CHR(13) + ;
              "Verificare il file selezionato",16,"Attenzione")
ENDIF

RETURN
   
