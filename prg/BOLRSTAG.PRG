v_seek	= 'TOP' + M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CAUS = DESCRI
ELSE
   SAY_CAUS = ""
ENDIF

v_seek	= 'MEZ' + M.ORD_ACURA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ACURA = DESCRI
ELSE
   SAY_ACURA = ""
ENDIF

v_seek	= 'ASP' + M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_ASPETT = DESCRI
ELSE
   SAY_ASPETT = ""
ENDIF

v_seek	= 'POR' + M.ORD_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = DESCRI
ELSE
   SAY_PORTO = ""
ENDIF

v_seek	= 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESVET = DESCRI
   INDVET = ALLTRIM(LIBERA)
ELSE
   DESVET = ""
   INDVET = ""
ENDIF

v_seek	= 'AGE' + M.ORD_AGE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   AGENTE = DESCRI
ELSE
   AGENTE = ""
ENDIF

v_seek	= 'CPA' + M.ORD_CPA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_CPA = SUBSTR(DESCRI,1,30)
ELSE
   SAY_CPA = ""
ENDIF

**=> ERASMO - INIZIO 24/07/2008
x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
x_codi = "ban_codban = '" + M.ORD_BANCA + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
IF !ExecCommand(cSql,"CUR_PARA")
   RETURN .F.
ENDIF
SELECT CUR_PARA
GO TOP
IF EOF()
   SAY_BANCA=""
ELSE
   SAY_BANCA=SUBSTR(BAN_DESBAN,1,30)
ENDIF

IF SUBSTR(M.ORD_DATORD,5,1) = "/"
   M.ORD_DATORD = RIBALTA2(M.ORD_DATORD)
ENDIF
**=> ERASMO - FINE 24/07/2008

SELECT CU_BOL_DD
GO TOP

ANCORA = 1 

IF PUB_STFAD 
   DO PRG\BOLSTAM WITH "RISTAMPA"   && GESTIONE DOS

   SELECT FILE_PRT
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
	  SCATTER MEMVAR MEMO
	  SELECT BOLL_STA
	  APPEND BLANK
	  GATHER MEMVAR
	  SELECT FILE_PRT
	  SKIP +1
   ENDDO

   SELECT BOLL_STA			&& AGGIUNGE UNA RIGA PER POSIZIONARSI SULLA PAGINA SUCCESSIVA
   APPEND BLANK
ELSE
   SELECT CU_BOL_DD
   GO BOTTOM
   APPEND BLANK
   REPLACE DAGGANCIO WITH 'EOF'
   GO TOP
   IF SOLO_UNO
	  SOLO_UNO = .F.
      IF !EOF()
         DO PRG\MENUSTA WITH "CU_BOL_DD",.T.,.T.,"XXX","BOLPJITA","BOL000.FRX"
      ELSE
         =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
      ENDIF
   ELSE
      IF !EOF()
         DO PRG\MENUSTA WITH "CU_BOL_DD",.T.,.T.,"XXX","BOLPJITA","BOL000.FRX"
      ELSE
         =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
      ENDIF
   ENDIF
   SELECT CU_BOL_DD
   GO BOTTOM
   IF SUBSTR(DAGGANCIO,1,3) = 'EOF'
      DELETE
   ENDIF
   GO TOP
ENDIF