*******************************************************************************************
***				PROJECT SRL  LIBRERIA DELLE FUNZIONI VARIE								***
*******************************************************************************************




************************
FUNCTION CAMBIADT
************************
PARA _DATA,_NOMEDT

IF _DATA = '  /  /    ' .OR. _DATA = SPACE(10) .OR. ;
   _DATA = '    /  /  ' .OR. EMPTY(_DATA)
   REPLACE &_NOMEDT WITH SPACE(10)
ELSE
   IF SUBSTR(_DATA,3,1) = '/'
      REPLACE &_NOMEDT WITH RIBALTA2(_DATA)
   ELSE
      REPLACE &_NOMEDT WITH _DATA
   ENDIF
ENDIF

RETURN(.T.)

************************
FUNCTION GETORFO
************************
**--> RECUPERA L'ORDINATO A FORNITORI PER QUELL'ARTICOLO TENENDO CONTO
**--> DELLA DATA DI SCADENZA DELLA COMMESSA
PARA ARTI,SCAD,FORNI,MAGA
SS1=STR(SELECT())

_N_PAR = PARAMETERS()
IF _N_PAR = 2
    L_FORNI = SPACE(10)
    L_MAGA  = SPACE(06)
ELSE
   IF _N_PAR = 3
       L_FORNI = FORNI
       L_MAGA  = SPACE(06)
   ELSE
       L_FORNI = FORNI
       L_MAGA  = MAGA      
   ENDIF
ENDIF

IF SUBSTR(SCAD,3,1) = '/'
   SCAD = RIBALTA2(SCAD)
ENDIF

OUT=0

IF PUB_CTRORF
ELSE
   M.ORD_QTAORF = 0
   SELECT &SS1
   RETURN(OUT)
ENDIF

v_seek   = ARTI
v_chiave = "ord_codart"
IF seek_std('u_orf_dd',v_seek,v_chiave,'CUR_ORDFOR_DD')
   SELECT CUR_ORDFOR_DD
   OUT=0
   DO WHILE !EOF()
      IF ALLTRIM(ORD_CODART)<>ALLTRIM(ARTI)
         EXIT
      ENDIF
      IF ORD_CHIUSO
         SKIP +1
         LOOP
      ENDIF
      IF EMPTY(L_FORNI) .OR. L_FORNI = SPACE(10)
      ELSE
         IF ORS_CODCLI = L_FORNI
         ELSE
            SKIP +1
            LOOP
         ENDIF
      ENDIF
      IF EMPTY(L_MAGA) .OR. L_MAGA = SPACE(06)
      ELSE
         IF ORS_MAGD = L_MAGA
         ELSE
            SKIP +1
            LOOP
         ENDIF
      ENDIF
      x_agga = "taggancio = '" + ALLTRIM(DAGGANCIO) + "'"
      x_cond = x_agga
      cSql   = "SELECT * FROM U_ORF_TT WHERE " + x_cond
      IF !ExecCommand(cSql,"CUR_ORDFOR_TT")
         return(.f.)
      ENDIF
      SELECT CUR_ORDFOR_TT
      IF EOF()
         SELECT CUR_ORDFOR_DD
         SKIP +1
         LOOP
      ENDIF
      IF ORD_FLGTIP
         SELECT CUR_ORDFOR_DD
         SKIP +1
         LOOP
      ENDIF            
      SELECT CUR_ORDFOR_DD
      V_QODET = ORD_QTAORD
      V_QEDET = ORD_QTAEV
      V_AGGA  = DAGGANCIO 
      IF PUB_QTAORF                  && NON TIENE CONTO DELLA DATA DI SCADENZA
         OUT=OUT + (V_QODET - V_QEDET)
      ELSE
         IF SCAD < ORD_DATCON
         ELSE
            OUT=OUT + (V_QODET - V_QEDET)
         ENDIF
      ENDIF
      SELECT CUR_ORDFOR_DD          
      SKIP +1
   ENDDO    
ELSE
   OUT=0
ENDIF

SELECT &SS1
RETURN(OUT)


************************
FUNCTION GETORDC
************************
**--> RECUPERA L'ORDINATO DA CLIENTI PER QUELL'ARTICOLO TENENDO CONTO
**--> DELLA DATA DI SCADENZA
PARA ARTI,SCAD,MAGA
SS1=STR(SELECT())

_N_PAR = PARAMETERS()
IF _N_PAR = 2
    L_MAGA  = SPACE(06)
ELSE
    L_MAGA  = MAGA      
ENDIF

IF SUBSTR(SCAD,3,1) = '/'
   SCAD = RIBALTA2(SCAD)
ENDIF

OUT=0

v_seek   = ARTI
v_chiave = "ord_codart"
IF seek_std('u_ord_dd',v_seek,v_chiave,'CUR_ORDCLI_DD')
   SELECT CUR_ORDCLI_DD
   DO WHILE !EOF()
      IF ALLTRIM(ORD_CODART)<>ALLTRIM(ARTI)
         EXIT
      ENDIF
      IF ORD_CHIUSO
         SKIP +1
         LOOP
      ENDIF
      IF EMPTY(L_MAGA) .OR. L_MAGA = SPACE(06)
      ELSE
         IF ORD_MAGA = L_MAGA
         ELSE
            SKIP +1
            LOOP
         ENDIF
      ENDIF
      V_QODET = ORD_QTAORD
      V_QEDET = ORD_QTAEV
      V_AGGA  = DAGGANCIO 
      OUT=OUT + (V_QODET - V_QEDET)
      SELECT CUR_ORDCLI_DD          
      SKIP +1
   ENDDO    
ENDIF

SELECT &SS1
RETURN(OUT)


************************
FUNCTION GETCTLA
************************
**--> RECUPERA L'ORDINATO IN CONTO LAVORO PER QUELL'ARTICOLO TENENDO CONTO
**--> DELLA DATA DI SCADENZA DELLA COMMESSA
 
PARA ARTI,SCAD
SS1=STR(SELECT())

IF SUBSTR(SCAD,3,1) = '/'
   SCAD = RIBALTA2(SCAD)
ENDIF

OUT=0

v_seek   = ARTI
v_chiave = "ord_codart"
IF seek_std('u_ctl_dd',v_seek,v_chiave,'CUR_ORDCTL_DD')
   SELECT CUR_ORDCTL_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF ALLTRIM(ORD_CODART)<>ALLTRIM(ARTI)
         EXIT
      ENDIF
      IF ORD_CHIUSO
         SKIP +1
         LOOP
      ENDIF
      V_QODET = ORD_QTAORD
      V_QEDET = ORD_QTAEV
      V_AGGA = DAGGANCIO 
      IF PUB_QTAORF                  && NON TIENE CONTO DELLA DATA DI SCADENZA
         OUT=OUT + (V_QODET - V_QEDET)
      ELSE
         IF SCAD < ORD_DATCON
         ELSE
            OUT=OUT + (V_QODET - V_QEDET)
         ENDIF
      ENDIF
      SELECT U_CTL_DD          
      SKIP +1
   ENDDO    
ENDIF

SELECT &SS1
RETURN(OUT)


************************
FUNCTION GETGIAC
************************
**--> RECUPERA LA GIACENZA PER ARTICOLO E SEDE
**--> _OPZ  => 1=GIACENZA EFFETTIVA    
**-->          2=GIACENZA DINAMICA IN DIMINUZIONE (CURSORE)
**-->          3=GIACENZA DINAMICA STATICA (CURSORE)
**--> _MAG  => CODICE MAGAZZINO SCARICO
**--> _MAGD => CODICE MAGAZZINO CARICO
**--> _ART  => CODICE ARTICOLO
**--> _ORD  => QUANTITA' ORDINATA
**--> _EVA  => QUANTITA' EVASA

PARA _OPZ,_MAG,_MAGD,_ART,_ORD,_EVA

SS1=STR(SELECT())

IF _OPZ = 1 
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(_ART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecCommand(cSql,"cur_giacenze")
      return(.f.)
   ENDIF
   SELECT cur_giacenze
   GO TOP
   IF EOF()
      OUT = 0
   ELSE
      OUT = MAG_GIACEN
   ENDIF
ENDIF

IF _OPZ = 2 
   SELECT CU_MAG_AN
   GO TOP
   LOCATE FOR MAG_CODSOC = PUB_CODSOC .AND. ;
              MAG_CODMAG = _MAG .AND. ;
              MAG_CODART = _ART
   IF FOUND()
      OUT = MAG_GIACEN
   ELSE
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(_ART) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"cur_giacenze")
         return(.f.)
      ENDIF
      SELECT cur_giacenze
      GO TOP
      IF EOF()
         M.MAG_CODSOC = PUB_CODSOC
         M.MAG_CODMAG = _MAG
         M.MAG_CODART = _ART
         M.MAG_GIACEN = 0 
      ELSE
         SCATTER MEMVAR MEMO
      ENDIF
      SELECT CU_MAG_AN
      APPEND BLANK
      GATHER MEMVAR MEMO  
      OUT = MAG_GIACEN
   ENDIF
   REPLACE MAG_GIACEN WITH MAG_GIACEN - (_ORD - _EVA)
   IF _MAGD = SPACE(06)
   ELSE
      GO TOP
      LOCATE FOR MAG_CODSOC = PUB_CODSOC .AND. ; 
                 MAG_CODMAG = _MAGD .AND. ;
                 MAG_CODART = _ART
      IF FOUND()
      ELSE
         x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
         x_maga = "mag_codmag = '" + ALLTRIM(_MAGD) + "'"
         x_codi = "mag_codart = '" + ALLTRIM(_ART) + "'"
         x_cond = x_soci + " and " + x_maga + " and " + x_codi
         Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
         IF !ExecCommand(cSql,"cur_giacenze")
            return(.f.)
         ENDIF
         SELECT cur_giacenze
         GO TOP
         IF EOF()
            M.MAG_CODSOC = PUB_CODSOC
            M.MAG_CODMAG = _MAGD
            M.MAG_CODART = _ART
            M.MAG_GIACEN = 0  
         ELSE
            SCATTER MEMVAR MEMO
         ENDIF
         SELECT CU_MAG_AN
         APPEND BLANK
         GATHER MEMVAR MEMO  
      ENDIF
      REPLACE MAG_GIACEN WITH MAG_GIACEN + (_ORD - _EVA)
   ENDIF
ENDIF   

IF _OPZ = 3 
   SELECT CU_MAG_AN
   GO TOP
   LOCATE FOR MAG_CODSOC = PUB_CODSOC .AND. ;
              MAG_CODMAG = _MAG .AND. ;
              MAG_CODART = _ART
   IF FOUND()
      OUT = MAG_GIACEN
   ELSE
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(_ART) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"cur_giacenze")
         return(.f.)
      ENDIF
      SELECT cur_giacenze
      GO TOP
      IF EOF()
         M.MAG_CODSOC = PUB_CODSOC
         M.MAG_CODMAG = _MAG
         M.MAG_CODART = _ART
         M.MAG_GIACEN = 0 
      ELSE
         SCATTER MEMVAR MEMO
      ENDIF
      SELECT CU_MAG_AN
      APPEND BLANK
      GATHER MEMVAR MEMO  
      OUT = MAG_GIACEN
   ENDIF
ENDIF   

SELECT &SS1
RETURN(OUT)


********************************
FUNCTION LASTPRE
********************************
**--> RITORNA IL PREZZO DI COSTO

PARA ARTICO

SS=STR(SELECT())

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(ARTICO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF EOF()
   OUT = 0
ELSE
   OUT = ART_PRZCOS
ENDIF

SELECT &SS

RETURN(OUT)

******************************
FUNCTION GIRA
******************************
PARAMETERS CHI
_APPO=SUBSTR(CHI,3,2)+SUBSTR(CHI,1,2)
RETURN(_APPO)


***************************************************************************
PROCEDURE ALBERELLO
***************************************************************************

PARA SI_VIDEO,XXGRUPPO,LIV_ESPL,_MAG

_N_PAR = PARAMETERS()
IF _N_PAR = 2
   LIV_ESPL = .F.
   _MAG = ""
ENDIF
IF _N_PAR = 3
   _MAG = ""
ENDIF

PUBLIC LIV_ESPLN
LIV_ESPLN = 0

IF LIV_ESPL = .F.
   v_seek	= 'NUM'+'LDB'+'LIV'
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      LIV_ESPLN = VAL(SUBSTR(LIBERA,1,2))
      IF LIV_ESPLN > 98
         LIV_ESPLN = 98
      ENDIF         
   ELSE
      LIV_ESPLN = 98
   ENDIF
ELSE
   LIV_ESPLN = 98
ENDIF
IF LIV_ESPLN < 1
   LIV_ESPLN = 98
ENDIF         
LIV_ESPLN = LIV_ESPLN + 1

CREATE CURSOR WEXPLODE (WCOD  C(16),  WDES C(40),    WCOS N(17,2), WPRZ N(17,2),  ;
                        WTIP  C(1) ,  WLIV N(4) ,    WQTA N(9,2) , WGIA N(9,2) ,  ;
                        WIMP  N(9,2), WDIS N(9,2),   TREE C(100), WEXP C(1), ;
                        WQTAT N(9,2), WCOST N(17,2), WPRZT N(17,2))

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "dit_gruppo = '" + ALLTRIM(XXGRUPPO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"cur_diba")
   return(.f.)
ENDIF
SELECT cur_diba
GO TOP
IF EOF()
   RETURN
ENDIF

_V_CODART=DIT_GRUPPO
_V_DESCRI=DIT_DESCRI
_V_COSTO =DIT_COSTO
_V_PREZZO=DIT_PREZZO
CNT=1

SELECT WEXPLODE
APPEND BLANK
REPLACE WCOD  WITH _V_CODART
REPLACE WDES  WITH _V_DESCRI
REPLACE WCOS  WITH _V_COSTO
REPLACE WPRZ  WITH _V_PREZZO
REPLACE WTIP  WITH "T"
REPLACE WLIV  WITH CNT
REPLACE WQTA  WITH 1
REPLACE TREE  WITH _V_CODART
REPLACE WQTAT WITH 1
REPLACE WCOST WITH _V_COSTO
REPLACE WPRZT WITH _V_PREZZO

DO TROVA WITH XXGRUPPO

* RIELABORA IL CURSORE CON I COMPONENTI
*
* PER OGNI ARTICOLO :
* ACCEDE AL MAGAZZINO PER PRELEVARE LA GIACENZA E L'IMPEGNATO
* EFFETTUA IL CALCOLO DELLA DISPONIBILITA'
* RIAGGIORNA IL CURSORE STESSO
* MOSTRA A VIDEO IL CURSORE  (TUTTI I COMPONENTI O SOLO I NON DISPONIBILI?)

SELECT WEXPLODE
GO TOP

DO WHILE !EOF()

	SELECT WEXPLODE
    ARTI=WCOD

    IF EMPTY(_MAG) .OR. _MAG = SPACE(06)
       x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
       x_codi = "mag_codart = '" + ALLTRIM(ARTI) + "'"
       x_cond = x_soci + " and " + x_codi
       Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codart"
    ELSE
       x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
       x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
       x_codi = "mag_codart = '" + ALLTRIM(ARTI) + "'"
       x_cond = x_soci + " and " + x_maga + " and " + x_codi
       Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
    ENDIF
    IF !ExecCommand(cSql,"cur_giacenze")
       return(.f.)
    ENDIF
    SELECT cur_giacenze
    GO TOP
    IF EOF()
	   V_GIACEN = 0
	   V_IMPORD = 0
	   V_DISPON = 0
    ELSE
       V_GIACEN = 0
       V_IMPORD = 0 
	   V_DISPON = 0
       DO WHILE .T.
          IF EOF()
             EXIT
          ENDIF
          IF DELETED()
             SKIP +1
             LOOP
          ENDIF
          V_GIACEN = V_GIACEN + MAG_GIACEN
	      V_IMPORD = V_IMPORD + MAG_IMPORD 
	      V_DISPON = V_DISPON + (MAG_GIACEN - MAG_IMPORD)
          SKIP +1
       ENDDO
    ENDIF
	
	SELECT WEXPLODE

	REPLACE WGIA WITH V_GIACEN
	REPLACE WIMP WITH V_IMPORD
	REPLACE WDIS WITH V_DISPON
	
	SELECT WEXPLODE
	SKIP+1

ENDDO	

SELECT WEXPLODE
PUN = RECCOUNT()
K   = SPACE(0)

SELECT WEXPLODE
GO TOP
DELETE FOR WLIV > LIV_ESPLN ALL
GO TOP

IF SI_VIDEO
   V_TIT="ESPLOSIONE GRUPPO - "+XXGRUPPO
   *IF PUB_PREZZI 
   *   V_TES="ALBERO:TREE:32;Q.TA:WQTA:9;GIACENZA:WGIA:9;DESCRIZIONE:WDES:30;TIPO:WTIP:1"
   *ELSE
   *   V_TES="ALBERO:TREE:32;Q.TA:WQTA:9;GIACENZA:WGIA:9;DESCRIZIONE:WDES:30;PREZZO:WPRZ:10;COSTO:WCOS:10;TIPO:WTIP:1"
   *ENDIF
   IF PUB_PREZZI 
	  V_TES="ALBERO:TREE:32;QTA.1:WQTA:9;QTA.T:WQTAT:9;GIACENZA:WGIA:9;DESCRIZIONE:WDES:30;TIPO:WTIP:1"
   ELSE
	  V_TES="ALBERO:TREE:32;QTA.1:WQTA:9;QTA.T:WQTAT:9;GIACENZA:WGIA:9;DESCRIZIONE:WDES:30;PREZZO:WPRZ:10;COSTO:WCOS:10;TIPO:WTIP:1"
   ENDIF
   =WSHOWDBF("WEXPLODE",V_TIT,V_TES)
ENDIF

RETURN

************************************************************************
PROCEDURE TROVA
************************************************************************
PARAMETERS CODE
PRIVATE CODE,REK,GRU

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_DD")
   return(.f.)
ENDIF

SELECT U_DIS_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTAT WITH V_QTA
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QTA),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QTA),2)

   SELECT U_DIS_DD
   
   IF DIS_TIPO=='G'
      REK=RECNO()
      GRU=CODE
      =TROVA1(DIS_CODART,V_QTA)
      SELECT U_DIS_DD
      GOTO REK
      CODE=GRU
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN

************************************************************************
PROCEDURE TROVA1
************************************************************************
PARAMETERS CODE1,QTA1
PRIVATE CODE1,REK1,GRU1,QTA1
CNT=CNT+1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE1) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D1")
   return(.f.)
ENDIF
SELECT U_DIS_D1
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA1),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D1
   
   IF DIS_TIPO=='G'
      REK1=RECNO()
      GRU1=CODE
      =TROVA2(DIS_CODART,V_QUANTI)
      SELECT U_DIS_D1
      GOTO REK1
      CODE=GRU1
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN

************************************************************************
PROCEDURE TROVA2
************************************************************************
PARAMETERS CODE2,QTA2
PRIVATE CODE2,REK2,GRU2,QTA2
CNT=CNT+1

x_codi = "dis_gruppo = '" + CODE2 + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D2")
   return(.f.)
ENDIF
SELECT U_DIS_D2
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA2),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D2
   
   IF DIS_TIPO=='G'
      REK2=RECNO()
      GRU2=CODE
      =TROVA3(DIS_CODART,V_QUANTI)
      SELECT U_DIS_D2
      GOTO REK2
      CODE=GRU2
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA3
************************************************************************
PARAMETERS CODE3,QTA3
PRIVATE CODE3,REK3,GRU3,QTA3
CNT=CNT+1

x_codi = "dis_gruppo = '" + CODE3 + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D3")
   return(.f.)
ENDIF
SELECT U_DIS_D3
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA3),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D3
   
   IF DIS_TIPO=='G'
      REK3=RECNO()
      GRU3=CODE
      =TROVA4(DIS_CODART,V_QUANTI)
      SELECT U_DIS_D3
      GOTO REK3
      CODE=GRU3
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA4
************************************************************************
PARAMETERS CODE4,QTA4
PRIVATE CODE4,REK4,GRU4,QTA4
CNT=CNT+1

x_codi = "dis_gruppo = '" + CODE4 + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D4")
   return(.f.)
ENDIF
SELECT U_DIS_D4
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA4),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D4
   
   IF DIS_TIPO=='G'
      REK4=RECNO()
      GRU4=CODE
      =TROVA5(DIS_CODART,V_QUANTI)
      SELECT U_DIS_D4
      GOTO REK4
      CODE=GRU4
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN

************************************************************************
PROCEDURE TROVA5
************************************************************************
PARAMETERS CODE5,QTA5
PRIVATE CODE5,REK5,GRU5,QTA5
CNT=CNT+1

x_codi = "dis_gruppo = '" + CODE5 + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D1")
   return(.f.)
ENDIF
SELECT U_DIS_D5
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA5),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D5
   
   IF DIS_TIPO=='G'
      REK5=RECNO()
      GRU5=CODE
      =TROVA6(DIS_CODART,V_QUANTI)
      SELECT U_DIS_D5
      GOTO REK5
      CODE=GRU5
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA6
************************************************************************
PARAMETERS CODE6,QTA6
PRIVATE CODE6,REK6,GRU6,QTA6
CNT=CNT+1

x_codi = "dis_gruppo = '" + CODE6 + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D6")
   return(.f.)
ENDIF
SELECT U_DIS_D6
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD  WITH _V_CODART
   REPLACE WDES  WITH _V_DESCRI
   REPLACE WCOS  WITH _V_COSTO
   REPLACE WPRZ  WITH _V_PREZZO
   REPLACE WTIP  WITH V_TIPO
   REPLACE WLIV  WITH CNT
   REPLACE WQTA  WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE  WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA6),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D6
   
   IF DIS_TIPO=='G'
      REK6=RECNO()
      GRU6=CODE
      =TROVA7(DIS_CODART,V_QUANTI)
      SELECT U_DIS_D6
      GOTO REK6
      CODE=GRU6
   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA7
************************************************************************
PARAMETERS CODE7,QTA7
PRIVATE CODE7,REK7,GRU7,QTA7
CNT=CNT+1

x_codi = "dis_gruppo = '" + CODE7 + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D7")
   return(.f.)
ENDIF
SELECT U_DIS_D7
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP
      LOOP
   ENDIF

   _V_CODART = DIS_CODART
   V_TIPO    = DIS_TIPO
   _V_DESCRI = DIS_DESCRI
   _V_COSTO  = DIS_COSTO
   _V_PREZZO = DIS_PREZZO
   V_QTA     = DIS_QTA
   V_EXP     = DIS_ESPLOD
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD WITH _V_CODART
   REPLACE WDES WITH _V_DESCRI
   REPLACE WCOS WITH _V_COSTO
   REPLACE WPRZ WITH _V_PREZZO
   REPLACE WTIP WITH V_TIPO
   REPLACE WLIV WITH CNT
   REPLACE WQTA WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE WITH V_XTREE + SPACE(WLIV) + WCOD
   V_QUANTI = ROUND((V_QTA * QTA7),2)
   REPLACE WQTAT WITH V_QUANTI
   REPLACE WCOST WITH ROUND((_V_COSTO*V_QUANTI),2)
   REPLACE WPRZT WITH ROUND((_V_PREZZO*V_QUANTI),2)

   SELECT U_DIS_D7
   
*   IF DIS_TIPO=='G'
*      REK7=RECNO()
*      GRU7=CODE
*      =TROVA8(DIS_CODART,V_QUANTI)
*      SELECT U_DIS_D7
*      GOTO REK7
*      CODE=GRU7
*   ENDIF
   
   SKIP +1

ENDDO

CNT=CNT-1

RETURN


***************************************************************************** 
 FUNCTION SCARICADB	&& FUNZIONE DI SCARICO DEI COMPONENTI DELLA DISTINTA BASE
***************************************************************************** 
*   FUNZIONE DI SCARICO MAGAZZINO DALLA DISTINTA BASE
*	
*	- SCARICA I COMPONENTI OTTENUTI DALL'ESPLOSIONE DELLA DISTINTA BASE
*
* 	- SE IMPOSTATO IL FLAG _XFLAG   = SI : EFFETTUA IL CARICO AUTOMATICO
*										   DEI GRUPPI/SOTTOGRUPPI
* 	- SE IMPOSTATO IL FLAG _XMOVIM  = NO : NON CREA I MOVIMENTI SU U_MAG_MO
*

PARA _XFLAG,_XMOVIM,_XQTA,_XTOP,_XCOD,_XMAG,_XCODCLI,_XDATA,_XNUMDOC,_XDTREGI

SI_VIDEO = .F.
SI_LIV   = .F.
DO ALBERELLO  WITH SI_VIDEO,_XCOD,SI_LIV && ESPLODE LA DISTINTA BASE SU FILE WEXPLODE

SELECT WEXPLODE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
	  SELECT WEXPLODE
	  SKIP+1
	  LOOP
   ENDIF	

   SCATTER MEMVAR MEMO 

   IF _XFLAG  = "NO"          && SCARTA I GRUPPI E SOTTOGRUPPI
	  IF WTIP = "A"
	  ELSE
		 SELECT WEXPLODE
		 SKIP+1
		 LOOP
	  ENDIF
   ENDIF

   *-->> DETERMINA LA QTA DA SCARICARE IN FUNZIONE DELLA DISTINTA----------
	    	
   QT_QT   = _XQTA * M.WQTA

   IF WTIP = "A" 	   && SOLO COMPONENTI          
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
      H_DADOVE = 'SCARICADB'
      H_GENMOV = _XMOVIM 
      H_TIPO   = 'GIA'
      H_IMPE   = ""
      H_MAGSCA = _XMAG
      H_MAGCAR = ""
      H_CODART = M.WCOD
      H_TOPSCA = _XTOP
      H_TOPCAR = ""
      H_QUANTI = QT_QT
      H_NUMDOC = _XNUMDOC
      H_DATDOC = _XDATA
      H_DATREG = _XDTREGI
      H_ORAMOV = TIME()
      H_CLIFOR = _XCODCLI
      H_PRZACQ = 0
      H_PRZVEN = 0
      H_CODIVA = ""
      H_SCONTO = 0
      H_VALUTA = ""
      H_NOTE   = ""
      H_CSC    = ""
      H_SAC    = ""
      H_GGG    = "SI"
      H_FORNIT = ""
      H_FLGTRA = .F.
      =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
   ENDIF

   * EFFETTUA IL MOVIMENTO DI CARICO AUTOMATICO SU GRUPPI/SOTTOGRUPPI -------
   IF _XFLAG  = "SI"          
	  IF WTIP = "A"
	  ELSE
         **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
         H_DADOVE = 'SCARICADB'
         H_GENMOV = _XMOVIM 
         H_TIPO   = 'GIA'
         H_IMPE   = ""
         H_MAGSCA = _XMAG
         H_MAGCAR = ""
         H_CODART = M.WCOD
         H_TOPSCA = "105"
         H_TOPCAR = ""
         H_QUANTI = QT_QT
         H_NUMDOC = _XNUMDOC
         H_DATDOC = _XDATA
         H_DATREG = _XDTREGI
         H_ORAMOV = TIME()
         H_CLIFOR = _XCODCLI
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = ""
         H_NOTE   = ""
         H_CSC    = ""
         H_SAC    = ""
         H_GGG    = "SI"
         H_FORNIT = ""
         H_FLGTRA = .F.
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
      ENDIF
   ENDIF

   SELECT WEXPLODE
   SKIP+1

ENDDO

RETURN(.T.)


***************************************************************************** 
 FUNCTION CARICADB	&& FUNZIONE DI CARICO DEI COMPONENTI DELLA DISTINTA BASE
*****************************************************************************
*   FUNZIONE DI CARICO MAGAZZINO DALLA DISTINTA BASE
*	
*	- CARICA I COMPONENTI OTTENUTI DALL'ESPLOSIONE DELLA DISTINTA BASE
*
* 	- SE IMPOSTATO IL FLAG _XFLAG   = SI : EFFETTUA LO SCARICO AUTOMATICO
*										  DEI GRUPPI/SOTTOGRUPPI
* 	- SE IMPOSTATO IL FLAG _XMOVIM  = NO : NON CREA I MOVIMENTI SU U_MAG_MO
*
*

PARA _XFLAG,_XMOVIM,_XQTA,_XTOP,_XCOD,_XMAG,_XCODCLI,_XDATA,_XNUMDOC,_XDTREGI

SI_VIDEO = .F.
SI_LIV   = .F.
DO ALBERELLO  WITH SI_VIDEO,_XCOD,SI_LIV && ESPLODE LA DISTINTA BASE SU FILE WEXPLODE

SELECT WEXPLODE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
	  SELECT WEXPLODE
	  SKIP+1
	  LOOP
   ENDIF	

   SCATTER MEMVAR MEMO 

   IF _XFLAG  = "NO"          && SCARTA I GRUPPI E SOTTOGRUPPI
   	  IF WTIP = "A"
      ELSE
		 SELECT WEXPLODE
		 SKIP+1
	     LOOP
 	  ENDIF
   ENDIF

   *-->> DETERMINA LA QTA DA SCARICARE IN FUNZIONE DELLA DISTINTA----------
	    	
   QT_QT   = _XQTA * M.WQTA
 
   IF WTIP = "A" 	   && SOLO COMPONENTI          
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
      H_DADOVE = 'CARICADB'
      H_GENMOV = _XMOVIM 
      H_TIPO   = 'GIA'
      H_IMPE   = ""
      H_MAGSCA = _XMAG
      H_MAGCAR = ""
      H_CODART = M.WCOD
      H_TOPSCA = _XTOP
      H_TOPCAR = ""
      H_QUANTI = QT_QT
      H_NUMDOC = _XNUMDOC
      H_DATDOC = _XDATA
      H_DATREG = _XDTREGI
      H_ORAMOV = TIME()
      H_CLIFOR = _XCODCLI
      H_PRZACQ = 0
      H_PRZVEN = 0
      H_CODIVA = ""
      H_SCONTO = 0
      H_VALUTA = ""
      H_NOTE   = ""
      H_CSC    = ""
      H_SAC    = ""
      H_GGG    = "SI"
      H_FORNIT = ""
      H_FLGTRA = .F.
      =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
   ENDIF 

   * EFFETTUA IL MOVIMENTO DI CARICO AUTOMATICO SU GRUPPI/SOTTOGRUPPI -------
   IF _XFLAG  = "SI"          
	  IF WTIP = "A"
      ELSE 
         **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
         H_DADOVE = 'CARICADB'
         H_GENMOV = _XMOVIM 
         H_TIPO   = 'GIA'
         H_IMPE   = ""
         H_MAGSCA = _XMAG
         H_MAGCAR = ""
         H_CODART = M.WCOD
         H_TOPSCA = "205"
         H_TOPCAR = ""
         H_QUANTI = QT_QT
         H_NUMDOC = _XNUMDOC
         H_DATDOC = _XDATA
         H_DATREG = _XDTREGI
         H_ORAMOV = TIME()
         H_CLIFOR = _XCODCLI
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = ""
         H_NOTE   = ""
         H_CSC    = ""
         H_SAC    = ""
         H_GGG    = "SI"
         H_FORNIT = ""
         H_FLGTRA = .F.
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
	  ENDIF
   ENDIF

   SELECT WEXPLODE
   SKIP+1

ENDDO

RETURN(.T.)


**************************************************************************
*   CARICA  IL MAGAZZINO SEDE DALLE BOLLE DI CARICO
*   SCARICA IL MAGAZZINO AGENTE DALLE BOLLE DI CARICO
**************************************************************************
***************************************************************************
PROCEDURE MAGSCAR
***************************************************************************

SELECT CU_TVE_DD
GO TOP

RELEASE XYZ_AGGA
PUBLIC  XYZ_AGGA
XYZ_AGGA = DAGGANCIO

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	 

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'MAGSCAR'
   H_GENMOV = 'SI'
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGS
   H_MAGCAR = M.ORD_MAGD
   H_CODART = M.ORD_CODART
   H_TOPSCA = '100'
   H_TOPCAR = '200'
   H_QUANTI = M.ORD_INVEND
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = ""
   H_SCONTO = 0
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   v_seek   = XYZ_AGGA
   v_chiave = "taggancio"
   cSql     = "select * from u_tve_tt where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"U_TVE_TT","R")
      return(.f.)
   ENDIF
   SELECT U_TVE_TT
   IF RECCOUNT() <> 0
      REPLACE ORD_RSCAR WITH 'S'
   ENDIF
   IF !ExecRW(cSql,"U_TVE_TT","W")
      return(.f.)
   ENDIF

   SELECT CU_TVE_DD
   SKIP +1

ENDDO

RETURN


**********************************************************************************
*            GESTIONE AUTOMATICA MAGAZZINI DEPOSITO                              *
**********************************************************************************
* SCARICO MAGAZZINO DEPOSITO DELLA QTA VENDUTA
* =============================================
***************************************************************************
PROCEDURE MAGSEDE
***************************************************************************

SELECT CU_FAT_DD
GO TOP
RELEASE XYZ_AGGA
PUBLIC  XYZ_AGGA
XYZ_AGGA = DAGGANCIO

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD

   SCATTER MEMVAR MEMO	 	 

   *  FORZA IL CODICE DEL DEPOSITO EFFETTIVO NEL CASO IN CUI IL DEPOSITO HA PIU' AGENTI
   x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "age_codice = '" + ALLTRIM(M.ORD_MAGA) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
   IF !ExecCommand(cSql,"cur_agente")
      return(.f.)
   ENDIF
   SELECT cur_agente
   GO TOP
   IF EOF()
      DEPCOLLE = SPACE(03)         && CODICE DEPOSITO  EFFETTIVO
   ELSE
      DEPCOLLE = AGE_DEPCOL        && CODICE DEPOSITO  EFFETTIVO
   ENDIF

   IF !EMPTY(DEPCOLLE)            
      M.ORD_MAGA = DEPCOLLE
   ENDIF   

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'MAGSEDE'
   H_GENMOV = 'SI'
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '200'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = ""
   H_SCONTO = 0
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   v_seek   = XYZ_AGGA
   v_chiave = "taggancio"
   cSql="select * from u_fat_tt where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"U_FAT_TT","R")
      return(.f.)
   ENDIF
   SELECT U_FAT_TT
   IF RECCOUNT() <> 0
      REPLACE ORD_SCAR WITH 'S'
   ELSE
      WAIT WINDOW "FATTURA NON SCARICATA : AGGANCIO "+DAGGANCIO
   ENDIF
   IF !ExecRW(cSql,"U_FAT_TT","W")
      return(.f.)
   ENDIF

   SELECT CU_FAT_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE FATSCMAG  && SCARICA IL MAGAZZINO
**************************************************************************

SELECT CU_FAT_DD
GO TOP

DO WHILE .T. 
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD

   SCATTER MEMVAR MEMO	 	

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'FATSCMAG'
   H_GENMOV = 'SI'
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '200'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CU_FAT_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE FATRIMAG  && RICARICA IL MAGAZZINO
**************************************************************************

v_seek	 = FAT_RECNO
v_chiave = "daggancio"
IF seek_std('u_fat_dd',v_seek,v_chiave,'CUR_DETTAGLI')
   SELECT CUR_DETTAGLI
ELSE
   WAIT WINDOW "Non trovato uncino in ricarico magazzino : FATRIMAG "+FAT_RECNO
   RETURN
ENDIF

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'FATRIMAG'
   H_GENMOV = 'SI'
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '100'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   IF !EMPTY(PUB_CFDEF)
      H_CLIFOR = PUB_CFDEF
   ELSE
	  H_CLIFOR = M.ORD_CODCLI
   ENDIF
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CUR_DETTAGLI
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE FATCANC  && ANNULLO FATTURE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = FAT_RECNO
CSQL="DELETE FROM U_FAT_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_FAT_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE FAPCANC  && ANNULLO FATTURE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = FAP_RECNO
CSQL="DELETE FROM U_FAP_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_FAP_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE ORFCANC  && ANNULLO ORDINI A FORNITORI IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = ORF_RECNO
CSQL="DELETE FROM U_ORF_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_ORF_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE LAVOCANC  && ANNULLO ORDINI C/LAVORO IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = CTL_RECNO
CSQL="DELETE FROM U_CTL_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_CTL_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE OFFCANC  && ANNULLO OFFERTE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = OFF_RECNO
CSQL="DELETE FROM U_OFF_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_OFF_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE ORDCANC  && ANNULLO ORDINI IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = ORD_RECNO
CSQL="DELETE FROM U_ORD_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_ORD_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE SPECANC  && ANNULLO SPEDIZIONI IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = SPE_RECNO
CSQL="DELETE FROM U_SPE_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_SPE_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE BFOCANC  && ANNULLO BOLLE FORNITORE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = BOL_RECNO
CSQL="DELETE FROM U_BFO_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_BFO_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE MRICANC  && ANNULLO ORDINI DI RIFORNIMENTO IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = ORD_RECNO
CSQL="DELETE FROM U_MRI_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_MRI_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE CEICANC  && ANNULLO CEI IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = CEI_RECNO
CSQL    = "DELETE FROM U_CEI_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_CEI_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE CEACANC  && ANNULLO CEA IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = CEA_RECNO
CSQL    = "DELETE FROM U_CEA_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_CEA_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE RIACANC  && ANNULLO RIA IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = RIA_RECNO
CSQL    = "DELETE FROM U_RIA_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_RIA_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE RAACANC  && ANNULLO RAA IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = RAA_RECNO
CSQL    = "DELETE FROM U_RAA_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_RAA_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE FAMCANC  && ANNULLO FATTURE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = FAM_RECNO
CSQL="DELETE FROM U_FAM_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_FAM_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE AMMCANC  && ANNULLO FATTURE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = AMM_RECNO
CSQL="DELETE FROM U_AMM_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_AMM_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE DISCANC  && ANNULLO DI.BA. IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = DIS_RECNO
CSQL    = "DELETE FROM U_DIS_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_DIS_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE CICCANC  && ANNULLO CICLO IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = CIC_RECNO
CSQL    = "DELETE FROM U_CIC_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_CIC_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE PROCANC  && ANNULLO COMMESSE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

x_agga = "daggancio = '" + COM_RECNO + "'"
x_cond = x_agga
Csql   = "select * from u_pro_dd where " + x_cond + " order by daggancio"
IF !ExecRW(cSql,"u_pro_dd","R")
   return(.f.)
ENDIF
SELECT u_pro_dd
GO TOP
IF EOF()
   WAIT WINDOW "Non trovato uncino "+COM_RECNO
ENDIF

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
 
   Z_MAGA   = ORD_MAGA
   Z_CODART = ORD_CODART
   Z_QTAIMG = ORD_QTAIMG
   Z_QTAIMC = ORD_QTAIMP
   Z_QTADPR = ORD_QTADPR
   
   IF ORD_FLGCOM = 'A'
      x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga   = "mag_codmag = '" + ALLTRIM(Z_MAGA) + "'"
      x_codi   = "mag_codart = '" + ALLTRIM(Z_CODART) + "'"
      x_cond   = x_soci + " and " + x_maga + " and " + x_codi
      Csql     = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecRW(Csql,"u_mag_an","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF reccount() <> 0
         REPLACE MAG_QTAIMG WITH MAG_QTAIMG - Z_QTAIMG
         REPLACE MAG_QTAIMC WITH MAG_QTAIMC - Z_QTAIMC
         REPLACE MAG_QTADPR WITH MAG_QTADPR - Z_QTADPR
      ENDIF
      IF !ExecRW(Csql,"u_mag_an","W")
         return(.f.)
      ENDIF
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + ALLTRIM(Z_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"cur_articolo")
         return(.f.)
      ENDIF
      SELECT cur_articolo
      GO TOP
      IF !EOF()
         IF ART_DISBAS = 'S'
            * DA FARE GESTIONE DI ESPLOSIONE DIS.BAS. ARTICOLO PER DISIMPEGNARE SU U_MAG_AN LE QUANTITA'
            * SU MAG_QTAIMC DA SCARICARE IN FASE DI EVASIONE (TRATTASI DI ARTICOLO DI ACQUISTO O C/LAV.
            =PRODISBA("PROCANC",Z_CODART,Z_MAGA,Z_QTADPR,"W")
        ENDIF
      ENDIF
      SELECT U_PRO_DD
   ENDIF

   DELETE      

   SKIP +1

ENDDO

IF !ExecRW(cSql,"u_pro_dd","W")
   return(.f.)
ENDIF

RETURN


**************************************************************************
PROCEDURE ESENOTE  && GESTIONE ESENZIONI / COMMENTI STANDARD
**************************************************************************

IF EMPTY(IVA_ESE)		&& SOLO SE ESENTE
   RETURN
ENDIF

IF EMPTY(V_CLIES)       && SOLO SE NUMERO DI ESENZIONE CLIENTE
   RETURN
ENDIF

IF PUB_ESIVA			&& SOLO PER IVE INDICATE
   IF !VERYIVA(IVA_ESE)
      RETURN
   ENDIF
ENDIF

*===>>  ESENZIONE IVA
x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = 'INESE'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"cur_notecom")
   return(.f.)
ENDIF
SELECT cur_notecom
GO TOP
IF EOF()
   =MESSAGEBOX("Testo standard 'INESE' "+CHR(13)+"non presente in testi standard",16,"*** ATTENZIONE ***") 
   RETURN
ENDIF
M.ORD_NOTE = not_testo
  
*===>   TRASFORMO DATI ESENZIONE  
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".NDESCLI.",V_CLIES)    && NUMERO DOCUMENTO ESENZIONE CLIENTE 
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".DTESCLI.",V_DTCLES)   && DATA DOCUMENTO ESENZIONE CLIENTE
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".NDESSOC.",V_NSES)  	  && NUMERO DOCUMENTO ESENZIONE SOCIETA
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".DTESSOC.",V_DTNSES)   && DATA DOCUMENTO ESENZIONE SOCIETA

SELECT CU_FAT_DD
APPEND BLANK
 
m.ord_codart = SPACE(16)
M.ORD_MAGA	 = SPACE(06)   
M.ORD_DESART = "*** COMMENTO ***"    
M.ORD_MAGA	 = SPACE(06)   
M.ORD_DES2	 = SPACE(25)
M.ORD_UM	 = SPACE(02)
M.ORD_IVA	 = SPACE(02)
M.ORD_PREZZO = 0
M.ORD_QTAORD = 0
M.ORD_PRZNET = 0
M.ORD_VALORE = 0
M.ORD_SC1    = 0
M.ORD_SC2    = 0
M.ORD_SC3    = 0	 
M.ord_pubbli = " "
M.ORD_VALCO  = 0        

GATHER MEMVAR MEMO
GO TOP

SELECT CU_FAT_DD
  
RETURN


***********************************
FUNCTION GETFATTU
***********************************
*--> AGGANCIA LE FATTURE PAGATE
PARA AGGA

SS=STR(SELECT())
OUT=""

v_seek	 = AGGA
v_chiave = "daggancio"
IF seek_std('u_ric_dd',v_seek,v_chiave,'CUR_DETTAGLI')
   SELECT CUR_DETTAGLI
   DO WHILE  .T.
      IF EOF()
         EXIT
      ENDIF
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
      OUT=OUT+" "+RIC_FATAGE
      SKIP +1
   ENDDO
ELSE
   OUT=""
ENDIF

SELECT &SS
RETURN(OUT)

***********************
PROCEDURE CHK2
***********************
PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH '  '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY
KEYBOARD "{RIGHTARROW}+{LEFTARROW}"
RETURN


***********************
PROCEDURE CHKR
***********************
PUSH KEY CLEAR
KEYBOARD "{CTRL+W}"
POP KEY
RETURN


***********************************************************************************************
*  SERVE PER TOGLIERE DAL CODICE ARTICOLO I CARATTERI FORZATI IN INPUTMASK PER EFFETTUARE LA  *
*  RICERCA PER DESCRIZIONE ARTICOLO                                                           *
***********************************************************************************************
FUNCTION TROVARTI     
***********************************************************************************************

PARA _CODART

V_CTR = 1
V_LEN = LEN(ALLTRIM(PUB_FORMAR))
V_CAR = .F.

DO WHILE .T.

   IF V_CTR > V_LEN
      EXIT
   ENDIF
   
   IF SUBSTR(PUB_FORMAR,V_CTR,1) = '.' .OR. SUBSTR(PUB_FORMAR,V_CTR,1) = '-' .OR. ;
      SUBSTR(PUB_FORMAR,V_CTR,1) = '/' .OR. SUBSTR(PUB_FORMAR,V_CTR,1) = ',' 
      V_CAR = .T.
      EXIT
   ENDIF
   
   V_CTR = V_CTR + 1
   
ENDDO

IF V_CAR
ELSE
   RETURN(_CODART)
ENDIF

V_CTR    = 1
V_LEN    = LEN(ALLTRIM(PUB_FORMAR))
V_CAR    = .F.
V_CODART = ""

DO WHILE .T.

   IF V_CTR > V_LEN
      EXIT
   ENDIF
   
   IF SUBSTR(_CODART,V_CTR,1) = '.' .OR. SUBSTR(_CODART,V_CTR,1) = '-' .OR. ;
      SUBSTR(_CODART,V_CTR,1) = '/' .OR. SUBSTR(_CODART,V_CTR,1) = ',' 
      V_CTR = V_CTR + 1
      LOOP
   ENDIF
   
   V_CODART = V_CODART + SUBSTR(_CODART,V_CTR,1)
   
   V_CTR = V_CTR + 1
   
ENDDO

RETURN(V_CODART)


**************************************************************************
FUNCTION DPUB           && STAMPA LA DICITURA MATERIALE PUBBLICITARIO
**************************************************************************

DESPUBL = ""
IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA 
   DESPUBL = DPU
ENDIF

XR=ALLTRIM(SUBSTR(ORD_desart,1,40))+"   "+DESPUBL

RETURN(XR)

*******************************************************************
*      PROCEDURE PER SELEZIONE RECORD                             *
*******************************************************************
PROCEDURE SCELTAM
PUSH KEY CLEAR

SAVE_REC=RECNO()
GOTO SAVE_REC

IF EMPTY(WSELEZ)
  REPLACE WSELEZ WITH '=====>'
ELSE
  REPLACE WSELEZ WITH '      '
ENDIF

POP KEY
KEYBOARD "{RIGHTARROW}+{LEFTARROW}"
RETURN


****************************
PROCEDURE PROC_SEL
****************************

SELECT CU_RIC_TT
IF SELE <> SELETTORE
  REPLACE SELE WITH SELETTORE
ELSE
  REPLACE SELE WITH SPACE(3)
ENDIF
KEYBOARD "{RIGHTARROW}"
KEYBOARD "{LEFTARROW}"

RETURN


*******************
PROCEDURE INTEMAG0
*******************

**--> GENERAZIONE CURSORE PER MOVIMENTI DI MAGAZZINO

CREATE CURSOR TABMOVI (STA_CODMAG C(06),   STA_DESMAG C(40), ;
					   STA_NUMDOC C(06),   STA_DATDOC C(10), ;
					   STA_TOP C(10),      STA_CODICE C(10), ;
					   STA_DESTOP C(40),   STA_DATREG C(10), ;  	
                       STA_QUANTI N(11,2), STA_SEGNO  C(01), ;
                       STA_RAGSOC C(30))
SELECT TABMOVI 
GO TOP

IF _V_CODMAG = SPACE(06)
   x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "mov_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_data = "mov_dtregi between '" + _V_DATADA + "' and '" + _V_DATAAL + "'"
   x_cond = x_soci + " and " + x_codi + " and " + x_data
   Csql   = "select * from u_mag_mo where " + x_cond + " order by mov_codsoc,mov_codmag,mov_codart,mov_dtregi"
ELSE
   x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
   x_maga = "mov_codmag = '" + ALLTRIM(_V_CODMAG) + "'"
   x_codi = "mov_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_data = "mov_dtregi between '" + _V_DATADA + "' and '" + _V_DATAAL + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi + " and " + x_data
   Csql   = "select * from u_mag_mo where " + x_cond + " order by mov_codsoc,mov_codmag,mov_codart,mov_dtregi"
ENDIF
IF !ExecCommand(cSql,"cur_movimenti")
   return(.f.)
ENDIF

SELECT CUR_MOVIMENTI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF MOV_CODART = _V_CODART 
   ELSE 
      EXIT
   ENDIF
   
   IF _V_CODMAG = SPACE(06)
   ELSE
      IF MOV_CODMAG = _V_CODMAG
      ELSE
         EXIT 
      ENDIF
   ENDIF

   IF MOV_DTREGI => RIBALTA2(_V_DATADA)
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
   IF MOV_DTREGI <= RIBALTA2(_V_DATAAL)
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
   V_CODMAG = MOV_CODMAG
   V_NUMDOC = MOV_NUMDOC
   V_DATDOC = RIBALTA2(MOV_DTDOCU)
   V_TOP    = MOV_TOP
   V_CODICE = MOV_CODFOR
   V_DATREG = RIBALTA2(MOV_DTREGI)
   V_QUANTI = MOV_QTAMOV
   V_RAGSOC = MOV_RAGSOC
   V_DESMAG = SPACE(40)
   V_COORD  = MOV_COORD 

   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   v_seek	= "TOP"+V_TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESTOP = DESCRI
      IF SUBSTR(LIBERA,1,1) = "C"
         V_SEGNO = "+"
      ELSE  
         V_SEGNO = "-"
      ENDIF
   ELSE  
      V_DESTOP = 'TOP SCONOSCIUTO'
      V_SEGNO  = ' '
   ENDIF 

   IF EMPTY(V_RAGSOC) .OR. V_RAGSOC = SPACE(40)
      V_RAGSOC = "NON TROVATA"
      IF VAL(ALLTRIM(V_TOP)) > 900 .AND. ;
         VAL(ALLTRIM(V_TOP)) < 910
         x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "cli_codcli = '" + ALLTRIM(V_CODICE) + "'"
	     x_cond = x_soci + " and " + x_codi
         Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
         IF !ExecCommand(cSql,"cur_cliente")
            return(.f.)
         ENDIF
         SELECT cur_cliente
         GO TOP
         IF EOF()
         ELSE
            V_RAGSOC = CLI_RAGSOC
         ENDIF      
      ELSE
         IF VAL(ALLTRIM(V_TOP)) = 190
            x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
            x_codi = "for_codcli = '" + ALLTRIM(V_CODICE) + "'"
	        x_cond = x_soci + " and " + x_codi
            Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
            IF !ExecCommand(cSql,"cur_fornitore")
               return(.f.)
            ENDIF
            SELECT cur_fornitore
            GO TOP
            IF EOF()
            ELSE
               V_RAGSOC = FOR_RAGSOC
            ENDIF      
         ELSE
            IF V_SEGNO = "+" 
               IF ALLTRIM(V_COORD) = "CLIENTE"
                  x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
                  x_codi = "cli_codcli = '" + ALLTRIM(V_CODICE) + "'"
	              x_cond = x_soci + " and " + x_codi
                  Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
                  IF !ExecCommand(cSql,"cur_cliente")
                     return(.f.)
                  ENDIF
                  SELECT cur_cliente
                  GO TOP
                  IF EOF()
                  ELSE
                     V_RAGSOC = CLI_RAGSOC
                  ENDIF      
               ELSE
                  x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
                  x_codi = "for_codcli = '" + ALLTRIM(V_CODICE) + "'"
	              x_cond = x_soci + " and " + x_codi
                  Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
                  IF !ExecCommand(cSql,"cur_fornitore")
                     return(.f.)
                  ENDIF
                  SELECT cur_fornitore
                  GO TOP
                  IF EOF()
                  ELSE
                     V_RAGSOC = FOR_RAGSOC
                  ENDIF      
	           ENDIF
            ELSE
               x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
               x_codi = "for_codcli = '" + ALLTRIM(V_CODICE) + "'"
	           x_cond = x_soci + " and " + x_codi
               Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
               IF !ExecCommand(cSql,"cur_fornitore")
                  return(.f.)
               ENDIF
               SELECT cur_fornitore
               GO TOP
               IF EOF()
               ELSE
                  V_RAGSOC = FOR_RAGSOC
               ENDIF      
	        ENDIF   
         ENDIF
      ENDIF
   ENDIF

   SELECT TABMOVI
   APPEND BLANK
   REPLACE STA_CODMAG WITH V_CODMAG
   REPLACE STA_DESMAG WITH V_DESMAG
   REPLACE STA_NUMDOC WITH V_NUMDOC
   REPLACE STA_DATDOC WITH V_DATDOC
   REPLACE STA_TOP    WITH V_TOP
   REPLACE STA_DESTOP WITH V_DESTOP
   REPLACE STA_CODICE WITH V_CODICE
   REPLACE STA_RAGSOC WITH V_RAGSOC
   REPLACE STA_DATREG WITH V_DATREG
   REPLACE STA_QUANTI WITH V_QUANTI
   REPLACE STA_SEGNO  WITH V_SEGNO
   
   SELECT CUR_MOVIMENTI
   SKIP +1

ENDDO

RETURN


******************
PROCEDURE INTEMAG1
******************

_V_GIACEN = 0

**--> GENERAZIONE CURSORE PER GIACENZE DI MAGAZZINO

CREATE CURSOR TABGIAC (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_QUANTI N(11,2))
SELECT TABGIAC 
GO TOP

IF _V_CODMAG = SPACE(06) .OR. EMPTY(_V_CODMAG)
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
ELSE
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(_V_CODMAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
ENDIF
IF !ExecCommand(cSql,"cur_giacenze")
   return(.f.)
ENDIF
SELECT cur_giacenze
GO TOP
IF EOF()
   _V_GIACEN = 0
   RETURN
ENDIF

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF MAG_GIACEN = 0
      SKIP +1
      LOOP
   ENDIF
   
   V_CODMAG  = MAG_CODMAG
   V_GIACEN  = MAG_GIACEN

   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   SELECT TABGIAC
   APPEND BLANK
   REPLACE STA_CODMAG WITH V_CODMAG
   REPLACE STA_DESMAG WITH V_DESMAG
   REPLACE STA_QUANTI WITH V_GIACEN

   _V_GIACEN = _V_GIACEN + V_GIACEN
   
   SELECT CUR_GIACENZE
   SKIP +1 

ENDDO

RETURN


******************
PROCEDURE INTEMAG2
******************

**--> GENERAZIONE CURSORE PER ORDINI DA FORNITORI

**--> CREAZIONE STRUTTURA TABELLA ORDINI A FORNITORI
CREATE CURSOR TABORDF (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_NUMERO C(06),   STA_DATA C(10),   ;
                       STA_QUANTI N(11,2), STA_CODICE C(10), ;
                       STA_RAGSOC C(40),   STA_DATCON C(10))

SELECT TABORDF 
GO TOP

IF _V_CODMAG = SPACE(06)
   x_codi = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_codi
   Csql   = "select * from u_orf_dd where " + x_cond + " order by ord_codart"
ELSE
   x_codi = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "ord_maga = '" + ALLTRIM(_V_CODMAG) + "'"
   x_cond = x_codi + " and " + x_maga
   Csql   = "select * from u_orf_dd where " + x_cond + " order by ord_codart,ord_maga"
ENDIF
IF !ExecCommand(cSql,"cur_ordfor_dd")
   return(.f.)
ENDIF

SELECT CUR_ORDFOR_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ORD_CODART = _V_CODART
   ELSE
      EXIT
   ENDIF

   IF _V_CODMAG = SPACE(06)
   ELSE
      IF ORD_MAGA = _V_CODMAG
      ELSE
         EXIT
      ENDIF
   ENDIF         

   IF ORD_CHIUSO = .T.
      SKIP +1
      LOOP
   ENDIF

   V_CODMAG = ORD_MAGA
   V_QUANTI = ORD_QTAORD - ORD_QTAEV
   V_DATCON = RIBALTA2(ORD_DATCON)
   
   IF V_QUANTI > 0
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF RIBALTA2(V_DATCON) => RIBALTA2(_V_DATADA)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   IF RIBALTA2(V_DATCON) <= RIBALTA2(_V_DATAAL)
   ELSE 
      SKIP +1
      LOOP
   ENDIF

   DAGGA = DAGGANCIO
   
   v_seek   = DAGGA
   v_chiave = "taggancio"
   IF seek_std('u_orf_tt',v_seek,v_chiave,'CUR_ORDFOR_TT')
   ELSE 
      SELECT CUR_ORDFOR_DD
      SKIP +1
      LOOP
   ENDIF
   
   SELECT CUR_ORDFOR_TT

*   IF ORD_DATORD => _V_DATADA
*   ELSE 
*      SELECT CUR_ORDFOR_DD
*      SKIP +1
*      LOOP
*   ENDIF
   
*   IF ORD_DATORD <= _V_DATAAL
*   ELSE 
*      SELECT CUR_ORDFOR_DD
*      SKIP +1
*      LOOP
*   ENDIF
    
   IF ORD_CHIUSO = .T.
      SELECT CUR_ORDFOR_DD
      SKIP +1
      LOOP
   ENDIF

   V_NUMERO = ORD_NUMORD
   V_DATA   = ORD_DATORD
   V_CODICE = ORD_CODCLI
   V_RAGSOC = ORD_RAGSOC
   
   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   IF V_QUANTI > 0
   ELSE
      SELECT CUR_ORDFOR_DD
      SKIP +1
      LOOP
   ENDIF

   SELECT TABORDF
   APPEND BLANK
   REPLACE STA_CODMAG WITH V_CODMAG
   REPLACE STA_DESMAG WITH V_DESMAG
   REPLACE STA_NUMERO WITH V_NUMERO
   REPLACE STA_DATA   WITH V_DATA
   REPLACE STA_QUANTI WITH V_QUANTI
   REPLACE STA_CODICE WITH V_CODICE
   REPLACE STA_RAGSOC WITH V_RAGSOC
   REPLACE STA_DATCON WITH V_DATCON

   _V_ORDFOR = _V_ORDFOR + V_QUANTI
   
   SELECT CUR_ORDFOR_DD
   SKIP +1

ENDDO

RETURN


******************
PROCEDURE INTEMAG3
******************

**--> VERIFICA ESISTENZA IMPEGNATO

V_TROV = 'NO'

IF _V_CODMAG = SPACE(06)
   v_seek   = _V_CODART
   v_chiave = "LCT_CODART"
   IF seek_std('u_com_et',v_seek,v_chiave,'CUR_COMMESSE_ET')
      SELECT CUR_COMMESSE_ET
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF _V_CODART = LCT_CODART
         ELSE
            EXIT
         ENDIF   
         IF DELETED()
            SKIP +1
            LOOP
         ENDIF
         IF LCT_TIPART = 'T'
            SKIP +1
            LOOP
         ENDIF
         IF LCT_QTAIMP > 0
         ELSE
            SKIP +1
            LOOP
         ENDIF
         V_TROV = 'SI'
         EXIT
      ENDDO
   ENDIF
ELSE
   x_codi = "lct_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "lct_codmag = '" + ALLTRIM(_V_CODMAG) + "'"
   x_tipo = "lct_tipart = 'A'"
   x_cond = x_codi + " and " + x_maga + " and " + x_tipo
   Csql   = "select * from u_com_et where " + x_cond + " order by lct_codart,lct_codmag,lct_tipart"
   IF !ExecCommand(cSql,"cur_commesse_et")
      return(.f.)
   ENDIF
   SELECT cur_commesse_et
   GO TOP
   IF EOF()
   ELSE
      IF LCT_QTAIMP > 0
         V_TROV = 'SI'
      ENDIF    
   ENDIF
   x_codi = "lct_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "lct_codmag = '" + ALLTRIM(_V_CODMAG) + "'"
   x_tipo = "lct_tipart = 'G'"
   x_cond = x_codi + " and " + x_maga + " and " + x_tipo
   Csql   = "select * from u_com_et where " + x_cond + " order by lct_codart,lct_codmag,lct_tipart"
   IF !ExecCommand(cSql,"cur_commesse_et")
      return(.f.)
   ENDIF
   SELECT cur_commesse_et
   GO TOP
   IF EOF()
   ELSE
      IF LCT_QTAIMP > 0
         V_TROV = 'SI'
      ENDIF    
   ENDIF
ENDIF   

IF V_TROV = 'SI'
ELSE
   RETURN
ENDIF   


**--> GENERAZIONE CURSORE PER IMPEGNATO DA COMMESSE DI PRODUZIONE

**--> CREAZIONE STRUTTURA TABELLA IMPEGNATO DA COMMESSE
CREATE CURSOR TABIMPC (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_NUMERO C(06),   STA_DATA C(10),   ;
                       STA_QUANTI N(11,2), STA_CODICE C(10), ;
                       STA_RAGSOC C(40),   STA_DATCON C(10))
SELECT TABIMPC 
INDEX ON STA_CODMAG + STA_NUMERO + STA_CODICE + STA_DATCON TAG I_TABIMPC ADDITIVE
SET ORDER TO I_TABIMPC
GO TOP

IF _V_CODMAG = SPACE(06)
   x_codi = "lcd_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_codi 
   Csql   = "select * from u_com_ed where " + x_cond + " order by lcd_codart,lcd_codmag"
ELSE
   x_codi = "lcd_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "lcd_codmag = '" + ALLTRIM(_V_CODMAG) + "'"
   x_cond = x_codi + " and " + x_maga 
   Csql   = "select * from u_com_ed where " + x_cond + " order by lcd_codart,lcd_codmag"
ENDIF
IF !ExecCommand(cSql,"cur_commesse_ed")
   return(.f.)
ENDIF

SELECT CUR_COMMESSE_ED
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF LCD_CODART = _V_CODART
   ELSE
      EXIT
   ENDIF

   IF _V_CODMAG = SPACE(06)
   ELSE
      IF LCD_CODMAG = _V_CODMAG
      ELSE
         EXIT
      ENDIF
   ENDIF         

   IF LCD_TIPART = 'A' .OR. LCD_TIPART = 'G'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   V_CODMAG = LCD_CODMAG
   V_QUANTI = LCD_QTAIMP
   V_NUMERO = LCD_NUMCOM
   V_ANNCOM = SUBSTR(LCD_DATCOM,1,4)
   V_DATCON = ribalta2(LCD_DATSCA)
   
   IF V_QUANTI > 0
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF RIBALTA2(V_DATCON) => RIBALTA2(_V_DATADA)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   IF RIBALTA2(V_DATCON) <= RIBALTA2(_V_DATAAL)
   ELSE 
      SKIP +1
      LOOP
   ENDIF

   x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "ord_anno = '" + V_ANNCOM + "'"
   x_nord = "ord_numord = '" + ALLTRIM(V_NUMERO) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_nord 
   Csql   = "select * from u_com_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
   IF !ExecCommand(cSql,"cur_commesse_tt")
      return(.f.)
   ENDIF
   SELECT cur_commesse_tt
   GO top
   IF !EOF()
      V_TROVART = 'NO'
      UNCINO = TAGGANCIO
      v_seek   = UNCINO
      v_chiave = "DAGGANCIO"
      IF seek_std('u_com_dd',v_seek,v_chiave,'CUR_COMMESSE_DD')
         SELECT CUR_COMMESSE_DD
         DO WHILE .T.
            IF EOF()
               EXIT
            ENDIF
            IF DAGGANCIO = UNCINO
            ELSE
               EXIT
            ENDIF
            IF ORD_CODART = _V_CODART .AND. ORD_DATCON = V_DATCON
               V_TROVART = 'SI'
               EXIT
            ENDIF
            SKIP +1
         ENDDO
         IF V_TROVART = 'SI'
            SELECT CUR_COMMESSE_ED
            SKIP +1
            LOOP
         ENDIF   
      ENDIF
      SELECT CUR_COMMESSE_TT
   ELSE 
      SELECT CUR_COMMESSE_ED
      SKIP +1
      LOOP
   ENDIF

*   IF ORD_DATORD => RIBALTA2(_V_DATADA)
*   ELSE 
*      SELECT CUR_COMMESSE_ED
*      SKIP +1
*      LOOP
*   ENDIF
   
*   IF ORD_DATORD <= RIBALTA2(_V_DATAAL)
*   ELSE 
*      SELECT CUR_COMMESSE_ED
*      SKIP +1
*      LOOP
*   ENDIF
    
   IF ORD_CHIUSO = .T.
      SELECT CUR_COMMESSE_ED
      SKIP +1
      LOOP
   ENDIF

   V_DATA   = ORD_DATORD
   V_CODICE = ORD_CODCLI
   V_RAGSOC = ORD_RAGSOC
   
   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   IF V_QUANTI > 0
   ELSE
      SELECT CUR_COMMESSE_ED
      SKIP +1
      LOOP
   ENDIF

   SELECT TABIMPC 
   SET ORDER TO I_TABIMPC
   V_SEEK = V_CODMAG + V_NUMERO + V_CODICE + V_DATCON
   SEEK V_SEEK

   IF FOUND()
      REPLACE STA_QUANTI WITH STA_QUANTI + V_QUANTI
   ELSE 
      APPEND BLANK
      REPLACE STA_CODMAG WITH V_CODMAG
      REPLACE STA_DESMAG WITH V_DESMAG
      REPLACE STA_NUMERO WITH V_NUMERO
      REPLACE STA_DATA   WITH V_DATA
      REPLACE STA_QUANTI WITH V_QUANTI
      REPLACE STA_CODICE WITH V_CODICE
      REPLACE STA_RAGSOC WITH V_RAGSOC
      REPLACE STA_DATCON WITH V_DATCON
   ENDIF
   
   _V_IMPCOM = _V_IMPCOM + V_QUANTI
   
   SELECT CUR_COMMESSE_ED
   SKIP +1

ENDDO

RETURN


****************************************************************************
* INIZIO FUNZIONI PRESE DA AQUAFUN.PRG CON EXEC PRESENTI IN AQUASQL\PRG    *
* N.B. : POTREBBERO ESSERE DISALLINEATE RISPETTO AD AQUAFUN.PRG DI MINERVA *
****************************************************************************
*************************
FUNCTION ESPL_DETT
*************************
PARA _CURS_DET

_SSXX=SELECT()
_RECORDXXX=RECNO()

CREATE CURSOR ESPLODI 	(ORD_CODART C(16),;
						 ORD_DESART C(200),;
						 ORD_QTAORD N(17,3),;
						 ORD_PREZZO N(17,3),;
	 					 ORD_SC1	N(7,3),;
	 					 ORD_SC2	N(7,3),;
	 					 ORD_SC3	N(7,3),;
	 					 ORD_IVA	C(3),;
						 ORD_VALORE	N(17,3),;
						 ORD_VALCO	N(17,3),;
						 ORD_COD1   C(16))
						
SELECT * FROM &_CURS_DET ORDER BY ORD_SEQUEN INTO CURSOR CUR_DETT

SELECT CUR_DETT
GO TOP

_VV_TT=0

DO WHILE !EOF()

   IF DELETED()
      SKIP
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART)!="*** COMMENTO ***"
	  VV_CODART=ORD_CODART
	  VV_DESART=ORD_DESART
	  VV_QTAORD=ORD_QTAORD
	  VV_PREZZO=ORD_PREZZO
  	  IF _CURS_DET = 'CU_PRO_DD'
   	     VV_SC1=0
	     VV_SC2=0
	     VV_SC3=0	
	  ELSE
   	     VV_SC1=ORD_SC1
	     VV_SC2=ORD_SC2
	     VV_SC3=ORD_SC3
	  ENDIF
	  VV_IVA=ORD_IVA
	  VV_VALORE=ORD_VALORE
	  _VV_TT=_VV_TT+ORD_VALORE
      SELECT ESPLODI
      APPEND BLANK
	  REPLACE ORD_CODART WITH VV_CODART
	  REPLACE ORD_COD1   WITH VV_CODART
	  REPLACE ORD_DESART WITH VV_DESART
	  REPLACE ORD_QTAORD WITH VV_QTAORD
	  REPLACE ORD_PREZZO WITH VV_PREZZO
	  REPLACE ORD_SC1	   WITH VV_SC1
	  REPLACE ORD_SC2    WITH VV_SC2
	  REPLACE ORD_SC3    WITH VV_SC3
	  REPLACE ORD_IVA    WITH VV_IVA
	  REPLACE ORD_VALORE WITH VV_VALORE
	  SELECT CUR_DETT
      SKIP
      LOOP
   ENDIF

   POSIZIONE=0
   PARZIALE =0
   RIGA	   =""
   V_NOTE=ORD_NOTE

   LUNGH_MEMO=LEN(ALLTRIM(V_NOTE))

   DO CASE
      CASE ".TT" $ ORD_CODICE 				
   		   XV_VALCO  =ORD_VALCO
           XV_VALORE =0
		   =ESPL_TT()					&& TESTO .TT
 	  OTHERWISE
 		   XV_VALCO =0
		   =ESPL_ALL()					&& TUTTI I TIPI DI TESTI
   ENDCASE

   SELECT CUR_DETT
   SKIP
   LOOP

ENDDO

SELECT ESPLODI
GO TOP

IF PUB_RISOLU
   DEFINE WINDOW WIN_DETT AT 1,1 SIZE 30,80
   MOVE WINDOW WIN_DETT CENTER
   BROWSE WINDOW WIN_DETT  NODELETE NOEDIT NORMAL FIELDS;
		 	     ORD_CODART	:R:16:H="Cod.articolo",;
				 ORD_DESART	:R:40:H="Descrizione articolo",;
				 ORD_QTAORD	:R:12:H="Quantità":P="999,999.999",;
				 ORD_PREZZO	:R:17:H="Prezzo":P="9,999,999,999.99",;
				 ORD_VALORE	:R:17:H="Valore":P="9,999,999,999.99",;
 				 ORD_SC1	:R:6 :H="Sc.1":P="999.99",;
 				 ORD_SC2	:R:6 :H="Sc.2":P="999.99",;
 				 ORD_SC3	:R:6 :H="Sc.3":P="999.99",;
 				 ORD_IVA	:R:3 :H="IVA":P="999",;
				 ORD_COD1	:R:16:H="Cod.articolo";
				 FONT "COURIER NEW",8 TITLE "Dettagli documento N°: "+ALLTRIM(M.ORD_NUMORD)+;
				 							" del "+ORD_DATORD+" - Valore "+ALLTRIM(PUNTINI(STR(_VV_TT,17,3)))
   DEACTIVATE WINDOW WIN_DETT					
   RELEASE WINDOW WIN_DETT					
ELSE
   DEFINE WINDOW WIN_DETT AT 1,1 SIZE 40,97
   MOVE WINDOW WIN_DETT CENTER
   BROWSE WINDOW WIN_DETT  NODELETE NOEDIT NORMAL FIELDS;
				 ORD_CODART	:R:16:H="Cod.articolo",;
				 ORD_DESART	:R:40:H="Descrizione articolo",;
				 ORD_QTAORD	:R:12:H="Quantità":P="999,999.999",;
				 ORD_PREZZO	:R:17:H="Prezzo":P="9,999,999,999.99",;
				 ORD_VALORE	:R:17:H="Valore":P="9,999,999,999.99",;
 				 ORD_SC1	:R:6 :H="Sc.1":P="999.99",;
 				 ORD_SC2	:R:6 :H="Sc.2":P="999.99",;
 				 ORD_SC3	:R:6 :H="Sc.3":P="999.99",;
 				 ORD_IVA	:R:3 :H="IVA":P="999",;
				 ORD_COD1	:R:16:H="Cod.articolo";
				 FONT "COURIER NEW",8 TITLE "Dettagli documento N°: "+ALLTRIM(M.ORD_NUMORD)+;
				 							" del "+ORD_DATORD+" - Valore "+ALLTRIM(PUNTINI(STR(_VV_TT,17,3)))
   DEACTIVATE WINDOW WIN_DETT					
   RELEASE WINDOW WIN_DETT					
ENDIF

SELECT(_SSXX)
GO _RECORDXXX

*EOF ESPL_DET

******************************
FUNCTION ESPL_TT
******************************
DO WHILE .T.														&& INTERPRETE DEL CONTENUTO COMMENTO

   POSIZIONE=POSIZIONE+1
   PARZIALE =PARZIALE+1
   CARATTERE=SUBSTR(V_NOTE,POSIZIONE,1)

   IF POSIZIONE>=LUNGH_MEMO
      SELECT ESPLODI
      APPEND BLANK
      REPLACE ORD_DESART WITH RIGA+CARATTERE
      =DES_LIN() 		&& IMPOSTA LA DESCRIZIONE DELLA LINGUA
      EXIT
   ENDIF

   IF PARZIALE=40
      RIGA=RIGA+CARATTERE
      SELECT ESPLODI
      APPEND BLANK
      REPLACE ORD_DESART WITH RIGA
      REPLACE ORD_VALORE WITH XV_VALCO
      =DES_LIN() 		&& IMPOSTA LA DESCRIZIONE DELLA LINGUA
      RIGA	  =""
      RIGA_SPEZZ=""
      PARZIALE=0
      ULTIMOSPAZIO=.F.
      NUM_SPAZI=OCCURS(" ",SUBSTR(V_NOTE,POSIZIONE+1,40))
      LOOP
   ENDIF

   IF CARATTERE=CHR(13)
      POSIZIONE=POSIZIONE+1
      SELECT ESPLODI
      APPEND BLANK
      REPLACE ORD_DESART WITH RIGA
  	  REPLACE ORD_VALORE WITH XV_VALCO
      =DES_LIN() 		&& IMPOSTA LA DESCRIZIONE DELLA LINGUA
      RIGA	  =""
      RIGA_SPEZZ=""
      PARZIALE=0
      ULTIMOSPAZIO=.F.
      NUM_SPAZI=OCCURS(" ",SUBSTR(V_NOTE,POSIZIONE+1,40))
	  LOOP
   ENDIF

   RIGA=RIGA+CARATTERE

ENDDO

******************************
FUNCTION ESPL_ALL
******************************

DO WHILE .T.														&& INTERPRETE DEL CONTENUTO COMMENTO

   POSIZIONE=POSIZIONE+1
   PARZIALE =PARZIALE+1

   CARATTERE=SUBSTR(V_NOTE,POSIZIONE,1)

   IF _CURS_DET = "CU_FAT_DD" .OR. _CURS_DET = "CU_FAP_DD" .OR. _CURS_DET = "CU_BOL_DD"		
	  XV_VALORE=ORD_VALCO     	&& GESTIONE SCONTI
   ELSE
	  XV_VALORE=ORD_VALORE
   ENDIF

   IF POSIZIONE >= LUNGH_MEMO
      SELECT ESPLODI
      APPEND BLANK
      REPLACE ORD_DESART WITH RIGA+CARATTERE
 	  REPLACE ORD_VALORE WITH XV_VALORE
      EXIT
   ENDIF

   IF PARZIALE >= 40
      RIGA=RIGA+CARATTERE
      SELECT ESPLODI
      APPEND BLANK
      REPLACE ORD_DESART WITH RIGA
      REPLACE ORD_VALORE WITH XV_VALCO
      RIGA	  =""
      RIGA_SPEZZ=""
      PARZIALE=0
      ULTIMOSPAZIO=.F.
      NUM_SPAZI=OCCURS(" ",SUBSTR(V_NOTE,POSIZIONE+1,40))
      LOOP
   ENDIF

   IF CARATTERE=CHR(13)
      POSIZIONE=POSIZIONE+1
      SELECT ESPLODI
      APPEND BLANK
      REPLACE ORD_DESART WITH RIGA
  	  REPLACE ORD_VALORE WITH XV_VALCO
      RIGA	  =""
      RIGA_SPEZZ=""
      PARZIALE=0
      ULTIMOSPAZIO=.F.
      NUM_SPAZI=OCCURS(" ",SUBSTR(V_NOTE,POSIZIONE+1,40))
	  LOOP
   ENDIF

   RIGA=RIGA+CARATTERE

ENDDO

RETURN


*************************
FUNCTION ESPL_CONT
*************************
PARA _CURS_DET

_SSXX=SELECT()
_RECORDXXX=RECNO()

CREATE CURSOR ESPLODI ;
       (CONTO C(13),       DESCRIC C(40),   DARE N(14,3),    AVERE N(14,3),   IMPOSTA N(14,3), ;
        NPARTCF N(10),     NATURA C(1),     IVA C(3),        CECO C(13),      DESCRIZ C(45),   ;
        DESCRI1 C(45),     ;
        IMPOSTA_A N(16,3), SALDO01 N(16,3), SALDO02 N(16,3), SALDO03 N(16,3),   ;
        SALDO04 N(16,3),   SALDO05 N(16,3), NUMFCF C(6),     DTSCACF C(10),     ;
        CIVA1CF C(3),      SALDO06 N(16,3), SALDO07 N(16,3),   ;
        SALDO08 N(16,3),   SALDO09 N(16,3), SALDO10 N(16,3), COD01 C(13),     COD02 C(13),       ;
        COD03 C(13),       COD04 C(13),     COD05 C(13),     ABBUONO N(16,3), PESO N(10,2),      ;
        TISPE C(3),        PORTO C(3),      CLDOG C(16),     COD06 C(13),     COD07 C(13),       ;
        COD08 C(13),       COD09 C(13),     COD10 C(13),     JTIPOCO C(1),    NOTE M,            ;
        CCLI C(10),        CFOR C(10),      OK_PAG C(1),     OK_PMULT C(1),   CNUMFAT C(6),      ;
        CFATAGE C(6),      CDATFAT C(10),   CDTSCAD C(10),   CPROTO N(10),    CCAGE C(3),        ;
        SOLOIVA N(14,3),   CONTOP C(13),    CODSYS C(10),    CODGRU C(10),    CODCCO C(13))
					
SELECT * FROM &_CURS_DET INTO CURSOR ESPLODI

SELECT ESPLODI
GO TOP

DO FORM FORM\espl_mov LINKED

*IF PUB_RISOLU
*   DEFINE WINDOW WIN_DETT AT 1,1 SIZE 30,80
*   MOVE WINDOW WIN_DETT CENTER
*   BROWSE WINDOW WIN_DETT  NODELETE NOEDIT NORMAL FIELDS;
*					 CONTO	    :R:13:H="Conto",;
*					 DESCRIC	:R:40:H="Descrizione",;
*					 DARE 		:R:15:H="Dare":P="9999,999,999.99",;
*					 AVERE  	:R:15:H="Avere":P="9999,999,999.99",;
*					 IMPOSTA	:R:15:H="Imposta":P="9999,999,999.99",;
*					 NPARTCF	:R:10 :H="N.partita",;
* 					 NATURA		:R:8  :H="Natura",;
*					 IVA 	    :R:5  :H="Iva",;
*					 CECO 	    :R:13 :H="C. di Costo",;
* 					 DESCRIZ	:R:45 :H="Commenti riga 1",;
* 					 DESCRI1	:R:45 :H="Commenti riga 2";
*					 FONT "COURIER NEW",8 TITLE "Dettagli prima nota"
*   DEACTIVATE WINDOW WIN_DETT					
*   RELEASE WINDOW WIN_DETT					
*ELSE
*   DEFINE WINDOW WIN_DETT AT 1,1 SIZE 40,97
*   MOVE WINDOW WIN_DETT CENTER
*   BROWSE WINDOW WIN_DETT  NODELETE NOEDIT NORMAL FIELDS;
*					 CONTO	    :R:13:H="Conto",;
*					 DESCRIC	:R:40:H="Descrizione",;
*					 DARE 		:R:15:H="Dare":P="9999,999,999.99",;
*					 AVERE  	:R:15:H="Avere":P="9999,999,999.99",;
*					 IMPOSTA	:R:15:H="Imposta":P="9999,999,999.99",;
* 					 NPARTCF	:R:10 :H="N.partita",;
* 					 NATURA		:R:8  :H="Natura",;
*					 IVA 	    :R:5  :H="Iva",;
*					 CECO 	    :R:13 :H="C. di Costo",;
* 					 DESCRIZ	:R:45 :H="Commenti riga 1",;
* 					 DESCRI1	:R:45 :H="Commenti riga 2";
*					 FONT "COURIER NEW",8 TITLE "Dettagli prima nota"
*   DEACTIVATE WINDOW WIN_DETT					
*   RELEASE WINDOW WIN_DETT					
*ENDIF

SELECT(_SSXX)
GO _RECORDXXX

RETURN


*************************
FUNCTION ESPL_CCOM
*************************
PARA _CURS_DET

_SSXX      = SELECT()
_RECORDXXX = RECNO()

IF !ExecCommand("select * from U_CCO_LE where 0=1","CUR_CCO_LE")
  return(.f.)
ENDIF
SELECT CUR_CCO_LE
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_CCO_LE FROM ARRAY TRANSITO
INDEX ON LEG_SEQUEN TAG SEQUEN ADDITIVE    

SELECT ESPLODI
SCATTER MEMVAR

IF M.DARE <> 0
   M.DARIP = M.DARE
ENDIF  
IF M.AVERE <> 0
   M.DARIP = M.AVERE
ENDIF  
M.RIPA     = 0
M.SALDO    = 0

v_seek	= 'TOP' + M.TOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DES = DESCRI
ENDIF

IF M.CECO = 'SI - C.COSTO '
   SELECT CORPO_CCO
   SET ORDER TO I_CORPO3
   SEEK M.CODSYS + M.CODGRU + M.CODCCO
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF CCO_CODSYS = M.CODSYS .AND. ;
         CCO_MOVGRU = M.CODGRU .AND. ;
         CCO_MOVCCO = M.CODCCO
      ELSE
         EXIT
      ENDIF
      Z_CODSOC = PUB_CODSOC
      Z_CODTOP = M.TOP
      Z_DESTOP = DES
      Z_CODCON = M.CONTO
      Z_DESCON = M.DESCRIC
      Z_PERCEN = CCO_PERCEN
      Z_NATURA = CCO_NATURA
      Z_CODGRU = CCO_CODGRU
      Z_DESGRU = CCO_DESGRU
      Z_CODCCO = CCO_CODCCO
      Z_DESCCO = CCO_DESCCO
      Z_CODSYS = CCO_CODSYS
      Z_VALORE = CCO_VALORE
      SELECT CU_CCO_LE
      APPEND BLANK
      REPLACE LEG_CODSOC WITH Z_CODSOC      
      REPLACE LEG_CODTOP WITH Z_CODTOP      
      REPLACE LEG_DESTOP WITH Z_DESTOP      
      REPLACE LEG_CODCON WITH Z_CODCON      
      REPLACE LEG_DESCON WITH Z_DESCON      
      REPLACE LEG_PERCEN WITH Z_PERCEN      
      REPLACE LEG_NATURA WITH Z_NATURA      
      REPLACE LEG_CODGRU WITH Z_CODGRU      
      REPLACE LEG_DESGRU WITH Z_DESGRU      
      REPLACE LEG_CODCCO WITH Z_CODCCO      
      REPLACE LEG_DESCCO WITH Z_DESCCO      
      REPLACE LEG_VALORE WITH Z_VALORE      
      REPLACE LEG_VALOLD WITH Z_VALORE
      REPLACE LEG_CODSYS WITH Z_CODSYS
      M.RIPA  = M.RIPA + LEG_VALORE
      M.SALDO = M.DARIP - M.RIPA
      SELECT CORPO_CCO
      SKIP +1
   ENDDO
ELSE
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_codi = "con_conto = '" + ALLTRIM(M.COD01) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_codi
   Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecCommand(Csql,"cur_ccosto")
      return(.f.)
   ENDIF
   SELECT cur_ccosto
   IF EOF()
   ELSE
      M.COD06   = COD06
      M.COD07   = COD07
      M.COD08   = COD08
      M.COD09   = COD09
      M.COD10   = COD10
      M.DESCR01 = SPACE(13)
      M.DESCR02 = SPACE(13)
      M.DESCR03 = SPACE(13)
      M.DESCR04 = SPACE(13)
      M.DESCR05 = SPACE(13)
      M.DESCR06 = SPACE(13)
      M.DESCR07 = SPACE(13)
      M.DESCR08 = SPACE(13)
      M.DESCR09 = SPACE(13)
      M.DESCR10 = SPACE(13)
      SELECT CCOSTO
      SET ORDER TO CONTO
      IF !EMPTY(M.COD01)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD01) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR01
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD01      
         REPLACE LEG_DESCCO WITH M.DESCR01      
         REPLACE LEG_VALORE WITH M.SALDO01      
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD02)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD02) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR02
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD02    
         REPLACE LEG_DESCCO WITH M.DESCR02      
         REPLACE LEG_VALORE WITH M.SALDO02
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD03)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD03) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR03
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD03  
         REPLACE LEG_DESCCO WITH M.DESCR03      
         REPLACE LEG_VALORE WITH M.SALDO03
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD04)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD04) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR04
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD04  
         REPLACE LEG_DESCCO WITH M.DESCR04      
         REPLACE LEG_VALORE WITH M.SALDO04
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD05)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD05) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR05
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD05    
         REPLACE LEG_DESCCO WITH M.DESCR05      
         REPLACE LEG_VALORE WITH M.SALDO05
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD06)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD06) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR06
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD06    
         REPLACE LEG_DESCCO WITH M.DESCR06      
         REPLACE LEG_VALORE WITH M.SALDO06
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD07)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD07) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR07
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD07    
         REPLACE LEG_DESCCO WITH M.DESCR07      
         REPLACE LEG_VALORE WITH M.SALDO07
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD08)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD08) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR08
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD08  
         REPLACE LEG_DESCCO WITH M.DESCR08      
         REPLACE LEG_VALORE WITH M.SALDO08
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD09)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD09) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR09
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD09    
         REPLACE LEG_DESCCO WITH M.DESCR09      
         REPLACE LEG_VALORE WITH M.SALDO09
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
      IF !EMPTY(M.COD10)
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(M.COD10) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(Csql,"cur_ccosto")
            return(.f.)
         ENDIF
         SELECT cur_ccosto
         IF EOF()
         ELSE
            STORE CON_DESCR   TO M.DESCR10
         ENDIF
         SELECT CU_CCO_LE
         APPEND BLANK
         REPLACE LEG_CODSOC WITH PUB_CODSOC      
         REPLACE LEG_CODTOP WITH M.TOP    
         REPLACE LEG_DESTOP WITH DES      
         REPLACE LEG_CODCON WITH M.CONTO      
         REPLACE LEG_DESCON WITH M.DESCRIC    
         REPLACE LEG_NATURA WITH M.NATURA      
         REPLACE LEG_CODGRU WITH SPACE(10)      
         REPLACE LEG_CODCCO WITH M.COD10    
         REPLACE LEG_DESCCO WITH M.DESCR10     
         REPLACE LEG_VALORE WITH M.SALDO10
         M.RIPA  = M.RIPA + LEG_VALORE
         M.SALDO = M.DARIP - M.RIPA
         SELECT CCOSTO
      ENDIF
   ENDIF
ENDIF

SELECT CU_CCO_LE
GO TOP
IF EOF()
   WAIT WINDOW "Nessun centro di costo da gestire " NOWAIT
ELSE
   SELECT CU_CCO_LE
   GO TOP
   DO FORM FORM\ESPL_CCO LINKED
ENDIF

SELECT(_SSXX)
GO _RECORDXXX

RETURN


******************************
FUNCTION DES_LIN
******************************

REPLACE ORD_VALORE WITH 0

DO CASE
   CASE "PREZZO TOTALE" $ ORD_DESART	&& SOSTITUISCO IL VALORE CON VALORE DEL .TT
   	    REPLACE ORD_VALORE WITH XV_VALCO
   CASE "TOTAL PRICE" $ ORD_DESART	&& SOSTITUISCO IL VALORE CON VALORE DEL .TT
	    REPLACE ORD_VALORE WITH XV_VALCO
   CASE "VALEUR TOTAL" $ ORD_DESART	&& SOSTITUISCO IL VALORE CON VALORE DEL .TT
        REPLACE ORD_VALORE WITH XV_VALCO
   CASE "VALOR TOTAL" $ ORD_DESART	&& SOSTITUISCO IL VALORE CON VALORE DEL .TT
  	    REPLACE ORD_VALORE WITH XV_VALCO
ENDCASE

RETURN


******************************
FUNCTION _COMMENT
******************************
* GESTISCE IL TASTO COMMENTI DEI DOCUMENTI

PARA _PROC,_CURSX

M.ORD_VALCO = 0

OK_COMM= .T.

PUB_FORM = ""
COD_STD  = ""
DO FORM FORM\TESTI_ST
IF !EMPTY(PUB_FORM)
   IF !FILE(PUB_FORM)
      =MESSAGEB("Manca form di gestione testi "+PUB_FORM,16,"*** ATTENZIONE ***")
      OK_COMM = .F.
      RETURN
   ELSE
      DO FORM FORM\&PUB_FORM WITH _PROC,_CURSX,COD_STD,M.ORD_VALUTA LINKED
      OK_COMM = .F.
      RETURN
   ENDIF
ELSE
   =CREA_NOTE(_PROC,_CURSX,COD_STD,M.ORD_VALUTA)   && VERIFICA SE DEVE CREARE TESTO PARTICOLARE
ENDIF

RETURN

******************************
FUNCTION STAM_NOTE            && PERMETTE STAMPARE O MENO I COMMENTI
******************************
PARA _TIPON,_CODICEN

RELEASE _SOLOIT,_SOLOEX
PUBLIC  _SOLOIT,_SOLOEX
_SOLOIT = .F.
_SOLOEX = .F.

SS=STR(SELECT())

x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = '" + ALLTRIM(_CODICEN) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"note_com")
   return(.f.)
ENDIF
SELECT note_com
GO TOP

V_DS = .F.

IF reccount() <> 0

   DO CASE

      CASE _TIPON = "BOL"
           IF NOS_BOLLE
		      V_DS= .T.	
           ENDIF

      CASE _TIPON = "OFF"
           IF NOS_OFFERT
		      V_DS= .T.	
           ENDIF

      CASE _TIPON = "ORD"
           IF NOS_ORDINI
		      V_DS= .T.	
           ENDIF

      CASE _TIPON = "FAP"
           IF NOS_FATTPR
		      V_DS= .T.	
           ENDIF

      CASE _TIPON = "SPE"
           IF NOS_DISTSP
		      V_DS= .T.	
           ENDIF

      CASE _TIPON = "COM"
           IF NOS_COMME
		      V_DS= .T.	
           ENDIF

      CASE _TIPON = "FAT"
           IF NOS_FATTUR
		      V_DS= .T.	
           ENDIF

   ENDCASE

   _SOLOIT = NOS_SOLOIT
   _SOLOEX = NOS_SOLOEX

   IF _SOLOIT .AND. _SOLOEX      && STAMPA SEMPRE TUTTO
   ELSE
      IF _SOLOIT				&& SOLO PER CLIENTE/FORNITORE ITALIA
	     IF M.ORD_CODNAZ  <>  "ITA"
 	        V_DS= .F.	
	     ENDIF
      ENDIF
      IF _SOLOEX				&& SOLO PER CLIENTE/FORNITORE ESTERO
         IF M.ORD_CODNAZ  =  "ITA"
  	        V_DS= .F.	
	     ENDIF
      ENDIF
   ENDIF
ENDIF

SELECT &SS
RETURN(V_DS)


******************************
FUNCTION GEST_NOTE            && PERMETTE IL TRANSITO DA UN DOCUMENTO ALL'ALTRO DEI COMMENTI
******************************
PARA _TIPON,_CODICEN

SS=STR(SELECT())

V_DS= .F.

x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = '" + ALLTRIM(_CODICEN) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"note_com")
   return(.f.)
ENDIF
SELECT note_com
GO TOP

IF reccount() <> 0
   DO CASE
      CASE _TIPON = "BOL"
           IF NOT_BOLLE
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "OFF"
           IF NOT_OFFERT
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "ORD"
           IF NOT_ORDINI
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "FAP"
           IF NOT_FATTPR
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "SPE"
           IF NOT_DISTSP
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "COM"
           IF NOT_COMME
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "FAT"
           IF NOT_FATTUR
		      V_DS= .T.	
           ENDIF
   ENDCASE
ENDIF

SELECT &SS
RETURN(V_DS)


******************************
FUNCTION CREA_NOTE            && ELABORA I COMMENTI E DETERMINA SE DEVE CREARE IL COMMENTO IN AUTOMATICO
******************************

*PARA _TIPON,_CURSORE,_TIP_TXT,_XVAL
PARA _TIPON,_CURSORE,_TIP_TXT,_XVAL,_PESO,_PALLET,_DTCONS

_N_PAR  = PARAMETERS()

IF _N_PAR   = 2
  _TIP_TXT = "NO_AUTO"
ENDIF

IF _N_PAR   = 4
   _PESO    = ""
   _PALLET  = ""
   _DTCONS  = ""
ENDIF

RELEASE _SOLOIT,_SOLOEX
PUBLIC  _SOLOIT,_SOLOEX
_SOLOIT = .F.
_SOLOEX = .F.

IF _TIP_TXT = "NO_AUTO"
   =ISRT_NOAU()   							 		&& TESTI SENZA CALCOLI
ELSE
   =ISRT_SIAU(_TIPON,_CURSORE,_TIP_TXT,_XVAL,_PESO,_PALLET,_DTCONS)	 	&& TESTI CON CALCOLI
ENDIF

RETURN


******************************
FUNCTION ISRT_NOAU
******************************
* ELABORA I COMMENTI E DETERMINA SE DEVE CREARE IL COMMENTO IN AUTOMATICO

SS=STR(SELECT())

IF !ExecCommand("select * from note_com","note_com")
   return
ENDIF
SELECT NOTE_COM

DO WHILE .NOT. EOF()

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   _SOLOIT = NOS_SOLOIT
   _SOLOEX = NOS_SOLOEX

   DO CASE
      CASE _TIPON = "BOL"
           IF NOA_BOLLE
		      _TESTO = NOT_TESTO	
		      =ISRT_NOTE(_TESTO,_CURSORE)
           ENDIF
      CASE _TIPON = "OFF"
           IF NOA_OFFERT
		      _TESTO = NOT_TESTO	
		      =ISRT_NOTE(_TESTO,_CURSORE)
           ENDIF
      CASE _TIPON = "ORD"
          IF NOA_ORDINI
		     _TESTO = NOT_TESTO	
		     =ISRT_NOTE(_TESTO,_CURSORE)
          ENDIF
      CASE _TIPON = "FAP"
           IF NOA_FATTPR
		      _TESTO = NOT_TESTO	
		      =ISRT_NOTE(_TESTO,_CURSORE)
           ENDIF
      CASE _TIPON = "SPE"
           IF NOA_DISTSP
		      _TESTO = NOT_TESTO	
		      =ISRT_NOTE(_TESTO,_CURSORE)
           ENDIF
      CASE _TIPON = "COM"
           IF NOA_COMME
		      _TESTO = NOT_TESTO	
		      =ISRT_NOTE(_TESTO,_CURSORE)
           ENDIF
      CASE _TIPON = "FAT"
          IF NOA_FATTUR
		     _TESTO = NOT_TESTO	
		     =ISRT_NOTE(_TESTO,_CURSORE)
          ENDIF
   ENDCASE

   SELECT NOTE_COM
   SKIP +1

ENDDO

SELECT NOTE_COM
USE

SELECT &SS
RETURN(.T.)


******************************
FUNCTION ISRT_SIAU
******************************
* ELABORA I COMMENTI E DETERMINA SE DEVE CREARE IL COMMENTO IN AUTOMATICO CON CALCOLI RICHIESTI

PARA _TIPON,_CURSORE,_TIP_TXT,_XVAL,_PESO,_PALLET,_DTCONS
SS=STR(SELECT())

_TESTO=""

x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = '" + ALLTRIM(_TIP_TXT) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"note_com")
   return(.f.)
ENDIF
SELECT note_com
GO TOP

IF reccount() <> 0
   _TESTO = NOT_TESTO
   DO CASE
      CASE NOC_TOTDO		&& EFFETTUA CALCOLO TOTALE MERCE E CREA TESTO
           M.ORD_VALCO = 0
	       _TXT = NOT_TESTO	
           M.ORD_NOTE=TXT_TT(_TIPON,_CURSORE,_TIP_TXT,_TXT,_XVAL)
      CASE NOC_SPINC
      CASE NOC_SCON
      CASE NOC_GEST3
           _TESTO=CHR(13)+CHR(13)+CHR(13)+CHR(13)+'- - - - - - - - - - - - - - - - - - - - - - -'+CHR(13)
           _TESTO=_TESTO+NOT_TESTO	+": "+ALLTRIM(_PESO)
      CASE NOC_GEST4
           _TESTO=NOT_TESTO	+": "+ALLTRIM(_PALLET)
      CASE NOC_GEST5
           _TESTO=NOT_TESTO	+": "+ALLTRIM(_DTCONS)
      CASE NOC_GEST6
           *** IN QUESTO CASO IL PESO CONTIENE L'INDIRIZZO DELLA DESTINAZIONE
           _TESTO=NOT_TESTO	+": "+ALLTRIM(_PESO)
   ENDCASE
ENDIF

SELECT &SS
RETURN


******************************
FUNCTION TXT_TT
******************************
* CREA TESTO CON TOTALE MERCE

PARA _TIPON,_CURSORE,_TIP_TXT,_TXT,_XVAL

SELECT &_CURSORE
_REC_ = RECNO()

GO TOP
_TVAL = 0
_MATP = 0

DO WHILE .NOT.EOF()

   IF DELETED()
	  SELECT &_CURSORE
	  SKIP +1
	  LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
	  SELECT &_CURSORE
	  SKIP +1
	  LOOP
   ENDIF

   IF ORD_PUBBLI = "S"
	  _MATP = _MATP + ORD_VALORE
   ENDIF

   _TVAL = _TVAL + ORD_VALORE

   SELECT &_CURSORE
   SKIP +1

ENDDO

SELECT &_CURSORE
GO _REC_

_TVAL = _TVAL - _MATP							&& TOTALE MERCE

IF _XVAL  = "ITL" .OR.  _XVAL  = "LIT"			&& ARROTONDAMENTO
   _TVAL	=	ROUND(_TVAL,0)
ELSE
   _TVAL	=	ROUND(_TVAL,2)
ENDIF

* INSERISCE NEL TESTO IL VALORE CALCOLATO / IMPORTO CALCOLATO

M.ORD_VALCO  = _TVAL

IF _XVAL = "ITL" .OR. _XVAL = "LIT"
   _TXT = STRTRAN(_TXT,".TOTMERCE","")
ELSE
   _TXT = STRTRAN(_TXT,".TOTMERCE","")
ENDIF

RETURN(_TXT)


******************************
FUNCTION NOTE_SPE
******************************
* STAMPA TESTI SPECIALI
PARA _TIN

SS=STR(SELECT())

_RIT = .F.

x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = '" + ALLTRIM(_TIN) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"cur_notecom")
   return(.f.)
ENDIF
SELECT cur_notecom
GO TOP

IF reccount() <> 0
   DO CASE
      CASE NOC_TOTDO		
	   	   _RIT = .T.
      CASE NOC_SPINC
	  	   _RIT = .T.
      CASE NOC_SCON
	       _RIT = .T.
   ENDCASE
   IF NOC_ALLIN 	&& ALLINEA A DX
   	  PUB_ALLIN = .T.
   ELSE
 	  PUB_ALLIN = .F.
   ENDIF		   		
ENDIF

SELECT &SS
RETURN(_RIT)


******************************
FUNCTION ARTI_SPE
******************************
* VERIFICA SE DEVE STAMPARE O MENO L'ARTICOLO NEL DOCUMENTO
PARA _TIPON,_CODICEN

SS=STR(SELECT())

V_DS= .F.

x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = '" + ALLTRIM(_CODICEN) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"cur_notecom")
   return(.f.)
ENDIF
SELECT cur_notecom
GO TOP

IF reccount() <> 0
   DO CASE
      CASE _TIPON = "BOL"
           IF NOS_BOLLE
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "OFF"
           IF NOS_OFFERT
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "ORD"
           IF NOS_ORDINI
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "FAP"
           IF NOS_FATTPR
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "SPE"
           IF NOS_DISTSP
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "COM"
           IF NOS_COMME
		      V_DS= .T.	
           ENDIF
      CASE _TIPON = "FAT"
           IF NOS_FATTUR
		      V_DS= .T.	
           ENDIF
   ENDCASE
ENDIF 

SELECT &SS
RETURN(V_DS)


******************************
FUNCTION ISRT_NOTE            && INSERISCE LE NOTE
******************************
PARA _XNOT,_CURSORE

STS=STR(SELECT())

IF _SOLOIT .AND. _SOLOEX      && STAMPA SEMPRE TUTTO
ELSE
   IF _SOLOIT				&& SOLO PER CLIENTE/FORNITORE ITALIA
	  IF M.ORD_CODNAZ  <>  "ITA"
		 SELECT &STS
		 RETURN(.T.)
	  ENDIF
   ENDIF
   IF _SOLOEX				&& SOLO PER CLIENTE/FORNITORE ESTERO
	  IF M.ORD_CODNAZ  =  "ITA"
		 SELECT &STS
		 RETURN(.T.)
	  ENDIF
   ENDIF
ENDIF

SELECT &_CURSORE
APPEND BLANK
m.ord_codart  = SPACE(16)
M.ORD_MAGA	  = SPACE(06)
M.ORD_DESART  = "*** COMMENTO ***"
M.ORD_MAGA	  = SPACE(06)
M.ORD_DES2	  = SPACE(25)
M.ORD_UM	  = SPACE(02)
M.ORD_IVA	  = SPACE(02)
M.ORD_PREZZO  = 0
M.ORD_QTAORD  = 0
M.ORD_PRZNET  = 0
M.ORD_VALORE  = 0
M.ORD_SC1     = 0
M.ORD_SC2     = 0
M.ORD_SC3     = 0	
M.ORD_NOTE    = _XNOT
M.ord_pubbli  = " "
GATHER MEMVAR MEMO

IF SUBSTR(_CURSORE,1,1) = 'C'		
ELSE
   V_SQL  = 'select * from ' + _CURSORE + ' where 1=0'
   IF !ExecRW(V_SQL,"pippo","R")
      return
   ENDIF
   SELECT pippo
   APPEND BLANK
   m.ord_codart  = SPACE(16)
   M.ORD_MAGA	 = SPACE(06)
   M.ORD_DESART  = "*** COMMENTO ***" 
   M.ORD_MAGA	 = SPACE(06)
   M.ORD_DES2	 = SPACE(25)
   M.ORD_UM	     = SPACE(02)
   M.ORD_IVA	 = SPACE(02)
   M.ORD_PREZZO  = 0
   M.ORD_QTAORD  = 0
   M.ORD_PRZNET  = 0
   M.ORD_VALORE  = 0
   M.ORD_SC1     = 0
   M.ORD_SC2     = 0
   M.ORD_SC3     = 0	
   M.ORD_NOTE    = _XNOT
   M.ord_pubbli  = " "
   GATHER MEMVAR MEMO
   IF !ExecRW("","pippo","W")
      return
   ENDIF
ENDIF

SELECT &_CURSORE
GO TOP

SELECT &STS
RETURN(.T.)

******************************
PROCEDURE OK_LIST
******************************

SS=STR(SELECT())

** >>> 1) VERIFICA ARTICOLO OBSOLETO *********************************************************

M.ORD_SC1 		= 0
M.ORD_SC2 		= 0
M.ORD_SC3 		= 0
M.ORD_PRORIG 	= 0

IF ART_OBSOL = "S"
   =MESSAGEBOX("Articolo obsoleto"+CHR(13)+"non più utilizzabile",16,"*** ATTENZIONE ***")
   SELECT &SS
   RETURN(.F.)
ENDIF	

IF !EMPTY(IVA_ESE)	
   M.ORD_IVA	=IVA_ESE
ENDIF	

** >>> 2) GESTIONE SCONTI/PREZZI DA TIPO LISTINO DI ANAGRAFICA CLIENTE U_CLI_AN **************

IF PUB_LIS01
   TLISTINO=""
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cu_cli_an")
      return(.f.)
   ENDIF
   SELECT cu_cli_an
   GO TOP
   IF reccount() <> 0
      TLISTINO=CLI_LISTIN
      M.ORD_SC1=CLI_SC1
      M.ORD_SC2=CLI_SC2
      M.ORD_SC3=CLI_SC3
   ENDIF
   SELECT U_ART_PR
   DO CASE
      CASE TLISTINO="1"
           M.ORD_PREZZO  =ART_PRZVEN
      CASE TLISTINO="2"
           M.ORD_PREZZO  =ART_PRZVE2
      CASE TLISTINO="3"
           M.ORD_PREZZO  =ART_PRZVE3
      CASE TLISTINO="4"
           M.ORD_PREZZO  =ART_PRZVE4
      CASE TLISTINO="5"
           M.ORD_PREZZO  =ART_PRZVE5
      OTHERWISE
           M.ORD_PREZZO=0
   ENDCASE
ENDIF PUB_LIS01

** >>> 3) GESTIONE LISTINO DI VENDITA DA U_LIS_VE PER ARTICOLO COLLEGATO ALL'AGENTE/ZONA******

DA_DOC = .T.  
IF PUB_LIS02
   =OK_LISVE(PUB_CODSOC,TLISTIN,M.ORD_CODART,M.ORD_DATORD,"ZONA")
ENDIF PUB_LIS02

** >>> 4) 3 SCONTI DA ANAGRAFICA CLIENTE U_CLI_AN ********************************************

IF PUB_LIS03
   LL = 10 - LEN(M.ORD_CODCLI)
   M.ORD_CODCLI =M.ORD_CODCLI+REPLICATE(" ",LL)
   TLISTINO=""
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cu_cli_an")
      return(.f.)
   ENDIF
   SELECT cu_cli_an
   GO TOP
   IF reccount() <> 0
      TLISTINO=CLI_LISTIN
      M.ORD_SC1=CLI_SC1
      M.ORD_SC2=CLI_SC2
      M.ORD_SC3=CLI_SC3
   ENDIF
ENDIF PUB_LIS03

** >>> 5) 3 SCONTI/PREZZO DA LISTINO U_LIS_TT CLIENTE ARTICOLO***************************************

IF PUB_LIS04
   =OK_LISCA(PUB_CODSOC,M.ORD_CODCLI,M.ORD_CODART,M.ORD_DATORD,"CLIENTE")
ENDIF PUB_LIS04

** >>> 6) 3 SCONTI DA LISTINO U_LIS_LI CLIENTE LINEA ARTICOLO*********************************

IF PUB_LIS05
   =OK_LISLI(PUB_CODSOC,M.ORD_CODCLI,XLINEA,M.ORD_DATORD,"LINEA")
ENDIF PUB_LIS05

** >>> 7) PREZZO DA LISTINO U_LIS_AG AGENTE ARTICOLO****************************************

IF PUB_LIS09
   =OK_LISAG(PUB_CODSOC,M.ORD_AGE,M.ORD_CODART,M.ORD_DATORD,"AGENTE")
ENDIF PUB_LIS05

** >>> 8) MAGGIORAZIONE PREZZO DA U_CLI_AN ANAGRAFICA CLIENTE*********************************

IF PUB_LIS06
   LL = 10 - LEN(M.ORD_CODCLI)
   M.ORD_CODCLI =M.ORD_CODCLI+REPLICATE(" ",LL)
   TLISTINO=""
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cu_cli_an")
      return(.f.)
   ENDIF
   SELECT cu_cli_an
   GO TOP
   IF reccount() <> 0
      TLISTINO=CLI_LISTIN
      _PERC=CLI_PERC
	  VPRE=M.ORD_PREZZO
	  IF M.ORD_VALUTA = "ITL" .OR. M.ORD_VALUTA = "LIT"
	 	 VPRE=VPRE+ROUND((VPRE*_PERC/100),0)
	  ELSE
	 	 VPRE=VPRE+ROUND((VPRE*_PERC/100),2)
	  ENDIF
	  M.ORD_PREZZO=VPRE
   ENDIF
ENDIF PUB_LIS06

** >>> 9) CONVERSIONE PREZZO SU BASE VALUTA CLIENTE*********************************

IF PUB_LIS07
   v_seek	= 'VVP' + ALLTRIM(M.ORD_VALUTA)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'PARA')
      SELECT PARA
      _CAMBIOX = VAL(ALLTRIM(LIBERA))
   ELSE
	  =MESSAGEBOX('Valuta inesistente',64,'*** ATTENZIONE ***')
      _CAMBIOX = 1
   ENDIF
   IF _CAMBIOX = 0
	  _CAMBIOX = 1
   ENDIF
   IF M.ORD_VALUTA = "ITL" .OR. M.ORD_VALUTA = "LIT"
  	  VPRE=M.ORD_PREZZO
	  VPRE=ROUND((VPRE/_CAMBIOX),0)
	  M.ORD_PREZZO=VPRE
   ELSE
  	  VPRE=M.ORD_PREZZO
	  VPRE=ROUND((VPRE/_CAMBIOX),2)
	  M.ORD_PREZZO=VPRE
   ENDIF
ENDIF PUB_LIS07

** >>> 10) 3 SCONTI/PREZZO DA LISTINO U_LIS_TT CLIENTE ARTICOLO MA SENZA IL CLIENTE ***************************************

IF PUB_LIS08
   =OK_LISCA(PUB_CODSOC,SPACE(10),M.ORD_CODART,M.ORD_DATORD,"CLIENTE")
ENDIF PUB_LIS08

SELECT &SS
RETURN(.T.)


******************************
FUNCTION VERYSIN
******************************
* VERIFICA SE STAMPA RIGA SINTETICA SU DOCUMENTO

PARA _CURSY

SELECT &_CURSY

CART     = ORD_CODART
DART     = ORD_DESART

* VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(CART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cu_art_pr")
   return(.f.)
ENDIF
SELECT cu_art_pr
GO TOP
IF reccount() <> 0
   IF ART_SINTE
  	  SELECT &_CURSY
      REPLACE ORD_SINTE  WITH  .T.
   ELSE
      SELECT &_CURSY
      REPLACE ORD_SINTE  WITH  .F.
   ENDIF
ELSE
   SELECT &_CURSY
   REPLACE ORD_SINTE  WITH  .F.
ENDIF  		

SELECT &_CURSY

RETURN


******************************
FUNCTION _BOLDAFAT
******************************
* RESTITUISCE VERO SE LA BOLLA E' DA ELABORARE

PARA __TOP

SS=STR(SELECT())

v_seek	 = 'TOP' + ALLTRIM(__TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'PARA')
   SELECT PARA
   FAT = SUBSTR(LIBERA,2,1)
ELSE
   FAT = SPACE(1)
ENDIF

IF FAT = 'V'
   _OUT = .T.
ELSE	
   _OUT = .F.
ENDIF

SELECT &SS
RETURN(_OUT)


******************************
FUNCTION _VERYNC
******************************
* RESTITUISCE VERO SE E' UNA NOTA DI ACCREDITO

PARA __TOP

SS=STR(SELECT())

v_seek	= 'TOP' + ALLTRIM(__TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'PARA')
   SELECT PARA
   NCR   = SUBSTR(LIBERA,11,1)
ELSE
   NCR    = SPACE(1)
ENDIF

IF NCR = 'S'
   _OUT = .T.
ELSE	
   _OUT = .F.
ENDIF

SELECT &SS
RETURN(_OUT)


******************************
FUNCTION _VERYFA
******************************
* RESTITUISCE VERO SE E' UNA FATTURA O NOTA CREDITO DEL CLIENTE

PARA __TOP

SS=STR(SELECT())

v_seek	= 'TOP' + ALLTRIM(__TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'PARA')
   SELECT PARA
   _FAT   = SUBSTR(LIBERA,2,1)
   VER_CO = SUBSTR(LIBERA,12,1)
ELSE
   _FAT   = SPACE(1)
   VER_CO = SPACE(1)
ENDIF

IF VER_CO = "C"   &&  VERIFICA SE CLIENTE
   IF _FAT = 'S'
	  _OUT = .T.
   ELSE	
	  _OUT = .F.
   ENDIF
ELSE	
   _OUT = .F.
ENDIF
  
SELECT &SS
RETURN(_OUT)


******************************
FUNCTION CREA_SPIN
******************************
* CREA ARTICOLO CON SPESE D'INCASSO

PARA _TIPON,_CURSORE,_XVAL,_CONDP

IF !PUB_SPINC		&& VERIFICA SE OPZIONE ATTIVA
   RETURN
ENDIF

SS=STR(SELECT())

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(m.ord_codcli) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cu_cli_an")
   return(.f.)
ENDIF
SELECT cu_cli_an
GO TOP
IF reccount() <> 0
   X_SPINC= CLI_SPINCA
   IF X_SPINC = 0		&& SOLO SE ESISTE SPESA INCASSO
	  SELECT &SS
	  RETURN
   ENDIF
ELSE
   SELECT &SS
   RETURN
ENDIF

X_SEEK  = ".INC            "
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(X_SEEK) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cu_art_pr")
   return(.f.)
ENDIF
SELECT cu_art_pr
GO TOP
IF reccount() <> 0
   X_MAGA	=ART_MAGA
   X_DESART	=ART_DESCR
   X_UM		=ART_UNIMIS
   X_IVA	=ART_CODIVA
ELSE	
   X_MAGA	=PUB_CODM
   X_DESART	="CODIFICARE SPESE INCASSO"
   X_UM		=PUB_UM
   X_IVA	=PUB_IVA
ENDIF

v_seek	= 'CPA' + ALLTRIM(_CONDP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'PARA')
   SELECT PARA
   IF UPPER(SUBSTR(LIBERA,10,1)) <> "X"	&& CPA NON RICEVUTA BANCARIA
      X_SPINC = 0
      SELECT &SS
	  RETURN
   ENDIF
ENDIF

SELECT &_CURSORE

APPEND BLANK
m.ord_codart    =SPACE(16)
M.ORD_MAGA		=SPACE(06)
M.ORD_DESART	="*** COMMENTO ***"
M.ORD_CODICE    =""
M.ORD_NOTE      =" "
GATHER MEMVAR MEMO

APPEND BLANK
m.ord_codart    =".INC            "
M.ORD_MAGA		=X_MAGA
M.ORD_DESART	=X_DESART
M.ORD_CODICE    =""
M.ORD_UM		=X_UM
M.ORD_IVA		=X_IVA
M.ORD_QTAORD    =1
M.ORD_PREZZO	=X_SPINC
M.ORD_PRZNET    =X_SPINC
M.ORD_VALORE    =X_SPINC
M.ORD_NOTE      =SPACE(10)
M.ord_pubbli	=" "
M.ORD_DATCON    =""
GATHER MEMVAR MEMO


* RIPULISCE VARIABILI USATE
m.ord_codart    =SPACE(16)
M.ORD_MAGA		=SPACE(06)
M.ORD_DESART	=SPACE(25)
M.ORD_DES2		=SPACE(25)
M.ORD_UM		=SPACE(02)
M.ORD_IVA		=SPACE(02)
M.ORD_PREZZO	=0
M.ORD_QTAORD    =0
M.ORD_PRZNET    =0
M.ORD_VALORE    =0
M.ORD_SC1       =0
M.ORD_SC2       =0
M.ORD_SC3       =0	
M.ORD_NOTE      =SPACE(10)
M.ord_pubbli	= " "
M.ORD_CODICE    =SPACE(16)
M.ORD_DATCON    =space(10)

SELECT &SS
RETURN


******************************
FUNCTION _RESDANCR
******************************
* RESTITUISCE VERO SE LA BOLLA E' DA ELABORARE

PARA __TOP

SS=STR(SELECT())

v_seek	 = 'TOP' + ALLTRIM(__TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'PARA')
   SELECT PARA
   FAT   = SUBSTR(LIBERA,2,1)
ELSE
   FAT    = SPACE(1)
ENDIF

IF FAT = 'R'
   _OUT = .T.
ELSE	
   _OUT = .F.
ENDIF

SELECT &SS
RETURN(_OUT)


******************************
FUNCTION _ELAPART
******************************
* ELABORA FATTURE A RICHIESTA IMPOSTANDO IL CAMPO SELEZIONE
* __TIPO = DATA :  ACCESSO PER DATA
* __TIPO = NUME :  ACCESSO PER DATA

PARA __TIPO,__COD

SS=STR(SELECT())

DO CASE

   CASE __TIPO = "CLI"
        x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
        x_clie = "par_codcli = '" + ALLTRIM(__COD) + "'"
        cSql   = "SELECT * FROM PART_CLI WHERE " + x_soci + " and " + x_clie + ;
                                               " order by par_codsoc,par_codcli"
        IF !ExecRW(cSql,"part_cli","R")
           return
        ENDIF
		SELECT PART_CLI
		DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF
 		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
           REPLACE PAR_SYS     WITH __RC     && NUMERO RECORD CORRENTE
           SELECT  CPART_CL
           APPEND BLANK
           GATHER MEMVAR MEMO
  	       REPLACE PAR_SYS     WITH __RC     && NUMERO RECORD CORRENTE
   		   SELECT PART_CLI
		   SKIP +1
		ENDDO
        IF !ExecRW("","part_cli","W")
           return
        ENDIF

	CASE __TIPO = "FOR"
        x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
        x_clie = "par_codcli = '" + ALLTRIM(__COD) + "'"
        cSql   = "SELECT * FROM PART_FOR WHERE " + x_soci + " and " + x_clie + ;
                                               " order by par_codsoc,par_codcli"
        IF !ExecRW(cSql,"part_for","R")
           return
        ENDIF
		SELECT PART_FOR
		DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF
 		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
           REPLACE PAR_SYS     WITH __RC     && NUMERO RECORD CORRENTE
           SELECT  CPART_FO
           APPEND BLANK
           GATHER MEMVAR MEMO
	 	   REPLACE PAR_SYS     WITH __RC     && NUMERO RECORD CORRENTE
   		   SELECT PART_FOR
		   SKIP +1
		ENDDO
        IF !ExecRW("","part_for","W")
           return
        ENDIF
ENDCASE

SELECT &SS
RETURN


******************************
FUNCTION VERYIVA    				   && VERIFICA SE IVA ABILITATA A STAMPA ESENZIONI CLIENTE
******************************
PARA _CIVA
_IVA=_CIVA

IF EMPTY(_IVA)
   RETURN(.T.)
ENDIF

v_seek	 = 'IVA' + ALLTRIM(_IVA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'PARA')
   SELECT PARA
   _ESENZ    = SUBSTR(LIBERA,122,1)
ELSE	
   =MESSAGEBOX('Parametro IVA non trovato'+_IVA,64,'*** ATTENZIONE ***')
   _ESENZ    = " "
ENDIF

IF _ESENZ = "S"
   RETURN(.T.)
ELSE
   RETURN(.F.)
ENDIF


******************************
FUNCTION _OPERAT
******************************
* GESTIONE LIVELLO ACCESSO A INFORMAZIONI PER OPERATORE
* __DATO = CAMPO DA CONTROLLARE

PARA __DATO

v_seek	 = ALLTRIM(__dato)
v_chiave = "codice"
IF seek_std('Res_Oper',v_seek,v_chiave,'Res_Oper')
   SELECT Res_Oper
   PUB_PREZZI = NO_PREZZI
ELSE
   PUB_PREZZI = .F.
ENDIF

RETURN


**********************
PROCEDURE CARI_COMP
**********************
**   Procedura per lo scarico/carico automatico del magazzino dei componenti partendo
**   dall'emissione di una bolla (BOL000.SC*) o da una movimentazione di magazzino
**   (MAGA000.SC*). Il tutto in base ad un flag sul parametro TOP della causale.
**
** _TIPO_ = "ORD"  : GESTISCE SOLO IMPEGNATO CARICANDOLO/SCARICANDOLO IN FUNZIONE
**                 : DEL PARAMETRO IMPEGNATO PRELEVATO DAL TOP
** _TIPO_ = "BOL"  : GESTISCE IMPEGNATO  / GIACENZA CARICANDOLO/SCARICANDOLO IN FUNZIONE
**                 : DEL PARAMETRO IMPEGNATO PRELEVATO DAL TOP E DEL PARAMETRO CARICO SCARICO COMPONENTI


PARA  _TIPO_

SAVES=STR(SELECT())

RELEASE V_QTAMOV,VQTAMOV1,VQTAMOV2,VQTAMOV3,VQTAMOV4,VQTAMOV5,VQTAMOV6,VQTAMOV7
PUBLIC  V_QTAMOV,VQTAMOV1,VQTAMOV2,VQTAMOV3,VQTAMOV4,VQTAMOV5,VQTAMOV6,VQTAMOV7
V_QTAMOV = 0
VQTAMOV1 = 0
VQTAMOV2 = 0
VQTAMOV3 = 0
VQTAMOV4 = 0
VQTAMOV5 = 0
VQTAMOV6 = 0
VQTAMOV7 = 0

SELECT WEXPLODE
GO TOP

DO WHILE !EOF()

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR

   IF M.WLIV = 1
      VQTAMOV1 = W_QUANTI
   ENDIF
   IF M.WLIV = 2
      VQTAMOV2 = VQTAMOV1 * M.WQTA
   ENDIF
   IF M.WLIV = 3
      VQTAMOV3 = VQTAMOV2 * M.WQTA
   ENDIF
   IF M.WLIV = 4
      VQTAMOV4 = VQTAMOV3 * M.WQTA
   ENDIF
   IF M.WLIV = 5
      VQTAMOV5 = VQTAMOV4 * M.WQTA
   ENDIF
   IF M.WLIV = 6
      VQTAMOV6 = VQTAMOV5 * M.WQTA
   ENDIF
   IF M.WLIV = 7
      VQTAMOV7 = VQTAMOV6 * M.WQTA
   ENDIF

   IF M.WTIP = 'T' .AND. M.WLIV = 1
      V_QTAMOV = VQTAMOV1
      SELECT WEXPLODE
      SKIP +1
      LOOP
   ENDIF

   IF M.WLIV = 2
      V_QTAMOV = VQTAMOV2
   ENDIF
   IF M.WLIV = 3
      V_QTAMOV = VQTAMOV3
   ENDIF
   IF M.WLIV = 4
      V_QTAMOV = VQTAMOV4
   ENDIF
   IF M.WLIV = 5
      V_QTAMOV = VQTAMOV5
   ENDIF
   IF M.WLIV = 6
      V_QTAMOV = VQTAMOV6
   ENDIF
   IF M.WLIV = 7
      V_QTAMOV = VQTAMOV7
   ENDIF

   IF M.WTIP = 'G' 
      SELECT WEXPLODE
      SKIP +1
      LOOP
   ENDIF

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.WCOD) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"u_art_pr")
      return(.f.)
   ENDIF
   SELECT u_art_pr
   GO TOP
   IF reccount() <> 0
      W_DA     = ART_DESCR
      W_UM     = ART_UNIMIS
      W_CF     = ART_CODF1
      W_CO     = ART_PRZCOS
   ELSE
      SELECT WEXPLODE
      SKIP +1
      LOOP
   ENDIF

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'CARI_COMP'
   IF _TIPO_ = 'BOL'
      H_GENMOV = 'SI' 
      H_TIPO   = 'GIA'
   ELSE
      H_GENMOV = "" 
      H_TIPO   = ""
   ENDIF
   H_IMPE   = IMPE
   H_MAGSCA = w_magaz
   H_MAGCAR = ""
   H_CODART = m.wcod
   H_TOPSCA = "200"
   H_TOPCAR = ""
   H_QUANTI = V_QTAMOV
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = W_CF
   H_PRZACQ = 0
   H_PRZVEN = 0
   H_CODIVA = ""
   H_SCONTO = 0
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT WEXPLODE
   SKIP +1

ENDDO

SELECT &SAVES
RETURN


******************************
FUNCTION _LISTFO
******************************
PARA _CODCLI,_CODART,_DATLIS,_ALLIST

IF SUBSTR(_DATLIS,3,1) = '/'
   _DATLIS = RIBALTA2(_DATLIS)
ENDIF
IF SUBSTR(_ALLIST,3,1) = '/'
   _ALLIST = RIBALTA2(_ALLIST)
ENDIF

SS=STR(SELECT())
OK_ESISTE = .F.

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie = "lis_codcli = '" + ALLTRIM(_codcli) + "'"
x_arti = "lis_codart = '" + ALLTRIM(_codart) + "'"
x_cond = x_soci + " and " + x_clie + " and " + x_arti
Csql   = "select * from u_lif_tt where " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
IF !ExecCommand(cSql,"u_lif_tt")
   return(.f.)
ENDIF
SELECT U_LIF_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF _DATLIS < LIS_DATLIS
      SKIP +1
      LOOP
   ENDIF
   
   IF _DATLIS > LIS_ALLIST
      SKIP +1
      LOOP
   ENDIF
 
   OK_ESISTE = .T.
   PUB_PREZZO = LIS_PREZZO
   PUB_SC1    = LIS_SC1
   PUB_SC2    = LIS_SC2
   PUB_SC3    = LIS_SC3

   EXIT

ENDDO

SELECT &SS
RETURN(OK_ESISTE)


***************************************************************************
FUNCTION LOG_CONT2
***************************************************************************
PARA _TIPOPE,_PROGRA,_ARCHIV,_CODCON,_DESCON,_NUMREG,_DATREG,_NUMDOC,_DATDOC,_VALDOC

SS=STR(SELECT())

X_SEEK = 'LOG_CONT'
IF !ExecRW("select * from para where codice=?X_SEEK","cu_para","R")
   return
ENDIF
SELECT CU_PARA
IF reccount() <> 0
ELSE
   APPEND BLANK
   REPLACE CODICE WITH 'LOG_CONT'
   REPLACE DESCRI WITH "LOG DI MONITORAGGIO ATTIVITA' SU COGE"
   REPLACE LIBERA WITH 'N'
ENDIF
X_LIBE = LIBERA
IF !ExecRW("","cu_para","W")
   return
ENDIF

IF SUBSTR(X_LIBE,1,1) = 'S'
   IF !ExecRW("select * from log_cont where 1=0","log_cont","R")
      return
   ENDIF
   SELECT LOG_CONT
   APPEND BLANK
   REPLACE LOG_PROGRA WITH _PROGRA
   REPLACE LOG_ARCHIV WITH _ARCHIV
   REPLACE LOG_TIPOPE WITH _TIPOPE
   REPLACE LOG_CODOPE WITH PUB_CODOPE
   REPLACE LOG_NOMOPE WITH PUB_NOMOPE
   REPLACE LOG_POSOPE WITH SYS(0)
   REPLACE LOG_CODCON WITH _CODCON
   REPLACE LOG_DESCON WITH _DESCON
   REPLACE LOG_NUMREG WITH ALLTRIM(_NUMREG)
   IF SUBSTR(_DATREG,3,1) = '/'
      REPLACE LOG_DATREG WITH RIBALTA2(_DATREG)
   ELSE
      REPLACE LOG_DATREG WITH _DATREG
   ENDIF
   REPLACE LOG_NUMDOC WITH _NUMDOC
   IF SUBSTR(_DATDOC,3,1) = '/'
      REPLACE LOG_DATDOC WITH RIBALTA2(_DATDOC)
   ELSE
      REPLACE LOG_DATDOC WITH _DATDOC
   ENDIF
   REPLACE LOG_VALDOC WITH _VALDOC
   REPLACE LOG_DATOPE WITH RIBALTA2(DTOC(DATE()))
   REPLACE LOG_ORAOPE WITH TIME()
   IF !ExecRW("","log_cont","W")
      return
   ENDIF
ENDIF

SELECT &SS

RETURN(.T.)


****************************************
FUNCTION OK_LISCA
****************************************
**
**  DETERMINA IL PREZZO DI VENDITA PER CLIENTE/ARTICOLO O TIPOLOGIA DEL LISTINO IN FUNZIONE DI PUB_LIS0A:
**
**
**  	- PER CLIENTE/ARTICOLO
**		- PER CLIENTE/ARTICOLO/DATA VALIDITA' DAL 
**						
**  RITORNA :
**
**		-  PUB_LISOK = .T. PER ABILITARE L'INSERIMENTO O MENO NELL'ARCHIVIO DEI LISTINI AGENTE/ARTICOLO                       
**		-  PUB_PREZZO/M.ORD_PREZZO : CONTENENTE L'ULTIMO PREZZO DI LISTINO VALIDO
**								 	 PER DETERMINARE SE IL PREZZO E' VALIDO CONSIDERA :
**
**									 IL FLAG DI VALIDITA' = SI 
**									 		- SE L'UTENTE STA CODIFICANDO I LISTINI FUTURI FINO
**											  A CHE NON HA ABILITATO IL LISTINO TRAMITE APPOSITA	
**											  PROCEDURA IL PREZZO NON E' CONSIDERATO
**
**									 PARTE DALL'ULTIMO PREZZO QUINDI IN VIGORE   	
**					
**

PARA _SOC,_CLI,_ART,_DTDO,_TIPO

IF SUBSTR(_DTDO,3,1) = '/'
ELSE
   _DTDO = RIBALTA2(_DTDO)
ENDIF

S_S=STR(SELECT())

IF !PUB_LIS0A       && GESTIONE LISTINO PER SOLO CLIENTE ARTICOLO E NO VERSIONE

   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "lis_codcli = '" + ALLTRIM(m.ord_codcli) + "'"
   x_arti = "lis_codart = '" + ALLTRIM(m.ord_codart) + "'"
   x_cond = x_soci + " and " + x_clie + " and " + x_arti
   Csql   = "select * from u_lis_tt where " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
   IF !ExecCommand(cSql,"cur_u_lis_tt")
      return(.f.)
   ENDIF
   SELECT CUR_U_LIS_TT
   IF reccount() <> 0
      M.ORD_PREZZO = LIS_PREZZO
	  M.ORD_SC1	   = LIS_SC1
	  M.ORD_SC2	   = LIS_SC2
	  M.ORD_SC3	   = LIS_SC3
 	  M.ORD_PRORIG = LIS_PROVVI			  			
      M.ORD_PUBBLI = LIS_PUBBLI  
   ELSE
	  IF !PUB_MSG_LISTINI 
	     =MESSAGEBOX("Articolo non presente"+CHR(13)+"nel listino del cliente",16,"*** ATTENZIONE ***") 
	  ENDIF
   ENDIF

   RETURN  
  
ENDIF !M.AZI_LIS0A       && GESTIONE LISTINO PER SOLO CLIENTE ARTICOLO

* GESTIONE VERSIONE LISTINO RICERCANDO LA VERSIONE IN VIGORE SU BASE 
* DATA DI VALIDITA' DEL LISTINO STESSO
* EFFETTUA UNA SELECT PER CLIENTE/ARTICOLO/DATA DOCUMENTO : SE ESISTE 
*														  : PRELEVA IL PREZZO + SCONTI

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie = "lis_codcli = '" + ALLTRIM(_CLI) + "'"
x_arti = "lis_codart = '" + ALLTRIM(_ART) + "'"
x_cond = x_soci + " and " + x_clie + " and " + x_arti
Csql   = "select * from u_lis_tt where " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
IF !ExecCommand(cSql,"TMP1")
   return(.f.)
ENDIF

PUB_LISOK = .T.				&& E' POSSIBILE INSERIRE IL LISTINO

SELECT TMP1
INDEX ON LIS_ALLIST	DESCENDING TAG DATADAL ADDITIVE
GO TOP

IF !EOF()    						&& ESISTONO DEI RECORD TROVATI
   IF SUBSTR(_DTDO,3,1) = '/'
   ELSE
      _DTDO = RIBALTA2(_DTDO)
   ENDIF
   =LIS_LOGU(_DTDO,_TIPO)			&& CERCA IL SCONTI IN VIGORE
   * VERIFICA SE ESISTE UN PREZZO GIA' INSERITO NELLA DATA DESIDERATA
   IF SUBSTR(_DTDO,3,1) = '/'
   ELSE
      _DTDO = RIBALTA2(_DTDO)
   ENDIF
   SELECT *;
	  FROM TMP1;
	  WHERE RIBALTA2(_DTDO)==LIS_DATLIS    INTO CURSOR TMP2
   IF !EOF()
	  IF LIS_LOGV("XXX",LIS_DATLIS,LIS_ALLIST,_TIPO,"XXX","XXX",_CLI)	&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
	     PUB_LISOK    = .F.							&& ESISTE UN PREZZO VALIDO DA QUEL GIORNO : NON E' POSSIBILE INSERIRE IL LISTINO
	  ENDIF
   ENDIF	
ENDIF          

SELECT &S_S

RETURN


****************************************
FUNCTION OK_LISVE
****************************************
**
**  DETERMINA IL PREZZO DI VENDITA PER CLIENTE/ZONA AGENTE O TIPOLOGIA DEL LISTINO IN FUNZIONE DI PUB_LIS0A:
**
**
**  	- PER CLIENTE/ZONA AGENTE
**		- PER CLIENTE/ZONA AGENTE/DATA VALIDITA' DAL 
**						
**  RITORNA :
**
**		-  PUB_LISOK = .T. PER ABILITARE L'INSERIMENTO O MENO NELL'ARCHIVIO DEI LISTINI AGENTE/ARTICOLO                       
**		-  PUB_PREZZO/M.ORD_PREZZO : CONTENENTE L'ULTIMO PREZZO DI LISTINO VALIDO
**								 	 PER DETERMINARE SE IL PREZZO E' VALIDO CONSIDERA :
**
**									 IL FLAG DI VALIDITA' = SI 
**									 		- SE L'UTENTE STA CODIFICANDO I LISTINI FUTURI FINO
**											  A CHE NON HA ABILITATO IL LISTINO TRAMITE APPOSITA	
**											  PROCEDURA IL PREZZO NON E' CONSIDERATO
**
**									 PARTE DALL'ULTIMO PREZZO QUINDI IN VIGORE   	
**					
**

PARA _SOC,_TLI,_ART,_DTDO,_TIPO

IF SUBSTR(_DTDO,3,1) = '/'
ELSE
   _DTDO = RIBALTA2(_DTDO)
ENDIF

S_S=STR(SELECT())

IF DA_DOC && RICHIAMO DA DOCUMENTI (ORD,BOL,,,, E NON DALLA PROCEDURA DI GESTIONE DEL LISTINO STESSO
   x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "age_codice = '" + ALLTRIM(m.ord_age) + "'"
   x_cond = x_soci + " and " + x_clie
   cSql="SELECT * FROM U_AGE_AN WHERE " + x_cond + " order by age_codsoc,age_codice"
   IF !ExecCommand(cSql,"u_age_an")
      return(.f.)
   ENDIF
   SELECT U_AGE_AN
   IF reccount() <> 0
	  _TLI=AGE_LISTIN
   ELSE
	  _TLI=SPACE(2)
   ENDIF
ENDIF

IF !PUB_LIS0A       && GESTIONE LISTINO PER SOLO TIPO LISTINO ARTICOLO E NO VERSIONE
   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_tipo = "lis_tipo = '" + ALLTRIM(_TLI) + "'"
   x_codi = "lis_codart = '" + ALLTRIM(_ART) + "'"
   x_cond = x_soci + " and " + x_tipo + " and " + x_codi
   cSql="SELECT * FROM U_LIS_VE WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_codart"
   IF !ExecCommand(cSql,"CUR_u_lis_ve")
      return(.f.)
   ENDIF
   SELECT CUR_U_LIS_VE
   IF reccount() <> 0
      M.ORD_PREZZO	= LIS_PREZZO
	  M.ORD_PRORIG 	= LIS_PROV1			  			
	  M.ORD_SC1  	= LIS_SCO
      M.ORD_PUBBLI  = LIS_PUBBLI  
   ENDIF
   RETURN  
ENDIF 

* GESTIONE VERSIONE LISTINO RICERCANDO LA VERSIONE IN VIGORE SU BASE 
* DATA DI VALIDITA' DEL LISTINO STESSO
* EFFETTUA UNA SELECT PER TIPO LISTINO/ARTICOLO/DATA DOCUMENTO : SE ESISTE 
*														  : PRELEVA IL PREZZO + SCONTI

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_tipo = "lis_tipo = '" + ALLTRIM(_TLI) + "'"
x_codi = "lis_codart = '" + ALLTRIM(_ART) + "'"
x_cond = x_soci + " and " + x_tipo + " and " + x_codi
cSql="SELECT * FROM U_LIS_VE WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_codart"
IF !ExecCommand(cSql,"TMP1")
   return(.f.)
ENDIF

PUB_LISOK = .T.				&& E' POSSIBILE INSERIRE IL LISTINO

SELECT TMP1
INDEX ON LIS_DATLIS DESCENDING TAG DATADAL ADDITIVE
GO TOP

IF !EOF()    						&& ESISTONO DEI RECORD TROVATI
   IF SUBSTR(_DTDO,3,1) = '/'
   ELSE
      _DTDO = RIBALTA2(_DTDO)
   ENDIF
   =LIS_LOGU(_DTDO,_TIPO)			&& CERCA IL PREZZO IN VIGORE
   * VERIFICA SE ESISTE UN PREZZO GIA' INSERITO NELLA DATA DESIDERATA
   IF SUBSTR(_DTDO,3,1) = '/'
   ELSE
      _DTDO = RIBALTA2(_DTDO)
   ENDIF
   SELECT *;
	  FROM TMP1;
	  WHERE RIBALTA2(_DTDO)==LIS_DATLIS    INTO CURSOR TMP2
   IF !EOF()
      IF LIS_LOGV("XXX",LIS_DATLIS,LIS_ALLIST,_TIPO,"XXX",LIS_TIPO,"XXX")	&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
	     PUB_LISOK    = .F.							&& ESISTE UN PREZZO VALIDO DA QUEL GIORNO : NON E' POSSIBILE INSERIRE IL LISTINO
	  ENDIF
   ENDIF	
ENDIF          

SELECT &S_S

RETURN


****************************************
FUNCTION OK_LISLI
****************************************
**
**  DETERMINA IL PREZZO DI VENDITA PER CLIENTE/LINEA PRODOTTO IN FUNZIONE DI PUB_LIS0A:
**
**  	- PER CLIENTE/LINEA PRODOTTO
**		- PER CLIENTE/LINEA PRODOTTO/DATA VALIDITA' DAL 
**						
**  RITORNA :
**
**		-  PUB_LISOK = .T. PER ABILITARE L'INSERIMENTO O MENO NELL'ARCHIVIO DEI LISTINI AGENTE/ARTICOLO                       
**		-  PUB_PREZZO/M.ORD_PREZZO : CONTENENTE L'ULTIMO PREZZO DI LISTINO VALIDO
**								 	 PER DETERMINARE SE IL PREZZO E' VALIDO CONSIDERA :
**
**									 IL FLAG DI VALIDITA' = SI 
**									 		- SE L'UTENTE STA CODIFICANDO I LISTINI FUTURI FINO
**											  A CHE NON HA ABILITATO IL LISTINO TRAMITE APPOSITA	
**											  PROCEDURA IL PREZZO NON E' CONSIDERATO
**
**									 PARTE DALL'ULTIMO PREZZO QUINDI IN VIGORE   	
**					
**


PARA _SOC,_CLI,_LIN,_DTDO,_TIPO

S_S=STR(SELECT())

IF !PUB_LIS0A       && GESTIONE LISTINO PER SOLO CLIENTE/LINEA PRODOTTO
   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "lis_codcli = '" + ALLTRIM(_CLI) + "'"
   x_line = "lis_linart = '" + ALLTRIM(_LIN) + "'"
   x_cond = x_soci + " and " + x_clie + " and " + x_line
   cSql="SELECT * FROM U_LIS_LI WHERE " + x_cond + " order by lis_codsoc,lis_codcli,lis_linart"
   IF !ExecCommand(cSql,"CUR_u_lis_li")
      return(.f.)
   ENDIF
   SELECT U_LIS_LI
   IF reccount() <> 0
      M.ORD_SC1 	= LIS_SC1
	  M.ORD_SC2 	= LIS_SC2
	  M.ORD_SC3 	= LIS_SC3			  			
	  M.ORD_PRORIG 	= LIS_PR1			  			
   ENDIF
   RETURN  
ENDIF !M.AZI_LIS0A       

* GESTIONE VERSIONE LISTINO RICERCANDO LA VERSIONE IN VIGORE SU BASE 
* DATA DI VALIDITA' DEL LISTINO STESSO
* EFFETTUA UNA SELECT PER TIPO CLIENTE/LINEA PRODOTTO/DATA DOCUMENTO : SE ESISTE 
*														  : PRELEVA IL PREZZO + SCONTI

SELECT *;
  FROM U_LIS_LI;
  WHERE PUB_CODSOC=LIS_CODSOC   AND;
        _CLI=LIS_CODCLI         AND;
        _LIN=LIS_LINART;
  INTO CURSOR TMP1

PUB_LISOK = .T.				&& E' POSSIBILE INSERIRE IL LISTINO

SELECT TMP1
INDEX ON RIBALTA2(LIS_DATLIS)	DESCENDING		TAG DATADAL    ADDITIVE
GO TOP

IF !EOF()    						&& ESISTONO DEI RECORD TROVATI
   =LIS_LOGU(_DTDO,_TIPO)			&& CERCA IL SCONTI IN VIGORE
   * VERIFICA SE ESISTE UN PREZZO GIA' INSERITO NELLA DATA DESIDERATA
   SELECT *;
	  FROM TMP1;
	  WHERE RIBALTA2(_DTDO)==RIBALTA2(LIS_DATLIS)    INTO CURSOR TMP2
   IF !EOF()
      IF LIS_LOGV("XXX",LIS_DATLIS,LIS_ALLIST,_TIPO,LIS_LINART,"XXX","XXX")	&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
	     PUB_LISOK    = .F.							&& ESISTE UN PREZZO VALIDO DA QUEL GIORNO : NON E' POSSIBILE INSERIRE IL LISTINO
	  ENDIF
   ENDIF	
ENDIF          

SELECT &S_S

RETURN


****************************************
FUNCTION OK_LISAG
****************************************
**
**  DETERMINA IL PREZZO DI VENDITA IN FUNZIONE DI PUB_LIS0A:
**
**  	- PER AGENTE/ARTICOLO
**		- PER AGENTE/ARTICOLO/DATA VALIDITA' DAL 
**						
**  RITORNA :
**
**		-  PUB_LISOK = .T. PER ABILITARE L'INSERIMENTO O MENO NELL'ARCHIVIO DEI LISTINI AGENTE/ARTICOLO                       
**		-  PUB_PREZZO/M.ORD_PREZZO : CONTENENTE L'ULTIMO PREZZO DI LISTINO VALIDO
**								 	 PER DETERMINARE SE IL PREZZO E' VALIDO CONSIDERA :
**
**									 IL FLAG DI VALIDITA' = SI 
**									 		- SE L'UTENTE STA CODIFICANDO I LISTINI FUTURI FINO
**											  A CHE NON HA ABILITATO IL LISTINO TRAMITE APPOSITA	
**											  PROCEDURA IL PREZZO NON E' CONSIDERATO
**
**									 PARTE DALL'ULTIMO PREZZO QUINDI IN VIGORE   	
**					
**


PARA _SOC,_AGE,_ART,_DTDO,_TIPO

S_S=STR(SELECT())

IF !PUB_LIS0A       && GESTIONE LISTINO PER SOLO CLIENTE/LINEA PRODOTTO
   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "lis_age = '" + ALLTRIM(_AGE) + "'"
   x_line = "lis_codart = '" + ALLTRIM(_ART) + "'"
   x_cond = x_soci + " and " + x_clie + " and " + x_line
   cSql="SELECT * FROM U_LIS_AG WHERE " + x_cond + " order by lis_codsoc,lis_age,lis_codart"
   IF !ExecCommand(cSql,"u_lis_ag")
      return(.f.)
   ENDIF
   SELECT U_LIS_AG
   IF reccount() <> 0
	  M.ORD_PREZZO 	= LIS_PREZZO			  			
   ENDIF
   RETURN  
ENDIF !M.AZI_LIS0A       

* GESTIONE VERSIONE LISTINO RICERCANDO  : ULTIMO PREZZO VALIDO

SELECT *;
  FROM U_LIS_AG;
  WHERE PUB_CODSOC      = LIS_CODSOC   			AND;
        _AGE            = LIS_AGE      			AND;
        _ART            = LIS_CODART;
    INTO CURSOR TMP1

PUB_LISOK = .T.				&& E' POSSIBILE INSERIRE IL LISTINO

SELECT TMP1
INDEX ON RIBALTA2(LIS_DATLIS)	DESCENDING		TAG DATADAL    ADDITIVE
GO TOP

IF !EOF()    						&& ESISTONO DEI RECORD TROVATI
   =LIS_LOGU(_DTDO,_TIPO)			&& CERCA IL PREZZO IN VIGORE
   * VERIFICA SE ESISTE UN PREZZO GIA' INSERITO NELLA DATA DESIDERATA
   SELECT *;
	  FROM TMP1;
	  WHERE RIBALTA2(_DTDO)==RIBALTA2(LIS_DATLIS)    INTO CURSOR TMP2
   IF !EOF()
      IF LIS_LOGV(LIS_AGE,LIS_DATLIS,LIS_ALLIST,_TIPO,"XXX","XXX","XXX")	&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
	     PUB_LISOK    = .F.							&& ESISTE UN PREZZO VALIDO DA QUEL GIORNO : NON E' POSSIBILE INSERIRE IL LISTINO
	  ENDIF
   ENDIF	
ENDIF          

SELECT &S_S

RETURN


****************************************
FUNCTION LIS_LOGU
****************************************
**
**  RICERCA IL PREZZO IN VIGORE
**						
**

PARA _DTD,_TIPO

IF SUBSTR(_DTD,3,1) = '/'
ELSE
   _DTD = RIBALTA2(_DTD)
ENDIF

S_S=STR(SELECT())

SELECT TMP1
GO TOP

DO WHILE .NOT.EOF()

   * -->> verifica che la data di fatturazione rientri 
   * -->> nel periodo di validità del listino
   IF !BETWEEN(RIBALTA2(_DTD),LIS_DATLIS,LIS_ALLIST)
      SELECT TMP1
      SKIP +1
      LOOP
   ENDIF

   DO CASE 
 	  CASE _TIPO = "CLIENTE"
		   IF LIS_LOGV("XXX",_DTD,LIS_ALLIST,_TIPO,"XXX","XXX",LIS_CODCLI)	&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
		      M.ORD_PREZZO	= LIS_PREZZO
			  M.ORD_SC1	    = LIS_SC1
			  M.ORD_SC2	    = LIS_SC2
			  M.ORD_SC3	    = LIS_SC3
		 	  M.ORD_PRORIG  = LIS_PROVVI			  			
  	          M.ORD_PUBBLI  = LIS_PUBBLI  
			  PUB_PREZZO    = LIS_PREZZO						&& ULTIMO PREZZO IN VIGORE	  			
			  PUB_PUBBLI    = LIS_PUBBLI
		      EXIT
		   ENDIF
	  CASE _TIPO = "ZONA"
		   IF LIS_LOGV("XXX",_DTD,LIS_ALLIST,_TIPO,"XXX",LIS_TIPO,"XXX")	&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
		      M.ORD_PREZZO	= LIS_PREZZO
			  M.ORD_PRORIG = LIS_PROV1			  			
			  M.ORD_SC1  	= LIS_SCO
			  *M.ORD_SC2    = LIS_PROV2			  			
			  PUB_PREZZO   = LIS_PREZZO						&& ULTIMO PREZZO IN VIGORE	  			
	          M.ORD_PUBBLI = LIS_PUBBLI  
			  PUB_PUBBLI   = LIS_PUBBLI
		      EXIT
		   ENDIF
 	  CASE _TIPO = "LINEA"
		   IF LIS_LOGV("XXX",_DTD,LIS_ALLIST,_TIPO,LIS_LINART,"XXX","XXX")		&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
		      M.ORD_SC1 	= LIS_SC1
			  M.ORD_SC2 	= LIS_SC2
			  M.ORD_SC3 	= LIS_SC3			  			
			  M.ORD_PRORIG	= LIS_PR1			  			
		      EXIT
		   ENDIF
 	  CASE _TIPO = "AGENTE"
		   IF LIS_LOGV(LIS_AGE,_DTD,LIS_ALLIST,_TIPO,"XXX","XXX","XXX")		&& VERIFICA SE IL LISTINO E' IN VIGORE SU ULTIMO PREZZO IN VIGORE
		      M.ORD_PREZZO = LIS_PREZZO						&& ULTIMO PREZZO IN VIGORE	  			
			  PUB_PREZZO   = LIS_PREZZO						&& ULTIMO PREZZO IN VIGORE	  			
		      EXIT
		   ENDIF
   ENDCASE
      
   SELECT TMP1
   SKIP +1

ENDDO

SELECT &S_S

RETURN 


****************************************
FUNCTION LIS_LOGV
****************************************
**
**  VERIFCA LA VALIDITA DEL LISTINO  
**						
**

PARA _AGE,_DAL,_AL,_TIPO,_LIN,_ZON,_CLI

IF SUBSTR(_DAL,3,1) = '/'
ELSE
   _DAL = RIBALTA2(_DAL)
ENDIF
IF SUBSTR(_AL,3,1) = '/'
ELSE
   _AL = RIBALTA2(_AL)
ENDIF

S_S=STR(SELECT())

_OKVALIDO = .F.   && CONSIDERA SEMPRE NON VALIDO IL LISTINO

* VERIFICA PER OGNI RIGA DI LSTINO IN ELABORAZIONE SE LISTINO VALIDO

DO CASE 
   CASE _TIPO = "CLIENTE"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_clie = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_line = "lis_codcli = '" + ALLTRIM(_CLI) + "'"
        x_cond = x_soci + " and " + x_clie + " and " + x_line
        cSql   = "SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_codcli"
        IF !ExecCommand(cSql,"cur_u_lis_lg")
           return(.f.)
        ENDIF
        SELECT CUR_U_LIS_LG
   	    GO TOP
		DO WHILE .NOT. EOF()
   	   	   IF DELETED()									&& NO RECORD CANCELLATI
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
		   IF ALLTRIM(LIS_TIPO) <> ALLTRIM(_TIPO) 			&& NO RECORD DIVERSI DAL TIPO LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
           IF ALLTRIM(LIS_CODCLI) <> ALLTRIM(_CLI) 			&& NO RECORD DIVERSI DAL CLIENTE
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
	  	   IF !BETWEEN(RIBALTA2(_AL),LIS_DATLIS,LIS_ALLIST)	&& NO RECORD FUORI DA INTERVALLO DATE DEL LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
    	   IF LIS_VALIDO = "SI"
			  _OKVALIDO = .T.
	          EXIT										&& OK HO TROVATO UN LISTINO IN VIGORE
		   ENDIF
		   SELECT CUR_U_LIS_LG									&& CERCA LISTINI SUCCESSIVI IN DIETRO
		   SKIP +1
		ENDDO
	CASE _TIPO = "ZONA"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_clie = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_line = "lis_zona = '" + ALLTRIM(_ZON) + "'"
        x_cond = x_soci + " and " + x_clie + " and " + x_line
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_zona"
        IF !ExecCommand(cSql,"cur_u_lis_lg")
           return(.f.)
        ENDIF
        SELECT CUR_U_LIS_LG
   	    GO TOP
		DO WHILE .NOT. EOF()
		   IF DELETED()									&& NO RECORD CANCELLATI
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
		   IF ALLTRIM(LIS_TIPO) <> ALLTRIM(_TIPO) 			&& NO RECORD DIVERSI DAL TIPO LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
     	   IF ALLTRIM(LIS_ZONA) <> ALLTRIM(_ZON) 			&& NO RECORD DIVERSI DALLA ZONA
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
	   	   IF !BETWEEN(RIBALTA2(_AL),LIS_DATLIS,LIS_ALLIST)	&& NO RECORD FUORI DA INTERVALLO DATE DEL LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
           IF LIS_VALIDO = "SI"
			  _OKVALIDO = .T.
	          EXIT
		   ENDIF
 	       SELECT CUR_U_LIS_LG
		   SKIP +1
     	ENDDO
   CASE _TIPO = "LINEA"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_clie = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_line = "lis_linart = '" + ALLTRIM(_LIN) + "'"
        x_cond = x_soci + " and " + x_clie + " and " + x_line
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_linart"
        IF !ExecCommand(cSql,"cur_u_lis_lg")
           return(.f.)
        ENDIF
        SELECT CUR_U_LIS_LG
   	    GO TOP
		DO WHILE .NOT. EOF()
	   	   IF DELETED()									&& NO RECORD CANCELLATI
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
		   IF ALLTRIM(LIS_TIPO) <> ALLTRIM(_TIPO) 			&& NO RECORD DIVERSI DAL TIPO LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
           IF ALLTRIM(LIS_LINART) <> ALLTRIM(_LIN) 			&& NO RECORD DIVERSI DALLA LINEA
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
		   IF !BETWEEN(RIBALTA2(_AL),LIS_DATLIS,LIS_ALLIST)	&& NO RECORD FUORI DA INTERVALLO DATE DEL LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
      	   IF LIS_VALIDO = "SI"
			  _OKVALIDO = .T.
	          EXIT
		   ENDIF
	       SELECT CUR_U_LIS_LG
		   SKIP +1
        ENDDO
   CASE _TIPO = "AGENTE"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_clie = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_line = "lis_age = '" + ALLTRIM(_AGE) + "'"
        x_cond = x_soci + " and " + x_clie + " and " + x_line
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_age"
        IF !ExecCommand(cSql,"cur_u_lis_lg")
           return(.f.)
        ENDIF
        SELECT CUR_U_LIS_LG
   	    GO TOP
		DO WHILE .NOT. EOF()
	   	   IF DELETED()									&& NO RECORD CANCELLATI
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
		   IF ALLTRIM(LIS_TIPO) <> ALLTRIM(_TIPO) 			&& NO RECORD DIVERSI DAL TIPO LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
	   	   IF ALLTRIM(LIS_AGE) <> ALLTRIM(_AGE) 			&& NO RECORD DIVERSI DALL'AGENTE
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
		   IF !BETWEEN(RIBALTA2(_AL),LIS_DATLIS,LIS_ALLIST)	&& NO RECORD FUORI DA INTERVALLO DATE DEL LISTINO
			  SELECT CUR_U_LIS_LG
			  SKIP +1
			  LOOP
		   ENDIF
       	   IF LIS_VALIDO = "SI"
			  _OKVALIDO = .T.
	          EXIT
		   ENDIF
           SELECT CUR_U_LIS_LG
		   SKIP +1
  	    ENDDO
  	    
ENDCASE

SELECT &S_S

RETURN (_OKVALIDO)


****************************************
FUNCTION LIS_LOGA
****************************************
**
**  AGGIORNA LOG VALIDITA DEL LISTINO  
**						
**

PARA _AGE,_DAL,_AL,_TIPO,_LINEA,_ZON,_CLI
S_S=STR(SELECT())

IF SUBSTR(_DAL,3,1) = '/'
ELSE
   _DAL = RIBALTA2(_DAL)
ENDIF
IF SUBSTR(_AL,3,1) = '/'
ELSE
   _AL = RIBALTA2(_AL)
ENDIF
 
DO CASE

   CASE _TIPO = "CLIENTE"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_tipo = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_clie = "lis_codcli = '" + ALLTRIM(_CLI) + "'"
        x_data = "lis_datlis = '" + RIBALTA2(_DAL) + "'"
        x_cond = x_soci + " and " + x_tipo + " and " + x_clie + " and " + x_data
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_codcli,lis_datlis"
        IF !ExecRW(cSql,"U_LIS_LG","R")
           return(.f.)
        ENDIF
        SELECT U_LIS_LG
        IF RECCOUNT() = 0
		   APPEND BLANK
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ELSE
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ENDIF
        IF !ExecRW(cSql,"U_LIS_LG","W")
           return(.f.)
        ENDIF

   CASE _TIPO = "ZONA"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_tipo = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_zona = "lis_zona = '" + ALLTRIM(_ZON) + "'"
        x_data = "lis_datlis = '" + RIBALTA2(_DAL) + "'"
        x_cond = x_soci + " and " + x_tipo + " and " + x_zona + " and " + x_data
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_zona,lis_datlis"
        IF !ExecRW(cSql,"U_LIS_LG","R")
           return(.f.)
        ENDIF
        SELECT U_LIS_LG
        IF RECCOUNT() = 0
		   APPEND BLANK
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ELSE
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ENDIF
        IF !ExecRW(cSql,"U_LIS_LG","W")
           return(.f.)
        ENDIF

   CASE _TIPO = "LINEA"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_tipo = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_line = "lis_linart = '" + ALLTRIM(_LINEA) + "'"
        x_data = "lis_datlis = '" + RIBALTA2(_DAL) + "'"
        x_cond = x_soci + " and " + x_tipo + " and " + x_line + " and " + x_data
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_linart,lis_datlis"
        IF !ExecRW(cSql,"U_LIS_LG","R")
           return(.f.)
        ENDIF
        SELECT U_LIS_LG
        IF RECCOUNT() = 0
		   APPEND BLANK
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ELSE
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ENDIF
        IF !ExecRW(cSql,"U_LIS_LG","W")
           return(.f.)
        ENDIF

   CASE _TIPO = "AGENTE"
        x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
        x_tipo = "lis_tipo = '" + ALLTRIM(_TIPO) + "'"
        x_agen = "lis_age = '" + ALLTRIM(_AGE) + "'"
        x_data = "lis_datlis = '" + RIBALTA2(_DAL) + "'"
        x_cond = x_soci + " and " + x_tipo + " and " + x_agen + " and " + x_data
        cSql="SELECT * FROM U_LIS_LG WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_age,lis_datlis"
        IF !ExecRW(cSql,"U_LIS_LG","R")
           return(.f.)
        ENDIF
        SELECT U_LIS_LG
        IF RECCOUNT() = 0
		   APPEND BLANK
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ELSE
		   REPLACE LIS_CODSOC    WITH  PUB_CODSOC
		   REPLACE LIS_AGE		  WITH  _AGE
		   REPLACE LIS_LINART    WITH  _LINEA
		   REPLACE LIS_ZONA      WITH  _ZON	
		   REPLACE LIS_CODCLI    WITH  _CLI	
		   REPLACE LIS_DATLIS    WITH  RIBALTA2(_DAL)
		   REPLACE LIS_ALLIST    WITH  RIBALTA2(_AL)	
		   REPLACE LIS_VALIDO    WITH  "SI"	
		   REPLACE LIS_TIPO      WITH  _TIPO	
        ENDIF
        IF !ExecRW(cSql,"U_LIS_LG","W")
           return(.f.)
        ENDIF

ENDCASE

SELECT &S_S

RETURN 


***************************************************************************
 FUNCTION LOG_RETE2
***************************************************************************
 PARA _TIPOPE,_PROGRA,_ARCHIV,_CODCON,_DESCON,_NUMREG,_DATREG,_NUMDOC,_DATDOC,_VALDOC,_QUANDO

 SS=STR(SELECT())

X_SEEK = 'LOG_RETE'
IF !ExecRW("select * from para where codice=?X_SEEK","PARA","R")
   return
ENDIF
SELECT PARA
IF reccount() <> 0
ELSE
   APPEND BLANK
   REPLACE CODICE WITH 'LOG_RETE'
   REPLACE DESCRI WITH "LOG DI MONITORAGGIO AGGIORNAMENTI RETE SU COGE"
   REPLACE LIBERA WITH 'N'
ENDIF
X_LIBE = LIBERA
IF !ExecRW("","PARA","W")
   return
ENDIF

IF SUBSTR(X_LIBE,1,1) = 'S'
   IF _QUANDO = 'INI'
      IF !ExecRW("select * from log_rete where 1=0","log_rete","R")
         return
      ENDIF
      SELECT LOG_RETE
      APPEND BLANK
      REPLACE LOG_PROGRA WITH _PROGRA
      REPLACE LOG_ARCHIV WITH _ARCHIV
      REPLACE LOG_TIPOPE WITH _TIPOPE
      REPLACE LOG_CODOPE WITH PUB_CODOPE
      REPLACE LOG_NOMOPE WITH PUB_NOMOPE
      REPLACE LOG_POSOPE WITH SYS(0)
      REPLACE LOG_CODCON WITH _CODCON
      REPLACE LOG_DESCON WITH _DESCON
      REPLACE LOG_NUMREG WITH ALLTRIM(_NUMREG)
      IF SUBSTR(_DATREG,3,1) = '/'
         REPLACE LOG_DATREG WITH RIBALTA2(_DATREG)
      ELSE
         REPLACE LOG_DATREG WITH _DATREG
      ENDIF
      REPLACE LOG_NUMDOC WITH _NUMDOC
      IF SUBSTR(_DATDOC,3,1) = '/'
         REPLACE LOG_DATDOC WITH RIBALTA2(_DATDOC)
      ELSE
         REPLACE LOG_DATDOC WITH _DATDOC
      ENDIF
      REPLACE LOG_VALDOC WITH _VALDOC
      REPLACE LOG_DATOPE WITH RIBALTA2(DTOC(DATE()))
      REPLACE LOG_ORAOPE WITH TIME()
      REPLACE LOG_QUANDO WITH _QUANDO
      REPLACE LOG_CODSYS WITH X_CODSYS
      REPLACE LOG_RISULT WITH 'KO'
   ELSE
      IF !ExecRW("select * from log_rete where log_codsys=?X_CODSYS","log_rete","R")
         return
      ENDIF
      SELECT LOG_RETE
      IF reccount() <> 0
         IF RLOCK()
            REPLACE LOG_RISULT WITH 'OK'
            UNLOCK
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW("","log_rete","W")
      return
   ENDIF
 ENDIF

 SELECT &SS

 RETURN(.T.)

******************
PROCEDURE INTEMAG4
******************

**--> CREAZIONE STRUTTURA TABELLA DA PRODURRE PER COMMESSE

CREATE CURSOR TABDPRC (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_NUMERO C(06),   STA_DATA C(10),   ;
                       STA_QUANTI N(11,2), STA_CODICE C(10), ;
                       STA_RAGSOC C(40),   STA_DATCON C(10))
SELECT TABDPRC 
GO TOP

IF _V_CODMAG = SPACE(06)
   x_arti = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_arti 
   cSql="SELECT * FROM U_COM_DD WHERE " + x_cond + " order by ord_codart,ord_maga"
ELSE
   x_arti = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "ord_maga = '" + ALLTRIM(_V_CODMAG) + "'"
   x_cond = x_arti + " and " + x_maga
   cSql="SELECT * FROM U_COM_DD WHERE " + x_cond + " order by ord_codart,ord_maga"
ENDIF
IF !ExecCommand(cSql,"cur_commesse_dd")
   return(.f.)
ENDIF

SELECT CUR_COMMESSE_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ORD_CODART = _V_CODART
   ELSE
      EXIT
   ENDIF

   IF _V_CODMAG = SPACE(06)
   ELSE
      IF ORD_MAGA = _V_CODMAG
      ELSE
         EXIT
      ENDIF
   ENDIF         

   IF ORD_CHIUSO = .T.
      SKIP +1
      LOOP
   ENDIF

   V_CODMAG = ORD_MAGA
   DAGGA    = DAGGANCIO
   V_DATCON = ribalta2(ORD_DATCON)

   IF RIBALTA2(V_DATCON) => RIBALTA2(_V_DATADA)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   IF RIBALTA2(V_DATCON) <= RIBALTA2(_V_DATAAL)
   ELSE 
      SKIP +1
      LOOP
   ENDIF

   v_seek   = DAGGA
   v_chiave = "TAGGANCIO"
   IF seek_std('u_com_tt',v_seek,v_chiave,'CUR_COMMESSE_TT')
   ELSE 
      SELECT CUR_COMMESSE_DD
      SKIP +1
      LOOP
   ENDIF

   SELECT CUR_COMMESSE_TT

*   IF ORD_DATORD < RIBALTA2(_V_DATADA)
*      SELECT U_COM_DD
*      SKIP +1
*      LOOP
*   ENDIF
   
*   IF ORD_DATORD > RIBALTA2(_V_DATAAL)
*      SELECT U_COM_DD
*      SKIP +1
*      LOOP
*   ENDIF
    
   IF ORD_CHIUSO = .T.
      SELECT CUR_COMMESSE_DD
      SKIP +1
      LOOP
   ENDIF

   V_NUMERO = ORD_NUMORD
   V_DATA   = RIBALTA2(ORD_DATORD)
   V_CODICE = ORD_CODCLI
   V_RAGSOC = ORD_RAGSOC
   
   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   x_codi = "lcd_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "lcd_codmag = '" + ALLTRIM(V_CODMAG) + "'"
   x_nume = "lcd_numcom = '" + ALLTRIM(V_NUMERO) + "'"
   x_data = "lcd_datsca = '" + ALLTRIM(V_DATCON) + "'"
   x_cond = x_codi + " and " + x_maga + " and " + x_nume + " and " + x_data 
   Csql   = "select * from u_com_ed where " + x_cond + " order by lcd_codart,lcd_codmag,lcd_numcom,lcd_datsca"
   IF !ExecCommand(cSql,"cur_commesse_ed")
      return(.f.)
   ENDIF
   IF EOF()
      V_QUANTI = 0
   ELSE
      V_QUANTI = LCD_QTADPR
   ENDIF   

   IF V_QUANTI > 0
   ELSE
      SELECT CUR_COMMESSE_DD
      SKIP +1
      LOOP
   ENDIF

   SELECT TABDPRC
   APPEND BLANK
   REPLACE STA_CODMAG WITH V_CODMAG
   REPLACE STA_DESMAG WITH V_DESMAG
   REPLACE STA_NUMERO WITH V_NUMERO
   REPLACE STA_DATA   WITH V_DATA
   REPLACE STA_QUANTI WITH V_QUANTI
   REPLACE STA_CODICE WITH V_CODICE
   REPLACE STA_RAGSOC WITH V_RAGSOC
   REPLACE STA_DATCON WITH V_DATCON
   
   _V_QTADPR = _V_QTADPR + V_QUANTI
   
   SELECT CUR_COMMESSE_DD
   SKIP +1

ENDDO

RETURN


******************
PROCEDURE INTEMAG5
******************

**--> GENERAZIONE CURSORE PER ORDINI DA CLIENTI

**--> CREAZIONE STRUTTURA TABELLA ORDINI DA CLIENTI
CREATE CURSOR TABORDC (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_NUMERO C(06),   STA_DATA C(10),   ;
                       STA_QUANTI N(11,2), STA_CODICE C(10), ;
                       STA_RAGSOC C(40),   STA_DATCON C(10))
                       
SELECT TABORDC
GO TOP

IF _V_CODMAG = SPACE(06)
   x_codi = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_codi 
   Csql   = "select * from u_ord_dd where " + x_cond + " order by ord_codart,ord_maga"
ELSE
   x_codi = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "ord_maga = '" + ALLTRIM(_V_CODMAG) + "'"
   x_cond = x_codi + " and " + x_maga 
   Csql   = "select * from u_ord_dd where " + x_cond + " order by ord_codart,ord_maga"
ENDIF
IF !ExecCommand(cSql,"cur_ordcli_dd")
   return(.f.)
ENDIF

SELECT CUR_ORDCLI_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ORD_CODART = _V_CODART
   ELSE
      EXIT
   ENDIF

   IF _V_CODMAG = SPACE(06)
   ELSE
      IF ORD_MAGA = _V_CODMAG
      ELSE
         EXIT
      ENDIF
   ENDIF         

   IF ORD_CHIUSO = .T.
      SKIP +1
      LOOP
   ENDIF

   V_CODSYS = ORD_CODSYS
   V_CODMAG = ORD_MAGA
   V_QUANTI = ORD_QTAORD
   V_DATCON = ribalta2(ORD_DATCON)

   IF RIBALTA2(V_DATCON) => RIBALTA2(_V_DATADA)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   IF RIBALTA2(V_DATCON) <= RIBALTA2(_V_DATAAL)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   DAGGA = DAGGANCIO
   
   v_seek   = DAGGA
   v_chiave = "taggancio"
   IF seek_std('u_ord_tt',v_seek,v_chiave,'CUR_ORDCLI_TT')
   ELSE 
      SELECT CUR_ORDCLI_DD
      SKIP +1
      LOOP
   ENDIF
   
   SELECT CUR_ORDCLI_TT

*   IF ORD_DATORD => _V_DATADA
*   ELSE 
*      SELECT CUR_ORDCLI_DD
*      SKIP +1
*      LOOP
*   ENDIF
   
*   IF ORD_DATORD <= _V_DATAAL
*   ELSE 
*      SELECT CUR_ORDCLI_DD
*      SKIP +1
*      LOOP
*   ENDIF
    
   IF ORD_CHIUSO = .T.
      SELECT CUR_ORDCLI_DD
      SKIP +1
      LOOP
   ENDIF

   V_NUMERO = ORD_NUMORD
   V_DATA   = ORD_DATORD
   V_CODICE = ORD_CODCLI
   V_RAGSOC = ORD_RAGSOC
      
   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   IF V_CODSYS = SPACE(10)
      x_codi = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
      x_maga = "ord_maga = '" + ALLTRIM(_V_CODMAG) + "'"
      x_cond = x_codi + " and " + x_maga 
      Csql   = "select * from u_bol_dd where " + x_cond + " order by ord_codart,ord_maga"
      IF !ExecCommand(cSql,"cur_bolle_dd")
         return(.f.)
      ENDIF
      SELECT CUR_BOLLE_DD
      GO TOP
      IF !EOF()
         DO WHILE .T.
            IF EOF()
               EXIT
            ENDIF
            IF ORD_CODART = _V_CODART .AND. ORD_MAGA = V_CODMAG
            ELSE
               EXIT
            ENDIF      
            DAGGA = DAGGANCIO
            v_seek   = DAGGA
            v_chiave = "TAGGANCIO"
            IF seek_std('u_bol_tt',v_seek,v_chiave,'CUR_BOLLE_TT')
               SELECT CUR_BOLLE_TT
               IF ORD_NUMORC = V_NUMERO .AND. ORD_DATORC = V_DATA
                  SELECT CUR_BOLLE_DD
                  V_QUANTI = V_QUANTI - ORD_QTAORD
                  SKIP +1 
                  LOOP
               ENDIF
            ENDIF
            SELECT CUR_BOLLE_DD
            SKIP +1
         ENDDO
      ENDIF
   ELSE
      v_seek   = V_CODSYS
      v_chiave = "ORD_CODSYS"
      IF seek_std('u_bol_dd',v_seek,v_chiave,'CUR_BOLLE_DD')
         SELECT CUR_BOLLE_DD
         GO TOP
         DO WHILE .T.
            IF EOF()
               EXIT
            ENDIF
            IF ORD_CODSYS = V_CODSYS
            ELSE
               EXIT
            ENDIF        
            V_QUANTI = V_QUANTI - ORD_QTAORD
            SKIP +1
         ENDDO   
      ENDIF
   ENDIF       

   IF V_QUANTI > 0
      SELECT TABORDC
      APPEND BLANK
      REPLACE STA_CODMAG WITH V_CODMAG
      REPLACE STA_DESMAG WITH V_DESMAG
      REPLACE STA_NUMERO WITH V_NUMERO
      REPLACE STA_DATA   WITH V_DATA
      REPLACE STA_QUANTI WITH V_QUANTI
      REPLACE STA_CODICE WITH V_CODICE
      REPLACE STA_RAGSOC WITH V_RAGSOC
      REPLACE STA_DATCON WITH V_DATCON
      _V_ORDCLI = _V_ORDCLI + V_QUANTI
   ENDIF
   
   SELECT CUR_ORDCLI_DD
   SKIP +1

ENDDO

RETURN

******************
PROCEDURE INTEMAG6
******************

**--> GENERAZIONE CURSORE PER ORDINI CONTO LAVORO

CREATE CURSOR TABCLAV (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_NUMERO C(06),   STA_DATA C(10),   ;
                       STA_NUMBOL C(06),   STA_DATBOL C(10),  ;
                       STA_QUANTI N(11,2), STA_CODICE C(10), ;
                       STA_RAGSOC C(40),   STA_DATCON C(10))

SELECT TABCLAV
GO TOP

v_seek   = _V_CODART
v_chiave = "ord_codart"
=seek_std('u_ctl_dd',v_seek,v_chiave,'CUR_ORDCLA_DD')

SELECT CUR_ORDCLA_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ORD_CODART = _V_CODART
   ELSE
      EXIT
   ENDIF

 *  IF _V_CODMAG = SPACE(06)
 *  ELSE
 *     IF ORD_MAGA = _V_CODMAG
 *     ELSE
 *        EXIT
 *    ENDIF
 *  ENDIF         

   IF ORD_CHIUSO = .T.
      SKIP +1
      LOOP
   ENDIF

   V_CODMAG = ORD_MAGA
   V_QUANTI = ORD_QTAORD - ORD_QTAEV
   V_DATCON = ribalta2(ORD_DATCON)
   
   IF V_QUANTI > 0
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF RIBALTA2(V_DATCON) => RIBALTA2(_V_DATADA)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   IF RIBALTA2(V_DATCON) <= RIBALTA2(_V_DATAAL)
   ELSE 
      SKIP +1
      LOOP
   ENDIF

   DAGGA = DAGGANCIO
   
   v_seek   = DAGGA
   v_chiave = "taggancio"
   IF seek_std('u_ctl_tt',v_seek,v_chiave,'CUR_ORDCLA_TT')
   ELSE 
      SELECT CUR_ORDCLA_DD
      SKIP +1
      LOOP
   ENDIF
   
   SELECT CUR_ORDCLA_TT

*   IF ORD_DATORD => _V_DATADA
*   ELSE 
*      SELECT CUR_ORDCLA_DD
*      SKIP +1
*      LOOP
*   ENDIF
   
*   IF ORD_DATORD <= _V_DATAAL
*   ELSE 
*      SELECT CUR_ORDCLA_DD
*      SKIP +1
*      LOOP
*   ENDIF
    
   IF ORD_CHIUSO = .T.
      SELECT CUR_ORDCLA_DD
      SKIP +1
      LOOP
   ENDIF

   V_NUMERO = ORD_NUMORD
   V_DATA   = ORD_DATORD
   V_CODICE = ORD_CODCLI
   V_RAGSOC = ORD_RAGSOC
   V_NUMBOL = ORD_NUMBOL
   V_DATBOL = ORD_DATBOL 
      
   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   IF V_QUANTI > 0
   ELSE
      SELECT CUR_ORDCLA_DD
      SKIP +1
      LOOP
   ENDIF

   SELECT TABCLAV
   APPEND BLANK
   REPLACE STA_CODMAG WITH V_CODMAG
   REPLACE STA_DESMAG WITH V_DESMAG
   REPLACE STA_NUMERO WITH V_NUMERO
   REPLACE STA_DATA   WITH V_DATA
   REPLACE STA_QUANTI WITH V_QUANTI
   REPLACE STA_CODICE WITH V_CODICE
   REPLACE STA_RAGSOC WITH V_RAGSOC
   REPLACE STA_DATCON WITH V_DATCON
   REPLACE STA_NUMBOL WITH V_NUMBOL
   REPLACE STA_DATBOL WITH V_DATBOL 

   _V_CONLAV = _V_CONLAV + V_QUANTI
   
   SELECT CUR_ORDCLA_DD
   SKIP +1

ENDDO

RETURN

******************
PROCEDURE INTEMAG7
******************

**--> VERIFICA ESISTENZA VERSATO

V_TROV = 'NO'

IF _V_CODMAG = SPACE(06)
   v_seek   = _V_CODART
   v_chiave = "LCT_CODART"
   IF seek_std('u_com_et',v_seek,v_chiave,'CUR_COMMESSE_ET')
      SELECT CUR_COMMESSE_ET
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF _V_CODART = LCT_CODART
         ELSE
            EXIT
         ENDIF   
         IF DELETED()
            SKIP +1
            LOOP
         ENDIF
         IF LCT_QTAPRO > 0
         ELSE
            SKIP +1
            LOOP
         ENDIF
         V_TROV = 'SI'
         EXIT
      ENDDO
   ENDIF
ELSE
   x_codi = "lct_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "lct_codmag = '" + ALLTRIM(_V_CODMAG) + "'"
   x_tipo = "lct_tipart = 'T'"
   x_cond = x_codi + " and " + x_maga + " and " + x_tipo
   Csql   = "select * from u_com_et where " + x_cond + " order by lct_codart,lct_codmag,lct_tipart"
   IF !ExecCommand(cSql,"cur_commesse_et")
      return(.f.)
   ENDIF
   SELECT cur_commesse_et
   GO TOP
   IF EOF()
   ELSE
      IF LCT_QTAPRO > 0
         V_TROV = 'SI'
      ENDIF    
   ENDIF
ENDIF   

IF V_TROV = 'SI'
ELSE
   RETURN
ENDIF   

**--> CREAZIONE STRUTTURA TABELLA VERSATO DA PRODUZIONE

CREATE CURSOR TABVERC (STA_CODMAG C(06),   STA_DESMAG C(40), ;
                       STA_NUMERO C(06),   STA_DATA C(10),   ;
                       STA_QUANTI N(11,2), STA_CODICE C(10), ;
                       STA_RAGSOC C(40),   STA_DATCON C(10))
SELECT TABVERC 
GO TOP

IF _V_CODMAG = SPACE(06)
   x_arti = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_cond = x_arti 
   cSql="SELECT * FROM U_COM_DD WHERE " + x_cond + " order by ord_codart,ord_maga"
ELSE
   x_arti = "ord_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "ord_maga = '" + ALLTRIM(_V_CODMAG) + "'"
   x_cond = x_arti + " and " + x_maga
   cSql="SELECT * FROM U_COM_DD WHERE " + x_cond + " order by ord_codart,ord_maga"
ENDIF
IF !ExecCommand(cSql,"cur_commesse_dd")
   return(.f.)
ENDIF

SELECT CUR_COMMESSE_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ORD_CODART = _V_CODART
   ELSE
      EXIT
   ENDIF

   IF _V_CODMAG = SPACE(06)
   ELSE
      IF ORD_MAGA = _V_CODMAG
      ELSE
         EXIT
      ENDIF
   ENDIF         

   IF ORD_CHIUSO = .T.
      SKIP +1
      LOOP
   ENDIF

   V_CODMAG = ORD_MAGA
   DAGGA    = DAGGANCIO
   V_DATCON = ribalta2(ORD_DATCON)

   IF RIBALTA2(V_DATCON) => RIBALTA2(_V_DATADA)
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   IF RIBALTA2(V_DATCON) <= RIBALTA2(_V_DATAAL)
   ELSE 
      SKIP +1
      LOOP
   ENDIF

   v_seek   = DAGGA
   v_chiave = "taggancio"
   IF seek_std('u_com_tt',v_seek,v_chiave,'CUR_COMMESSE_TT')
   ELSE 
      SELECT CUR_COMMESSE_DD
      SKIP +1
      LOOP
   ENDIF

   SELECT CUR_COMMESSE_TT

*   IF ORD_DATORD < RIBALTA2(_V_DATADA)
*      SELECT CUR_COMMESSE_DD
*      SKIP +1
*      LOOP
*   ENDIF
   
*   IF ORD_DATORD > RIBALTA2(_V_DATAAL)
*      SELECT CUR_COMMESSE_DD
*      SKIP +1
*      LOOP
*   ENDIF
    
   IF ORD_CHIUSO = .T.
      SELECT CUR_COMMESSE_DD
      SKIP +1
      LOOP
   ENDIF

   V_NUMERO = ORD_NUMORD
   V_DATA   = RIBALTA2(ORD_DATORD)
   V_CODICE = ORD_CODCLI
   V_RAGSOC = ORD_RAGSOC
   
   v_seek	= 'MAG'+V_CODMAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_DESMAG = DESCRI
   ELSE  
      V_DESMAG = SPACE(40)
   ENDIF 

   x_codi = "lcd_codart = '" + ALLTRIM(_V_CODART) + "'"
   x_maga = "lcd_codmag = '" + ALLTRIM(V_CODMAG) + "'"
   x_nume = "lcd_numcom = '" + ALLTRIM(V_NUMERO) + "'"
   x_data = "lcd_datsca = '" + ALLTRIM(V_DATCON) + "'"
   x_cond = x_codi + " and " + x_maga + " and " + x_nume + " and " + x_data 
   Csql   = "select * from u_com_ed where " + x_cond + " order by lcd_codart,lcd_codmag,lcd_numcom,lcd_datsca"
   IF !ExecCommand(cSql,"cur_commesse_ed")
      return(.f.)
   ENDIF
   IF EOF()
      V_QUANTI = 0
   ELSE
      V_QUANTI = LCD_QTAPRO
   ENDIF   

   IF V_QUANTI > 0
   ELSE
      SELECT CUR_COMMESSE_DD
      SKIP +1
      LOOP
   ENDIF

   SELECT TABVERC
   APPEND BLANK
   REPLACE STA_CODMAG WITH V_CODMAG
   REPLACE STA_DESMAG WITH V_DESMAG
   REPLACE STA_NUMERO WITH V_NUMERO
   REPLACE STA_DATA   WITH V_DATA
   REPLACE STA_QUANTI WITH V_QUANTI
   REPLACE STA_CODICE WITH V_CODICE
   REPLACE STA_RAGSOC WITH V_RAGSOC
   REPLACE STA_DATCON WITH V_DATCON
   
   _V_QTAVER = _V_QTAVER + V_QUANTI
   
   SELECT CUR_COMMESSE_DD
   SKIP +1

ENDDO

RETURN

******************
PROCEDURE MAGAUTO
******************

*******************************************************************
**                     SCARICO/CARICO MAGAZZINI                   * 
** TRATTA LE FATTURE DEI DEPOSITI O AGENTI CON DEPOSITO           *
** TRATTA LA BOLLA DI CARICO PER GLI AGENTI NORMALI				  * 	
*******************************************************************

PUBLIC DEPCOLLE 

RIT = MESSAGEBOX("Proseguo con l'operazione ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

CREATE CURSOR CU_FAT_DD;
(DAGGANCIO C(10),ORD_CODART C(16),ORD_ARTGRU N(1),ORD_UM C(2),ORD_IVA C(3),ORD_DESART C(40),ORD_DES2 C(40),ORD_MAGA C(6),ORD_QTAORD N(10,2),ORD_PREZZO N(13,3),ORD_VALORE N(17,3),ORD_DATCON C(10),ORD_QTAFAT N(10),ORD_DATORD C(10),ORD_NUMORD C(6),ORD_CODCLI C(10))

_per   = 'S'
_sca   = 'S'
x_peri = "ord_perif = '" + _per + "'"
x_scar = "ord_scar  <> '" + _sca + "'"
cSql="SELECT * FROM u_fat_tt WHERE " + x_peri + " and " + x_scar + " order by taggancio"
IF !ExecCommand(cSql,"U_FAT_TT")
   return(.f.)
ENDIF
SELECT U_FAT_TT
GO TOP
WAIT WINDOW "Elaborazione fatture : attendere prego" NOWAIT

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP + 1
      LOOP
   ENDIF
  
   IF ORD_PERIF <> 'S'     && SCARTA FATTURE FATTE DIRETTAMENTE DA SEDE (SCARICO DA BOLLA)
      SKIP + 1
      LOOP
   ENDIF
  
   IF ORD_SCAR = 'S'       && SCARTO FATTURE GIA ELABORATE
      SKIP + 1
      LOOP
   ENDIF
  
   AGENTE = ALLTRIM(ORD_AGE)
   DEPOSITO = .F.
   DEPCOLLE = SPACE(03)

   x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
   x_clie = "age_codice = '" + ALLTRIM(AGENTE) + "'"
   x_cond = x_soci + x_clie
   cSql="SELECT * FROM U_AGE_AN WHERE " + x_cond + " order by age_codsoc,age_codice"
   IF !ExecCommand(cSql,"CUR_AGENTE")
      return(.f.)
   ENDIF
   SELECT CUR_AGENTE
   GO TOP
   IF EOF()
   ELSE
      IF AGE_DEPOSI <> 'D'
         DEPOSITO = .F.
      ELSE
         DEPOSITO = .T.
      ENDIF
   ENDIF
  
   SELECT U_FAT_TT

   IF !DEPOSITO    && SCARTA LE FATTURE DELL'AGENTE IN QUANTO TRATTATE SU BOLLA DI CARICO
      SKIP + 1
      LOOP
   ENDIF

   **	ELABORA LE FATTURE DI AGENTI DEL DEPOSITO         
   **    LO SCARICO AVVIENE CON IL CODICE DEL DEPOSITO E NON DELL'AGENTE

   TAGGA   = TAGGANCIO
   NUMORD  = ORD_NUMORD
   DATORD  = ORD_DATORD
   CODCLI  = ORD_CODCLI
    
   IF DEPOSITO
      v_seek	= TAGGA
      v_chiave = "daggancio"
      IF seek_std('u_fat_dd',v_seek,v_chiave,'u_fat_dd')
         SELECT U_FAT_DD
         DO WHILE !EOF()
            IF DELETED()
               SKIP + 1
               LOOP
            ENDIF
            IF TAGGA <> DAGGANCIO
               EXIT
            ENDIF
            IF ALLTRIM(ORD_DESART) = '*** COMMENTO ***'
               SKIP + 1
               LOOP
            ENDIF
            SCATTER MEMVAR
            SELECT CU_FAT_DD
            APPEND BLANK
            GATHER MEMVAR
            REPLACE ORD_NUMORD WITH NUMORD
            REPLACE ORD_DATORD WITH DATORD
            REPLACE ORD_CODCLI WITH CODCLI
            SELECT U_FAT_DD
            SKIP + 1
         ENDDO  
      ENDIF
   ENDIF
  
   SELECT U_FAT_TT
   SKIP + 1

ENDDO  

DO MAGSEDE    && AGGIORNA I DEPOSITI

*****************************************************************
*    CARICO DEL MAGAZZINO SEDE E SCARICO DEL MAGAZZINO AGENTE   *
*****************************************************************
WAIT WINDOW "ELABORAZIONE BOLLE DI CARICO : ATTENDERE PREGO" NOWAIT

CREATE CURSOR CU_TVE_DD;
(DAGGANCIO C(10),ORD_CODART C(16),ORD_ARTGRU N(1),ORD_UM C(2),ORD_IVA C(3),ORD_DESART C(40),ORD_DES2 C(40),ORD_MAGA C(6),ORD_QTAORD N(10,2),ORD_PREZZO N(13,3),ORD_VALORE N(17,3),ORD_DATCON C(10),ORD_QTAFAT N(10),ORD_DATORD C(10),ORD_NUMORD C(6),ORD_CODCLI C(10),ORD_MAGS C(6),ORD_MAGD C(6),ORD_INVEND N(10,2))

_sca   = 'S'
x_scar = "ord_rscar  <> '" + _sca + "'"
cSql="SELECT * FROM u_tve_tt WHERE " + x_scar + " order by taggancio"
IF !ExecCommand(cSql,"U_TVE_TT")
   return(.f.)
ENDIF
SELECT U_TVE_TT
GO TOP
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP + 1
      LOOP
   ENDIF
  
   IF ORD_RSCAR = 'S'  && SCARTO BOLLE GIA' SCARICATE
      SKIP + 1
      LOOP
   ENDIF
  
   TAGGA  = TAGGANCIO
   MAGS   = ORD_MAGS
   MAGD   = ORD_MAGD
   NUMORD = ORD_NUMORD
   DATORD = ORD_DATORD
   CODCLI = ORD_CODCLI
  
   v_seek	= TAGGA
   v_chiave = "daggancio"
   IF seek_std('u_tve_dd',v_seek,v_chiave,'u_tve_dd')
      SELECT U_TVE_DD
      DO WHILE !EOF()
         IF DELETED()
            SKIP + 1
            LOOP
         ENDIF
         IF TAGGA <> DAGGANCIO
            EXIT
         ENDIF
         SCATTER MEMVAR
         SELECT CU_TVE_DD
         APPEND BLANK
         GATHER MEMVAR
         REPLACE ORD_MAGS WITH MAGS
         REPLACE ORD_MAGD WITH MAGD
         REPLACE ORD_NUMORD WITH NUMORD
         REPLACE ORD_DATORD WITH DATORD
         REPLACE ORD_CODCLI WITH CODCLI
         SELECT U_TVE_DD
         SKIP + 1
      ENDDO
   ENDIF
  
   SELECT U_TVE_TT
   SKIP + 1
  
ENDDO  

DO MAGSCAR  && AGGIORNA I MAGAZZINI AGENTI

RELEASE DEPCOLLE 

= MESSAGEBOX("Operazione conclusa",62,"ATTENZIONE")

RETURN


*****************
PROCEDURE CARINUM
*****************

CREATE CURSOR WNUMERI (WNUM N(02,0), WALF C(20))
INDEX ON WNUM TAG I_NUMERO ADDITIVE

SELECT WNUMERI

APPEND BLANK
REPLACE WNUM WITH 1
REPLACE WALF WITH 'UN'
APPEND BLANK
REPLACE WNUM WITH 2
REPLACE WALF WITH 'DUE'
APPEND BLANK
REPLACE WNUM WITH 3
REPLACE WALF WITH 'TRE'
APPEND BLANK
REPLACE WNUM WITH 4
REPLACE WALF WITH 'QUATTRO'
APPEND BLANK
REPLACE WNUM WITH 5
REPLACE WALF WITH 'CINQUE'
APPEND BLANK
REPLACE WNUM WITH 6
REPLACE WALF WITH 'SEI'
APPEND BLANK
REPLACE WNUM WITH 7
REPLACE WALF WITH 'SETTE'
APPEND BLANK
REPLACE WNUM WITH 8
REPLACE WALF WITH 'OTTO'
APPEND BLANK
REPLACE WNUM WITH 9
REPLACE WALF WITH 'NOVE'
APPEND BLANK
REPLACE WNUM WITH 10
REPLACE WALF WITH 'DIECI'

APPEND BLANK
REPLACE WNUM WITH 11
REPLACE WALF WITH 'UNDICI'
APPEND BLANK
REPLACE WNUM WITH 12
REPLACE WALF WITH 'DODICI'
APPEND BLANK
REPLACE WNUM WITH 13
REPLACE WALF WITH 'TREDICI'
APPEND BLANK
REPLACE WNUM WITH 14
REPLACE WALF WITH 'QUATTORDICI'
APPEND BLANK
REPLACE WNUM WITH 15
REPLACE WALF WITH 'QUINDICI'
APPEND BLANK
REPLACE WNUM WITH 16
REPLACE WALF WITH 'SEDICI'
APPEND BLANK
REPLACE WNUM WITH 17
REPLACE WALF WITH 'DICIASETTE'
APPEND BLANK
REPLACE WNUM WITH 18
REPLACE WALF WITH 'DICIOTTO'
APPEND BLANK
REPLACE WNUM WITH 19
REPLACE WALF WITH 'DICIANOVE'
APPEND BLANK
REPLACE WNUM WITH 20
REPLACE WALF WITH 'VENTI'

APPEND BLANK
REPLACE WNUM WITH 21
REPLACE WALF WITH 'VENTUNO'
APPEND BLANK
REPLACE WNUM WITH 22
REPLACE WALF WITH 'VENTIDUE'
APPEND BLANK
REPLACE WNUM WITH 23
REPLACE WALF WITH 'VENTITRE'
APPEND BLANK
REPLACE WNUM WITH 24
REPLACE WALF WITH 'VENTIQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 25
REPLACE WALF WITH 'VENTICINQUE'
APPEND BLANK
REPLACE WNUM WITH 26
REPLACE WALF WITH 'VENTISEI'
APPEND BLANK
REPLACE WNUM WITH 27
REPLACE WALF WITH 'VENTISETTE'
APPEND BLANK
REPLACE WNUM WITH 28
REPLACE WALF WITH 'VENTOTTO'
APPEND BLANK
REPLACE WNUM WITH 29
REPLACE WALF WITH 'VENTINOVE'
APPEND BLANK
REPLACE WNUM WITH 30
REPLACE WALF WITH 'TRENTA'

APPEND BLANK
REPLACE WNUM WITH 31
REPLACE WALF WITH 'TRENTUNO'
APPEND BLANK
REPLACE WNUM WITH 32
REPLACE WALF WITH 'TRENTADUE'
APPEND BLANK
REPLACE WNUM WITH 33
REPLACE WALF WITH 'TRENTATRE'
APPEND BLANK
REPLACE WNUM WITH 34
REPLACE WALF WITH 'TRENTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 35
REPLACE WALF WITH 'TRENTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 36
REPLACE WALF WITH 'TRENTASEI'
APPEND BLANK
REPLACE WNUM WITH 37
REPLACE WALF WITH 'TRENTASETTE'
APPEND BLANK
REPLACE WNUM WITH 38
REPLACE WALF WITH 'TRENTOTTO'
APPEND BLANK
REPLACE WNUM WITH 39
REPLACE WALF WITH 'TRENTANOVE'
APPEND BLANK
REPLACE WNUM WITH 40
REPLACE WALF WITH 'QUARANTA'

APPEND BLANK
REPLACE WNUM WITH 41
REPLACE WALF WITH 'QUARANTUNO'
APPEND BLANK
REPLACE WNUM WITH 42
REPLACE WALF WITH 'QUARANTADUE'
APPEND BLANK
REPLACE WNUM WITH 43
REPLACE WALF WITH 'QUARANTATRE'
APPEND BLANK
REPLACE WNUM WITH 44
REPLACE WALF WITH 'QUARANTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 45
REPLACE WALF WITH 'QUARANTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 46
REPLACE WALF WITH 'QUARANTASEI'
APPEND BLANK
REPLACE WNUM WITH 47
REPLACE WALF WITH 'QUARANTASETTE'
APPEND BLANK
REPLACE WNUM WITH 48
REPLACE WALF WITH 'QUARANTAOTTO'
APPEND BLANK
REPLACE WNUM WITH 49
REPLACE WALF WITH 'QUARANTANOVE'
APPEND BLANK
REPLACE WNUM WITH 50
REPLACE WALF WITH 'CINQUANTA'

APPEND BLANK
REPLACE WNUM WITH 51
REPLACE WALF WITH 'CINQUANTUNO'
APPEND BLANK
REPLACE WNUM WITH 52
REPLACE WALF WITH 'CINQUANTADUE'
APPEND BLANK
REPLACE WNUM WITH 53
REPLACE WALF WITH 'CINQUANTATRE'
APPEND BLANK
REPLACE WNUM WITH 54
REPLACE WALF WITH 'CINQUANTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 55
REPLACE WALF WITH 'CINQUANTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 56
REPLACE WALF WITH 'CINQUANTASEI'
APPEND BLANK
REPLACE WNUM WITH 57
REPLACE WALF WITH 'CINQUANTASETTE'
APPEND BLANK
REPLACE WNUM WITH 58
REPLACE WALF WITH 'CINQUANTAOTTO'
APPEND BLANK
REPLACE WNUM WITH 59
REPLACE WALF WITH 'CINQUANTANOVE'
APPEND BLANK
REPLACE WNUM WITH 60
REPLACE WALF WITH 'SESSANTA'

APPEND BLANK
REPLACE WNUM WITH 61
REPLACE WALF WITH 'SESSANTUNO'
APPEND BLANK
REPLACE WNUM WITH 62
REPLACE WALF WITH 'SESSANTADUE'
APPEND BLANK
REPLACE WNUM WITH 63
REPLACE WALF WITH 'SESSANTATRE'
APPEND BLANK
REPLACE WNUM WITH 64
REPLACE WALF WITH 'SESSANTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 65
REPLACE WALF WITH 'SESSANTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 66
REPLACE WALF WITH 'SESSANTASEI'
APPEND BLANK
REPLACE WNUM WITH 67
REPLACE WALF WITH 'SESSANTASETTE'
APPEND BLANK
REPLACE WNUM WITH 68
REPLACE WALF WITH 'SESSANTOTTO'
APPEND BLANK
REPLACE WNUM WITH 69
REPLACE WALF WITH 'SESSANTANOVE'
APPEND BLANK
REPLACE WNUM WITH 70
REPLACE WALF WITH 'SETTANTA'

APPEND BLANK
REPLACE WNUM WITH 71
REPLACE WALF WITH 'SETTANTUNO'
APPEND BLANK
REPLACE WNUM WITH 72
REPLACE WALF WITH 'SETTANTADUE'
APPEND BLANK
REPLACE WNUM WITH 73
REPLACE WALF WITH 'SETTANTATRE'
APPEND BLANK
REPLACE WNUM WITH 74
REPLACE WALF WITH 'SETTANTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 75
REPLACE WALF WITH 'SETTANTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 76
REPLACE WALF WITH 'SETTANTASEI'
APPEND BLANK
REPLACE WNUM WITH 77
REPLACE WALF WITH 'SETTANTASETTE'
APPEND BLANK
REPLACE WNUM WITH 78
REPLACE WALF WITH 'SETTANTOTTO'
APPEND BLANK
REPLACE WNUM WITH 79
REPLACE WALF WITH 'SETTANTANOVE'
APPEND BLANK
REPLACE WNUM WITH 80
REPLACE WALF WITH 'OTTANTA'

APPEND BLANK
REPLACE WNUM WITH 81
REPLACE WALF WITH 'OTTANTUNO'
APPEND BLANK
REPLACE WNUM WITH 82
REPLACE WALF WITH 'OTTANTADUE'
APPEND BLANK
REPLACE WNUM WITH 83
REPLACE WALF WITH 'OTTANTATRE'
APPEND BLANK
REPLACE WNUM WITH 84
REPLACE WALF WITH 'OTTANTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 85
REPLACE WALF WITH 'OTTANTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 86
REPLACE WALF WITH 'OTTANTASEI'
APPEND BLANK
REPLACE WNUM WITH 87
REPLACE WALF WITH 'OTTANTASETTE'
APPEND BLANK
REPLACE WNUM WITH 88
REPLACE WALF WITH 'OTTANTAOTTO'
APPEND BLANK
REPLACE WNUM WITH 89
REPLACE WALF WITH 'OTTANTANOVE'
APPEND BLANK
REPLACE WNUM WITH 90
REPLACE WALF WITH 'NOVANTA'

APPEND BLANK
REPLACE WNUM WITH 91
REPLACE WALF WITH 'NOVANTUNO'
APPEND BLANK
REPLACE WNUM WITH 92
REPLACE WALF WITH 'NOVANTADUE'
APPEND BLANK
REPLACE WNUM WITH 93
REPLACE WALF WITH 'NOVANTATRE'
APPEND BLANK
REPLACE WNUM WITH 94
REPLACE WALF WITH 'NOVANTAQUATTRO'
APPEND BLANK
REPLACE WNUM WITH 95
REPLACE WALF WITH 'NOVANTACINQUE'
APPEND BLANK
REPLACE WNUM WITH 96
REPLACE WALF WITH 'NOVANTASEI'
APPEND BLANK
REPLACE WNUM WITH 97
REPLACE WALF WITH 'NOVANTASETTE'
APPEND BLANK
REPLACE WNUM WITH 98
REPLACE WALF WITH 'NOVANTOTTO'
APPEND BLANK
REPLACE WNUM WITH 99
REPLACE WALF WITH 'NOVANTANOVE'

RETURN

******************
PROCEDURE VISI_ART
******************

LPARAMETERS V_CONTROL_DA, V_VALUE_DA

IF SUBSTR(V_CONTROL_DA,5,1) = '0' .OR. SUBSTR(V_CONTROL_DA,5,1) = '1' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '2' .OR. SUBSTR(V_CONTROL_DA,5,1) = '3' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '4' .OR. SUBSTR(V_CONTROL_DA,5,1) = '5' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '6' .OR. SUBSTR(V_CONTROL_DA,5,1) = '7' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '8' .OR. SUBSTR(V_CONTROL_DA,5,1) = '9'
   _V_FILADA   = VAL(SUBSTR(V_CONTROL_DA,4,2)) 
   _V_PIANODA  = VAL(SUBSTR(V_CONTROL_DA,8,1))
ELSE   
   _V_FILADA   = VAL(SUBSTR(V_CONTROL_DA,4,1)) 
   _V_PIANODA  = VAL(SUBSTR(V_CONTROL_DA,7,1))
ENDIF

CTR_CONTA = 0

x_maga = "loc_codmag = '" + _V_CODMAG + "'"
x_cors = "loc_corsia = '" + _V_CORSIA + "'"
x_fila = "loc_fila = " + STR(_V_FILADA,2,0)
x_pian = "loc_piano = " + STR(_V_PIANODA,2,0)
cSql="SELECT * FROM u_loc_gi WHERE " + x_maga + " and " + x_cors + " and " + ;
                                       x_fila + " and " + x_pian + ;
                                   " order by loc_codmag,loc_corsia,loc_fila,loc_piano,loc_codart"
IF !ExecCommand(cSql,"U_LOC_GI")
   return(.f.)
ENDIF
SELECT U_LOC_GI
GO TOP

SELECT U_LOC_GI
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_LOC_GI FROM ARRAY TRANSITO
SELECT CU_LOC_GI
INDEX ON loc_codmag + loc_corsia + STR(loc_fila,2,0) + ;
         STR(loc_piano,2,0) + RIBALTA2(loc_datcar) TAG I_LOC5C ADDITIVE 

SELECT U_LOC_GI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF LOC_CODMAG = _V_CODMAG  .AND. ;
      LOC_CORSIA = _V_CORSIA  .AND. ;
      LOC_FILA   = _V_FILADA  .AND. ;
      LOC_PIANO  = _V_PIANODA
   ELSE
      EXIT
   ENDIF

   SCATTER MEMVAR
   
   SELECT CU_LOC_GI
   APPEND BLANK
   GATHER MEMVAR

   CTR_CONTA = CTR_CONTA +1
      
   SELECT U_LOC_GI
   SKIP +1

ENDDO  

SELECT CU_LOC_GI
SET ORDER TO I_LOC5C
GO TOP
IF EOF()
   SELECT U_LOC_GI
   RETURN
ENDIF   

IF CTR_CONTA > 1
   do form FORM\selubic
ELSE
   REPLACE SELEZIONE WITH "=>"   
   do form FORM\selubic
ENDIF

RETURN


******************
PROCEDURE VISI_VAL
******************

LPARAMETERS V_CONTROL_AL, V_VALUE_AL, V_CONTROL_DA, V_VALUE_DA

IF SUBSTR(V_CONTROL_DA,5,1) = '0' .OR. SUBSTR(V_CONTROL_DA,5,1) = '1' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '2' .OR. SUBSTR(V_CONTROL_DA,5,1) = '3' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '4' .OR. SUBSTR(V_CONTROL_DA,5,1) = '5' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '6' .OR. SUBSTR(V_CONTROL_DA,5,1) = '7' .OR. ;
   SUBSTR(V_CONTROL_DA,5,1) = '8' .OR. SUBSTR(V_CONTROL_DA,5,1) = '9'
   _V_FILADA   = VAL(SUBSTR(V_CONTROL_DA,4,2)) 
   _V_PIANODA  = VAL(SUBSTR(V_CONTROL_DA,8,1))
ELSE   
   _V_FILADA   = VAL(SUBSTR(V_CONTROL_DA,4,1)) 
   _V_PIANODA  = VAL(SUBSTR(V_CONTROL_DA,7,1))
ENDIF

CTR_CONTA = 0

IF _V_CODART = SPACE(16) .OR. EMPTY(_V_CODART)
   x_maga = "loc_codmag = '" + _V_CODMAG + "'"
   x_cors = "loc_corsia = '" + _V_CORSIA + "'"
   x_fila = "loc_fila = " + STR(_V_FILADA,2,0)
   x_pian = "loc_piano = " + STR(_V_PIANODA,2,0)
   cSql="SELECT * FROM u_loc_gi WHERE " + x_maga + " and " + x_cors + " and " + ;
                                          x_fila + " and " + x_pian + ;
                                      " order by loc_codmag,loc_corsia,loc_fila,loc_piano,loc_codart"
ELSE
   x_maga = "loc_codmag = '" + _V_CODMAG + "'"
   x_cors = "loc_corsia = '" + _V_CORSIA + "'"
   x_fila = "loc_fila = " + STR(_V_FILADA,2,0)
   x_pian = "loc_piano = " + STR(_V_PIANODA,2,0)
   x_arti = "loc_codart = '" + _V_CODART + "'"
   cSql="SELECT * FROM u_loc_gi WHERE " + x_maga + " and " + x_cors + " and " + ;
                                          x_fila + " and " + x_pian + " and " + x_arti + ;
                                      " order by loc_codmag,loc_corsia,loc_fila,loc_piano,loc_codart"
ENDIF
IF !ExecCommand(cSql,"U_LOC_GI")
   return(.f.)
ENDIF
SELECT U_LOC_GI
GO TOP

SELECT U_LOC_GI
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_LOC_GI FROM ARRAY TRANSITO
SELECT CU_LOC_GI
INDEX ON loc_codmag + loc_corsia + STR(loc_fila,2,0) + ;
         STR(loc_piano,2,0) + loc_codart + RIBALTA2(loc_datcar) TAG I_LOC5C ADDITIVE 

SELECT U_LOC_GI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

*   IF LOC_CODMAG = _V_CODMAG  .AND. ;
*      LOC_CORSIA = _V_CORSIA  .AND. ;
*      LOC_FILA   = _V_FILADA  .AND.   ;
*      LOC_PIANO  = _V_PIANODA .AND. ;
*      LOC_CODART = _V_CODART
*   ELSE
*      EXIT
*   ENDIF

   SCATTER MEMVAR
   
   SELECT CU_LOC_GI
   APPEND BLANK
   GATHER MEMVAR

   CTR_CONTA = CTR_CONTA +1
      
   SELECT U_LOC_GI
   SKIP +1

ENDDO  

SELECT CU_LOC_GI
SET ORDER TO I_LOC5C
GO TOP
IF EOF()
   SELECT U_LOC_GI
   RETURN
ENDIF   

IF CTR_CONTA > 1
   do form FORM\selubic
ELSE
   REPLACE SELEZIONE WITH "=>"   
   do form FORM\selubic
ENDIF

SELECT CU_LOC_GI
GO TOP
IF EOF()
ELSE
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF SELEZIONE = '=>'
         _V_CODART = LOC_CODART
         _V_DESART = LOC_DESART
         _V_UNITAM = LOC_UNITAM
         EXIT
      ENDIF
      SKIP +1
      LOOP
   ENDDO      
ENDIF

RETURN


**************************************************************************
  PROCEDURE CALCFAT  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_fat_dd")
RETURN

**************************************************************************
  PROCEDURE CALCFAP  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_fap_dd")
RETURN

**************************************************************************
  PROCEDURE CALCORF  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_orf_dd")
RETURN

**************************************************************************
  PROCEDURE CALCBOL  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_bol_dd")
RETURN

**************************************************************************
  PROCEDURE CALCPRB  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_prb_dd")
RETURN

**************************************************************************
  PROCEDURE CALCOFF  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_off_dd")
RETURN

**************************************************************************
  PROCEDURE CALCORD  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_ord_dd")
RETURN

**************************************************************************
  PROCEDURE CALCFAM  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_fam_dd")
RETURN

*****************************************************************************
  PROCEDURE FATCAVOL && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO
*****************************************************************************
para _tag
=CALCdocge1(_TAG,"fathookd","U_FAT_DD","U_FAT_TT",.T.)
RETURN

******************************************************************************
  PROCEDURE BOLCAVOL && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO
******************************************************************************
para _tag
=CALCdocge1(_TAG,"bolhookd","u_bol_dd","u_bol_tt",.T.)
RETURN

******************************************************************************
  PROCEDURE PRBCAVOL && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO
******************************************************************************
para _tag
=CALCdocge1(_TAG,"prbhookd","u_prb_dd","u_prb_tt",.T.)
RETURN

**************************************************************************
  PROCEDURE CALCCTL  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_ctl_dd")
RETURN

**************************************************************************
  PROCEDURE CALCSPE  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_spe_dd")
RETURN

**************************************************************************
  PROCEDURE CALCBFO  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_bfo_dd")
RETURN

**************************************************************************
  PROCEDURE CALCMRI  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_mri_dd")
RETURN

**************************************************************************
  PROCEDURE CALCAMM  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************
=CALCdocgen("cu_amm_dd")
RETURN

**************************************************************************
  function CALCdocgen  && CALCOLA IL VALORE DEL DOCUMENTO IVE COMPRESE
**************************************************************************
***  RICHIAMATA NEL SEGUENTE MODO =CALCdocgen("cu_fat_dd")
para _tabella

SWS=SELECT()
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
MATPUBX     = 0

IF _TABELLA = "cu_orf_dd"
   _ALRID    = ALLTRIM(PUB_IVA)
   _ESENZI=.F.				&& CLIENTE NON IN ESENZIONE
ELSE
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(m.ord_codcli) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_cli_an")
      return(.f.)
   ENDIF
   SELECT u_cli_an
   IF reccount() <> 0
      _ALRID    = CLI_ALRID
	  IF !EMPTY(CLI_ALRID)
	     _ESENZI = .T.			&& CLIENTE IN ESENZIONE
	  ELSE
	     _ALRID  = ALLTRIM(PUB_IVA)
	     _ESENZI = .F.			&& CLIENTE NON IN ESENZIONE
	  ENDIF
   ELSE
	  _ALRID    = ALLTRIM(PUB_IVA)
	  _ESENZI=.F.				&& CLIENTE NON IN ESENZIONE
   ENDIF
ENDIF

SELECT &_tabella
GO TOP

IVA1   = SPACE(3)
IVA2   = SPACE(3)
IVA3   = SPACE(3)
IVA4   = SPACE(3)
IVA5   = SPACE(3)
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

DO WHILE .NOT. EOF()

   IF DELETED()
      SELECT &_tabella
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT &_tabella
      SKIP +1
      LOOP
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)

   IF ORD_PUBBLI = "S"
      MATPUBX = MATPUBX + ORD_VALORE
   ENDIF

   IF !ExecCommand("select * from para where codice = 'IVA'+?COD_IVA","para")
      return
   ENDIF
   SELECT PARA
   IF reccount() <> 0
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

   SELECT &_tabella
   SKIP +1

ENDDO

V_SPESE = M.ORD_SPBOLL + M.ORD_SPTRAS

IF !_ESENZI      					&& SOLO SE NON IN ESENZIONE
   V_IMPSP = V_SPESE * (VAL(PUB_IVA)/100)
ELSE
   V_IMPSP = 0		 				&& ESENTE
ENDIF

* davide inizio
* ----------------------------------------------------------------------------
* -->> inserisco l'iva delle spese(20%) sulle ive al 20
FOR HF=1 TO 5
  _IMPO ="IMPO"+ALLTRIM(STR(HF))
  _IMPOS="IMPOS"+ALLTRIM(STR(HF))
  IF &_IMPO=0
  	LOOP
  ENDIF	
  IF ROUND((&_IMPOS/&_IMPO)*100,0)=VAL(PUB_IVA)
     &_IMPOS=&_IMPOS+V_IMPSP
     EXIT
  ENDIF
NEXT

IF M.ORD_VALUTA = "ITL" .OR.  M.ORD_VALUTA = "LIT"
   IF IMPOS1	-INT(IMPOS1)<>0
	  IMPOS1=INT(IMPOS1)+1
   ENDIF
   IF IMPOS2	-INT(IMPOS2)<>0
	  IMPOS2=INT(IMPOS2)+1
   ENDIF
   IF IMPOS3	-INT(IMPOS3)<>0
	  IMPOS3=INT(IMPOS3)+1
   ENDIF
   IF IMPOS4	-INT(IMPOS4)<>0
	  IMPOS4=INT(IMPOS4)+1
   ENDIF
   IF IMPOS5	-INT(IMPOS5)<>0
	  IMPOS5=INT(IMPOS5)+1
   ENDIF
ELSE
   IMPOS1		=	ROUND((IMPOS1+.0000),2)
   IMPOS2		=	ROUND((IMPOS2+.0000),2)
   IMPOS3		=	ROUND((IMPOS3+.0000),2)
   IMPOS4		=	ROUND((IMPOS4+.0000),2)		
   IMPOS5		=	ROUND((IMPOS5+.0000),2)
ENDIF

M.T_IMPONIB = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5
M.T_IMPOSTA = IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5

* davide fine
* ----------------------------------------------------------

M.T_IMPONIB = M.T_IMPONIB + V_SPESE
M.T_VALORE  = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX

M.ORD_VALORE = M.T_VALORE

=MAX_EURO(M.ORD_VALORE,M.ORD_VALUTA)

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

SELECT(SWS)

RETURN(.t.)


*******************************************************************************************
  function CALCdocge1  && CALCOLA IL VALORE DEL DOCUMENTO IVE COMPRESE  SU DVASE EFFETTIVO
*******************************************************************************************
*  RICHIAMATA NEL SEGUENTE MODO : =CALCdocge1(_chiave,"fathookd","u_fat_dd","u_fat_tt",.F.)
*  								  _chiave = TAGGANCIO PER FARE LA SEEK
*  								  _IND 	  = INDICE PER LA SEEK
*  								  _DBASED = ARCHIVIO DETTAGLI DA ELABORARE
*  								  _DBASET = ARCHIVIO TESTATA  DA ELABORARE
*  								  _OKAGG  = AGGIORNA O MENO LA TESTATA

PARA  _chiave,_IND,_dettagli,_TESTATA,_OKAGG

SWS=SELECT()

M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
MATPUBX     = 0

IVA1   = SPACE(3)
IVA2   = SPACE(3)
IVA3   = SPACE(3)
IVA4   = SPACE(3)
IVA5   = SPACE(3)
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

V_SQL = 'select * from ' + _dettagli + ' where daggancio = ?_chiave'
IF !ExecCommand(v_sql,_dettagli)
    return
ENDIF
SELECT &_dettagli

DO WHILE .NOT. EOF()

   IF DELETED()
      SELECT &_dettagli
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT &_dettagli
      SKIP +1
      LOOP
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)

   DO CASE
   	  CASE ALLTRIM(_DETTAGLI) = "U_FAT_DD"
		   IF ORD_PUBBLI = "S"
		      MATPUBX = MATPUBX + ORD_VALORE
		   ENDIF
	  CASE ALLTRIM(_DETTAGLI) = "U_BOL_DD"
		   IF ORD_PUBBLI = "S"
		      MATPUBX = MATPUBX + ORD_VALORE
		   ENDIF
   ENDCASE
  
   IF !ExecCommand("select * from para where codice = 'IVA'+?COD_IVA","para")
      return
   ENDIF
   SELECT PARA
   IF reccount() <> 0
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

   SELECT &_dettagli
   SKIP +1

ENDDO

V_SPESE = M.ORD_SPBOLL + M.ORD_SPTRAS

IF !_ESENZI      					&& SOLO SE NON IN ESENZIONE
   V_IMPSP = V_SPESE * (VAL(PUB_IVA)/100)
ELSE
   V_IMPSP = 0		 				&& ESENTE
ENDIF

* davide inizio
* ----------------------------------------------------------------------------
* -->> inserisco l'iva delle spese(20%) sulle ive al 20
FOR HF=1 TO 5
  _IMPO ="IMPO"+ALLTRIM(STR(HF))
  _IMPOS="IMPOS"+ALLTRIM(STR(HF))
  IF &_IMPO=0
  	LOOP
  ENDIF	

  IF ROUND((&_IMPOS/&_IMPO)*100,0)=VAL(PUB_IVA)
     &_IMPOS=&_IMPOS+V_IMPSP
     EXIT
  ENDIF
NEXT

IMPOS1		=	ROUND((IMPOS1+.0000),2)
IMPOS2		=	ROUND((IMPOS2+.0000),2)
IMPOS3		=	ROUND((IMPOS3+.0000),2)
IMPOS4		=	ROUND((IMPOS4+.0000),2)		
IMPOS5		=	ROUND((IMPOS5+.0000),2)

M.T_IMPONIB = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5
M.T_IMPOSTA = IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5

* davide fine
* ----------------------------------------------------------

M.T_IMPONIB = M.T_IMPONIB + V_SPESE
M.T_VALORE  = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX

M.ORD_VALORE = M.T_VALORE

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

IF M.T_IMPONIB <> 0
   IF _OKAGG
      v_sql = 'select * from ' + _testata + ' where taggancio = ?_chiave'
      IF !ExecRW(v_sql,_testata,"R")
         return
      ENDIF
      SELECT &_testata
      IF reccount() <> 0
         REPLACE ORD_VALORE WITH M.ORD_VALORE
      ENDIF
      IF !ExecRW("",_testata,"W")
         return
      ENDIF
   ENDIF
ENDIF

SELECT(SWS)

RETURN(.T.)


*********************
FUNCTION PRENDI_DATI
*********************
* -->> funzione che aggancia una tabella e ritorna
* -->> il contenuto del campo cercato
* -->> Sintassi:
*               =PRENDI_DATI(_tabella,_indice,_chiave,_campo)
* -->> Dove:
*				_tabella	= nome della tabella a cui accedere
*				_indice		= nome dell'indice per il SET ORDER
*				_chiave		= stringa della chiave di ricerca
*				_campo		= nome del campo da cui prendere il dato di ritorno

* -->> Esempio:
*               =PRENDI_DATI("U_CLI_AN","U_CLI_AN",V_CODCLI,"CLI_CODFIS")

para _tabella,_indice,_chiave,_campo

out       = ""
dati_save = select()

v_sql = 'select * from ' + _tabella + ' where ' + _campo + ' = ?_chiave'
IF !ExecCommand(v_sql,_tabella)
   return
ENDIF
SELECT &_tabella
IF reccount() <> 0
   out=&_campo
endif
select(dati_save)
return(out)

******************************
FUNCTION SINTE
******************************
* STAMPA DESCRIZIONE ARTICOLO + VALORE

_TXT     = TRANSFORM(ORD_VALORE, '99,999,999,999.999')
PUB_NOTE = ALLTRIM(ORD_DESART) + "  " + _TXT

RETURN(PUB_NOTE)


*****************************************************************************
PROCEDURE nonattivo
*****************************************************************************
=MESSAGEBOX("Procedura attualmente non attiva",64,"*** INFORMAZIONE ***")
RETURN


*****************************************************************************
PROCEDURE ORFCAR
*****************************************************************************

IF !ExecCommand("select * from U_MAG_CL where 0=1","CU_MAG_CL")
   return(.f.)
ENDIF
IF !ExecCommand("select * from U_MAG_MO where 0=1","CU_MAG_MO")
   return(.f.)
ENDIF
IF !ExecCommand("select * from U_CER_MO where 0=1","CU_CER_MO")
   return(.f.)
ENDIF

DEFINE WINDOW DETTAGLI AT 0,0 SIZE 20,100;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW  DETTAGLI CENTER 

ORDINE=NUMORD
ORDIDT=DATORD

SELECT CUR_TESTFORN
SCATTER MEMVAR MEMO
AGGA=TAGGANCIO

x_agga = "daggancio = '" + AGGA + "'"
cSql="SELECT * FROM U_ORF_DD WHERE " + x_agga + " order by daggancio"
IF !ExecCommand(cSql,"CU_ORF_DD")
   return(.f.)
ENDIF
SELECT CU_ORF_DD
GO TOP
IF EOF()
   =MSGBOX("Nessuna riga d'ordine inserita",'ATTENZIONE',31)
   RETURN
ENDIF 

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF ORD_CHIUSO
      SKIP +1
      LOOP
   ENDIF
   IF SUBSTR(ORD_CODART,1,2) = 'CC'
      SKIP +1
      LOOP
   ENDIF
   IF ORD_CODART = SPACE(16) .OR. EMPTY(ORD_CODART)
      SKIP +1
      LOOP
   ENDIF   
   XC_CODART=ORD_CODART
   x_soci = "cer_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cer_codice = '" + ALLTRIM(XC_CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   cSql="SELECT * FROM U_CER_AN WHERE " + x_cond + " order by cer_codsoc,cer_codice"
   IF !ExecCommand(cSql,"CUR_CERDATI")
      return(.f.)
   ENDIF
   SELECT CUR_CERDATI
   GO TOP
   IF EOF()
   ELSE
      M.CER_COLATA = CER_COLATA 
      M.CER_QUALIT = CER_QUALIT 
      M.CER_NUMERO = CER_NUMERO
      SELECT CU_ORF_DD
      REPLACE ORD_COLATA WITH M.CER_COLATA ,;
  		      ORD_QUALIT WITH M.CER_QUALIT ,;
  		      ORD_CERTBV WITH M.CER_NUMERO
   ENDIF
   SELECT CU_ORF_DD
   SKIP +1
ENDDO

SELECT CU_ORF_DD
GO TOP
BROWSE TITLE'DETTAGLI ORDINI' FIELDS ORD_CODART:H='COD.ART.':R, ;
                                     ORD_DESART:20:H='DESCRIZIONE':R, ;
                                     ORD_PREZZO:H='PREZZO':R, ;
                                     ORD_QTAORD:H='Q.ORDINATA', ;
                                     ORD_QTAEV:H='Q.CONSEGN.':R, ;
                                     ORD_QTADEV:H='Q.RICEVUTA':;
                                     V=(ORD_QTAEV+ORD_QTADEV<=ORD_QTAORD):;
                                     E="GIA' CONS. + DA CONS. > QTA ORDINATA",;
                                     ORD_COLATA:H='COLATA',;
                                     ORD_QUALIT:H='QUALITA',;
                                     ORD_DIAMET:H='DIAMETRO',;
                                     ORD_CERTBV:H='IDENTIFICAZIONE',;
                                     ORD_DESCER:H='DESCR.CERTIF.',;
                                     ORD_CERANN:H='ANNO';
                                     NOMENU NODELETE WINDOW DETTAGLI 

DEACTIVATE WINDOW DETTAGLI
RELEASE WINDOWS DETTAGLI

PUSH KEY CLEAR

_TOT_RICEV=0

SELECT CU_ORF_DD
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   _TOT_RICEV=_TOT_RICEV+ORD_QTADEV
   SKIP +1
ENDDO

IF _TOT_RICEV>0
   DO MOVIMENTO
   =MESSAGEBOX('Carico magazzino effettuato correttamente',64,'Operazione terminata') 
ELSE
   =MESSAGEBOX('Nessuna quantità evasa. Carico magazzino non effettuato',64,'Operazione annullata') 
ENDIF

RETURN


***************************************************************************
PROCEDURE MOVIMENTO
***************************************************************************

O_CHIUSO=.T.

SELECT CU_ORF_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   DAGGA=DAGGANCIO
 
   IF ORD_QTAORD > ORD_QTAEV
   ELSE
      REPLACE ORD_CHIUSO WITH .T.
      SKIP +1
      LOOP
   ENDIF  
  
   IF ORD_QTADEV = 0
      REPLACE ORD_CHIUSO WITH .F.
      O_CHIUSO=.F.
      SKIP +1
      LOOP
   ENDIF

   IF (ORD_QTAEV+ORD_QTADEV) < ORD_QTAORD
      REPLACE ORD_CHIUSO WITH .F.
      O_CHIUSO=.F.
   ELSE   
      REPLACE ORD_CHIUSO WITH .T.
   ENDIF  
      
   CODART = ORD_CODART
   UM     = ORD_UM
   IVA    = ORD_IVA
   DESART = ORD_DESART
   DES2   = ORD_DES2
   MAGA   = ORD_MAGA
   QTAORD = ORD_QTAORD
   QTAEV  = ORD_QTAEV       && QTA ANCORA DA EVADERE 
   QTADEV = ORD_QTADEV      && QTA  CARICO MAGAZINO DIGITATA
   PREZZO = ORD_PREZZO
   SC1    = ORD_SC1
   SC2    = ORD_SC2
   SC3    = ORD_SC3
   PRZNET = ORD_PRZNET
   VALORE = ORD_VALORE
   PRORIG = ORD_PRORIG
   DATCON = ORD_DATCON
   FLARTC = ORD_FLARTC
   QTAFAT = ORD_QTAFAT
   VIEW   = ORD_VIEW
   CONSD  = ORD_CONSD
   CHIUSO = ORD_CHIUSO
   *** NUOVI CAMPI PER GESTIONE CERTIFICATI TBV
   _CERTBV	= ALLT(ORD_CERTBV)
   _ANNO	= ORD_CERANN
   _NUMACC	= ORD_NUMACC
   _COLATA	= ORD_COLATA
   _QUALIT  = ORD_QUALIT
   _DIAMET  = ORD_DIAMET
   _DESCER  = ORD_DESCER
    
   SELECT CUR_TESTFORN
   CODSOC=ORD_CODSOC
   CODCLI=ORD_CODCLI

   IF EMPTY(V_CODCLI) .OR. V_CODCLI =SPACE(10) 
   ELSE
      SELECT CU_MAG_CL
      APPEND BLANK
      REPLACE MOV_CODSOC WITH CODSOC
      REPLACE MOV_CODMAG WITH MAGA
      REPLACE MOV_CODART WITH CODART
      IF PUB_CAUCFO = SPACE(03) .OR. EMPTY(PUB_CAUCFO)
         REPLACE MOV_TOP    WITH '100'
      ELSE
         REPLACE MOV_TOP    WITH PUB_CAUCFO
      ENDIF
      REPLACE MOV_DTREGI WITH RIBALTA2(DATAREG)
      REPLACE MOV_NUMDOC WITH BOLLA
      REPLACE MOV_DTDOCU WITH RIBALTA2(DATA)
      REPLACE MOV_QTAMOV WITH QTADEV
      REPLACE MOV_PREACQ WITH PREZZO
      REPLACE MOV_SCONTO WITH SC1
      REPLACE MOV_CODFOR WITH CODCLI
      REPLACE MOV_PREVEN WITH PRZNET
      REPLACE MOV_IVAVEN WITH IVA
      REPLACE MOV_VALACQ WITH VALORE
      REPLACE MOV_CODORD WITH V_CODCLI
      REPLACE MOV_RAGORD WITH V_RAGSOC
      REPLACE MOV_NUMORD WITH V_NUMORD
      REPLACE MOV_DATORD WITH V_DATORD
      REPLACE MOV_TIPORD WITH V_TIPORD
      REPLACE MOV_FLGFAT WITH .F.
      REPLACE MOV_QTAGIA WITH QTADEV
      REPLACE MOV_NUMFAT WITH SPACE(06)
      REPLACE MOV_DATFAT WITH SPACE(10)
   ENDIF

   _KGTOT  = 0
   _CODTAG = SPACE(03)
   _DESTAG = SPACE(30)
   _CODCOL = SPACE(03)
   _DESCOL = SPACE(30)

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"cur_articolo")
      return(.f.)
   ENDIF
   SELECT cur_articolo
   GO TOP
   IF !EOF()
	  *** recupero dati che mi servono per movimentare le taglie/colori
      _CODTAG = ART_CODTAG
      _DESTAG = ART_DESTAG
      _CODCOL = ART_CODCOL
      _DESCOL = ART_DESCOL
	  *** recupero dati che mi servono per movimentare i certificati
   	  _KGTOT=ART_PESOUM
   	  _LINEA=ART_LINEA
      v_seek   = "REP"+_LINEA
      v_chiave = "codice" 
      cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
      IF !ExecRW(cSql,"PARA","R")
         return(.f.)
      ENDIF
      SELECT PARA
      IF RECCOUNT() = 0
		 _NUMACC=""
      ELSE
	  	 _NUMACC=LIBERA
	  	 REPLACE LIBERA WITH ALLT(STR(VAL(LIBERA)+1,6,0))
      ENDIF
      IF !ExecRW(cSql,"PARA","W")
         return(.f.)
      ENDIF
   ENDIF     

   H_DADOVE = 'MOVIMENTO'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = MAGA
   H_MAGCAR = ""
   H_CODART = CODART
   IF PUB_CAUCFO = SPACE(03) .OR. EMPTY(PUB_CAUCFO)
      H_TOPSCA = '100'
   ELSE
      H_TOPSCA = PUB_CAUCFO
   ENDIF
   H_TOPCAR = ""
   H_QUANTI = QTADEV
   H_NUMDOC = BOLLA
   H_DATDOC = DATA
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = CODCLI
   H_PRZACQ = PREZZO
   H_PRZVEN = PRZNET
   H_CODIVA = IVA
   H_SCONTO = SC1
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CU_ORF_DD
   QTAEV=ORD_QTAEV+QTADEV
   REPLACE ORD_QTAEV  WITH QTAEV
   REPLACE ORD_QTADEV WITH 0

   VPRE=PREZZO
   VPRE=VPRE-ROUND((VPRE*SC1/100),6)
   VPRE=VPRE-ROUND((VPRE*SC2/100),6)
   VPRE=VPRE-ROUND((VPRE*SC3/100),6)
   PRZNET=VPRE
   VALORE	=	ROUND((PRZNET*QTAORD),2)
   REPLACE ORD_VALORE WITH VALORE
   REPLACE ORD_PRZNET WITH PRZNET

   IF !PUB_CERTIF
      SELECT CU_ORF_DD
	  SKIP +1
	  LOOP
   ENDIF

   *** -----------------------------------------------------               
   *** >>> AGGIORNAMENTO ARCHIVIO MOVIMENTI CERTIFICATI U_CER_MO           
   *** -----------------------------------------------------               
   *** INSERISCO UNA RIGA CONTENENTE I DATI RELATIVI A QUESTO ORDINE       
   *** E LA INIDCO COME RIGA DI CARICO (PERCHE' CORRISPONDE A ORDINE/BOLLA 
   *** DI UN FORNITORE)                                                    

   IF EMPTY(_CERTBV)
	  _CERTBV=ALLT(STR(NEWPROG('CER'),10))
   ENDIF

   IF EMPTY(_ANNO)
	  _ANNO=PUB_ANNO
   ENDIF

   INSERT INTO CU_CER_MO (;                                                 
	   	CER_CODSOC,;
	   	CER_CARSCA,;
	   	CER_CERTBV,;
	   	CER_ANNO  ,;
	   	CER_DATACS,;
	   	CER_CODICE,;
	   	CER_COLATA,;
		CER_QUALIT,;
		CER_NUMERO,;
		CER_DATA  ,;
		CER_DESCRI,;
		CER_DIAMET,;
	   	CER_CODFOR,;
	   	CER_DESFOR,;
	   	CER_CODCLI,;
	   	CER_DESCLI,;
	   	CER_NUMORD,;
	   	CER_DATORD,;
	   	CER_NUMBOL,;
	   	CER_DATBOL,;
	   	CER_FASCI ,;
	   	CER_KGTOT ,;
	   	CER_KGUTIL,;
	   	CER_NUMACC,;
	   	CER_TIPO);
      VALUES (;                                                             
	   	PUB_CODSOC,;                   
	   	'C',;                      
	   	_CERTBV,;                
	   	_ANNO,;                 
  		RIBALTA2(DATAREG),;                  
	   	CODART,;
	   	_COLATA,;
		_QUALIT,;
		_CERTBV,;
		RIBALTA2(DATAREG),;
		_DESCER,;
		_DIAMET,;
	   	CODFOR,;                   
	   	RAGSOC,;                   
	   	'',;                       
	   	'',;                       
	   	NUMORD,;                   
	   	RIBALTA2(DATORD),;                   
		BOLLA,;                    
	   	RIBALTA2(DATA),;                     
	   	QTADEV,;               
	   	QTADEV*_KGTOT,;               
	   	0,;               
	   	_NUMACC,;
	   	'M');  
   	                                                                
   *** -----------------------------------------------------               
   *** <<< AGGIORNAMENTO ARCHIVIO MOVIMENTI CERTIFICATI U_CER_MO           
   *** -----------------------------------------------------               

   SELECT CU_ORF_DD
   SKIP +1

ENDDO

v_seek	 = AGGA
v_chiave = "taggancio" 
cSql="select * from u_orf_tt where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"U_ORF_TT","R")
   return(.f.)
ENDIF
SELECT U_ORF_TT
IF RECCOUNT() = 0
   =MSGBOX('Testate mancanti !','ATTENZIONE',32)
ELSE
   IF O_CHIUSO=.F.
      REPLACE ORD_CHIUSO WITH .F.  && ORDINE APERTO
   ELSE
      REPLACE ORD_CHIUSO WITH .T.  && ORDINE CHIUSO
   ENDIF  
ENDIF
IF !ExecRW(cSql,"U_ORF_TT","W")
   return(.f.)
ENDIF

SELECT CU_ORF_DD
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   v_seek   = DAGGANCIO
   v_chiave = "daggancio" 
   cSql="select * from u_orf_dd where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"U_ORF_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF ORD_CODART = M.ORD_CODART .AND. ORD_DATCON = M.ORD_DATCON
      ELSE
         SKIP +1
         LOOP
      ENDIF      
      DO U_ORF_DD
      SKIP +1
   ENDDO 
   IF !ExecRW(cSql,"U_ORF_DD","W")
      return(.f.)
   ENDIF
   SELECT CU_ORF_DD
   SKIP +1
ENDDO

IF !ExecRW('','u_mag_cl','I','','CU_MAG_CL')
   return(.f.)
ENDIF
*IF !ExecRW('','u_mag_mo','I','','CU_MAG_MO')
*   return(.f.)
*ENDIF
IF !ExecRW('','u_cer_mo','I','','CU_CER_MO')
   return(.f.)
ENDIF

RAGSOC  = space(40)
NUMORD  = SPACE(06)
DATORD  = SPACE(10)
BOLLA   = SPACE(14)
DATA    = SPACE(10)
DATAREG = SPACE(10)

RETURN


**************************************************************************
PROCEDURE BOLSCMAG  && SCARICA IL MAGAZZINO
**************************************************************************

IF ZTB.ININSERIMENTO
   IF M.ORD_CAUS = PUB_CTLO .AND. M.ORD_MAGD <> SPACE(06)
      x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
      x_anno = "ord_anno = '" + SUBSTR(M.ORD_DATCTL,1,4) + "'"
      x_nord = "ord_numord = '" + ALLTRIM(M.ORD_NUMCTL) + "'"
      x_cond = x_soci + " and " + x_anno + " and " + x_nord 
      Csql   = "select * from u_ctl_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
      IF !ExecCommand(cSql,"CUR_CTL_TT")
         return(.f.)
      ENDIF
      SELECT CUR_CTL_TT
      IF RECCOUNT() = 0
         V_ESISTECTL = 'NO'
         * PRELEVA IL N.DI ORDINE CONTO LAVORO
         v_seek   = 'NUMCTL'+PUB_CODSOC
         v_chiave = "codice"
         cSql     ="select * from para where " + v_chiave + " = '" + v_seek + "'"
         IF !ExecRW(cSql,"PARA","R")
            return(.f.)
         ENDIF
         SELECT PARA
         IF RECCOUNT() <> 0
            V2=VAL(ALLTRIM(SUBSTR(LIBERA,2,7))) + 1
            REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),2,7)
            M.ORD_NUMCTL = ALLTRIM(SUBSTR(LIBERA,2,7))
            M.ORD_DATCTL = DTOC(DATE())
         ELSE
            RIT = MSGBOX('Parametro numero ordine c/lavoro non trovato','ATTENZIONE',31)
            RETURN
         ENDIF
         IF !ExecRW(cSql,"PARA","W")
            return(.f.)
         ENDIF
         PUB_LNO      = 6
         M.ORD_NUMCTL = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMCTL))
         M.ORD_DATCTL = RIBALTA2(M.ORD_DATCTL)
         * PRELEVA UNCINO PER LEGARE TESTATA/DETTAGLIO
         X_TAGGANCIO = STR(NEWPROG('NUMCTL'),10)
         X_UNCINO    = X_TAGGANCIO
         * AGGIUNGE RECORD TESTATA SU DB
         SELECT CUR_CTL_TT
         APPEND BLANK
         GATHER MEMVAR 
         REPLACE TAGGANCIO  WITH X_TAGGANCIO
         REPLACE TNUMERO    WITH M.ORD_NUMCTL
         REPLACE ORD_CODSOC WITH PUB_CODSOC
         REPLACE ORD_NUMORD WITH M.ORD_NUMCTL
         REPLACE ORD_DATORD WITH M.ORD_DATCTL
         REPLACE ORD_ORA    WITH TIME()
         REPLACE ORD_CAUS   WITH PUB_CTLO
         REPLACE ORD_CODOPE WITH PUB_CODOPE
         REPLACE ORD_NUMBOL WITH M.ORD_NUMORD
         IF SUBSTR(M.ORD_DATORD,3,1) = '/'
            REPLACE ORD_DATBOL WITH ribalta2(M.ORD_DATORD)
         ELSE
            REPLACE ORD_DATBOL WITH M.ORD_DATORD
         ENDIF
         IF !ExecRW('','u_ctl_tt','I','','CUR_CTL_TT')
            return(.f.)
         ENDIF
      ELSE
         V_ESISTECTL = 'SI'
      ENDIF
   ENDIF
ENDIF

SELECT CU_BOL_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   IF ZTB.ININSERIMENTO
      IF M.ORD_CAUS = PUB_CTLO .AND. M.ORD_MAGD <> SPACE(06)
         IF V_ESISTECTL = 'NO'
            cSql="select * from u_ctl_dd where 1=0"
            IF !ExecCommand(cSql,"CUR_CTL_DD")
               return(.f.)
            ENDIF
            SELECT CUR_CTL_DD
            APPEND BLANK
            GATHER MEMVAR
            REPLACE DAGGANCIO  WITH X_TAGGANCIO
            REPLACE ORD_MAGA   WITH M.ORD_MAGD
            REPLACE ORD_DATCON WITH RIBALTA2(M.ORD_DATCON)
            IF !ExecRW('','u_ctl_dd','I','','CUR_CTL_DD')
               return(.f.)
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   SELECT CU_BOL_DD
   SCATTER MEMVAR MEMO
   
   RELEASE XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   PUBLIC  XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   XYZ_FORNIT = M.ORD_FORNIT
   XYZ_RAGSOC = M.ORD_RAGFOR 
   XYZ_PRZUCA = M.ORD_PRZULC
   XYZ_RAGFOR = M.ORD_RAGFOR

   _TOPSCA = M.ORD_CAUS   

   v_seek   = 'TOP'+M.ORD_CAUS
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      _TOPCAR = SUBSTR(CODICE,4,3)   
   ELSE
      _TOPCAR = '100 '  
   ENDIF
   IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
      _TOPCAR = '100 '  
   ENDIF
  
   H_DADOVE = 'BOLSCMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = M.ORD_MAGD
   H_CODART = M.ORD_CODART
   H_TOPSCA = _TOPSCA
   H_TOPCAR = _TOPCAR
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = CSC
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = M.ORD_FORNIT
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   *SELECT CU_BOL_DD
   *REPLACE ORD_FORNIT WITH XYZ_FORNIT 
   *REPLACE ORD_RAGFOR WITH XYZ_RAGSOC 
   *REPLACE ORD_PRZULC WITH XYZ_PRZUCA

   **==> Gestione del file delle bolle trasferite per i pdv
   x_uniq = "orf_unique = '" + ALLTRIM(M.ORD_CODSYS) + "'"
   x_lega = "orf_agganc = '" + ALLTRIM(M.ORD_LEGAME) + "'"
   x_cond = x_uniq + " and " + x_lega
   Csql   = "select * from u_orf_po where " + x_cond
   IF !ExecRW(Csql,"U_ORF_PO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_PO
   IF EOF()
      **==> Gestione del file delle bolle di trasferimento da un pdv ad un altro pdv
      IF M.ORD_CAUS = PUB_CAUTRA
         x_cond = "pdv_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
         Csql   = "select * from u_pdv_an where " + x_cond
         IF !ExecCommand(Csql,"CU_PDV_AN")
            return(.f.)
         ENDIF
         SELECT CU_PDV_AN
         GO TOP
         IF EOF()
            VV_CODPDV = SPACE(10)
            VV_DESPDV = SPACE(50)
            VV_CODMAG = SPACE(06)
         ELSE
            VV_CODPDV = PDV_CODICE
            VV_DESPDV = PDV_DESCRI
            VV_CODMAG = PDV_CODMAG
         ENDIF         
         Csql   = "select * from u_orf_co where 1=0"
         IF !ExecRW(Csql,"U_ORF_CO","R")
            return(.f.)
         ENDIF
         M.ORF_CODPDV = VV_CODPDV
         M.ORF_DESPDV = VV_DESPDV
         M.ORF_CODMAG = VV_CODMAG
         M.ORF_CODART = M.ORD_CODART
         M.ORF_DESART = M.ORD_DESART
         M.ORF_UNITAM = M.ORD_UM
         M.ORF_NUMPRO = SPACE(06)
         M.ORF_DATPRO = SPACE(10)
         M.ORF_QTAPRO = 0
         M.ORF_QTAORD = 0
         M.ORF_QTADOR = 0
         M.ORF_CODFOR = M.ORD_FORNIT
         M.ORF_RAGSOC = M.ORD_RAGFOR
         M.ORF_NUMORD = SPACE(06)
         M.ORF_DATORD = SPACE(10)
         M.ORF_PREZZO = M.ORD_PRZNET
         M.ORF_DATCON = M.ORD_DATCON
         M.ORF_CODSYS = M.ORD_CODSYS
         M.ORF_FLGTRA = .F.
         M.ORF_GIACEN = 0
         M.ORF_QTAORF = 0
         M.ORF_QUANTI = 0
         M.ORF_SYSCOD = M.ORD_SYSCOD
         M.SELEZIONE  = SPACE(10)
         M.ORF_AGGANC = M.DAGGANCIO
         M.ORF_SYSSYS = SPACE(10)
         M.ORF_ANNO   = M.ORD_ANNO
         M.ORF_UNIQUE = SYS(2015)
         M.ORF_TIPAGG = SPACE(01)
         M.ORF_CHIUSO = .F.
         M.ORF_QTAEV  = 0
         M.ORF_DESTIN = 'PDV '
         M.ORF_NUMDDT = M.ORD_NUMORD
         M.ORF_DATDDT = M.ORD_DATORD
         M.ORF_QTADDT = M.ORD_QTAORD
         M.ORF_FLGCON = M.ORD_FLGCON
         M.ORF_QTASPE = 0
         M.ORF_QTADSP = M.ORD_QTAORD
         M.ORF_CODMIT = PUB_CLISOC
         M.ORF_RAGMIT = PUB_RAGSOC
         SELECT U_ORF_CO
         APPEND BLANK
         DO U_ORF_CO
         IF !ExecRW(Csql,"U_ORF_CO","W")
            return(.f.)
         ENDIF
      ENDIF
   ELSE
      REPLACE ORF_QTASPE WITH ORF_QTASPE + M.ORD_QTAORD
      SCATTER MEMVAR
      Csql   = "select * from u_orf_co where 1=0"
      IF !ExecRW(Csql,"U_ORF_CO","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_CO
      APPEND BLANK
      DO U_ORF_CO
      REPLACE SELEZIONE  WITH SPACE(10)
      REPLACE ORF_FLGTRA WITH .F.
      REPLACE ORF_FLGCON WITH M.ORD_FLGCON
      REPLACE ORF_QTADSP WITH M.ORD_QTAORD
      REPLACE ORF_QTASPE WITH 0
      REPLACE ORF_NUMDDT WITH M.ORD_NUMORD
      REPLACE ORF_DATDDT WITH M.ORD_DATORD
      REPLACE ORF_QTADDT WITH M.ORD_QTAORD
      REPLACE ORF_TIPAGG WITH SPACE(01)
      REPLACE ORF_CODMIT WITH PUB_CLISOC
      REPLACE ORF_RAGMIT WITH PUB_RAGSOC
      IF !ExecRW(Csql,"U_ORF_CO","W")
         return(.f.)
      ENDIF
   ENDIF
   IF !ExecRW(Csql,"u_orf_po","W")
      return(.f.)
   ENDIF

   **==> Gestione del file delle bolle di reso da pdv a sede
   IF M.ORD_CAUS = PUB_CAUREF
      Csql   = "select * from u_bol_re where 1=0"
      IF !ExecRW(Csql,"U_BOL_RE","R")
         return(.f.)
      ENDIF
      SELECT U_BOL_RE
      APPEND BLANK
      REPLACE ORF_CODPDV WITH M.ORD_CODBUN
      REPLACE ORF_DESPDV WITH M.ORD_DESBUN
      REPLACE ORF_CODMAG WITH M.ORD_MAGA
      REPLACE ORF_CODART WITH M.ORD_CODART
      REPLACE ORF_DESART WITH M.ORD_DESART
      REPLACE ORF_UNITAM WITH M.ORD_UM
      REPLACE ORF_NUMPRO WITH M.ORS_NUMORC
      REPLACE ORF_DATPRO WITH M.ORS_DATORC
      REPLACE ORF_QTAPRO WITH M.ORD_QTAOLD
      REPLACE ORF_QTAORD WITH 0
      REPLACE ORF_QTADOR WITH 0
      REPLACE ORF_CODFOR WITH M.ORD_CODCLI
      REPLACE ORF_RAGSOC WITH M.ORD_RAGSOC
      REPLACE ORF_NUMORD WITH SPACE(06)
      REPLACE ORF_DATORD WITH SPACE(10)
      REPLACE ORF_PREZZO WITH M.ORD_PRZNET
      REPLACE ORF_DATCON WITH M.ORD_DATCON
      REPLACE ORF_CODSYS WITH SPACE(10)
      REPLACE ORF_FLGTRA WITH .F.
      REPLACE ORF_GIACEN WITH 0
      REPLACE ORF_QTAORF WITH 0
      REPLACE ORF_QUANTI WITH 0
      REPLACE ORF_SYSCOD WITH SPACE(10)
      REPLACE SELEZIONE  WITH SPACE(10)
      REPLACE ORF_AGGANC WITH M.DAGGANCIO
      REPLACE ORF_SYSSYS WITH SPACE(10)
      REPLACE ORF_ANNO   WITH M.ORD_ANNO
      REPLACE ORF_QTAAGG WITH 0
      REPLACE ORF_UNIQUE WITH M.ORD_CODSYS
      REPLACE ORF_TIPAGG WITH SPACE(01)
      REPLACE ORF_CHIUSO WITH .F.
      REPLACE ORF_QTAEV  WITH 0
      REPLACE ORF_DESTIN WITH 'SEDE'
      REPLACE ORF_NUMDDT WITH M.ORD_NUMORD
      REPLACE ORF_DATDDT WITH M.ORD_DATORD
      REPLACE ORF_QTADDT WITH M.ORD_QTAORD
      REPLACE ORF_FLGCON WITH .T.
      REPLACE ORF_QTASPE WITH 0
      REPLACE ORF_QTADSP WITH M.ORD_QTAORD
      REPLACE ORF_CODMIT WITH PUB_CLISOC
      REPLACE ORF_RAGMIT WITH PUB_RAGSOC
      REPLACE ORF_CDFORN WITH XYZ_FORNIT
      REPLACE ORF_DSFORN WITH XYZ_RAGFOR
      IF !ExecRW(Csql,"U_BOL_RE","W")
         return(.f.)
      ENDIF
   ENDIF

   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'S'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "BOL"
      ENDIF
      SELECT(SSSS)
   ENDIF

   SELECT CU_BOL_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE BOLRIMAG  && RICARICA IL MAGAZZINO
**************************************************************************

v_seek	 = BOL_RECNO
v_chiave = "daggancio"
IF seek_std('u_bol_dd',v_seek,v_chiave,'CUR_DETTAGLI')
ELSE
   WAIT WINDOW "Non trovato uncino in ricarico magazzino : BOLRIMAG "+BOL_RECNO
   RETURN
ENDIF

SELECT CUR_DETTAGLI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   v_seek   = 'TOP'+M.ORD_CAUS
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      _TOPSCA = SUBSTR(LIBERA,35,3)   
      _TOPCAR = SUBSTR(CODICE,4,3)   
   ELSE
      _TOPSCA = '100 '
      _TOPCAR = '200 '  
   ENDIF
   IF EMPTY(_TOPSCA) .OR. _TOPSCA = SPACE(03)
      _TOPSCA = '100 '
   ENDIF
   IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
      _TOPCAR = '200 '  
   ENDIF
      
   H_DADOVE = 'BOLRIMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = M.ORD_MAGD
   H_CODART = M.ORD_CODART
   H_TOPSCA = _TOPSCA
   H_TOPCAR = _TOPCAR
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   IF !EMPTY(ALLTRIM(M.ORD_FORNIT))
      H_CLIFOR = M.ORD_FORNIT
   ELSE
      IF !EMPTY(ALLTRIM(PUB_CFDEF))
         H_CLIFOR = PUB_CFDEF
      ELSE
         H_CLIFOR = M.ORD_CODCLI
      ENDIF
   ENDIF
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = M.ORD_CODCLI    &&  MAGAZZINO VIAGGIANTE
   H_CSC    = CSC
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   **==> Gestione del file delle bolle trasferite per i pdv
   x_uniq = "orf_unique = '" + ALLTRIM(M.ORD_CODSYS) + "'"
   x_lega = "orf_agganc = '" + ALLTRIM(M.ORD_LEGAME) + "'"
   x_cond = x_uniq + " and " + x_lega
   Csql   = "select * from u_orf_po where " + x_cond
   IF !ExecRW(Csql,"U_ORF_PO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_PO
   IF EOF()
   ELSE
      REPLACE ORF_QTASPE WITH ORF_QTASPE - M.ORD_QTAORD
   ENDIF
   IF !ExecRW(Csql,"u_orf_po","W")
      return(.f.)
   ENDIF
   x_uniq = "orf_unique = '" + ALLTRIM(M.ORD_CODSYS) + "'"
   x_lega = "orf_agganc = '" + ALLTRIM(M.ORD_LEGAME) + "'"
   x_cond = x_uniq + " and " + x_lega
   Csql   = "select * from u_orf_co where " + x_cond
   IF !ExecRW(Csql,"U_ORF_CO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_CO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      DELETE
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_ORF_CO","W")
      return(.f.)
   ENDIF

   **==> Gestione del file delle bolle trasferite tra pdv e pdv 
   x_uniq = "orf_codsys = '" + ALLTRIM(M.ORD_CODSYS) + "'"
   x_arti = "orf_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_maga = "orf_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"
   x_cond = x_uniq + " and " + x_arti + " and " + x_maga 
   Csql   = "select * from u_orf_co where " + x_cond
   IF !ExecRW(Csql,"U_ORF_CO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_CO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      DELETE
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_ORF_CO","W")
      return(.f.)
   ENDIF
   
   **==> Gestione del file delle bolle di reso da pdv a sede
   IF M.ORD_CAUS = PUB_CAUREF
      x_uniq = "orf_unique = '" + ALLTRIM(M.ORD_CODSYS) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(M.DAGGANCIO) + "'"
      x_cond = x_uniq + " and " + x_lega
      Csql   = "select * from u_bol_re where " + x_cond
      IF !ExecRW(Csql,"U_BOL_RE","R")
         return(.f.)
      ENDIF
      SELECT U_BOL_RE
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         DELETE
         SKIP +1
      ENDDO
      IF !ExecRW(Csql,"U_BOL_RE","W")
         return(.f.)
      ENDIF
   ENDIF
   
   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'C'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "BOL"
      ENDIF
      SELECT(SSSS)
   ENDIF

   SELECT CUR_DETTAGLI
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE BOLCANC  && ANNULLO BOLLE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = BOL_RECNO
CSQL="DELETE FROM U_BOL_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_BOL_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE PRBCANC  && ANNULLO BOLLE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

SWS=SELECT()

_DELETE = BOL_RECNO
CSQL="DELETE FROM U_PRB_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_PRB_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE BOLRESIC     && RICARICA IL MAGAZZINO SEDE DA RESI CLIENTE
**************************************************************************

SELECT CU_BOL_DD
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   H_DADOVE = 'BOLRESIC'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = M.ORD_CAUS
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = CSC
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CU_BOL_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
  PROCEDURE BOLRESIS  && SCARICA IL MAGAZZINO
**************************************************************************

v_seek	 = BOL_RECNO
v_chiave = "daggancio"
IF seek_std('u_bol_dd',v_seek,v_chiave,'CUR_DETTAGLI')
ELSE
   WAIT WINDOW "Non trovato uncino in resis magazzino : BOLRESIS "+ BOL_RECNO
   RETURN
ENDIF

SELECT CUR_DETTAGLI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   H_DADOVE = 'BOLRESIS'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '200'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = CSC
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CUR_DETTAGLI
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE PDVSCMAG  && SCARICA IL MAGAZZINO E I SALDI
**************************************************************************
PARAMETERS _CURSORE,_SEQUEN,_ANNO,_PROGRE,_DATOPE,_ORAOPE

SELECT &_CURSORE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   REPLACE CAS_NUMFAT WITH XXX_NUMFAT
   REPLACE CAS_DATFAT WITH XXX_DATFAT
   REPLACE CAS_CODCLI WITH XXX_CODCLI
   REPLACE CAS_RAGSOC WITH XXX_RAGSOC
   REPLACE CAS_SEQUEN WITH _SEQUEN
   REPLACE CAS_ANNO   WITH _ANNO
   REPLACE CAS_CODPDV WITH PUB_CODBUN
   REPLACE CAS_CODCAS WITH PUB_CODCAS
   REPLACE CAS_PROGRE WITH _PROGRE
   REPLACE CAS_DATOPE WITH _DATOPE
   REPLACE CAS_ORAOPE WITH _ORAOPE
   REPLACE CAS_CODMAG WITH PUB_CODM
   IF CAS_QUANTI <> 0 
      IF M.CAS_QUANTI > 0
         H_TOP = PUB_CAUCAS
         H_QTA = M.CAS_QUANTI
         H_VAL = M.CAS_PREZZO
      ELSE
         H_TOP = PUB_CAUREC
         H_QTA = M.CAS_QUANTI * -1
         H_VAL = M.CAS_PREZZO * -1
      ENDIF
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
      H_DADOVE = 'ECASH'
      H_GENMOV = 'SI' 
      H_TIPO   = 'GIA'
      H_IMPE   = ""
      H_MAGSCA = PUB_CODM
      H_MAGCAR = ""
      H_CODART = M.CAS_CODART
      H_TOPSCA = H_TOP
      H_TOPCAR = ""
      H_QUANTI = H_QTA
      H_NUMDOC = _PROGRE
      H_DATDOC = _DATOPE
      H_DATREG = RIBALTA2(DTOC(DATE()))
      H_ORAMOV = _ORAOPE
      H_CLIFOR = M.CAS_CODCLI
      H_PRZACQ = 0
      H_PRZVEN = H_VAL
      H_CODIVA = M.CAS_CODIVA
      H_SCONTO = M.CAS_SCONTO
      H_VALUTA = ""
      H_NOTE   = M.CAS_NOTE
      H_CSC    = ""
      H_SAC    = ""
      H_GGG    = "SI"
      H_FORNIT = ""
      H_FLGTRA = .F.
      =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
      
      SELECT &_CURSORE	                        &&  07/07/2003
      REPLACE CAS_FORNIT WITH XYZ_FORNIT        &&  07/07/2003
      REPLACE CAS_RAGFOR WITH XYZ_RAGSOC        &&  07/07/2003

      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA ED ARTICOLO VENDUTO
      V_PDV     = PUB_CODBUN
      V_PERI_G  = _DATOPE
      V_PERI_M  = SUBSTR(_DATOPE,1,4) + "/" + SUBSTR(_DATOPE,6,2) + SPACE(03)
      V_PERI_A  = SUBSTR(_DATOPE,1,4) + SPACE(06)
      V_SEEK_G = '2G' + V_PDV + V_PERI_G + M.CAS_CODART
      V_SEEK_M = '2M' + V_PDV + V_PERI_M + M.CAS_CODART
      V_SEEK_A = '2A' + V_PDV + V_PERI_A + M.CAS_CODART
      x_tipo = "sal_tipo = '2G'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_G + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2G'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_G
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '2M'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_M + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2M'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_M
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '2A'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_A + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2A'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_A
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      v_seek   = 'IVA'+M.CAS_CODIVA
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         ALIQ = SUBSTR(LIBERA,1,3)
         NUM_ALIQ = VAL(ALIQ)
         DES_ALIQ = DESCRI
      ELSE
         NUM_ALIQ = 0
         DES_ALIQ = ""
      ENDIF
      V_PDV  = PUB_CODBUN
      V_PERI = _DATOPE
      x_soci = "cor_codsoc = '" + pub_codsoc + "'"
      x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "cor_data = '" + V_PERI + "'"
      x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
      Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
      IF !ExecRW(cSql,"U_IVA_CO","R")
         return(.f.)
      ENDIF
      SELECT U_IVA_CO
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
         REPLACE COR_CODSOC WITH PUB_CODSOC
         REPLACE COR_CODPDV WITH V_PDV
         REPLACE COR_DATA   WITH V_PERI
         REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
      ENDIF
      REPLACE COR_TOTALE WITH COR_TOTALE + M.CAS_IMPORT
      IF NUM_ALIQ = 0
         IF EMPTY(COR_CDIVAN) .OR. COR_CDIVAN = SPACE(03)
            REPLACE COR_CDIVAN WITH M.CAS_CODIVA
            REPLACE COR_DEIVAN WITH DES_ALIQ
         ENDIF
         REPLACE COR_VAIVAN    WITH COR_VAIVAN + M.CAS_IMPORT
      ELSE
         V_IVA = .F.
         IF NUM_ALIQ = 4
            REPLACE COR_CDIVA1 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA1 WITH NUM_ALIQ
            REPLACE COR_VAIVA1 WITH COR_VAIVA1 + M.CAS_IMPORT
            REPLACE COR_IMIVA1 WITH COR_IMIVA1 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA1 WITH COR_VAIVA1 - COR_IMIVA1
            V_IVA = .T.
         ENDIF    
         IF NUM_ALIQ = 10
            REPLACE COR_CDIVA2 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA2 WITH NUM_ALIQ
            REPLACE COR_VAIVA2 WITH COR_VAIVA2 + M.CAS_IMPORT
            REPLACE COR_IMIVA2 WITH COR_IMIVA2 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA2 WITH COR_VAIVA2 - COR_IMIVA2
            V_IVA = .T.
         ENDIF    
         IF NUM_ALIQ = 20
            REPLACE COR_CDIVA3 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA3 WITH NUM_ALIQ
            REPLACE COR_VAIVA3 WITH COR_VAIVA3 + M.CAS_IMPORT
            REPLACE COR_IMIVA3 WITH COR_IMIVA3 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA3 WITH COR_VAIVA3 - COR_IMIVA3
            V_IVA = .T.
         ENDIF    
         IF V_IVA 
         ELSE
            IF COR_CDIVA4 = M.CAS_CODIVA
               REPLACE COR_VAIVA4 WITH COR_VAIVA4 + M.CAS_IMPORT
               REPLACE COR_IMIVA4 WITH COR_IMIVA4 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
               V_IVA = .T.
            ENDIF    
            IF COR_CDIVA5 = M.CAS_CODIVA
               REPLACE COR_VAIVA5 WITH COR_VAIVA5 + M.CAS_IMPORT
               REPLACE COR_IMIVA5 WITH COR_IMIVA5 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
               V_IVA = .T.
            ENDIF    
         ENDIF 
         IF V_IVA 
         ELSE
            IF EMPTY(COR_CDIVA4) .OR. COR_CDIVA4 = SPACE(03)
               REPLACE COR_CDIVA4 WITH M.CAS_CODIVA
               REPLACE COR_PEIVA4 WITH NUM_ALIQ
               REPLACE COR_VAIVA4 WITH M.CAS_IMPORT
               REPLACE COR_IMIVA4 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
            ELSE
               IF EMPTY(COR_CDIVA5) .OR. COR_CDIVA5 = SPACE(03)
                  REPLACE COR_CDIVA5 WITH M.CAS_CODIVA
                  REPLACE COR_PEIVA5 WITH NUM_ALIQ
                  REPLACE COR_VAIVA5 WITH M.CAS_IMPORT
                  REPLACE COR_IMIVA5 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                  REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      REPLACE COR_NETIVA WITH COR_IMIVA1 + COR_IMIVA2  + COR_IMIVA3 + COR_IMIVA4 + COR_IMIVA5 + COR_VAIVAN
      IF !ExecRW(cSql,"U_IVA_CO","W")
         return(.f.)
      ENDIF
   ENDIF

   IF M.CAS_TIPINC = SPACE(03) .OR. EMPTY(M.CAS_TIPINC)
   ELSE
      V_PDV     = PUB_CODBUN
      V_PERI_G  = _DATOPE
      V_PERI_M  = SUBSTR(_DATOPE,1,4) + "/" + SUBSTR(_DATOPE,6,2) + SPACE(03)
      V_PERI_A  = SUBSTR(_DATOPE,1,4) + SPACE(06)
      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA
      V_SEEK_G = '1G' + V_PDV + V_PERI_G + SPACE(16)
      V_SEEK_M = '1M' + V_PDV + V_PERI_M + SPACE(16)
      V_SEEK_A = '1A' + V_PDV + V_PERI_A + SPACE(16)
      x_tipo = "sal_tipo = '1G'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_G + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1G'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_G
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '1M'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_M + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1M'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_M
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '1A'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_A + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1A'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_A
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF

      x_codi = "pdv_codice = '" + ALLTRIM(M.CAS_TIPINC) + "'"
      Csql   = "select * from u_pdv_pa where " + x_codi
      IF !ExecCommand(cSql,"U_PDV_PA")
         return(.f.)
      ENDIF
      SELECT U_PDV_PA 
      GO top
      IF !EOF()
         X_TIPPAG = PDV_TIPPAG
      ELSE
         X_TIPPAG = 'C'
      ENDIF
      
      V_TROV = .F.

      x_cpdv = "cas_codpdv = '" + ALLTRIM(PUB_CODBUN) + "'"
      x_maga = "cas_codmag = '" + ALLTRIM(PUB_CODM) + "'"
      x_cass = "cas_codcas = '" + ALLTRIM(PUB_CODCAS) + "'"
      x_peri = "cas_datope = '" + _DATOPE + "'"
      x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
      Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
      IF !ExecRW(cSql,"U_PDV_SC","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SC
      IF RECCOUNT() <> 0
         V_TROV = .T.
      ELSE
         x_cpdv = "cas_codpdv = '" + ALLTRIM(PUB_CODBUN) + "'"
         x_maga = "cas_codmag = '" + ALLTRIM(PUB_CODM) + "'"
         x_cass = "cas_codcas = '" + ALLTRIM(PUB_CODCAS) + "'"
         x_peri = "cas_datope <= '" + _DATOPE + "'"
         x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
         Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
         IF !ExecRW(cSql,"U_PDV_SC","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SC
         GO TOP
         IF EOF()
         ELSE
            GO BOTTOM
            SCATTER MEMVAR MEMO
            SELECT U_PDV_SC
            APPEND BLANK
*           GATHER MEMVAR MEMO
            DO U_PDV_SC
            REPLACE CAS_DATOPE WITH _DATOPE
            V_TROV = .T.
         ENDIF
      ENDIF
      SELECT U_PDV_SC
      IF V_TROV
      ELSE
         APPEND BLANK
         REPLACE CAS_CODPDV WITH PUB_CODBUN
         REPLACE CAS_CODCAS WITH PUB_CODCAS
         REPLACE CAS_CODMAG WITH PUB_CODM
         REPLACE CAS_DATOPE WITH _DATOPE
         REPLACE CAS_ORAOPE WITH _ORAOPE
         REPLACE CAS_VALCON WITH 0
         REPLACE CAS_VALNOC WITH 0
         REPLACE CAS_VALPOS WITH 0
         REPLACE CAS_VALCAR WITH 0
         REPLACE CAS_VALASS WITH 0
         REPLACE CAS_VALFIN WITH 0
         REPLACE CAS_VALALT WITH 0
      ENDIF   
      REPLACE CAS_ORAOPE WITH _ORAOPE
      IF X_TIPPAG = 'C'
         REPLACE CAS_VALCON WITH CAS_VALCON + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'R'
         REPLACE CAS_VALCON WITH CAS_VALCON - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'B'
         REPLACE CAS_VALPOS WITH CAS_VALPOS + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'P'
         REPLACE CAS_VALCAR WITH CAS_VALCAR + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'A'
         REPLACE CAS_VALASS WITH CAS_VALASS + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'F'
         REPLACE CAS_VALFIN WITH CAS_VALFIN + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'V'
         REPLACE CAS_VALALT WITH CAS_VALALT + M.CAS_IMPORT
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SC","W")
         return(.f.)
      ENDIF

      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      V_PDV  = PUB_CODBUN
      V_PERI = _DATOPE
      x_soci = "cor_codsoc = '" + pub_codsoc + "'"
      x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "cor_data = '" + V_PERI + "'"
      x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
      Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
      IF !ExecRW(cSql,"U_IVA_CO","R")
         return(.f.)
      ENDIF
      SELECT U_IVA_CO
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
         REPLACE COR_CODSOC WITH PUB_CODSOC
         REPLACE COR_CODPDV WITH V_PDV
         REPLACE COR_DATA   WITH V_PERI
         REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
      ENDIF
      REPLACE COR_NUMSCO    WITH COR_NUMSCO + 1
      IF !ExecRW(cSql,"U_IVA_CO","W")
         return(.f.)
      ENDIF
   
   ENDIF

   _SEQUEN = _SEQUEN + 10

   SELECT &_CURSORE
   SKIP +1

ENDDO

IF !ExecRW('','u_pdv_ca','I','',_CURSORE)
   return(.f.)
ENDIF

RETURN


**************************************************************************
PROCEDURE PDVSCMAGV  && RICARICA IL MAGAZZINO E I SALDI
**************************************************************************

SELECT CU_PDV_CAV
GO TOP
X_DATOPEV = CAS_DATOPE
X_ORAOPEV = TIME()
X_ANNOV   = SUBSTR(X_DATOPEV,1,4)
X_PROGREV = CAS_PROGRE
X_SEQUENV = 10

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   REPLACE CAS_NUMFAT WITH XXX_NUMFAT
   REPLACE CAS_DATFAT WITH XXX_DATFAT
   REPLACE CAS_CODCLI WITH XXX_CODCLI
   REPLACE CAS_RAGSOC WITH XXX_RAGSOC
   REPLACE CAS_ANNO   WITH X_ANNOV
   REPLACE CAS_CODPDV WITH PUB_CODBUN
   REPLACE CAS_CODCAS WITH PUB_CODCAS
   REPLACE CAS_DATOPE WITH X_DATOPEV
   REPLACE CAS_ORAOPE WITH X_ORAOPEV
   REPLACE CAS_CODMAG WITH PUB_CODM
   SCATTER MEMVAR MEMO
   IF CAS_QUANTI <> 0 
      IF M.CAS_QUANTI > 0
         H_TOP = PUB_CAUCAS
         H_QTA = M.CAS_QUANTI
         H_VAL = M.CAS_PREZZO
      ELSE
         H_TOP = PUB_CAUREC
         H_QTA = M.CAS_QUANTI * -1
         H_VAL = M.CAS_PREZZO * -1
      ENDIF
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
      H_DADOVE = 'ECASH'
      H_GENMOV = 'SI' 
      H_TIPO   = 'GIA'
      H_IMPE   = ""
      H_MAGSCA = M.CAS_CODMAG
      H_MAGCAR = ""
      H_CODART = M.CAS_CODART
      H_TOPSCA = H_TOP
      H_TOPCAR = ""
      H_QUANTI = H_QTA
      H_NUMDOC = M.CAS_PROGRE
      H_DATDOC = M.CAS_DATOPE
      H_DATREG = RIBALTA2(DTOC(DATE()))
      H_ORAMOV = TIME()
      H_CLIFOR = M.CAS_CODCLI
      H_PRZACQ = 0
      H_PRZVEN = H_VAL
      H_CODIVA = M.CAS_CODIVA
      H_SCONTO = M.CAS_SCONTO
      H_VALUTA = ""
      H_NOTE   = M.CAS_NOTE
      H_CSC    = ""
      H_SAC    = ""
      H_GGG    = "SI"
      H_FORNIT = ""
      H_FLGTRA = .F.
      =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

      SELECT CU_PDV_CAV                         &&  07/07/2003
      REPLACE CAS_FORNIT WITH XYZ_FORNIT        &&  07/07/2003
      REPLACE CAS_RAGFOR WITH XYZ_RAGSOC        &&  07/07/2003

      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA ED ARTICOLO VENDUTO
      V_PDV     = M.CAS_CODPDV
      V_PERI_G  = M.CAS_DATOPE
      V_PERI_M  = SUBSTR(M.CAS_DATOPE,1,4) + "/" + SUBSTR(M.CAS_DATOPE,6,2) + SPACE(03)
      V_PERI_A  = SUBSTR(M.CAS_DATOPE,1,4) + SPACE(06)
      V_SEEK_G = '2G' + V_PDV + V_PERI_G + M.CAS_CODART
      V_SEEK_M = '2M' + V_PDV + V_PERI_M + M.CAS_CODART
      V_SEEK_A = '2A' + V_PDV + V_PERI_A + M.CAS_CODART
      x_tipo = "sal_tipo = '2G'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_G + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2G'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_G
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '2M'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_M + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2M'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_M
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '2A'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_A + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2A'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_A
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      v_seek   = 'IVA'+M.CAS_CODIVA
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         ALIQ = SUBSTR(LIBERA,1,3)
         NUM_ALIQ = VAL(ALIQ)
         DES_ALIQ = DESCRI
      ELSE
         NUM_ALIQ = 0
         DES_ALIQ = ""
      ENDIF
      V_PDV  = PUB_CODBUN
      V_PERI = M.CAS_DATOPE
      x_soci = "cor_codsoc = '" + pub_codsoc + "'"
      x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "cor_data = '" + V_PERI + "'"
      x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
      Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
      IF !ExecRW(cSql,"U_IVA_CO","R")
         return(.f.)
      ENDIF
      SELECT U_IVA_CO
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
         REPLACE COR_CODSOC WITH PUB_CODSOC
         REPLACE COR_CODPDV WITH V_PDV
         REPLACE COR_DATA   WITH V_PERI
         REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
      ENDIF
      REPLACE COR_TOTALE WITH COR_TOTALE + M.CAS_IMPORT
      IF NUM_ALIQ = 0
         IF EMPTY(COR_CDIVAN) .OR. COR_CDIVAN = SPACE(03)
            REPLACE COR_CDIVAN WITH M.CAS_CODIVA
            REPLACE COR_DEIVAN WITH DES_ALIQ
         ENDIF
         REPLACE COR_VAIVAN    WITH COR_VAIVAN + M.CAS_IMPORT
      ELSE
         V_IVA = .F.
         IF NUM_ALIQ = 4
            REPLACE COR_CDIVA1 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA1 WITH NUM_ALIQ
            REPLACE COR_VAIVA1 WITH COR_VAIVA1 + M.CAS_IMPORT
            REPLACE COR_IMIVA1 WITH COR_IMIVA1 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA1 WITH COR_VAIVA1 - COR_IMIVA1
            V_IVA = .T.
         ENDIF    
         IF NUM_ALIQ = 10
            REPLACE COR_CDIVA2 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA2 WITH NUM_ALIQ
            REPLACE COR_VAIVA2 WITH COR_VAIVA2 + M.CAS_IMPORT
            REPLACE COR_IMIVA2 WITH COR_IMIVA2 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA2 WITH COR_VAIVA2 - COR_IMIVA2
            V_IVA = .T.
         ENDIF    
         IF NUM_ALIQ = 20
            REPLACE COR_CDIVA3 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA3 WITH NUM_ALIQ
            REPLACE COR_VAIVA3 WITH COR_VAIVA3 + M.CAS_IMPORT
            REPLACE COR_IMIVA3 WITH COR_IMIVA3 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA3 WITH COR_VAIVA3 - COR_IMIVA3
            V_IVA = .T.
         ENDIF    
         IF V_IVA 
         ELSE
            IF COR_CDIVA4 = M.CAS_CODIVA
               REPLACE COR_VAIVA4 WITH COR_VAIVA4 + M.CAS_IMPORT
               REPLACE COR_IMIVA4 WITH COR_IMIVA4 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
               V_IVA = .T.
            ENDIF    
            IF COR_CDIVA5 = M.CAS_CODIVA
               REPLACE COR_VAIVA5 WITH COR_VAIVA5 + M.CAS_IMPORT
               REPLACE COR_IMIVA5 WITH COR_IMIVA5 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
               V_IVA = .T.
            ENDIF    
         ENDIF 
         IF V_IVA 
         ELSE
            IF EMPTY(COR_CDIVA4) .OR. COR_CDIVA4 = SPACE(03)
               REPLACE COR_CDIVA4 WITH M.CAS_CODIVA
               REPLACE COR_PEIVA4 WITH NUM_ALIQ
               REPLACE COR_VAIVA4 WITH M.CAS_IMPORT
               REPLACE COR_IMIVA4 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
            ELSE
               IF EMPTY(COR_CDIVA5) .OR. COR_CDIVA5 = SPACE(03)
                  REPLACE COR_CDIVA5 WITH M.CAS_CODIVA
                  REPLACE COR_PEIVA5 WITH NUM_ALIQ
                  REPLACE COR_VAIVA5 WITH M.CAS_IMPORT
                  REPLACE COR_IMIVA5 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                  REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      REPLACE COR_NETIVA WITH COR_IMIVA1 + COR_IMIVA2  + COR_IMIVA3 + COR_IMIVA4 + COR_IMIVA5 + COR_VAIVAN
      IF !ExecRW(cSql,"U_IVA_CO","W")
         return(.f.)
      ENDIF
   ENDIF

   IF M.CAS_TIPINC = SPACE(03) .OR. EMPTY(M.CAS_TIPINC)
   ELSE
      V_PDV     = M.CAS_CODPDV
      V_PERI_G  = M.CAS_DATOPE
      V_PERI_M  = SUBSTR(M.CAS_DATOPE,1,4) + "/" + SUBSTR(M.CAS_DATOPE,6,2) + SPACE(03)
      V_PERI_A  = SUBSTR(M.CAS_DATOPE,1,4) + SPACE(06)
      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA
      V_SEEK_G = '1G' + V_PDV + V_PERI_G + SPACE(16)
      V_SEEK_M = '1M' + V_PDV + V_PERI_M + SPACE(16)
      V_SEEK_A = '1A' + V_PDV + V_PERI_A + SPACE(16)
      x_tipo = "sal_tipo = '1G'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_G + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1G'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_G
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '1M'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_M + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1M'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_M
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '1A'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_A + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1A'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_A
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF

      x_codi = "pdv_codice = '" + ALLTRIM(M.CAS_TIPINC) + "'"
      Csql   = "select * from u_pdv_pa where " + x_codi
      IF !ExecCommand(cSql,"U_PDV_PA")
         return(.f.)
      ENDIF
      SELECT U_PDV_PA 
      GO top
      IF !EOF()
         X_TIPPAG = PDV_TIPPAG
      ELSE
         X_TIPPAG = 'C'
      ENDIF
      
      V_TROV = .F.

      x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
      x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
      x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
      x_peri = "cas_datope = '" + M.CAS_DATOPE + "'"
      x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
      Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
      IF !ExecRW(cSql,"U_PDV_SC","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SC
      IF RECCOUNT() <> 0
         V_TROV = .T.
      ELSE
         x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
         x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
         x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
         x_peri = "cas_datope <= '" + M.CAS_DATOPE + "'"
         x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
         Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
         IF !ExecRW(cSql,"U_PDV_SC","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SC
         GO TOP
         IF EOF()
         ELSE
            GO BOTTOM
            SCATTER MEMVAR MEMO
            SELECT U_PDV_SC
            APPEND BLANK
            DO U_PDV_SC
            REPLACE CAS_DATOPE WITH M.CAS_DATOPE
            V_TROV = .T.
         ENDIF
      ENDIF
      SELECT U_PDV_SC
      IF V_TROV
      ELSE
         APPEND BLANK
         REPLACE CAS_CODPDV WITH M.CAS_CODPDV
         REPLACE CAS_CODCAS WITH M.CAS_CODCAS
         REPLACE CAS_CODMAG WITH M.CAS_CODMAG
         REPLACE CAS_DATOPE WITH M.CAS_DATOPE
         REPLACE CAS_ORAOPE WITH M.CAS_ORAOPE
         REPLACE CAS_VALCON WITH 0
         REPLACE CAS_VALNOC WITH 0
         REPLACE CAS_VALPOS WITH 0
         REPLACE CAS_VALCAR WITH 0
         REPLACE CAS_VALASS WITH 0
         REPLACE CAS_VALFIN WITH 0
         REPLACE CAS_VALALT WITH 0
      ENDIF   
      REPLACE CAS_ORAOPE WITH M.CAS_ORAOPE
      IF X_TIPPAG = 'C'
         REPLACE CAS_VALCON WITH CAS_VALCON + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'R'
         REPLACE CAS_VALCON WITH CAS_VALCON - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'B'
         REPLACE CAS_VALPOS WITH CAS_VALPOS + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'P'
         REPLACE CAS_VALCAR WITH CAS_VALCAR + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'A'
         REPLACE CAS_VALASS WITH CAS_VALASS + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'F'
         REPLACE CAS_VALFIN WITH CAS_VALFIN + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'V'
         REPLACE CAS_VALALT WITH CAS_VALALT + M.CAS_IMPORT
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SC","W")
         return(.f.)
      ENDIF
      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      V_PDV  = PUB_CODBUN
      V_PERI = M.CAS_DATOPE
      x_soci = "cor_codsoc = '" + pub_codsoc + "'"
      x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "cor_data = '" + V_PERI + "'"
      x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
      Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
      IF !ExecRW(cSql,"U_IVA_CO","R")
         return(.f.)
      ENDIF
      SELECT U_IVA_CO
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
         REPLACE COR_CODSOC WITH PUB_CODSOC
         REPLACE COR_CODPDV WITH V_PDV
         REPLACE COR_DATA   WITH V_PERI
         REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
      ENDIF
      REPLACE COR_NUMSCO    WITH COR_NUMSCO + 1
      IF !ExecRW(cSql,"U_IVA_CO","W")
         return(.f.)
      ENDIF
   ENDIF

   X_SEQUENV = X_SEQUENV + 10

   SELECT CU_PDV_CAV
   SKIP +1

ENDDO

IF !ExecRW('','u_pdv_ca','I','','CU_PDV_CAV')
   return(.f.)
ENDIF

RETURN


**************************************************************************
PROCEDURE PDVRIMAG  && RICARICA IL MAGAZZINO E I SALDI
**************************************************************************

PARA _MAGA,_PROG,_DATA

x_maga = "cas_codmag = '" + _MAGA + "'"
x_prog = "cas_progre = '" + _PROG + "'"
x_data = "cas_datope = '" + _DATA + "'"
x_cond = x_maga + " and " + x_prog + " and " + x_data
Csql   = "select * from u_pdv_ca where " + x_cond + " order by cas_codmag,cas_progre,cas_datope,cas_oraope,cas_sequen"
IF !ExecRW(cSql,"U_PDV_CA","R")
   return(.f.)
ENDIF
SELECT U_PDV_CA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   IF M.CAS_QUANTI <> 0 
      H_TOP = SPACE(03) 
      IF M.CAS_QUANTI > 0
         v_seek	= 'TOP' + PUB_CAUCAS
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            H_TOP = SUBSTR(LIBERA,35,3)
         ENDIF
         IF EMPTY(H_TOP) .OR. H_TOP = SPACE(03)
            H_TOP = '100'
         ENDIF 
         H_QTA = M.CAS_QUANTI
         H_VAL = M.CAS_PREZZO
      ELSE
         v_seek	= 'TOP' + PUB_CAUREC
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            H_TOP = SUBSTR(LIBERA,35,3)
         ENDIF
         IF EMPTY(H_TOP) .OR. H_TOP = SPACE(03)
            H_TOP = '200'
         ENDIF 
         H_QTA = M.CAS_QUANTI * -1
         H_VAL = M.CAS_PREZZO * -1
      ENDIF
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
      H_DADOVE = 'ECASH'
      H_GENMOV = 'SI' 
      H_TIPO   = 'GIA'
      H_IMPE   = ""
      H_MAGSCA = M.CAS_CODMAG
      H_MAGCAR = ""
      H_CODART = M.CAS_CODART
      H_TOPSCA = H_TOP
      H_TOPCAR = ""
      H_QUANTI = H_QTA
      H_NUMDOC = M.CAS_PROGRE
      H_DATDOC = M.CAS_DATOPE
      H_DATREG = RIBALTA2(DTOC(DATE()))
      H_ORAMOV = TIME()
      H_CLIFOR = M.CAS_CODCLI
      H_PRZACQ = 0
      H_PRZVEN = H_VAL
      H_CODIVA = M.CAS_CODIVA
      H_SCONTO = M.CAS_SCONTO
      H_VALUTA = ""
      H_NOTE   = M.CAS_NOTE
      H_CSC    = ""
      H_SAC    = ""
      H_GGG    = "SI"
      H_FORNIT = M.CAS_FORNIT
      H_FLGTRA = .F.
      =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA ED ARTICOLO VENDUTO
      V_PDV     = M.CAS_CODPDV
      V_PERI_G  = M.CAS_DATOPE
      V_PERI_M  = SUBSTR(M.CAS_DATOPE,1,4) + "/" + SUBSTR(M.CAS_DATOPE,6,2) + SPACE(03)
      V_PERI_A  = SUBSTR(M.CAS_DATOPE,1,4) + SPACE(06)
      V_SEEK_G = '2G' + V_PDV + V_PERI_G + M.CAS_CODART
      V_SEEK_M = '2M' + V_PDV + V_PERI_M + M.CAS_CODART
      V_SEEK_A = '2A' + V_PDV + V_PERI_A + M.CAS_CODART
      x_tipo = "sal_tipo = '2G'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_G + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI - M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2G'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_G
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI * -1
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '2M'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_M + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI - M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2M'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_M
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI * -1
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '2A'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_A + "'"
      x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         REPLACE SAL_QUANTI WITH SAL_QUANTI - M.CAS_QUANTI
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '2A'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_A
         REPLACE SAL_CODART WITH M.CAS_CODART
         REPLACE SAL_DESART WITH M.CAS_DESART
         REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         REPLACE SAL_QUANTI WITH M.CAS_QUANTI * -1
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      v_seek   = 'IVA'+M.CAS_CODIVA
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         ALIQ = SUBSTR(LIBERA,1,3)
         NUM_ALIQ = VAL(ALIQ)
         DES_ALIQ = DESCRI
      ELSE
         NUM_ALIQ = 0
         DES_ALIQ = ""
      ENDIF
      V_PDV  = PUB_CODBUN
      V_PERI = M.CAS_DATOPE
      x_soci = "cor_codsoc = '" + pub_codsoc + "'"
      x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "cor_data = '" + V_PERI + "'"
      x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
      Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
      IF !ExecRW(cSql,"U_IVA_CO","R")
         return(.f.)
      ENDIF
      SELECT U_IVA_CO
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
         REPLACE COR_CODSOC WITH PUB_CODSOC
         REPLACE COR_CODPDV WITH V_PDV
         REPLACE COR_DATA   WITH V_PERI
         REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
      ENDIF
      REPLACE COR_TOTALE WITH COR_TOTALE - M.CAS_IMPORT
      IF NUM_ALIQ = 0
         IF EMPTY(COR_CDIVAN) .OR. COR_CDIVAN = SPACE(03)
            REPLACE COR_CDIVAN WITH M.CAS_CODIVA
            REPLACE COR_DEIVAN WITH DES_ALIQ
         ENDIF
         REPLACE COR_VAIVAN    WITH COR_VAIVAN - M.CAS_IMPORT
      ELSE
         V_IVA = .F.
         IF NUM_ALIQ = 4
            REPLACE COR_CDIVA1 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA1 WITH NUM_ALIQ
            REPLACE COR_VAIVA1 WITH COR_VAIVA1 + M.CAS_IMPORT
            REPLACE COR_IMIVA1 WITH COR_IMIVA1 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA1 WITH COR_VAIVA1 - COR_IMIVA1
            V_IVA = .T.
         ENDIF    
         IF NUM_ALIQ = 10
            REPLACE COR_CDIVA2 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA2 WITH NUM_ALIQ
            REPLACE COR_VAIVA2 WITH COR_VAIVA2 + M.CAS_IMPORT
            REPLACE COR_IMIVA2 WITH COR_IMIVA2 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA2 WITH COR_VAIVA2 - COR_IMIVA2
            V_IVA = .T.
         ENDIF    
         IF NUM_ALIQ = 20
            REPLACE COR_CDIVA3 WITH M.CAS_CODIVA
            REPLACE COR_PEIVA3 WITH NUM_ALIQ
            REPLACE COR_VAIVA3 WITH COR_VAIVA3 + M.CAS_IMPORT
            REPLACE COR_IMIVA3 WITH COR_IMIVA3 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
            REPLACE COR_IVIVA3 WITH COR_VAIVA3 - COR_IMIVA3
            V_IVA = .T.
         ENDIF    
         IF V_IVA 
         ELSE
            IF COR_CDIVA4 = M.CAS_CODIVA
               REPLACE COR_VAIVA4 WITH COR_VAIVA4 + M.CAS_IMPORT
               REPLACE COR_IMIVA4 WITH COR_IMIVA4 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
               V_IVA = .T.
            ENDIF    
            IF COR_CDIVA5 = M.CAS_CODIVA
               REPLACE COR_VAIVA5 WITH COR_VAIVA5 + M.CAS_IMPORT
               REPLACE COR_IMIVA5 WITH COR_IMIVA5 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
               V_IVA = .T.
            ENDIF    
         ENDIF 
         IF V_IVA 
         ELSE
            IF EMPTY(COR_CDIVA4) .OR. COR_CDIVA4 = SPACE(03)
               REPLACE COR_CDIVA4 WITH M.CAS_CODIVA
               REPLACE COR_PEIVA4 WITH NUM_ALIQ
               REPLACE COR_VAIVA4 WITH M.CAS_IMPORT
               REPLACE COR_IMIVA4 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
            ELSE
               IF EMPTY(COR_CDIVA5) .OR. COR_CDIVA5 = SPACE(03)
                  REPLACE COR_CDIVA5 WITH M.CAS_CODIVA
                  REPLACE COR_PEIVA5 WITH NUM_ALIQ
                  REPLACE COR_VAIVA5 WITH M.CAS_IMPORT
                  REPLACE COR_IMIVA5 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                  REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      REPLACE COR_NETIVA WITH COR_IMIVA1 + COR_IMIVA2  + COR_IMIVA3 + COR_IMIVA4 + COR_IMIVA5 + COR_VAIVAN
      IF !ExecRW(cSql,"U_IVA_CO","W")
         return(.f.)
      ENDIF
   ENDIF

   IF M.CAS_TIPINC = SPACE(03) .OR. EMPTY(M.CAS_TIPINC)
   ELSE
      V_PDV     = M.CAS_CODPDV
      V_PERI_G  = M.CAS_DATOPE
      V_PERI_M  = SUBSTR(M.CAS_DATOPE,1,4) + "/" + SUBSTR(M.CAS_DATOPE,6,2) + SPACE(03)
      V_PERI_A  = SUBSTR(M.CAS_DATOPE,1,4) + SPACE(06)
      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA
      V_SEEK_G = '1G' + V_PDV + V_PERI_G + SPACE(16)
      V_SEEK_M = '1M' + V_PDV + V_PERI_M + SPACE(16)
      V_SEEK_A = '1A' + V_PDV + V_PERI_A + SPACE(16)
      x_tipo = "sal_tipo = '1G'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_G + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1G'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_G
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT 
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '1M'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_M + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1M'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_M
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT 
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF
      x_tipo = "sal_tipo = '1A'"
      x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "sal_period = '" + V_PERI_A + "'"
      x_codi = "sal_codart = '" + SPACE(16) + "'"
      x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
      Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
      IF !ExecRW(cSql,"U_PDV_SA","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SA
      IF RECCOUNT() <> 0
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE SAL_TIPO   WITH '1A'
         REPLACE SAL_CODPDV WITH V_PDV
         REPLACE SAL_PERIOD WITH V_PERI_A
         IF M.CAS_TIPINC = 'RES'
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
         ELSE
            REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SA","W")
         return(.f.)
      ENDIF

      x_codi = "pdv_codice = '" + ALLTRIM(M.CAS_TIPINC) + "'"
      Csql   = "select * from u_pdv_pa where " + x_codi
      IF !ExecCommand(cSql,"U_PDV_PA")
         return(.f.)
      ENDIF
      SELECT U_PDV_PA 
      GO top
      IF !EOF()
         X_TIPPAG = PDV_TIPPAG
      ELSE
         X_TIPPAG = 'C'
      ENDIF
      
      V_TROV = .F.

      x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
      x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
      x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
      x_peri = "cas_datope = '" + M.CAS_DATOPE + "'"
      x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
      Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
      IF !ExecRW(cSql,"U_PDV_SC","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SC
      IF RECCOUNT() <> 0
         V_TROV = .T.
      ELSE
         x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
         x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
         x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
         x_peri = "cas_datope <= '" + M.CAS_DATOPE + "'"
         x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
         Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
         IF !ExecRW(cSql,"U_PDV_SC","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SC
         GO TOP
         IF EOF()
         ELSE
            GO BOTTOM
            SCATTER MEMVAR MEMO
            SELECT U_PDV_SC
            APPEND BLANK
            DO U_PDV_SC
            REPLACE CAS_DATOPE WITH M.CAS_DATOPE
            V_TROV = .T.
         ENDIF
      ENDIF
      SELECT U_PDV_SC
      IF V_TROV
      ELSE
         APPEND BLANK
         REPLACE CAS_CODPDV WITH M.CAS_CODPDV
         REPLACE CAS_CODCAS WITH M.CAS_CODCAS
         REPLACE CAS_CODMAG WITH M.CAS_CODPAG
         REPLACE CAS_DATOPE WITH M.CAS_DATOPE
         REPLACE CAS_ORAOPE WITH M.CAS_ORAOPE
         REPLACE CAS_VALCON WITH 0
         REPLACE CAS_VALNOC WITH 0
         REPLACE CAS_VALPOS WITH 0
         REPLACE CAS_VALCAR WITH 0
         REPLACE CAS_VALASS WITH 0
         REPLACE CAS_VALFIN WITH 0
         REPLACE CAS_VALALT WITH 0
      ENDIF   
      REPLACE CAS_ORAOPE WITH M.CAS_ORAOPE
      IF X_TIPPAG = 'C'
         REPLACE CAS_VALCON WITH CAS_VALCON - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'R'
         REPLACE CAS_VALCON WITH CAS_VALCON + M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'B'
         REPLACE CAS_VALPOS WITH CAS_VALPOS - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'P'
         REPLACE CAS_VALCAR WITH CAS_VALCAR - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'A'
         REPLACE CAS_VALASS WITH CAS_VALASS - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'F'
         REPLACE CAS_VALFIN WITH CAS_VALFIN - M.CAS_IMPORT
      ENDIF
      IF X_TIPPAG = 'V'
         REPLACE CAS_VALALT WITH CAS_VALALT - M.CAS_IMPORT
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SC","W")
         return(.f.)
      ENDIF

      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      V_PDV  = PUB_CODBUN
      V_PERI = M.CAS_DATOPE
      x_soci = "cor_codsoc = '" + pub_codsoc + "'"
      x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
      x_peri = "cor_data = '" + V_PERI + "'"
      x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
      Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
      IF !ExecRW(cSql,"U_IVA_CO","R")
         return(.f.)
      ENDIF
      SELECT U_IVA_CO
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
         REPLACE COR_CODSOC WITH PUB_CODSOC
         REPLACE COR_CODPDV WITH V_PDV
         REPLACE COR_DATA   WITH V_PERI
         REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
      ENDIF
      REPLACE COR_NUMSCO    WITH COR_NUMSCO - 1
      IF COR_FATNDA = M.CAS_NUMFAT
         REPLACE COR_FATNDA WITH SPACE(06)
         REPLACE COR_FATNAL WITH SPACE(06)
      ELSE
         IF COR_FATNAL = M.CAS_NUMFAT
            V_NUMORDN = VAL(COR_FATNAL) - 1
            V_NUMORDX = STR(V_NUMORDN,6,0)
            PUB_LNO   = 6
            V_NUMORDX = TRC(PUB_LNO,ALLTRIM(V_NUMORDX))
            REPLACE COR_FATNAL WITH V_NUMORDX
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_IVA_CO","W")
         return(.f.)
      ENDIF

   ENDIF

   SELECT U_PDV_CA
   SKIP +1

ENDDO

IF !ExecRW(cSql,"U_PDV_CA","W")
   return(.f.)
ENDIF

RETURN


**************************************************************************
PROCEDURE PDVCANC  && ANNULLO MOVIMENTI DI INCASSO IN FASE DI VARIAZIONE
**************************************************************************

PARA _MAGA,_PROG,_DATA

Csql = "select * from u_can_ca where 1=0"
IF !ExecCommand(cSql,"CU_CAN_CA")
   return(.f.)
ENDIF

x_maga = "cas_codmag = '" + _MAGA + "'"
x_prog = "cas_progre = '" + _PROG + "'"
x_data = "cas_datope = '" + _DATA + "'"
x_cond = x_maga + " and " + x_prog + " and " + x_data
Csql   = "select * from u_pdv_ca where " + x_cond + " order by cas_codmag,cas_progre,cas_datope,cas_oraope,cas_sequen"
IF !ExecRW(cSql,"U_PDV_CA","R")
   return(.f.)
ENDIF
SELECT U_PDV_CA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CAN_CA
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE CAS_TRASME WITH .F.
   SELECT U_PDV_CA
   DELETE
   SKIP +1
ENDDO
IF !ExecRW(cSql,"U_PDV_CA","W")
   return(.f.)
ENDIF

IF !ExecRW('','u_can_ca','I','','CU_CAN_CA')
   return(.f.)
ENDIF

RETURN


*****************************************************************************
PROCEDURE PDVGESTSC
*****************************************************************************
PARAMETERS _DATOPE,_ORAOPE,_TOTOPE

V_CONT = 0
V_NOCO = 0
V_ALTR = 0
V_TROV = .F.

x_cpdv = "cas_codpdv = '" + ALLTRIM(PUB_CODBUN) + "'"
x_maga = "cas_codmag = '" + ALLTRIM(PUB_CODM) + "'"
x_cass = "cas_codcas = '" + ALLTRIM(PUB_CODCAS) + "'"
x_peri = "cas_datope = '" + _DATOPE + "'"
x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
IF !ExecRW(cSql,"U_PDV_SC","R")
   return(.f.)
ENDIF
SELECT U_PDV_SC
IF RECCOUNT() <> 0
   V_TROV = .T.
ELSE
   x_cpdv = "cas_codpdv = '" + ALLTRIM(PUB_CODBUN) + "'"
   x_maga = "cas_codmag = '" + ALLTRIM(PUB_CODM) + "'"
   x_cass = "cas_codcas = '" + ALLTRIM(PUB_CODCAS) + "'"
   x_peri = "cas_datope <= '" + _DATOPE + "'"
   x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
   Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
   IF !ExecRW(cSql,"U_PDV_SC","R")
      return(.f.)
   ENDIF
   SELECT U_PDV_SC
   GO TOP
   IF EOF()
   ELSE
      GO BOTTOM
      SCATTER MEMVAR MEMO
      SELECT U_PDV_SC
      APPEND BLANK
      *GATHER MEMVAR MEMO
      DO U_PDV_SC
      REPLACE CAS_DATOPE WITH _DATOPE
      V_TROV = .T.
   ENDIF
ENDIF

SELECT U_PDV_SC
IF V_TROV
ELSE
   APPEND BLANK
   REPLACE CAS_CODPDV WITH PUB_CODBUN
   REPLACE CAS_CODCAS WITH PUB_CODCAS
   REPLACE CAS_CODMAG WITH PUB_CODM
   REPLACE CAS_DATOPE WITH _DATOPE
   REPLACE CAS_ORAOPE WITH _ORAOPE
   REPLACE CAS_VALCON WITH 0
   REPLACE CAS_VALNOC WITH 0
   REPLACE CAS_VALPOS WITH 0
   REPLACE CAS_VALCAR WITH 0
   REPLACE CAS_VALASS WITH 0
   REPLACE CAS_VALFIN WITH 0
   REPLACE CAS_VALALT WITH 0
ENDIF   
REPLACE CAS_ORAOPE WITH _ORAOPE
IF X_TIPO = 'C'
   IF X_SEGNO = '+'
      REPLACE CAS_VALCON WITH CAS_VALCON + _TOTOPE
   ELSE
      REPLACE CAS_VALCON WITH CAS_VALCON - _TOTOPE
   ENDIF
ENDIF
IF X_TIPO = 'V'
   IF X_SEGNO = '+'
      REPLACE CAS_VALCON WITH CAS_VALCON + _TOTOPE
      REPLACE CAS_VALNOC WITH CAS_VALNOC + _TOTOPE
   ELSE
      REPLACE CAS_VALCON WITH CAS_VALCON - _TOTOPE
      REPLACE CAS_VALNOC WITH CAS_VALNOC - _TOTOPE
   ENDIF
ENDIF
IF X_TIPO = 'B'
   IF X_SEGNO = '+'
      REPLACE CAS_VALPOS WITH CAS_VALPOS + _TOTOPE
   ELSE
      REPLACE CAS_VALPOS WITH CAS_VALPOS - _TOTOPE
   ENDIF
ENDIF
IF X_TIPO = 'P'
   IF X_SEGNO = '+'
      REPLACE CAS_VALCAR WITH CAS_VALCAR + _TOTOPE
   ELSE
      REPLACE CAS_VALCAR WITH CAS_VALCAR - _TOTOPE
   ENDIF
ENDIF
IF X_TIPO = 'A'
   IF X_SEGNO = '+'
      REPLACE CAS_VALASS WITH CAS_VALASS + _TOTOPE
   ELSE
      REPLACE CAS_VALASS WITH CAS_VALASS - _TOTOPE
   ENDIF
ENDIF
IF X_TIPO = 'F'
   IF X_SEGNO = '+'
      REPLACE CAS_VALFIN WITH CAS_VALFIN + _TOTOPE
   ELSE
      REPLACE CAS_VALFIN WITH CAS_VALFIN - _TOTOPE
   ENDIF
ENDIF

V_CONT = CAS_VALCON
V_NOCO = CAS_VALNOC
V_ALTR = CAS_VALPOS + CAS_VALCAR + CAS_VALASS + CAS_VALFIN + CAS_VALALT

IF !ExecRW(cSql,"U_PDV_SC","W")
   return(.f.)
ENDIF

RETURN


*****************************************************************************
PROCEDURE LAVOCAR
*****************************************************************************

CREATE CURSOR TABSCO1 (TQTADEV N(10,2), TQTAEV N(10,2), TQTAORD N(10,2), ;
					   TUNIMIS C(02),	TCODART C(16),  TDESART C(40),   ;
                       TPREZZO N(13,3), TCODARR C(16),  TAGGANC C(10),   ;
                       TCODMAG C(06),   TDATCON C(10))

DEFINE WINDOW DETTAGLI AT 0,0 SIZE 20,80;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW  DETTAGLI CENTER 

ORDINE=NUMORD
ORDIDT=DATORD

SELECT CUR_TESTATA
SCATTER MEMVAR MEMO
AGGA=TAGGANCIO

x_agga = "daggancio = '" + AGGA + "'"
cSql   = "SELECT * FROM U_CTL_DD WHERE " + x_agga + " order by daggancio"
IF !ExecCommand(cSql,"CU_CTL_DD")
   return(.f.)
ENDIF
SELECT CU_CTL_DD
GO TOP
IF EOF()
   =MSGBOX("Nessuna riga d'ordine inserita",'ATTENZIONE',31)
   RETURN
ENDIF 

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF ORD_CHIUSO
      SKIP +1
      LOOP
   ENDIF
   IF SUBSTR(ORD_CODART,1,2) = 'CC'
      SKIP +1
      LOOP
   ENDIF
   IF ORD_CODART = SPACE(16) .OR. EMPTY(ORD_CODART)
      SKIP +1
      LOOP
   ENDIF
   X_CODART = ORD_CODART
   X_DESART = ORD_DESART
   X_UNIMIS = ORD_UM
   X_PREZZO = ORD_PREZZO
   X_QTAORD = ORD_QTAORD
   X_QTAEV  = ORD_QTAEV
   X_QTADEV = ORD_QTADEV
   X_CODARR = ORD_CODARR
   X_AGGANC = DAGGANCIO
   X_CODMAG = ORD_MAGA
   X_DATCON = ORD_DATCON
   SELECT TABSCO1
   APPEND BLANK
   REPLACE TCODART WITH X_CODART    
   REPLACE TDESART WITH X_DESART    
   REPLACE TUNIMIS WITH X_UNIMIS    
   REPLACE TPREZZO WITH X_PREZZO    
   REPLACE TQTAORD WITH X_QTAORD    
   REPLACE TQTAEV  WITH X_QTAEV    
   REPLACE TQTADEV WITH X_QTADEV    
   REPLACE TCODARR WITH X_CODARR    
   REPLACE TAGGANC WITH X_AGGANC    
   REPLACE TCODMAG WITH X_CODMAG    
   REPLACE TDATCON WITH X_DATCON    
   SELECT CU_CTL_DD
   SKIP +1
ENDDO

SELECT TABSCO1
GO TOP
    
DO FORM FORM\LAVMCARI

SELECT TABSCO1
USE

RETURN

******************************
FUNCTION _ELAFAT
******************************
* ELABORA FATTURE A RICHIESTA IMPOSTANDO IL CAMPO SELEZIONE
* __TIPO = DATA :  ACCESSO PER DATA
* __TIPO = NUME :  ACCESSO PER DATA

PARA __TIPO,__DATDA,__DATAL,__ANNO,__NUME,__AGG,__CCLI,__AGE

DO CASE

   CASE __TIPO = "DATA"
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_dat1 = RIBALTA2(__DATDA)
        x_dat2 = RIBALTA2(__DATAL)
        x_data = "ord_datord between '" + x_dat1 + "' and '" + x_dat2 + "'"
        x_agen = "ord_age = '" + ALLTRIM(__AGE) + "'"
        x_clie = "ord_codcli = '" + ALLTRIM(__CCLI) + "'"
        x_cond = x_soci + " and " + x_data
        IF EMPTY(__AGE) .OR. __AGE = SPACE(03)
        ELSE     								&& SCARTA FATTURE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_agen
        ENDIF
        IF EMPTY(__CCLI) .OR. __CCLI = SPACE(10)
        ELSE     								&& SCARTA FATTURE NON DEL CLIENTE DIGITATO
           x_cond = x_cond + " and " + x_clie
       ENDIF
       Csql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
       IF !ExecCommand(Csql,"U_FAT_TT")
          return(.f.)
       ENDIF
       SELECT U_FAT_TT
       GO TOP
       DO WHILE .T.
          IF EOF()
             EXIT
          ENDIF
	      IF DELETED()
		     SKIP +1
		     LOOP
	      ENDIF
          SCATTER MEMVAR MEMO
          __RC = SYS(2015)
	      REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
          SELECT  CFAT_TT
          APPEND BLANK
          GATHER MEMVAR MEMO
          REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
	      REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
	      SELECT U_FAT_TT
          SKIP +1
       ENDDO

   CASE __TIPO = "NUME"
        PUB_LNO = 6
        _numero = TRC(PUB_LNO,ALLTRIM(__NUME))
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_anno = "ord_anno = '" + PUB_ANNO + "'"
        x_nord = "ord_numord = '" + _numero + "'"
        x_cond = x_soci + " and " + x_anno
        IF EMPTY(__NUME) .OR. __NUME = SPACE(06)
        ELSE     								&& SCARTA FATTURE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_nord
        ENDIF
        Csql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
        IF !ExecCommand(Csql,"U_FAT_TT")
           return(.f.)
        ENDIF
        SELECT U_FAT_TT
        GO TOP
        DO WHILE .T.
           IF EOF()
              EXIT
           ENDIF
	       IF DELETED()
		      SKIP +1
		      LOOP
	       ENDIF
  	       SCATTER MEMVAR MEMO
  	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
 	       SELECT  CFAT_TT
           APPEND BLANK
           GATHER MEMVAR MEMO
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
 		   SELECT U_FAT_TT
		   SKIP +1
		ENDDO
ENDCASE

RETURN

******************************
FUNCTION _ELABOL
******************************
* ELABORA BOLLE A RICHIESTA IMPOSTANDO IL CAMPO SELEZIONE
* __TIPO = DATA :  ACCESSO PER DATA
* __TIPO = NUME :  ACCESSO PER DATA
* __TIPO = DATX :  ACCESSO PER DATA TENENDO PRESENTE IL TIPO DI FATTURAZIONE
* __TIPO = DATY :  ACCESSO PER DATA TENENDO PRESENTE IL CLIENTE EMITTENTE ORDINE

PARA __TIPO,__DATDA,__DATAL,__ANNO,__NUME,__AGG,__CCLI,__AGE

DO CASE

   CASE __TIPO = "DATA"
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_dat1 = RIBALTA2(__DATDA)
        x_dat2 = RIBALTA2(__DATAL)
        x_data = "ord_datord between '" + x_dat1 + "' and '" + x_dat2 + "'"
        x_agen = "ord_age = '" + ALLTRIM(__AGE) + "'"        
        x_clie = "ord_codcli = '" + ALLTRIM(__CCLI) + "'"
        x_flbo = "ord_flbol != 'S'"             && SCARTA BOLLE GIA' ELABORATE
        x_cond = x_soci + " and " + x_data + " and " + x_flbo
        IF EMPTY(__AGE) .OR. __AGE = SPACE(03)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_agen
        ENDIF
        IF EMPTY(__CCLI) .OR. __CCLI = SPACE(10)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_clie
        ENDIF
        Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
        IF !ExecRW(cSql,"U_BOL_TT","R")
           return(.f.)
        ENDIF
        SELECT U_BOL_TT
        GO TOP
	    DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF
		   IF DELETED()
		      SKIP +1
		      LOOP
	       ENDIF
		   IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF
           _CAUS = ORD_CAUS
           IF !_BOLDAFAT(_CAUS)				&& SCARTA BOLLE NON DA FATTURARE
	 	      SKIP +1
	 	      LOOP
	 	   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
           IF M.ORD_CLIFAT = SPACE(10) .OR. EMPTY(M.ORD_CLIFAT)
           ELSE
              x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
              x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CLIFAT) + "'"
              x_cond = x_soci + " and " + x_codi   
              cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
              IF !ExecCommand(cSql,"CUR_CLIENTI")
                 RETURN .F.
              ENDIF
              SELECT CUR_CLIENTI
              GO TOP   
              IF EOF()
              ELSE
                 M.ORD_CODCLI = CLI_CODCLI
                 M.ORD_RAGSOC = CLI_RAGSOC
                 M.ORD_INDIRI = CLI_INDIR
                 M.ORD_CAP    = CLI_CAP
                 M.ORD_LOCALI = CLI_LOCALI
                 M.ORD_PARIVA = CLI_PARIVA
              ENDIF
           ENDIF           
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO	 	
	       REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
	 	   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
		   SELECT U_BOL_TT
		   SKIP +1
		ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF

   CASE __TIPO = "NUME"
        PUB_LNO = 6
        _numero = TRC(PUB_LNO,ALLTRIM(__NUME))
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_anno = "ord_anno = '" + PUB_ANNO + "'"
        x_nord = "ord_numord = '" + _numero + "'"
        x_cond = x_soci + " and " + x_anno 
        IF EMPTY(__NUME) .OR. __NUME = SPACE(06)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_nord
        ENDIF
        Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
        IF !ExecRW(cSql,"U_BOL_TT","R")
           return(.f.)
        ENDIF
        SELECT U_BOL_TT
        GO TOP
		DO WHILE .T.
	       IF EOF()
		      EXIT
		   ENDIF
		   IF DELETED()
		     SKIP +1
		     LOOP
		   ENDIF
 		   IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF
 		   IF ORD_FLBOL = 'S'				&& SCARTA BOLLE GIA' FATTURATE
		      SKIP +1
		      LOOP
		   ENDIF
           IF !_BOLDAFAT(ORD_CAUS)			&& SCARTA BOLLE NON DA FATTURARE
              SELECT U_BOL_TT
              SKIP +1
		      LOOP
		   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
	       REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
 	       IF M.ORD_CLIFAT = SPACE(10) .OR. EMPTY(M.ORD_CLIFAT)
           ELSE
              x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
              x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CLIFAT) + "'"
              x_cond = x_soci + " and " + x_codi   
              cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
              IF !ExecCommand(cSql,"CUR_CLIENTI")
                 RETURN .F.
              ENDIF
              SELECT CUR_CLIENTI
              GO TOP   
              IF EOF()
              ELSE
                 M.ORD_CODCLI = CLI_CODCLI
                 M.ORD_RAGSOC = CLI_RAGSOC
                 M.ORD_INDIRI = CLI_INDIR
                 M.ORD_CAP    = CLI_CAP
                 M.ORD_LOCALI = CLI_LOCALI
                 M.ORD_PARIVA = CLI_PARIVA
              ENDIF
           ENDIF
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO	
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
		   SELECT U_BOL_TT
		   SKIP +1
  	    ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF

   CASE __TIPO = "DATX"
         x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
         x_dat1 = RIBALTA2(__DATDA)
         x_dat2 = RIBALTA2(__DATAL)
         x_data = "ord_datord between '" + x_dat1 + "' and '" + x_dat2 + "'"
         x_flbo = "ord_flbol != 'S'"             && SCARTA BOLLE GIA' ELABORATE
         x_clie = "ord_codcli = '" + ALLTRIM(__CCLI) + "'"
         x_cond = x_soci + " and " + x_data  + " and " + x_flbo
         IF EMPTY(__CCLI) .OR. __CCLI = SPACE(10)
         ELSE     								&& SCARTA BOLLE NON DEL CLIENTE DIGITATO
            x_cond = x_cond + " and " + x_clie
         ENDIF
         Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
         IF !ExecRW(cSql,"U_BOL_TT","R")
            return(.f.)
         ENDIF
         SELECT U_BOL_TT
         GO TOP
		 DO WHILE .T.
		    IF EOF()
		       EXIT
		    ENDIF
 		    IF DELETED()
		       SKIP +1
		       LOOP
		    ENDIF
		    IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		       SKIP +1
		       LOOP
		    ENDIF
 		    IF !EMPTY(__AGE)					&& SCARTA BOLLE CON TIPO FATTURAZIONE CLIENTE DIVERSO DA QUELLO DIGITATO
		       XX_CODCLI = ORD_CODCLI
               x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
               x_codi = "cli_codcli = '" + XX_CODCLI + "'"
               x_cond = x_soci + " and " + x_codi   
               cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
               IF !ExecCommand(cSql,"CUR_CLIENTI")
                  RETURN .F.
               ENDIF
               SELECT CUR_CLIENTI
               GO TOP   
               IF EOF()
                  XX_TIPFAT = SPACE(10)
               ELSE
                  XX_TIPFAT = CLI_TIPFAT
               ENDIF	     
   		       SELECT U_BOL_TT
  		       IF ALLTRIM(XX_TIPFAT)<>ALLTRIM(__AGE)
		          SKIP +1
		          LOOP
		       ENDIF
		    ENDIF
           _CAUS = ORD_CAUS
           IF !_BOLDAFAT(_CAUS)				&& SCARTA BOLLE NON DA FATTURARE
		      SKIP +1
		      LOOP
		   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
           IF M.ORD_CLIFAT = SPACE(10) .OR. EMPTY(M.ORD_CLIFAT)
           ELSE
              x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
              x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CLIFAT) + "'"
              x_cond = x_soci + " and " + x_codi   
              cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
              IF !ExecCommand(cSql,"CUR_CLIENTI")
                 RETURN .F.
              ENDIF
              SELECT CUR_CLIENTI
              GO TOP   
              IF EOF()
              ELSE
                 M.ORD_CODCLI = CLI_CODCLI
                 M.ORD_RAGSOC = CLI_RAGSOC
                 M.ORD_INDIRI = CLI_INDIR
                 M.ORD_CAP    = CLI_CAP
                 M.ORD_LOCALI = CLI_LOCALI
                 M.ORD_PARIVA = CLI_PARIVA
              ENDIF	     
           ENDIF  
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
 		   SELECT U_BOL_TT
		   SKIP +1
		ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF
        
	CASE __TIPO = "DATY"
         x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
         x_dat1 = RIBALTA2(__DATDA)
         x_dat2 = RIBALTA2(__DATAL)
         x_data = "ord_datord between '" + x_dat1 + "' and '" + x_dat2 + "'"
         x_fltr = "ord_fltras != 'S'"             && SCARTA BOLLE GIA' ELABORATE X IL TRASPORTO
         x_agen = "ord_age = '" + ALLTRIM(__AGE) + "'"        
         x_clie = "ord_codcli = '" + ALLTRIM(__CCLI) + "'"
         x_cond = x_soci + " and " + x_data  + " and " + x_fltr
         IF EMPTY(__AGE) .OR. __AGE = SPACE(03)
         ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
            x_cond = x_cond + " and " + x_agen
         ENDIF
         IF EMPTY(__CCLI) .OR. __CCLI = SPACE(10)
         ELSE     								&& SCARTA BOLLE NON DEL CLIENTE DIGITATO
            x_cond = x_cond + " and " + x_clie
         ENDIF
         Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
         IF !ExecRW(cSql,"U_BOL_TT","R")
            return(.f.)
         ENDIF
         SELECT U_BOL_TT
         GO TOP
		 DO WHILE .T.
		    IF EOF()
		       EXIT
		    ENDIF
		    IF DELETED()
		       SKIP +1
		       LOOP
		    ENDIF
		    IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		       SKIP +1
		       LOOP
		    ENDIF
            _CAUS = ORD_CAUS
            IF !_BOLDAFAT(_CAUS) 				&& SCARTA BOLLE NON DA FATTURARE
		       IF ORD_TIPORD = 'ODS' .OR. ORD_TIPORD = 'BO '
		       ELSE
   		          SKIP +1
		          LOOP
		       ENDIF
		    ENDIF
 	        SCATTER MEMVAR MEMO
 	        __RC = SYS(2015)
		    REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
            IF M.ORD_CLIFAT = SPACE(10) .OR. EMPTY(M.ORD_CLIFAT)
            ELSE
               x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
               x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CLIFAT) + "'"
               x_cond = x_soci + " and " + x_codi   
                cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
               IF !ExecCommand(cSql,"CUR_CLIENTI")
                  RETURN .F.
                ENDIF
               SELECT CUR_CLIENTI
               GO TOP   
               IF EOF()
               ELSE
                  M.ORD_CODCLI = CLI_CODCLI
                  M.ORD_RAGSOC = CLI_RAGSOC
                  M.ORD_INDIRI = CLI_INDIR
                  M.ORD_CAP    = CLI_CAP
                  M.ORD_LOCALI = CLI_LOCALI
                  M.ORD_PARIVA = CLI_PARIVA
               ENDIF	               
            ENDIF
            SELECT  CBOL_TT
            APPEND BLANK
            GATHER MEMVAR MEMO	
		    REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		    REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
		    SELECT U_BOL_TT
		    SKIP +1
		 ENDDO
         IF !ExecRW(cSql,"U_BOL_TT","W")
            return(.f.)
         ENDIF
        		 
ENDCASE

RETURN

******************************
FUNCTION _ELABOL1
******************************
* ELABORA BOLLE PER GESTIONE NOTE CREDITO
* __TIPO = DATA :  ACCESSO PER DATA
* __TIPO = NUME :  ACCESSO PER DATA

PARA __TIPO,__DATDA,__DATAL,__ANNO,__NUME,__AGG,__CCLI,__AGE

DO CASE

   CASE __TIPO = "DATA"
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_dat1 = RIBALTA2(__DATDA)
        x_dat2 = RIBALTA2(__DATAL)
        x_data = "ord_datord between '" + x_dat1 + "' and '" + x_dat2 + "'"
        x_agen = "ord_age = '" + ALLTRIM(__AGE) + "'"       
        x_clie = "ord_codcli = '" + ALLTRIM(__CCLI) + "'"
        x_cond = x_soci + " and " + x_data
        IF EMPTY(__AGE) .OR. __AGE = SPACE(03)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_agen
        ENDIF
        IF EMPTY(__CCLI) .OR. __CCLI = SPACE(10)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_clie
        ENDIF
        Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
        IF !ExecRW(cSql,"U_BOL_TT","R")
           return(.f.)
        ENDIF
		DO WHILE .T.		   
		   IF EOF()
		      EXIT
		   ENDIF
		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
 		   IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
		   SELECT U_BOL_TT
		   SKIP +1
		ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF

   CASE __TIPO = "NUME"
        PUB_LNO = 6
        _numero = TRC(PUB_LNO,ALLTRIM(__NUME))
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_anno = "ord_anno = '" + PUB_ANNO + "'"
        x_nord = "ord_numord = '" + _numero + "'"
        x_cond = x_soci + " and " + x_anno 
        IF EMPTY(__NUME) .OR. __NUME = SPACE(06)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_nord
        ENDIF
        Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
        IF !ExecRW(cSql,"U_BOL_TT","R")
           return(.f.)
        ENDIF
        SELECT U_BOL_TT
        GO TOP
		DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF
		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
		   IF ORD_FLBOL = "S" 				&& SCARTA BOLLE GIA' ELABORATE
		      SKIP +1
		      LOOP
		   ENDIF
 		   IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF
           IF !_BOLDAFAT(ORD_CAUS)			&& SCARTA BOLLE NON DA FATTURARE
              SKIP +1
	          LOOP
		   ENDIF
  	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO
	 	   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
		   SELECT U_BOL_TT
		   SKIP +1
		ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF

ENDCASE

RETURN

******************************
FUNCTION _ELARES
******************************
* ELABORA RESI A RICHIESTA IMPOSTANDO IL CAMPO SELEZIONE
* __TIPO = DATA :  ACCESSO PER DATA
* __TIPO = NUME :  ACCESSO PER DATA

PARA __TIPO,__DATDA,__DATAL,__ANNO,__NUME,__AGG,__CCLI,__AGE

DO CASE

   CASE __TIPO = "DATA"
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_dat1 = RIBALTA2(__DATDA)
        x_dat2 = RIBALTA2(__DATAL)
        x_data = "ord_datord between '" + x_dat1 + "' and '" + x_dat2 + "'"
        x_agen = "ord_age = '" + ALLTRIM(__AGE) + "'"        
        x_clie = "ord_codcli = '" + ALLTRIM(__CCLI) + "'"
        x_flbo = "ord_flbol != 'S'"             && SCARTA BOLLE GIA' ELABORATE
        x_cond = x_soci + " and " + x_data + " and " + x_flbo
        IF EMPTY(__AGE) .OR. __AGE = SPACE(03)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_agen
        ENDIF
        IF EMPTY(__CCLI) .OR. __CCLI = SPACE(10)
        ELSE     								&& SCARTA BOLLE NON DEL CLIENTE DIGITATO
           x_cond = x_cond + " and " + x_clie
        ENDIF        
        Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
        IF !ExecRW(cSql,"U_BOL_TT","R")
           return(.f.)
        ENDIF
        SELECT U_BOL_TT
        GO TOP
		DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF
 		   IF DELETED()
		     SKIP +1
		     LOOP
		   ENDIF
		   IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF
           _CAUS = ORD_CAUS
           IF !_RESDANCR(_CAUS)				&& SCARTA BOLLE NON DA FATTURARE
		      SKIP +1
		      LOOP
		   ENDIF
  	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE	
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	 && IMPOSTA CAMPO SELEZIONE
		   SELECT U_BOL_TT
		   SKIP +1
		ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF
        
   CASE __TIPO = "NUME"
        PUB_LNO = 6
        _numero = TRC(PUB_LNO,ALLTRIM(__NUME))
        x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
        x_anno = "ord_anno = '" + PUB_ANNO + "'"
        x_nord = "ord_numord = '" + _numero + "'"
        x_cond = x_soci + " and " + x_anno 
        IF EMPTY(__NUME) .OR. __NUME = SPACE(06)
        ELSE     								&& SCARTA BOLLE NON DELL'AGENTE DIGITATO
           x_cond = x_cond + " and " + x_nord
        ENDIF
        Csql = "select * from u_bol_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
        IF !ExecRW(cSql,"U_BOL_TT","R")
           return(.f.)
        ENDIF
        SELECT U_BOL_TT
        GO TOP
		DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF
		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
		   IF ORD_FLBOL = "S" 				&& SCARTA BOLLE GIA' ELABORATE
		      SKIP +1
		      LOOP
		   ENDIF
		   IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF
           IF !_RESDANCR(ORD_CAUS)			&& SCARTA BOLLE NON DA FATTURARE
              SKIP +1
	  	      LOOP
		   ENDIF
 	       SCATTER MEMVAR MEMO
 	       __RC = SYS(2015)
		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
           SELECT  CBOL_TT
           APPEND BLANK
           GATHER MEMVAR MEMO
 		   REPLACE ORD_CODSYS  WITH __RC     && NUMERO RECORD CORRENTE
		   REPLACE SELEZIONE   WITH __AGG	&& IMPOSTA CAMPO SELEZIONE
		   SELECT U_BOL_TT
		   SKIP +1
		ENDDO
        IF !ExecRW(cSql,"U_BOL_TT","W")
           return(.f.)
        ENDIF

ENDCASE

RETURN

*********************************************************************************
* 			GESTIONE ESENZIONI / COMMENTI STANDARD	DA BOLLE/ORDINI/OFFERTE		*
*********************************************************************************
PROCEDURE ESENOTB
**********************

IF EMPTY(IVA_ESE)
   RETURN
ENDIF

IF PUB_ESIVA			&& SOLO PER IVE INDICATE
   IF !VERYIVA(IVA_ESE)
      RETURN
   ENDIF
ENDIF

*===>>  ESENZIONE IVA
x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_codi = "not_codice = 'INESE'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from note_com where " + x_cond + " order by not_codsoc,not_codice"
IF !ExecCommand(cSql,"cur_notecom")
   return(.f.)
ENDIF
SELECT cur_notecom
GO TOP
IF EOF()
   =MESSAGEBOX("Testo standard 'INESE' "+CHR(13)+"non presente in testi standard",16,"*** ATTENZIONE ***") 
   RETURN
ENDIF
M.ORD_NOTE=not_testo
  
*===>   TRASFORMO DATI ESENZIONE  
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".NDESCLI.",V_CLIES)    && NUMERO DOCUMENTO ESENZIONE CLIENTE 
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".DTESCLI.",V_DTCLES)   && DATA DOCUMENTO ESENZIONE CLIENTE
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".NDESSOC.",V_NSES)  	  && NUMERO DOCUMENTO ESENZIONE SOCIETA
M.ORD_NOTE=STRTRAN(M.ORD_NOTE,".DTESSOC.",V_DTNSES)   && DATA DOCUMENTO ESENZIONE SOCIETA

SELECT CU_FAT_DD
APPEND BLANK
m.ord_codart = SPACE(16)
M.ORD_MAGA	 = SPACE(06)   
M.ORD_DESART = "*** COMMENTO ***"    
M.ORD_MAGA	 = SPACE(06)   
M.ORD_DES2	 = SPACE(25)
M.ORD_UM	 = SPACE(02)
M.ORD_IVA	 = SPACE(02)
M.ORD_PREZZO = 0
M.ORD_QTAORD = 0
M.ORD_PRZNET = 0
M.ORD_VALORE = 0
M.ORD_SC1    = 0
M.ORD_SC2    = 0
M.ORD_SC3    = 0	 
M.ord_pubbli = " "
M.ORD_VALCO  = 0        
GATHER MEMVAR MEMO

RETURN


********************************************************************************
* Funzione - LEGDFUNZ     Data: 13.09.02   Autore: Cristina Calzolari by Project
********************************************************************************

FUNCTION LEGDFUNZ

PARA _TABE,_TIPODOC,_ANNO,_CODCLI,_RAGSOC,_NUMDOC,_DATDOC,_TIPCRE,_NUMCRE,_DATCRE,_SALCON

X_SELE=SELECT()

W_NP = PARAMETERS()
IF W_NP < 10
   =MESSAGEBOX("Errore parametri insufficienti !","Errore !")
   RETURN(.F.)
ENDIF

IF SUBSTR(_DATDOC,3,1)='/'
   XXX_DATDOC = RIBALTA2(_DATDOC)
ELSE
   XXX_DATDOC = _DATDOC   
ENDIF

IF SUBSTR(_DATCRE,3,1)='/'
   XXX_DATCRE = RIBALTA2(_DATCRE)
ELSE
   XXX_DATCRE = _DATCRE
ENDIF

O_ANNO = _ANNO

*SELECT &_TABE
*SCATTER MEMVAR 

IF !ExecCommand("select * from u_leg_do where 0=1","cu_leg_do")
   return(.f.)
ENDIF
SELECT CU_LEG_DO
APPEND BLANK
REPLACE LEG_TIPDOC  WITH _TIPODOC
REPLACE LEG_CODCLI 	WITH _CODCLI
REPLACE LEG_RAGSOC 	WITH _RAGSOC
REPLACE LEG_NUMDOC 	WITH _NUMDOC
REPLACE LEG_DATDOC 	WITH XXX_DATDOC
REPLACE LEG_TIPCRE 	WITH _TIPCRE
REPLACE LEG_NUMCRE 	WITH _NUMCRE
REPLACE LEG_DATCRE 	WITH XXX_DATCRE
REPLACE LEG_ANNO 	WITH SUBSTR(XXX_DATDOC,1,4)
IF _SALCON
	REPLACE LEG_SALCON 	WITH "S"
ELSE
	REPLACE LEG_SALCON 	WITH "C"	
ENDIF
REPLACE LEG_DATEFF 	WITH RIBALTA2(DTOC(DATE()))
REPLACE LEG_ORACRE 	WITH SUBSTR(TIME(),1,5)
REPLACE LEG_CODOPE 	WITH PUB_CODOPE

IF !ExecRW('','u_leg_do','I','','CU_LEG_DO')
   return(.f.)
ENDIF

SELECT(X_SELE)


*******************
PROCEDURE CARI_LOC
*******************
* RICARICO IN AUTOMATICO DEL MAGAZZINO LOGISTICO

IF PUB_MLEBDT
   SCATTER MEMVAR MEMO 
   x_aggi = "aggancio = '" + M.TAGGANCIO + "'"
   x_cond = x_aggi
   Csql   = "select * from u_loc_mo where " + x_cond + " order by aggancio"
   IF !ExecCommand(cSql,"cu_loc_mo")
      return(.f.)
   ENDIF
   SELECT cu_loc_mo
   GO TOP
   IF EOF()
   ELSE
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR
         x_maga = "loc_codmag = '" + ALLTRIM(M.LOC_CODMAG) + "'"
         x_cors = "loc_corsia = '" + ALLTRIM(M.LOC_CORSIA) + "'"
         x_fila = "loc_fila = " + ALLTRIM(STR(M.LOC_FILA,2,0)) 
         x_pian = "loc_piano = '" + ALLTRIM(M.LOC_PIANO) + "'"
         x_arti = "loc_codart = '" + ALLTRIM(M.LOC_CODART) + "'"
         x_data = "loc_datcar = '" + ALLTRIM(M.LOC_DATCAR) + "'"
         x_cond = x_maga + " and " + x_cors + " and " + x_fila + " and " + x_pian + " and " + x_arti + " and " + x_data
         Csql   = "select * from u_loc_gi where " + x_cond + " order by loc_codmag,loc_corsia,loc_fila,loc_piano,loc_codart,loc_datcar"
         IF !ExecRW(Csql,"u_log_gi","R")
 	        return(.f.)
         ENDIF
         SELECT U_LOC_GI
         GO TOP
         IF EOF()
            append blank
            DO u_loc_gi
         ELSE
            REPLACE LOC_QTAGIA WITH LOC_QTAGIA + M.LOC_QTAGIA
         ENDIF
         IF !ExecRW("","u_log_gi","W")
	        return(.f.)
         ENDIF
         SELECT CU_LOC_MO
         SKIP +1
      ENDDO
      _DELETE = M.TAGGANCIO
      CSQL="DELETE FROM U_LOC_MO WHERE AGGANCIO = ?_DELETE"
      IF !ExecCommand(CSQL,"U_LOC_MO")
          RETURN (.f.)
      ENDIF 
   ENDIF         
ENDIF 

RETURN


*******************
PROCEDURE CARI_DIR
*******************
* RICARICO IN AUTOMATICO DEL MAGAZZINO DIREZIONALE

IF PUB_CLIDIR
   XX=SELECT()
   SCATTER MEMVAR MEMO 
   x_aggi = "daggancio = '" + M.TAGGANCIO + "'"
   x_cond = x_aggi
   Csql   = "select * from u_bol_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(cSql,"curs_bol_dd")
      return(.f.)
   ENDIF
   SELECT curs_bol_dd
   GO TOP
   IF EOF()
   ELSE
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   
            SKIP +1
            LOOP
         ENDIF   
         SCATTER MEMVAR
         x_cord = "mov_codord = '" + ALLTRIM(M.MOV_CODORD) + "'"
         x_nord = "mov_numord = '" + ALLTRIM(M.MOV_NUMORD) + "'"
         x_data = "mov_datord = '" + ALLTRIM(M.MOV_DATORD) + "'"
         x_tipo = "mov_tipord = '" + ALLTRIM(M.MOV_TIPORD) + "'"
         x_arti = "mov_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
         x_maga = "mov_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"
         x_cond = x_cord + " and " + x_nord + " and " + x_data + " and " + x_tipo + " and " + x_arti + " and " + x_maga
         Csql   = "select * from u_mag_cl where " + x_cond + " order by mov_codord,mov_numord,mov_datord,mov_tipord,mov_codart,mov_codmag"
         IF !ExecRW(Csql,"u_mag_cl","R")
 	        return(.f.)
         ENDIF
         SELECT U_MAG_CL
         GO TOP
         IF EOF()
         ELSE 
            REPLACE MOV_QTAGIA WITH MOV_QTAGIA + M.ORD_QTAORD
            IF MOV_FLGFAT
               IF MOV_NUMFAT = SPACE(06) .OR. EMPTY(MOV_NUMFAT)
                  REPLACE MOV_FLGFAT WITH .F.
               ENDIF
            ENDIF
         ENDIF
         IF !ExecRW("","u_mag_cl","W")
	        return(.f.)
         ENDIF
         SELECT CURS_BOL_DD
         SKIP +1
      ENDDO
   ENDIF         
   SELECT(XX)
ENDIF 

RETURN


*******************
PROCEDURE SCAR_LOC
*******************
* SCARICO IN AUTOMATICO DEL MAGAZZINO LOGISTICO

IF ALLTRIM(M.ORD_DESART) = "*** COMMENTO ***"   
   RETURN
ENDIF   

IF PUB_MLEBDT
   SCATTER MEMVAR MEMO 
   IF !ExecCommand("select * from u_loc_mo where 0=1","cu_loc_mo")
      return(.f.)
   ENDIF
   X_QTAORD = M.ORD_QTAORD
   X_QTAGIA = 0
   x_maga   = "loc_codmag = '" + ALLTRIM(M.ORD_MAGS) + "'"
   x_arti   = "loc_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_cond   = x_maga + " and " + x_arti
   Csql     = "select * from u_loc_gi where " + x_cond + " order by loc_codmag,loc_codart,loc_datcar"
   IF !ExecRW(Csql,"u_loc_gi","R")
      return(.f.)
   ENDIF
   SELECT u_loc_gi
   GO TOP
   IF EOF()
   ELSE
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         X_QTAGIA = X_QTAGIA + LOC_QTAGIA
         SCATTER MEMVAR
         IF X_QTAORD > X_QTAGIA
            REPLACE LOC_QTAGIA WITH 0
            SELECT CU_LOC_MO
            APPEND BLANK
            GATHER MEMVAR
            REPLACE LOC_CAUSAL WITH '200'
            REPLACE LOC_NUMBOL WITH M.ORD_NUMORD
            REPLACE LOC_DATBOL WITH M.ORD_DATORD
            REPLACE LOC_CODCLI WITH M.ORD_CODCLI
            REPLACE LOC_RAGSOC WITH M.ORD_RAGSOC
            REPLACE LOC_DATMOV WITH ribalta2(DTOC(DATE()))
            REPLACE AGGANCIO   WITH M.DAGGANCIO
         ELSE
            X_QTAMOV = LOC_QTAGIA - (X_QTAGIA - X_QTAORD)
            REPLACE LOC_QTAGIA WITH X_QTAGIA - X_QTAORD
            SELECT CU_LOC_MO
            APPEND BLANK
            GATHER MEMVAR
            REPLACE LOC_QTAGIA WITH X_QTAMOV
            REPLACE LOC_CAUSAL WITH '200'
            REPLACE LOC_NUMBOL WITH M.ORD_NUMORD
            REPLACE LOC_DATBOL WITH M.ORD_DATORD
            REPLACE LOC_CODCLI WITH M.ORD_CODCLI
            REPLACE LOC_RAGSOC WITH M.ORD_RAGSOC
            REPLACE LOC_DATMOV WITH ribalta2(DTOC(DATE()))
            REPLACE AGGANCIO   WITH M.DAGGANCIO
            EXIT
         ENDIF   
         SELECT U_LOC_GI
         SKIP +1
      ENDDO   
      SELECT U_LOC_GI
      DELETE FOR LOC_QTAGIA < 1 ALL
   ENDIF
   IF !ExecRW("","u_loc_gi","W")
      return(.f.)
   ENDIF
   SELECT CU_LOC_MO
   GO TOP
   IF EOF()
   ELSE
      IF !ExecRW('','u_loc_mo','I','','CU_LOC_MO')
         return(.f.)
      ENDIF
   ENDIF
ENDIF 

RETURN


*******************
PROCEDURE SCAR_DIR
*******************

* SCARICO IN AUTOMATICO DEL MAGAZZINO DIREZIONALE

IF ALLTRIM(M.ORD_DESART) = "*** COMMENTO ***"   
   RETURN
ENDIF   

IF PUB_CLIDIR
   XX     = SELECT()
   x_cord = "mov_codord = '" + ALLTRIM(M.MOV_CODORD) + "'"
   x_nord = "mov_numord = '" + ALLTRIM(M.MOV_NUMORD) + "'"
   x_data = "mov_datord = '" + ALLTRIM(M.MOV_DATORD) + "'"
   x_tipo = "mov_tipord = '" + ALLTRIM(M.MOV_TIPORD) + "'"
   x_arti = "mov_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_maga = "mov_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"
   x_cond = x_cord + " and " + x_nord + " and " + x_data + " and " + x_tipo + " and " + x_arti + " and " + x_maga
   Csql   = "select * from u_mag_cl where " + x_cond + " order by mov_codord,mov_numord,mov_datord,mov_tipord,mov_codart,mov_codmag"
   IF !ExecRW(Csql,"u_mag_cl","R")
 	  return(.f.)
   ENDIF
   SELECT U_MAG_CL
   GO TOP
   IF EOF()
   ELSE 
      IF MOV_QTAGIA < M.ORD_QTAORD
         REPLACE MOV_QTAGIA WITH 0
      ELSE
         REPLACE MOV_QTAGIA WITH MOV_QTAGIA - M.ORD_QTAORD
      ENDIF
      IF MOV_QTAGIA > 0
      ELSE
         REPLACE MOV_FLGFAT WITH .T.
      ENDIF
   ENDIF
   IF !ExecRW("","u_mag_cl","W")
      return(.f.)
   ENDIF
   SELECT(XX)
ENDIF 

RETURN


******************************
FUNCTION DETDUPLE            && CERCA SE CI SONO RECORDS DOPPI NEL CURSORE DETTAGLI (ARTICOLO+DATA CONSEGNA)
******************************
PARA _DBARC,_CDART,_DTCON,_FLACC

IF SUBSTR(_DBARC,1,1) = 'C'
ELSE
   IF SUBSTR(_DTCON,3,1) = '/'
      _DTCON = RIBALTA2(_DTCON)
   ENDIF
ENDIF

SS=STR(SELECT())

V_PRIMA = .T.

DO WHILE .T.

   SELECT * FROM &_DBARC                  ;
            WHERE ORD_CODART = _CDART AND ;
                  ORD_DATCON = _DTCON     ;
            INTO CURSOR PIPPO

   V_CTR = 0

   SELECT PIPPO

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      V_CTR = V_CTR + 1

      SKIP +1

   ENDDO

   IF _FLACC
   ELSE
      EXIT
   ENDIF

   IF V_CTR > 0
   ELSE
      EXIT
   ENDIF

   IF V_PRIMA
      *=MESSAGEBOX('Stesso articolo e data consegna'+CHR(13)+ ;
      *            'Aggiungo 1 gg alla data consegna',16,'*** ATTENZIONE ***')
      V_PRIMA = .F.
   ENDIF

   V_GGCON = VAL(SUBSTR(_DTCON,1,2))
   V_MMCON = VAL(SUBSTR(_DTCON,4,2))
   V_AACON = VAL(SUBSTR(_DTCON,7,4))

   IF V_MMCON = 11 .OR. V_MMCON = 4 .OR. V_MMCON = 6 .OR. V_MMCON = 9
      IF V_GGCON = 30
         V_GGCON = 1
         V_MMCON = V_MMCON + 1
      ELSE
         V_GGCON = V_GGCON +1
      ENDIF
   ENDIF

   IF V_MMCON = 2
      IF V_GGCON = 28
         V_GGCON = 1
         V_MMCON = V_MMCON + 1
      ELSE
         V_GGCON = V_GGCON +1
      ENDIF
   ENDIF

   IF V_MMCON = 1 .OR. V_MMCON = 3 .OR. V_MMCON = 5 .OR. ;
      V_MMCON = 7 .OR. V_MMCON = 8 .OR. V_MMCON = 10
      IF V_GGCON = 31
         V_GGCON = 1
         V_MMCON = V_MMCON + 1
      ELSE
         V_GGCON = V_GGCON +1
      ENDIF
   ENDIF

   IF V_MMCON = 12
      IF V_GGCON = 31
         V_GGCON = 1
         V_MMCON = 1
         V_AACON = V_AACON + 1
      ELSE
         V_GGCON = V_GGCON +1
      ENDIF
   ENDIF

   V_GGCONS = STR(V_GGCON,2,0)
   IF SUBSTR(V_GGCONS,1,1) = ' '
      V_GGCONS = '0' + SUBSTR(V_GGCONS,2,1)
   ENDIF

   V_MMCONS = STR(V_MMCON,2,0)
   IF SUBSTR(V_MMCONS,1,1) = ' '
      V_MMCONS = '0' + SUBSTR(V_MMCONS,2,1)
   ENDIF

   V_AACONS = STR(V_AACON,4,0)

   _DTCON = V_GGCONS + '/' + V_MMCONS + '/' + V_AACONS

ENDDO	

OUT = _DTCON

SELECT &SS

RETURN(OUT)


**************************************************************************
PROCEDURE ORDCAIMP  && CARICA IMPEGNATO
**************************************************************************

SELECT CU_ORD_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO	 	

   * PRELEVA PREZZO DI COSTO DA ANAGRAFICA ARTICOLI
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"cur_articoli")
      return(.f.)
   ENDIF
   SELECT cur_articoli
   GO TOP
   IF EOF()
      V_PRZCO = 0
      V_UMX   = SPACE(02)
   ELSE
      V_PRZCO = ART_PRZCOS
      V_UMX   = ART_UNIMIS
   ENDIF

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'ORDCAIMP'
   H_GENMOV = "" 
   H_TIPO   = ""
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '100'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = ""
   H_DATDOC = RIBALTA2(DTOC(DATE()))
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR =  M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = 0
   H_CODIVA = ""
   H_SCONTO = 0
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = ""
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'C'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "ORD"
      ENDIF
      SELECT(SSSS)
   ENDIF

   SELECT CU_ORD_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
  PROCEDURE ORDSCIMP  && SCARICA IMPEGNATO
**************************************************************************

v_seek	 = ORD_RECNO
v_chiave = "daggancio"
IF seek_std('u_ord_dd',v_seek,v_chiave,'CUR_DETTAGLI')
ELSE
   WAIT WINDOW "Non trovato uncino in riscarico impegnato magazzino : ORDSCIMP "+ORD_RECNO
   RETURN
ENDIF

SELECT CUR_DETTAGLI
GO TOP

IF EOF()
   WAIT WINDOW "Non trovato uncino in riscarico impegnato magazzino : ORDSCIMP " + ORD_RECNO
   RETURN
ENDIF

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO	 	

   * PRELEVA PREZZO DI COSTO DA ANAGRAFICA ARTICOLI
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"cur_articoli")
      return(.f.)
   ENDIF
   SELECT cur_articoli
   GO TOP
   IF EOF()
      V_PRZCO = 0
      V_UMX   = SPACE(02)
   ELSE
      V_PRZCO = ART_PRZCOS
      V_UMX   = ART_UNIMIS
   ENDIF

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
   H_DADOVE = 'ORDSCIMP'
   H_GENMOV = "" 
   H_TIPO   = ""
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '200'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = ""
   H_DATDOC = RIBALTA2(DTOC(DATE()))
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR =  M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = 0
   H_CODIVA = ""
   H_SCONTO = 0
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = ""
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'S'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "ORD"
      ENDIF
      SELECT(SSSS)
   ENDIF

   SELECT CUR_DETTAGLI
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE SPERIMAG  && RICARICA IL MAGAZZINO
**************************************************************************

v_seek	 = SPE_RECNO
v_chiave = "daggancio"
IF seek_std('u_spe_dd',v_seek,v_chiave,'CUR_DETTAGLI')
ELSE
   WAIT WINDOW "Non trovato uncino in ricarico magazzino : SPERIMAG "+SPE_RECNO
   RETURN
ENDIF

SELECT CUR_DETTAGLI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   H_DADOVE = 'SPERIMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '100'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CUR_DETTAGLI
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE BFOSCMAG  && RISCARICA IL MAGAZZINO (AGGIORNAMENTO)
**************************************************************************

V_CAUCON = SPACE(03)
v_seek	 = "TOP"+M.ORD_CAUS
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CAUCON = SUBSTR(LIBERA,35,3)
ENDIF
IF V_CAUCON = SPACE(03) .OR. EMPTY(V_CAUCON)
   V_CAUCON = '200'
ENDIF

v_seek	 = BOL_RECNO
v_chiave = "daggancio"
IF seek_std('u_bfo_dd',v_seek,v_chiave,'CUR_DETTAGLI')
ELSE
   WAIT WINDOW "Non trovato uncino in ricarico magazzino : BFOSCMAG "+BOL_RECNO
   RETURN
ENDIF

SELECT CUR_DETTAGLI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   RELEASE WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON
   PUBLIC  WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON
   WWW_LEGAME = M.ORD_LEGAME
   WWW_CODSYS = M.ORD_CODSYS
   WWW_CODART = M.ORD_CODART
   WWW_CODMAG = M.ORD_MAGA
   WWW_DATCON = M.ORD_DATCON

   H_DADOVE = 'BFOSCMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = V_CAUCON
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   IF ZZZ_FLGTIP = 0
   ELSE
      H_CLIFOR = M.ORD_CODFOR
      IF EMPTY(H_CLIFOR) .OR. H_CLIFOR = SPACE(10)
         H_CLIFOR = M.ORD_CODCLI
      ENDIF
   ENDIF
   H_PRZACQ = M.ORD_PRZNET
   H_PRZVEN = 0
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   IF ZZZ_FLGTIP = 0
      RELEASE V_TTDD
      PUBLIC  V_TTDD
      V_TTDD = .F.
      x_agga = "daggancio = '" + M.ORD_LEGAME + "'"
      x_csys = "ord_codsys = '" + M.ORD_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_DD","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_DD
      GO TOP
      IF EOF()
      ELSE
         V_TTDD = .T.
         REPLACE ORD_QTAEV WITH ORD_QTAEV - M.ORD_QTAORD
         x_agga = "taggancio = '" + WWW_LEGAME + "'"
         x_cond = x_agga 
         cSql   = "SELECT * FROM U_ORF_TT WHERE " + x_cond
         IF !ExecRW(cSql,"U_ORF_TT","R")
            return(.f.)
         ENDIF 
         SELECT U_ORF_TT
         GO TOP
         IF EOF()
         ELSE
            REPLACE ORD_CHIUSO WITH .F.
         ENDIF
         IF !ExecRW(cSql,"U_ORF_TT","W")
            return(.f.)
         ENDIF 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_DD","W")
         return(.f.)
      ENDIF 
      IF V_TTDD
      ELSE
         x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
         x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
         x_cond = x_agga + " and " + x_csys
         cSql   = "SELECT * FROM U_ORF_PO WHERE " + x_cond
         IF !ExecRW(cSql,"U_ORF_PO","R")
            return(.f.)
         ENDIF 
         SELECT U_ORF_PO
         GO TOP
         IF EOF()
            V_DDT = .F.
         ELSE
            REPLACE ORF_QTAEV WITH ORF_QTAEV - M.ORD_QTAORD
            IF ORF_QTADOR > ORF_QTAEV
               REPLACE ORF_CHIUSO WITH .F.
            ELSE
               REPLACE ORF_CHIUSO WITH .T.
            ENDIF
            V_DDT = .T.
            WWW_NUMPRO = ORF_NUMPRO
            WWW_NUMORD = ORF_NUMORD
            WWW_NUMDDT = M.ORD_NUMORD
         ENDIF
         IF !ExecRW(cSql,"U_ORF_PO","W")
            return(.f.)
         ENDIF 
         IF V_DDT
            x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
            x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
            x_npro = "orf_numpro = '" + WWW_NUMPRO + "'"
            x_nord = "orf_numord = '" + WWW_NUMORD + "'"
            x_nddt = "orf_numddt = '" + WWW_NUMDDT + "'"
            x_cond = x_agga + " and " + x_csys + " and " + x_npro + " and " + x_nord + " and " + x_nddt
            cSql   = "SELECT * FROM U_ORF_DT WHERE " + x_cond
            IF !ExecRW(cSql,"U_ORF_DT","R")
               return(.f.)
            ENDIF 
            SELECT U_ORF_DT
            GO TOP
            DO WHILE .T.
               IF EOF()
                  EXIT
               ENDIF
               DELETE
               SKIP +1
            ENDDO
            *IF EOF()
            *ELSE
            *   REPLACE ORF_TIPAGG WITH 'A'
            *   REPLACE ORF_FLGTRA WITH .F.
            *   REPLACE ORF_FLGCON WITH M.ORD_FLGCON
            *ENDIF
            IF !ExecRW(cSql,"U_ORF_DT","W")
               return(.f.)
            ENDIF 
         ENDIF
      ENDIF
   ENDIF

   IF ZZZ_FLGTIP = 1
      x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
      x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_CO WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_CO","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_CO
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE - M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_CO","W")
         return(.f.)
      ENDIF 
   ENDIF

   IF ZZZ_FLGTIP = 2
      x_uniq = "orf_unique = '" + ALLTRIM(WWW_CODSYS) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(WWW_LEGAME) + "'"
      x_cond = x_uniq + " and " + x_lega
      cSql   = "SELECT * FROM U_BOL_RE WHERE " + x_cond
      IF !ExecRW(cSql,"U_BOL_RE","R")
         return(.f.)
      ENDIF 
      SELECT U_BOL_RE
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE - M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_BOL_RE","W")
         return(.f.)
      ENDIF 
   ENDIF
   
   SELECT CUR_DETTAGLI
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE BFOCAMAG  && CARICA IL MAGAZZINO
**************************************************************************

SELECT CU_BFO_DD
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   RELEASE WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON
   PUBLIC  WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON
   WWW_LEGAME = M.ORD_LEGAME
   WWW_CODSYS = M.ORD_CODSYS
   WWW_CODART = M.ORD_CODART
   WWW_CODMAG = M.ORD_MAGA
   WWW_DATCON = M.ORD_DATCON
   
   H_DADOVE = 'BFOCAMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = M.ORD_CAUS
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   IF ZZZ_FLGTIP = 0
   ELSE
      H_CLIFOR = M.ORD_CODFOR
      IF EMPTY(H_CLIFOR) .OR. H_CLIFOR = SPACE(10)
         H_CLIFOR = M.ORD_CODCLI
      ENDIF
   ENDIF
   H_PRZACQ = M.ORD_PRZNET
   H_PRZVEN = 0
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   IF ZZZ_FLGTIP = 0
      RELEASE V_TTDD
      PUBLIC  V_TTDD
      V_TTDD = .F.
      x_agga = "daggancio = '" + M.ORD_LEGAME + "'"
      x_csys = "ord_codsys = '" + M.ORD_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_DD","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_DD
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORD_QTAEV WITH ORD_QTAEV + M.ORD_QTAORD
         V_TTDD = .T.
      ENDIF
      IF !ExecRW(cSql,"U_ORF_DD","W")
         return(.f.)
      ENDIF 
      x_agga = "daggancio = '" + WWW_LEGAME + "'"
      x_cond = x_agga
      cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
      IF !ExecCommand(cSql,"U_ORF_DD")
         return(.f.)
      ENDIF 
      V_TROV = .F.
      SELECT U_ORF_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ORD_QTAEV < ORD_QTAORD
            V_TROV = .T.
            EXIT
         ENDIF
         SKIP +1
      ENDDO
      x_agga = "taggancio = '" + WWW_LEGAME + "'"
      x_cond = x_agga 
      cSql   = "SELECT * FROM U_ORF_TT WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_TT","R")
         return(.f.) 
      ENDIF 
      SELECT U_ORF_TT
      GO TOP
      IF EOF()
      ELSE
         IF V_TROV
            REPLACE ORD_CHIUSO WITH .F.
         ELSE
            REPLACE ORD_CHIUSO WITH .T.
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_ORF_TT","W")
         return(.f.)
      ENDIF 
      IF V_TTDD
      ELSE
         x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
         x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
         x_cond = x_agga + " and " + x_csys
         cSql   = "SELECT * FROM U_ORF_PO WHERE " + x_cond
         IF !ExecRW(cSql,"U_ORF_PO","R")
            return(.f.)
         ENDIF 
         SELECT U_ORF_PO
         GO TOP
         IF EOF()
            V_DDT = .F.
         ELSE
            REPLACE ORF_QTAEV WITH ORF_QTAEV + M.ORD_QTAORD
            IF ORF_QTADOR > ORF_QTAEV
               REPLACE ORF_CHIUSO WITH .F.
            ELSE
               REPLACE ORF_CHIUSO WITH .T.
            ENDIF
            SCATTER MEMVAR MEMO 
            V_DDT = .T.
            WWW_NUMPRO = ORF_NUMPRO
            WWW_NUMORD = ORF_NUMORD
            WWW_NUMDDT = M.ORD_NUMORD
         ENDIF
         IF !ExecRW(cSql,"U_ORF_PO","W")
            return(.f.)
         ENDIF 
         IF V_DDT
            x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
            x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
            x_npro = "orf_numpro = '" + WWW_NUMPRO + "'"
            x_nord = "orf_numord = '" + WWW_NUMORD + "'"
            x_nddt = "orf_numddt = '" + WWW_NUMDDT + "'"
            x_cond = x_agga + " and " + x_csys + " and " + x_npro + " and " + x_nord + " and " + x_nddt
            cSql   = "SELECT * FROM U_ORF_DT WHERE " + x_cond
            IF !ExecRW(cSql,"U_ORF_DT","R")
               return(.f.)
            ENDIF 
            SELECT U_ORF_DT
            GO TOP
            IF EOF()
               APPEND BLANK
            ENDIF
            *GATHER MEMVAR
            M.ID_UNIQUE = " "
            DO U_ORF_DT
            REPLACE ORF_FLGTRA WITH .F.
            REPLACE SELEZIONE  WITH SPACE(10)
            REPLACE ORF_TIPAGG WITH SPACE(01)
            REPLACE ORF_CHIUSO WITH .F.
            REPLACE ORF_QTAEV  WITH 0
            REPLACE ORF_NUMDDT WITH M.ORD_NUMORD
            REPLACE ORF_DATDDT WITH M.ORD_DATORD
            REPLACE ORF_QTADDT WITH M.ORD_QTAORD
            REPLACE ORF_FLGCON WITH M.ORD_FLGCON
            IF !ExecRW(cSql,"U_ORF_DT","W")
               return(.f.)
            ENDIF 
         ENDIF
      ENDIF
   ENDIF

   IF ZZZ_FLGTIP = 1
      x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
      x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_CO WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_CO","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_CO
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE + M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_CO","W")
         return(.f.)
      ENDIF 
   ENDIF

   IF ZZZ_FLGTIP = 2
      x_uniq = "orf_unique = '" + ALLTRIM(WWW_CODSYS) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(WWW_LEGAME) + "'"
      x_cond = x_uniq + " and " + x_lega
      cSql   = "SELECT * FROM U_BOL_RE WHERE " + x_cond
      IF !ExecRW(cSql,"U_BOL_RE","R")
         return(.f.)
      ENDIF 
      SELECT U_BOL_RE
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE + M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_BOL_RE","W")
         return(.f.)
      ENDIF 
   ENDIF
   
   
   SELECT CU_BFO_DD
   SKIP +1

ENDDO

RETURN
*****************************************************************************
FUNCTION DMESE           && RESTITUISCE LA DESCRIZIONE DEL MESE
*****************************************************************************
PARA V1

SS=STR(SELECT())

IF VAL(V1) = 1
   V2="GENNAIO"
ENDIF
IF VAL(V1) = 2
   V2="FEBBRAIO"
ENDIF
IF VAL(V1) = 3
   V2="MARZO"
ENDIF
IF VAL(V1) = 4
   V2="APRILE"
ENDIF
IF VAL(V1) = 5
   V2="MAGGIO"
ENDIF
IF VAL(V1) = 6
   V2="GIUGNO"
ENDIF
IF VAL(V1) = 7
   V2="LUGLIO"
ENDIF
IF VAL(V1) = 8
   V2="AGOSTO"
ENDIF
IF VAL(V1) = 9
   V2="SETTEMBRE"
ENDIF
IF VAL(V1) = 10
   V2="OTTOBRE"
ENDIF
IF VAL(V1) = 11
   V2="NOVEMBRE"
ENDIF
IF VAL(V1) = 12
   V2="DICEMBRE"
ENDIF

SELECT &SS

RETURN(V2)


****************
FUNCTION NUMEFAT
****************
**--> USATA SUL REPORT MANCUNO NELLE REVERSALI

PARA VNUMFAT,VPROTO,VCODCLI

SS=STR(SELECT())

OUT=VNUMFAT

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_codi = "par_codcli = '" + ALLTRIM(VCODCLI) + "'"
cSql="SELECT * FROM PART_CLI WHERE " + x_soci + " and " + x_codi + " order by par_codsoc,par_codcli"
IF !ExecCommand(cSql,"cur_partcli")
   return(.f.)
ENDIF
SELECT CUR_PARTCLI
GO TOP
IF !EOF()
   DO WHILE !EOF()
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
      IF PAR_TIPODO<>"FAT"
         SKIP +1
         LOOP
      ENDIF
      IF PAR_NPROG=200
         SKIP +1
         LOOP
      ENDIF
      IF PAR_NPART<>VPROTO
         SKIP +1
         LOOP
      ENDIF
      IF PAR_NUMFAT<>VNUMFAT
         SKIP +1
         LOOP
      ENDIF
      IF VAL(PAR_NPROT)<>0
         OUT=PAR_NPROT
      ENDIF
      EXIT
   ENDDO
ELSE
   && COME ERA PRIMA CASO DELLA STAMPA DEI FORNITORI
   OUT=VNUMFAT
ENDIF

SELECT &SS
RETURN(OUT)

***************************************************************************
FUNCTION CVT
***************************************************************************
PARA V_STR
V_OUT=SUBSTR(V_STR,1,2)+'.'+SUBSTR(V_STR,3,2)+'.'+SUBSTR(V_STR,5)
IF LEN(ALLTRIM(V_STR))=4
   V_OUT=SUBSTR(V_OUT,1,5)
ENDIF
IF LEN(ALLTRIM(V_STR))=0
   V_OUT=""
ENDIF
V_OUT=PADR(V_OUT,15)
RETURN(V_OUT)


***************************************************************************
PROCEDURE CEIDELE  && CANCELLA LE CESSIONI INTRACOMUNITARIE SU VENDITE
**************************************************************************

V_CONT = 0

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql   = "select * from u_cei_tt where " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecRW(Csql,"U_CEI_TT","R")
   return(.f.)
ENDIF
SELECT U_CEI_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD > PERAL
      EXIT
   ENDIF

   TAGGA  = TAGGANCIO
   V_CONT = V_CONT+1   

   WAIT WINDOW "Cessione : "+ORD_NUMORD+" Cancellata" TIMEOUT(1)
  
   _DELETE = TAGGA 
   CSQL    = "DELETE FROM U_CEI_DD WHERE DAGGANCIO = ?_DELETE"
   IF !ExecCommand(CSQL,"U_CEI_DD")
      RETURN (.f.)
   ENDIF 
  
   SELECT U_CEI_TT
   DELETE  
   
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_CEI_TT","W")
   return(.f.)
ENDIF

RETURN


******************************
FUNCTION CEISTAT             && CALCOLA IL VALORE MEDIO STATISTICO INTRASTAT
******************************
PARA _TIPO

OUT = ""
OUT = _TIPO + (_TIPO *.15)

RETURN(OUT)


**************************************************************************
PROCEDURE CALCCEI  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************

SWS=SELECT()
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
MATPUBX     = 0

SELECT CU_CEI_DD
GO TOP
DO WHILE .T. 
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   SELECT CU_CEI_DD
   M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE
   SELECT CU_CEI_DD
   SKIP +1
ENDDO
M.ORD_VALORE = M.T_IMPONIB
SELECT(SWS)

RETURN


**************************************************************************
FUNCTION QUESTA           && TOTALE PAGINA CORRENTE
**************************************************************************
PARA V1

SWS     = SELECT()
_SONOLI = RECNO()

LOCATE FOR ALLTRIM(STR((V1),5,0)) = ALLTRIM(PGRIGA)

PPAG    = PROGPAG

SELECT(SWS)

GO _SONOLI 

RETURN(PPAG)


**************************************************************************
FUNCTION RIP_PAGI           && RIPORTO PAGINA PRECEDENTE
**************************************************************************
PARA V1

SWS     = SELECT()
_SONOLI = RECNO()

IF V1 = 1
   PPAG = 0
   SELECT(SWS)
   GO _SONOLI 
ELSE
   LOCATE FOR ALLTRIM(STR((V1-1),5,0)) = ALLTRIM(PGRIGA)
   PPAG=PROGTOT
   SELECT(SWS)
   GO _SONOLI 
ENDIF

RETURN(PPAG)


**************************************************************************
  PROCEDURE CALCRIA  && CALCOLA IL VALORE DEL DOCUMENTO CON R.A.
**************************************************************************

SWS=SELECT()

M.T_IMPONIX = 0
M.T_CONTRIB = 0
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
M.T_RITACC  = 0

v_seek	 = 'RIA'+M.ORD_CODRAC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   VRA  = VAL(SUBSTR(LIBERA,1,6))
   VRAI = VAL(SUBSTR(LIBERA,9,6))
ELSE
   VRA  = 0
   VRAI = 100
ENDIF

SELECT CU_RIA_DD
GO TOP

DO WHILE .NOT. EOF()

   IF DELETED()
      SELECT CU_RIA_DD
      SKIP +1
      LOOP
   ENDIF

   CIVA = ORD_IVA

   v_seek	= 'IVA'+CIVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      VIVA = VAL(SUBSTR(LIBERA,1,3))
   ELSE
      VIVA = 0
   ENDIF

   SELECT CU_RIA_DD

   M.T_IMPONIX = M.T_IMPONIX + ORD_VALORE
   M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE + (ORD_VALORE * (M.ORD_PERCCO / 100))
   M.T_IMPOSTA = M.T_IMPOSTA + ((ORD_VALORE + (ORD_VALORE * (M.ORD_PERCCO / 100))) * (VIVA/100))
   M.T_CONTRIB = M.T_CONTRIB + (ORD_VALORE * (M.ORD_PERCCO / 100))

   SELECT CU_RIA_DD
   SKIP +1

ENDDO

M.T_IMPOSTA= ROUND(M.T_IMPOSTA,2)
V_IMPNET   = ROUND((M.T_IMPONIX - (M.T_IMPONIX * (100 - VRAI)) / 100),2)
M.T_RITACC = ROUND(((V_IMPNET * VRA) /100),2)
M.T_IMPONIB= ROUND(M.T_IMPONIB,2)
M.T_CONTRIB= ROUND(M.T_CONTRIB,2)
M.T_VALORE = M.T_IMPONIB + M.T_IMPOSTA - M.T_RITACC
M.ORD_TOTIMP = M.T_IMPONIB
M.ORD_TOTIVA = M.T_IMPOSTA
M.ORD_TOTRAC = M.T_RITACC
M.ORD_TOTFAT = M.T_VALORE
M.ORD_TOTCON = M.T_CONTRIB

SELECT(SWS)

RETURN


**************************************************************************
  PROCEDURE CALCRAA  && CALCOLA IL VALORE DEL DOCUMENTO CON R.A.
**************************************************************************

SWS=SELECT()

M.T_CONTRIB = 0
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
M.T_RITACC  = 0
M.T_RITPRE  = 0
M.T_QUOPRE  = 0

v_seek	 = 'RIA'+M.ORD_CODRAC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   VRA  = VAL(SUBSTR(LIBERA,1,6))
   VRAI = VAL(SUBSTR(LIBERA,9,6))
ELSE
   VRA  = 0
   VRAI = 100
ENDIF

SELECT CU_RAA_DD
GO TOP

DO WHILE .NOT. EOF()

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE

   SKIP +1

ENDDO

V_IMPNET   = ROUND(((M.T_IMPONIB - (M.T_IMPONIB * (100 - VRAI)) / 100)),2)
M.T_RITACC = ROUND(((V_IMPNET * VRA) /100),2)
M.T_VALORE = ROUND((M.T_IMPONIB + M.T_IMPOSTA - M.T_RITACC),2)
M.T_RITPRN = ROUND(((M.T_IMPONIB * M.ORD_PERCPA) /100),2)
M.T_RITPRE = ROUND(((M.T_RITPRN * M.ORD_PERCCO) /100),2)
M.T_QUOPRE = ROUND(((M.T_RITPRE / 3) * 2),2)
M.T_VALORE = ROUND((M.T_IMPONIB - M.T_RITACC - M.T_RITPRE + M.T_QUOPRE),2)

M.ORD_TOTIMP = M.T_IMPONIB
M.ORD_TOTIVA = 0
M.ORD_TOTRAC = M.T_RITACC
M.ORD_TOTPRE = M.T_RITPRE
M.ORD_TOTQPR = M.T_QUOPRE
M.ORD_TOTFAT = M.T_VALORE

SELECT(SWS)

RETURN


***************************************************************************
PROCEDURE CEIFDELE  && CANCELLA LE CESSIONI INTRACOMUNITARIE SU ACQUISTI
**************************************************************************

V_CONT = 0

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql   = "select * from u_cea_tt where " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecRW(Csql,"U_CEA_TT","R")
   return(.f.)
ENDIF
SELECT U_CEA_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD > PERAL
      EXIT
   ENDIF

   TAGGA  = TAGGANCIO
   V_CONT = V_CONT+1   

   WAIT WINDOW "Cessione su acquisto : "+ORD_NUMORD+" Cancellata" TIMEOUT(1)
  
   _DELETE = TAGGA 
   CSQL    = "DELETE FROM U_CEA_DD WHERE DAGGANCIO = ?_DELETE"
   IF !ExecCommand(CSQL,"U_CEA_DD")
      RETURN (.f.)
   ENDIF 
  
   SELECT U_CEA_TT
   DELETE  
   
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_CEA_TT","W")
   return(.f.)
ENDIF

RETURN


******************************
FUNCTION CEASTAT             && CALCOLA IL VALORE MEDIO STATISTICO INTRASTAT
******************************
PARA _TIPO

OUT = ""
OUT = _TIPO + (_TIPO *.15)

RETURN(OUT)


**************************************************************************
PROCEDURE CALCCEA  && CALCOLA IL VALORE DEL DOCUMENTO
**************************************************************************

SWS=SELECT()
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
M.T_VALORE  = 0
MATPUBX     = 0

SELECT CU_CEA_DD
GO TOP
DO WHILE .T. 
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   SELECT CU_CEA_DD
   M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE
   SELECT CU_CEA_DD
   SKIP +1
ENDDO
M.ORD_VALORE = M.T_IMPONIB
SELECT(SWS)

RETURN


**************************************************************************
PROCEDURE FAMSCMAG  && CARICA IL MAGAZZINO
**************************************************************************

SELECT CU_FAM_DD
GO TOP

DO WHILE .T. 
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD

   SCATTER MEMVAR MEMO	 	

   H_DADOVE = 'FAMSCMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '100'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CU_FAM_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
  PROCEDURE FAMRIMAG  && RISCARICA IL MAGAZZINO
**************************************************************************

v_seek	 = FAT_RECNO
v_chiave = "daggancio"
IF seek_std('u_fam_dd',v_seek,v_chiave,'CUR_DETTAGLI')
   SELECT CUR_DETTAGLI
ELSE
   WAIT WINDOW "Non trovato uncino in ricarico magazzino : FAMRIMAG "+FAT_RECNO
   RETURN
ENDIF

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   H_DADOVE = 'FAMRIMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '200'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   IF !EMPTY(PUB_CFDEF)
      H_CLIFOR = PUB_CFDEF
   ELSE
	  H_CLIFOR = M.ORD_CODCLI
   ENDIF
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT U_FAM_DD
   SKIP +1

ENDDO

RETURN

******************************
FUNCTION _DATOKO
******************************
* CONTROLLO DEL CONTENUTO DI UN CAMPO CONSIDERANDO SOLO I CARATTERI NUMERICI/SPECIALI/ALFABETICI
* __DATO = CAMPO DA CONTROLLARE

PARA __DATO

__RISPO = .F.		&& DATO OK

LEN__DATO = LEN(ALLTRIM(__DATO))

FOR K=1 TO LEN__DATO

   IF ASC(SUBSTR(__DATO,K,1)) => 33 .AND. ASC(SUBSTR(__DATO,K,1)) <= 125
      LOOP   && CARATTERE CORRETTO
   ENDIF

   __RISPO = .T.	&& DATO KO

NEXT

RETURN(__RISPO)

******************************************************************
PROCEDURE ADDLOG
******************************************************************
PARA V_MSG

V_SS=SELECT()

cSql = "select * from log_user"
IF !ExecRW(cSql,"LOG_USER","R")
   RETURN .F.
ENDIF

SELECT LOG_USER   
APPEND BLANK
REPLACE OPERATORE  WITH PUB_CODOPE
REPLACE DESCRI     WITH PUB_nomope
REPLACE DATA       WITH RIBALTA2(DTOC(DATE()))
REPLACE ORA        WITH TIME()
REPLACE OPERAZIONE WITH V_MSG 

IF !ExecRW(cSql,"LOG_USER","W")
   RETURN .F.
ENDIF

SELECT(V_SS)
RETURN



********************** 
 FUNCTION DESGRU
********************** 
PARA V1

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_grup = "dit_gruppo = '" + V1 + "'"
x_cond = x_soci + " and " + x_grup
cSql = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"CUR_DIS_TT")
   RETURN .F.
ENDIF
SELECT CUR_DIS_TT
IF !EOF()
   V2       = SUBSTR(DIT_DESCRI,1,25)
   V_PREZZO = DIT_PREZZO
   V_COSTO  = DIT_COSTO
ELSE  
   V2       = SPACE(25)
   V_PREZZO = 0
   V_COSTO  = 0
ENDIF
RETURN(V2)


**********************
FUNCTION CERCADB
**********************
**--> RICERCA IN DISTINTA BASE SE ESISTE
PARA ARTI

SAVES=STR(SELECT())

OUT = .F.

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_grup = "dit_gruppo = '" + ARTI + "'"
x_cond = x_soci + " and " + x_grup
cSql = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"CUR_DIS_TT")
   RETURN .F.
ENDIF
SELECT CUR_DIS_TT
IF !EOF()
   OUT = .T.
ENDIF

SELECT &SAVES

RETURN(OUT)




************************
FUNCTION PRODISBA
************************
**--> ESPLOSIONE DI.BA. PER GESTIONE QTA SUI COMPONENTI.
**--> _PRG => PRO000   = gestione commessa di produzione
**            PROCANC  = CANCELLAZIONE VECCHIA COMMESSA DI PRODUZIONE
**            PROLANC1 = LANCIO COMMESSA IN PRODUZIONE
**            PROVERS1 = VERSAMENTO COMMESSA DI PRODUZIONE A MAGAZZINO
**            PRORILAN = RILANCIO COMMESSE IN PRODUZIONE
**            PROMAGAN = RICALCOLO QTA SU U_MAG_AN
**--> _ART => CODICE ARTICOLO DA ESPLODERE
**--> _MAG => CODICE MAGAZZINO 
**--> _QTA => QUANTITA' DA GESTIRE
**--> _SAC => S = SALDO
**            C = CONTO
**            R = ROTTO
**            W = ALTRO

PARA _PRG,_ART,_MAG,_QTA,_SAC

SS1=STR(SELECT())

RELEASE XXX_SCARICO,V_SKIPPA,VQTAORD,VQTAMOV2,VQTAMOV3,VQTAMOV4,VQTAMOV5,VQTAMOV6,VQTAMOV7,V_QTAGIA
PUBLIC  XXX_SCARICO,V_SKIPPA,VQTAORD,VQTAMOV2,VQTAMOV3,VQTAMOV4,VQTAMOV5,VQTAMOV6,VQTAMOV7,V_QTAGIA
XXX_SCARICO = 0
V_SKIPPA    = .F.
VQTAORD     = 0
VQTAMOV2    = 0
VQTAMOV3    = 0
VQTAMOV4    = 0
VQTAMOV5    = 0
VQTAMOV6    = 0
VQTAMOV7    = 0
V_QTAGIA    = 0

IF _PRG = "PROLANC1" .OR. _PRG = "PRO000" .OR. _PRG = "PRORILAN" .OR. _PRG = "PROMAGAN"
   DO ALBE_QTA WITH .F.,_ART,_QTA
   SELECT WEXPLODE
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF WLIV = 1 
         SKIP +1
         LOOP
      ENDIF
      W_MAGA   = _MAG
      W_CODART = WCOD
      W_DESART = WDES
      W_QTAALL = WQTALL
      W_UM     = WUM
      SCATTER MEMVAR 
      IF M.WLIV = 1
         VQTAORD  = _QTA * M.WQTA  
      ENDIF   
      IF M.WLIV = 2
         VQTAORD  = _QTA * M.WQTA 
         VQTAMOV2 = VQTAORD
      ENDIF   
      IF M.WLIV = 3
         VQTAORD  = VQTAMOV2 * M.WQTA 
         VQTAMOV3 = VQTAORD
      ENDIF   
      IF M.WLIV = 4
         VQTAORD  = VQTAMOV3 * M.WQTA 
         VQTAMOV4 = VQTAORD
      ENDIF   
      IF M.WLIV = 5
         VQTAORD  = VQTAMOV4 * M.WQTA 
         VQTAMOV5 = VQTAORD
      ENDIF   
      IF M.WLIV = 6
         VQTAORD  = VQTAMOV5 * M.WQTA 
         VQTAMOV6 = VQTAORD
      ENDIF   
      IF M.WLIV = 7
         VQTAORD  = VQTAMOV6 * M.WQTA 
         VQTAMOV7 = VQTAORD
      ENDIF   
      IF M.WLIV = 8
         VQTAORD  = VQTAMOV7 * M.WQTA 
      ENDIF   

      **==> CONVERTO IL PESI IN MM ()
      VQTAORD = CONV_PESO(VQTAORD,W_CODART,W_UM)
     
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(W_MAGA) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(M.WCOD) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"U_MAG_AN")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF RECCOUNT() <> 0
         V_QTAGIA = MAG_GIACEN
      ELSE
         V_QTAGIA = 0
      ENDIF
      V_SKIPPA = .F.
      IF M.WTIP = 'G'
         IF VQTAORD > V_QTAGIA
            XXX_SCARICO = V_QTAGIA
         ELSE
            XXX_SCARICO = VQTAORD
            V_SKIPPA = .T.
         ENDIF
         IF XXX_SCARICO > 0
            IF M.WLIV = 2
               VQTAMOV2 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 3
               VQTAMOV3 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 4
               VQTAMOV4 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 5
               VQTAMOV5 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 6
               VQTAMOV6 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 7
               VQTAMOV7 = VQTAORD - XXX_SCARICO
            ENDIF
         ENDIF   
      ELSE
         XXX_SCARICO = VQTAORD
      ENDIF
      IF XXX_SCARICO = 0
      ELSE
         **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
         H_DADOVE = 'PRODISBA'
         H_GENMOV = "" 
         H_TIPO   = ""
         H_IMPE   = ""
         H_MAGSCA = W_MAGA
         H_MAGCAR = ""
         H_CODART = W_CODART
         H_TOPSCA = '100'
         H_TOPCAR = ""
         H_QUANTI = XXX_SCARICO
         H_NUMDOC = ""
         H_DATDOC = RIBALTA2(DTOC(DATE()))
         H_DATREG = RIBALTA2(DTOC(DATE()))
         H_ORAMOV = TIME()
         H_CLIFOR = ""
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = ""
         H_NOTE   = ""
         H_CSC    = ""
         H_SAC    = ""
         H_GGG    = ""
         H_FORNIT = ""
         H_FLGTRA = .F.
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
      ENDIF
      IF V_SKIPPA
         V_SKIPPA = .F.
         SELECT WEXPLODE
         SKIP +1
         IF EOF()
            EXIT
         ENDIF
         DO WHILE .T.
            IF EOF()
               SKIP -1
               EXIT
            ENDIF
            IF WLIV > M.WLIV
            ELSE
               SKIP -1
               EXIT
            ENDIF
            SELECT WEXPLODE
            SKIP +1
         ENDDO
      ENDIF            
      SELECT WEXPLODE
      SKIP +1 
   ENDDO
ENDIF      


IF _PRG = "PROCANC"
   DO ALBE_QTA WITH .F.,_ART,_QTA
   SELECT WEXPLODE
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF WLIV = 1 
         SKIP +1
         LOOP
      ENDIF
      W_MAGA   = _MAG
      W_CODART = WCOD
      W_DESART = WDES
      W_QTAALL = WQTALL
      W_UM     = WUM
      SCATTER MEMVAR 
      IF M.WLIV = 1
         VQTAORD  = _QTA * M.WQTA  
      ENDIF   
      IF M.WLIV = 2
         VQTAORD  = _QTA * M.WQTA 
         VQTAMOV2 = VQTAORD
      ENDIF   
      IF M.WLIV = 3
         VQTAORD  = VQTAMOV2 * M.WQTA 
         VQTAMOV3 = VQTAORD
      ENDIF   
      IF M.WLIV = 4
         VQTAORD  = VQTAMOV3 * M.WQTA 
         VQTAMOV4 = VQTAORD
      ENDIF   
      IF M.WLIV = 5
         VQTAORD  = VQTAMOV4 * M.WQTA 
         VQTAMOV5 = VQTAORD
      ENDIF   
      IF M.WLIV = 6
         VQTAORD  = VQTAMOV5 * M.WQTA 
         VQTAMOV6 = VQTAORD
      ENDIF   
      IF M.WLIV = 7
         VQTAORD  = VQTAMOV6 * M.WQTA 
         VQTAMOV7 = VQTAORD
      ENDIF   
      IF M.WLIV = 8
         VQTAORD  = VQTAMOV7 * M.WQTA 
      ENDIF   

      **==> CONVERTO IL PESI IN MM ()
      VQTAORD = CONV_PESO(VQTAORD,W_CODART,W_UM)

      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(W_MAGA) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(M.WCOD) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"U_MAG_AN")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF RECCOUNT() <> 0
         V_QTAGIA = MAG_GIACEN
      ELSE
         V_QTAGIA = 0
      ENDIF
      V_SKIPPA = .F.
      IF M.WTIP = 'G'
         IF VQTAORD > V_QTAGIA
            XXX_SCARICO = V_QTAGIA
         ELSE
            XXX_SCARICO = VQTAORD
            V_SKIPPA = .T.
         ENDIF
         IF XXX_SCARICO > 0
            IF M.WLIV = 2
               VQTAMOV2 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 3
               VQTAMOV3 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 4
               VQTAMOV4 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 5
               VQTAMOV5 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 6
               VQTAMOV6 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 7
               VQTAMOV7 = VQTAORD - XXX_SCARICO
            ENDIF
         ENDIF   
      ELSE
         XXX_SCARICO = VQTAORD
      ENDIF
      IF XXX_SCARICO = 0
      ELSE
         **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
         H_DADOVE = 'PRODISBA'
         H_GENMOV = "" 
         H_TIPO   = ""
         H_IMPE   = ""
         H_MAGSCA = W_MAGA
         H_MAGCAR = ""
         H_CODART = W_CODART
         H_TOPSCA = '200'
         H_TOPCAR = ""
         H_QUANTI = XXX_SCARICO
         H_NUMDOC = ""
         H_DATDOC = RIBALTA2(DTOC(DATE()))
         H_DATREG = RIBALTA2(DTOC(DATE()))
         H_ORAMOV = TIME()
         H_CLIFOR = ""
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = ""
         H_NOTE   = ""
         H_CSC    = ""
         H_SAC    = ""
         H_GGG    = ""
         H_FORNIT = ""
         H_FLGTRA = .F.
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
      ENDIF
      IF V_SKIPPA
         V_SKIPPA = .F.
         SELECT WEXPLODE
         SKIP +1
         IF EOF()
            EXIT
         ENDIF
         DO WHILE .T.
            IF EOF()
               SKIP -1
               EXIT
            ENDIF
            IF WLIV > M.WLIV
            ELSE
               SKIP -1
               EXIT
            ENDIF
            SELECT WEXPLODE
            SKIP +1
         ENDDO
      ENDIF            
      SELECT WEXPLODE
      SKIP +1 
   ENDDO
ENDIF      

IF _PRG = "PROVERS1"
   DO ALBE_QTA WITH .F.,_ART,_QTA
   SELECT WEXPLODE
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF WLIV = 1 
         SKIP +1
         LOOP
      ENDIF
      W_MAGA   = _MAG
      W_CODART = WCOD
      W_DESART = WDES
      W_QTAALL = WQTALL
      W_UM     = WUM
      SCATTER MEMVAR 
      IF M.WLIV = 1
         VQTAORD  = _QTA * M.WQTA  
      ENDIF   
      IF M.WLIV = 2
         VQTAORD  = _QTA * M.WQTA 
         VQTAMOV2 = VQTAORD
      ENDIF   
      IF M.WLIV = 3
         VQTAORD  = VQTAMOV2 * M.WQTA 
         VQTAMOV3 = VQTAORD
      ENDIF   
      IF M.WLIV = 4
         VQTAORD  = VQTAMOV3 * M.WQTA 
         VQTAMOV4 = VQTAORD
      ENDIF   
      IF M.WLIV = 5
         VQTAORD  = VQTAMOV4 * M.WQTA 
         VQTAMOV5 = VQTAORD
      ENDIF   
      IF M.WLIV = 6
         VQTAORD  = VQTAMOV5 * M.WQTA 
         VQTAMOV6 = VQTAORD
      ENDIF   
      IF M.WLIV = 7
         VQTAORD  = VQTAMOV6 * M.WQTA 
         VQTAMOV7 = VQTAORD
      ENDIF   
      IF M.WLIV = 8
         VQTAORD  = VQTAMOV7 * M.WQTA 
      ENDIF   

      **==> CONVERTO IL PESI IN MM ()
      VQTAORD = CONV_PESO(VQTAORD,W_CODART,W_UM)

      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(W_MAGA) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(M.WCOD) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"U_MAG_AN")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF RECCOUNT() <> 0
         V_QTAGIA = MAG_GIACEN
      ELSE
         V_QTAGIA = 0
      ENDIF
      V_SKIPPA = .F.
      IF M.WTIP = 'G'
         IF VQTAORD > V_QTAGIA
            XXX_SCARICO = V_QTAGIA
         ELSE
            XXX_SCARICO = VQTAORD
            V_SKIPPA = .T.
         ENDIF
         IF XXX_SCARICO > 0
            IF M.WLIV = 2
               VQTAMOV2 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 3
               VQTAMOV3 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 4
               VQTAMOV4 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 5
               VQTAMOV5 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 6
               VQTAMOV6 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 7
               VQTAMOV7 = VQTAORD - XXX_SCARICO
            ENDIF
         ENDIF   
      ELSE
         XXX_SCARICO = VQTAORD
      ENDIF
      IF XXX_SCARICO = 0
      ELSE
         H_DADOVE = 'PRODISBA'
         H_GENMOV = 'SI' 
         H_TIPO   = 'GIA'
         H_IMPE   = ""
         H_MAGSCA = W_MAGA
         H_MAGCAR = ""
         H_CODART = W_CODART
         H_TOPSCA = 'SCP'
         H_TOPCAR = ""
         H_QUANTI = XXX_SCARICO
         H_NUMDOC = Z_NUMCOM
         H_DATDOC = Z_DATCOM
         H_DATREG = RIBALTA2(DTOC(DATE()))
         H_ORAMOV = TIME()
         H_CLIFOR = Z_CODCLI
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = ""
         H_NOTE   = ""
         H_CSC    = ""
         H_SAC    = _SAC
         H_GGG    = "SI"
         H_FORNIT = ""
         H_FLGTRA = .F.
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)
      ENDIF
      IF V_SKIPPA
         V_SKIPPA = .F.
         SELECT WEXPLODE
         SKIP +1
         IF EOF()
            EXIT
         ENDIF
         DO WHILE .T.
            IF EOF()
               SKIP -1
               EXIT
            ENDIF
            IF WLIV > M.WLIV
            ELSE
               SKIP -1
               EXIT
            ENDIF
            SELECT WEXPLODE
            SKIP +1
         ENDDO
      ENDIF            
      SELECT WEXPLODE
      SKIP +1 
   ENDDO
ENDIF      

OUT = .T.

SELECT &SS1

RETURN(OUT)


***************************************************************************
PROCEDURE ALBE_QTA
***************************************************************************

PARA SI_VIDEO,XXGRUPPO,XXQTA,LIV_ESPL

PUBLIC LIV_ESPLN
LIV_ESPLN = 0

PUBLIC XX_QTA1,XX_QTA2,XX_QTA3,XX_QTA4,XX_QTA5,XX_QTA6,XX_QTA7
XX_QTA1 = 0
XX_QTA2 = 0
XX_QTA3 = 0
XX_QTA4 = 0
XX_QTA5 = 0
XX_QTA6 = 0
XX_QTA7 = 0

IF LIV_ESPL = .F.
   v_seek	= 'NUM'+'LDB'+'LIV'
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      LIV_ESPLN = VAL(SUBSTR(LIBERA,1,2))
      IF LIV_ESPLN > 98
         LIV_ESPLN = 98
      ENDIF         
   ELSE
      LIV_ESPLN = 98
   ENDIF
ELSE
   LIV_ESPLN = 98
ENDIF
IF LIV_ESPLN < 1
   LIV_ESPLN = 98
ENDIF         
LIV_ESPLN = LIV_ESPLN + 1

CREATE CURSOR WEXPLODE (WCOD C(16), WDES C(40), WCOS N(17,6), WPRZ N(17,6), ;
                        WTIP C(1),  WLIV N(4) , WQTA N(11,2), TREE C(100),  ;
                        WEXP C(1),  WQTALL N(11,2), WUM C(03))

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "dit_gruppo = '" + ALLTRIM(XXGRUPPO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"cur_diba")
   return(.f.)
ENDIF
SELECT cur_diba
GO TOP
IF EOF()
   RETURN
ENDIF

V_CODART=DIT_GRUPPO
V_DESCRI=DIT_DESCRI
V_COSTO =DIT_COSTO
V_PREZZO=DIT_PREZZO
V_UM    =DIT_UM

CNT=1
XX_QTA1 = XXQTA
XX_QTA  = XX_QTA1

SELECT WEXPLODE
APPEND BLANK
REPLACE WCOD   WITH V_CODART
REPLACE WDES   WITH V_DESCRI
REPLACE WCOS   WITH V_COSTO
REPLACE WPRZ   WITH V_PREZZO
REPLACE WTIP   WITH "T"
REPLACE WLIV   WITH CNT
REPLACE WQTA   WITH 1
REPLACE TREE   WITH V_CODART
REPLACE WQTALL WITH 0
REPLACE WUM    WITH V_UM

DO TROVA_QTA WITH XXGRUPPO

SELECT WEXPLODE
PUN = RECCOUNT()
K   = SPACE(0)

SELECT WEXPLODE
GO TOP
DELETE FOR WLIV > LIV_ESPLN ALL
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF WLIV = 1
      XX_QTA  = WQTA * XXQTA
      XX_QTA1 = XX_QTA
   ENDIF
   IF WLIV = 2
      XX_QTA  = WQTA * XX_QTA1
      XX_QTA2 = XX_QTA
   ENDIF
   IF WLIV = 3
      XX_QTA  = WQTA * XX_QTA2
      XX_QTA3 = XX_QTA
   ENDIF
   IF WLIV = 4
      XX_QTA  = WQTA * XX_QTA3
      XX_QTA4 = XX_QTA
   ENDIF
   IF WLIV = 5
      XX_QTA  = WQTA * XX_QTA4
      XX_QTA5 = XX_QTA
   ENDIF
   IF WLIV = 6
      XX_QTA  = WQTA * XX_QTA5
      XX_QTA6 = XX_QTA
   ENDIF
   IF WLIV = 7
      XX_QTA  = WQTA * XX_QTA6
      XX_QTA7 = XX_QTA
   ENDIF
   REPLACE WQTALL WITH XX_QTA
   SELECT WEXPLODE
   SKIP +1
ENDDO

SELECT WEXPLODE
GO TOP

IF SI_VIDEO
   V_TIT="ESPLOSIONE GRUPPO - "+XXGRUPPO
   V_TES="ALBERO:TREE:32;Q.TA X 1:WQTA:9;Q.TA X N:WQTALL:13;DESCRIZIONE:WDES:25;PREZZO:WPRZ:10;COSTO:WCOS:10;TIPO:WTIP:1"
   =WSHOWDBF("WEXPLODE",V_TIT,V_TES)
ENDIF

RETURN


************************************************************************
PROCEDURE TROVA_QTA
************************************************************************
PARAMETERS CODE
PRIVATE CODE,REK,GRU

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_DD")
   return(.f.)
ENDIF

SELECT U_DIS_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_DD
   
   IF DIS_TIPO=='G'
      REK = RECNO()
      GRU = CODE
      =TROVA_QTA1(DIS_CODART)
      SELECT U_DIS_DD
      *GOTO REK
      CODE = GRU
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA1
************************************************************************
PARAMETERS CODE1
PRIVATE CODE1,REK1,GRU1

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE1) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D1")
   return(.f.)
ENDIF

SELECT U_DIS_D1
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D1
   
   IF DIS_TIPO=='G'
      REK1 = RECNO()
      GRU1 = CODE
      =TROVA_QTA2(DIS_CODART)
      SELECT U_DIS_D1
      *GOTO REK1
      CODE=GRU1
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA2
************************************************************************
PARAMETERS CODE2
PRIVATE CODE2,REK2,GRU2

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE2) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D2")
   return(.f.)
ENDIF

SELECT U_DIS_D2
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D2
   
   IF DIS_TIPO=='G'
      REK2 = RECNO()
      GRU2 = CODE
      =TROVA_QTA3(DIS_CODART)
      SELECT U_DIS_D2
      *GOTO REK2
      CODE=GRU2
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA3
************************************************************************
PARAMETERS CODE3
PRIVATE CODE3,REK3,GRU3

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE3) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D3")
   return(.f.)
ENDIF

SELECT U_DIS_D3
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D3
   
   IF DIS_TIPO=='G'
      REK3 = RECNO()
      GRU3 = CODE
      =TROVA_QTA4(DIS_CODART)
      SELECT U_DIS_D3
      *GOTO REK3
      CODE=GRU3
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA4
************************************************************************
PARAMETERS CODE4
PRIVATE CODE4,REK4,GRU4

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE4) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D4")
   return(.f.)
ENDIF

SELECT U_DIS_D4
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D4
   
   IF DIS_TIPO=='G'
      REK4 = RECNO()
      GRU4 = CODE
      =TROVA_QTA5(DIS_CODART)
      SELECT U_DIS_D4
      *GOTO REK4
      CODE=GRU4
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA5
************************************************************************
PARAMETERS CODE5
PRIVATE CODE5,REK5,GRU5

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE5) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D5")
   return(.f.)
ENDIF

SELECT U_DIS_D5
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D5
   
   IF DIS_TIPO=='G'
      REK5 = RECNO()
      GRU5 = CODE
      =TROVA_QTA6(DIS_CODART)
      SELECT U_DIS_D5
      *GOTO REK5
      CODE=GRU5
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA6
************************************************************************
PARAMETERS CODE6
PRIVATE CODE6,REK6,GRU6

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE6) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D6")
   return(.f.)
ENDIF

SELECT U_DIS_D6
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D6
   
   IF DIS_TIPO=='G'
      REK6 = RECNO()
      GRU6 = CODE
      =TROVA_QTA7(DIS_CODART)
      SELECT U_DIS_D6
      *GOTO REK6
      CODE = GRU6
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA7
************************************************************************
PARAMETERS CODE7
PRIVATE CODE7,REK7,GRU7

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE7) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D7")
   return(.f.)
ENDIF

SELECT U_DIS_D7
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D7
   
*   IF DIS_TIPO=='G'
*      REK7 = RECNO()
*      GRU7 = CODE
*      =TROVA_QTA8(DIS_CODART)
*      SELECT U_DIS_D7
*      GOTO REK7
*      CODE=GRU7
*   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


***************************************************************************
PROCEDURE ALBE_QTAX
***************************************************************************

PARA SI_VIDEO,XXGRUPPO,XXQTA,YYQTA,LIV_ESPL

PUBLIC LIV_ESPLN
LIV_ESPLN = 0

PUBLIC XX_QTA1,XX_QTA2,XX_QTA3,XX_QTA4,XX_QTA5,XX_QTA6,XX_QTA7
XX_QTA1 = 0
XX_QTA2 = 0
XX_QTA3 = 0
XX_QTA4 = 0
XX_QTA5 = 0
XX_QTA6 = 0
XX_QTA7 = 0

PUBLIC YY_QTA1,YY_QTA2,YY_QTA3,YY_QTA4,YY_QTA5,YY_QTA6,YY_QTA7
YY_QTA1 = 0
YY_QTA2 = 0
YY_QTA3 = 0
YY_QTA4 = 0
YY_QTA5 = 0
YY_QTA6 = 0
YY_QTA7 = 0

IF LIV_ESPL = .F.
   v_seek	= 'NUM'+'LDB'+'LIV'
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      LIV_ESPLN = VAL(SUBSTR(LIBERA,1,2))
      IF LIV_ESPLN > 98
         LIV_ESPLN = 98
      ENDIF         
   ELSE
      LIV_ESPLN = 98
   ENDIF
ELSE
   LIV_ESPLN = 98
ENDIF
IF LIV_ESPLN < 1
   LIV_ESPLN = 98
ENDIF         
LIV_ESPLN = LIV_ESPLN + 1

CREATE CURSOR WEXPLODE (WCOD C(16), WDES C(40), WCOS N(17,6), WPRZ N(17,6), ;
                        WTIP C(1),  WLIV N(4) , WQTA N(11,2), TREE C(100),  ;
                        WEXP C(1),  WQTALL N(11,2), WQTALY N(11,2))
                        
x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "dit_gruppo = '" + ALLTRIM(XXGRUPPO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"CUR_DIBA")
   return(.f.)
ENDIF
SELECT CUR_DIBA
GO TOP
IF EOF()
   RETURN
ENDIF

V_CODART = DIT_GRUPPO
V_DESCRI = DIT_DESCRI
V_COSTO  = DIT_COSTO
V_PREZZO = DIT_PREZZO

CNT = 1

XX_QTA1 = XXQTA
XX_QTA  = XX_QTA1
YY_QTA1 = YYQTA
YY_QTA  = YY_QTA1

SELECT WEXPLODE
APPEND BLANK
REPLACE WCOD   WITH V_CODART
REPLACE WDES   WITH V_DESCRI
REPLACE WCOS   WITH V_COSTO
REPLACE WPRZ   WITH V_PREZZO
REPLACE WTIP   WITH "T"
REPLACE WLIV   WITH CNT
REPLACE WQTA   WITH 1
REPLACE TREE   WITH V_CODART
REPLACE WQTALL WITH 0
REPLACE WQTALY WITH 0

DO TROVA_QTAX WITH XXGRUPPO

SELECT WEXPLODE
PUN=RECCOUNT()
K=SPACE(0)

SELECT WEXPLODE
GO TOP
DELETE FOR WLIV > LIV_ESPLN ALL
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF WLIV = 1
      XX_QTA  = WQTA * XXQTA
      XX_QTA1 = XX_QTA
      YY_QTA  = WQTA * YYQTA
      YY_QTA1 = YY_QTA
   ENDIF
   IF WLIV = 2
      XX_QTA  = WQTA * XX_QTA1
      XX_QTA2 = XX_QTA
      YY_QTA  = WQTA * YY_QTA1
      YY_QTA2 = YY_QTA
   ENDIF
   IF WLIV = 3
      XX_QTA  = WQTA * XX_QTA2
      XX_QTA3 = XX_QTA
      YY_QTA  = WQTA * YY_QTA2
      YY_QTA3 = YY_QTA
   ENDIF
   IF WLIV = 4
      XX_QTA  = WQTA * XX_QTA3
      XX_QTA4 = XX_QTA
      YY_QTA  = WQTA * YY_QTA3
      YY_QTA4 = YY_QTA
   ENDIF
   IF WLIV = 5
      XX_QTA  = WQTA * XX_QTA4
      XX_QTA5 = XX_QTA
      YY_QTA  = WQTA * YY_QTA4
      YY_QTA5 = YY_QTA
   ENDIF
   IF WLIV = 6
      XX_QTA  = WQTA * XX_QTA5
      XX_QTA6 = XX_QTA
      YY_QTA  = WQTA * YY_QTA5
      YY_QTA6 = YY_QTA
   ENDIF
   IF WLIV = 7
      XX_QTA  = WQTA * XX_QTA6
      XX_QTA7 = XX_QTA
      YY_QTA  = WQTA * YY_QTA6
      YY_QTA7 = YY_QTA
   ENDIF
   REPLACE WQTALL WITH XX_QTA
   REPLACE WQTALY WITH YY_QTA
   SELECT WEXPLODE
   SKIP +1
ENDDO

SELECT WEXPLODE
GO TOP

IF SI_VIDEO
	V_TIT="ESPLOSIONE GRUPPO - "+XXGRUPPO
	V_TES="ALBERO:TREE:32;Q.TA X 1:WQTA:9;Q.TA X N:WQTALL:13;DESCRIZIONE:WDES:25;PREZZO:WPRZ:10;COSTO:WCOS:10;TIPO:WTIP:1"
	=WSHOWDBF("WEXPLODE",V_TIT,V_TES)
ENDIF

RETURN

************************************************************************
PROCEDURE TROVA_QTAX
************************************************************************
PARAMETERS CODE
PRIVATE CODE,REK,GRU

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_DD")
   return(.f.)
ENDIF

SELECT U_DIS_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_DD

   IF DIS_TIPO=='G'
      REK = RECNO()
      GRU = CODE
      =TROVA_QTAX1(DIS_CODART)
      SELECT U_DIS_DD
      *GOTO REK
      CODE = GRU
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX1
************************************************************************
PARAMETERS CODE1
PRIVATE CODE1,REK1,GRU1

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE1) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D1")
   return(.f.)
ENDIF

SELECT U_DIS_D1
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D1

   IF DIS_TIPO=='G'
      REK1 = RECNO()
      GRU1 = CODE
      =TROVA_QTAX2(DIS_CODART)
      SELECT U_DIS_D1
      *GOTO REK1
      CODE = GRU1
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX2
************************************************************************
PARAMETERS CODE2
PRIVATE CODE2,REK2,GRU2

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE2) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D2")
   return(.f.)
ENDIF

SELECT U_DIS_D2
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D2

   IF DIS_TIPO=='G'
      REK2 = RECNO()
      GRU2 = CODE
      =TROVA_QTAX3(DIS_CODART)
      SELECT U_DIS_D2
      *GOTO REK2
      CODE = GRU2
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX3
************************************************************************
PARAMETERS CODE3
PRIVATE CODE3,REK3,GRU3

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE3) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D3")
   return(.f.)
ENDIF

SELECT U_DIS_D3
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D3

   IF DIS_TIPO=='G'
      REK3 = RECNO()
      GRU3 = CODE
      =TROVA_QTAX4(DIS_CODART)
      SELECT U_DIS_D3
      *GOTO REK3
      CODE = GRU3
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX4
************************************************************************
PARAMETERS CODE4
PRIVATE CODE4,REK4,GRU4

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE4) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D4")
   return(.f.)
ENDIF

SELECT U_DIS_D4
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D4

   IF DIS_TIPO=='G'
      REK4 = RECNO()
      GRU4 = CODE
      =TROVA_QTAX5(DIS_CODART)
      SELECT U_DIS_D4
      *GOTO REK4
      CODE = GRU4
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX5
************************************************************************
PARAMETERS CODE5
PRIVATE CODE5,REK5,GRU5

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE5) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D5")
   return(.f.)
ENDIF

SELECT U_DIS_D5
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D5

   IF DIS_TIPO=='G'
      REK5 = RECNO()
      GRU5 = CODE
      =TROVA_QTAX6(DIS_CODART)
      SELECT U_DIS_D5
      *GOTO REK5
      CODE = GRU5
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX6
************************************************************************
PARAMETERS CODE6
PRIVATE CODE6,REK6,GRU6

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE6) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D6")
   return(.f.)
ENDIF

SELECT U_DIS_D6
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D6

   IF DIS_TIPO=='G'
      REK6 = RECNO()
      GRU6 = CODE
      =TROVA_QTAX7(DIS_CODART)
      SELECT U_DIS_D6
      *GOTO REK6
      CODE = GRU6
   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN

************************************************************************
PROCEDURE TROVA_QTAX7
************************************************************************
PARAMETERS CODE7
PRIVATE CODE7,REK7,GRU7

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE7) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D7")
   return(.f.)
ENDIF

SELECT U_DIS_D7
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_QTALY  = 0 
    
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WQTALY WITH 0
      
   SELECT U_DIS_D7

*   IF DIS_TIPO=='G'
*      REK7 = RECNO()
*      GRU7 = CODE
*      =TROVA_QTAX8(DIS_CODART)
*      SELECT U_DIS_D7
*      *GOTO REK7
*      CODE = GRU7
*   ENDIF
      
   SKIP +1
  
ENDDO

CNT = CNT - 1

RETURN


************************
FUNCTION CREA_ED
************************
**--> CREAZIONE CURSORE DI APPOGGIO PER STAMPA COMMESSA CON COMPONENTI
**--> _CUR_I => NOME CURSORE DI INPUT
**--> _CUR_O => NOME CURSORE DI OUTPUT

PARA _CUR_I,_CUR_O

SS1=STR(SELECT())
OUT = .T.

SELECT &_CUR_I
HH=AFIELDS(TRANSITO)
CREATE CURSOR &_CUR_O FROM ARRAY TRANSITO

SELECT &_CUR_I
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO
   
   SELECT &_CUR_O
   APPEND BLANK
   GATHER MEMVAR MEMO
            
   DO ALBE_QTA WITH .F.,M.ORD_CODART,M.ORD_QTAORD
   
   SELECT WEXPLODE
   GO TOP

   IF EOF()
      SELECT &_CUR_I
      SKIP +1
      LOOP
   ENDIF
   
   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF WLIV = 1 
         SKIP +1
         LOOP
      ENDIF

      SCATTER MEMVAR

      M.ORD_CODART = M.WCOD
      M.ORD_DESART = M.WDES
      M.ORD_DES2   = SPACE(40)
      M.ORD_QTAORD = M.WQTALL
      M.ORD_PREZZO = M.WPRZ
      XVPRE        = M.ORD_PREZZO
      XPRZNET      = XVPRE
	  XPRZNET      = ROUND(XPRZNET,2)
      M.ORD_PRZNET = XPRZNET
	  M.ORD_VALORE = ROUND((M.ORD_PRZNET * M.ORD_QTAORD),2)
      M.ORD_UM     = M.WUM

      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         X_RIPCOM     = ART_RIPCOM
         M.ORD_DESART = ART_DESCR
         M.ORD_DES2	  = ART_DESEST
      ENDIF
      
      **==> CONVERTO IL PESI IN MM ()
      M.ORD_QTAORD = CONV_PESO(M.ORD_QTAORD,M.ORD_CODART,M.ORD_UM)
      
      IF X_RIPCOM = 'S'
      ELSE
         SELECT WEXPLODE
         SKIP +1 
         LOOP
      ENDIF
          
      SELECT &_CUR_O
      APPEND BLANK
      GATHER MEMVAR MEMO
    
      SELECT WEXPLODE
      SKIP +1 
   
   ENDDO
   
   SELECT &_CUR_I
   SKIP +1

ENDDO

SELECT &SS1

RETURN(OUT)


************************
FUNCTION CONV_PESO
************************
PARA _QTA,_ART,_UM

SS1=STR(SELECT())

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + _ART + "'"
x_cond = x_soci + " and " + x_codi
cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"CUR_ARTI")
   RETURN .F.
ENDIF
SELECT CUR_ARTI
GO TOP
IF !EOF()
   A_UM   = ART_UNIMIS
   A_PESO = ART_PESOUM
ELSE
   A_UM   = W_UM
   A_PESO = 0
ENDIF
      
IF A_UM = _UM
ELSE
   IF A_PESO = 0
   ELSE
      _QTA = (1000 * _QTA) / A_PESO 
   ENDIF
ENDIF

SELECT &SS1

RETURN(_QTA)


***************************************************************************
PROCEDURE ALBECICLO
***************************************************************************

PARA SI_VIDEO,XXGRUPPO

CREATE CURSOR WEXPLODEC (WCOD N(3),WDES C(40), WTM N(6,2), WPM N(6,2), WCAR N(8,2))

x_soci = "cit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cit_gruppo = '" + ALLTRIM(XXGRUPPO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cic_tt where " + x_cond + " order by cit_codsoc,cit_gruppo"
IF !ExecCommand(cSql,"cur_ciclo")
   return(.f.)
ENDIF
SELECT cur_ciclo
GO TOP
IF EOF()
   RETURN
ENDIF
  
AGGA = TAGGANCIO

x_agga = "daggancio = '" + AGGA + "'"
x_cond = x_agga
Csql   = "select * from u_cic_dd where " + x_cond + " order by daggancio,cic_sequen"
IF !ExecCommand(cSql,"cur_ciclo")
   return(.f.)
ENDIF
SELECT cur_ciclo
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   M.WCOD = CIC_MACCHI
   M.WDES = CIC_DESCRI
   M.WTM  = CIC_CSTTM
   M.WPM  = CIC_CSTPM
   M.WCAR = CIC_CARICO
   SELECT WEXPLODEC
   APPEND BLANK
   GATHER MEMVAR
   SELECT cur_ciclo
   SKIP +1
ENDDO   

SELECT WEXPLODEC
GO TOP

IF SI_VIDEO
	V_TIT="VISUALIZZA CICLO DI LAVORO GRUPPO : "+XXGRUPPO
	V_TES="MACCHINA:WCOD:10;DESCRIZIONE:WDES:40;TM:WPM:6;PM:WTM:6;CARICO:WCAR:8"
	=WSHOWDBF("WEXPLODEC",V_TIT,V_TES)
ENDIF

RETURN


************************
FUNCTION CREA_EB
************************
**--> CREAZIONE DETTAGLI ESPLOSI PER BOLLA DI EVASIONE (NO SCARICO PERCHE' GIA' SCARICATI)
**--> _CUR => NOME CURSORE IN CUI SCRIVERE

PARA _CUR

SS1=STR(SELECT())
OUT = .T.

IF PUB_DDTRIC
ELSE
   SELECT &SS1
   RETURN(OUT)
ENDIF

DO ALBE_QTA WITH .F.,M.ORD_CODART,M.ORD_QTAORD
   
SELECT WEXPLODE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF WLIV = 1 
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   M.ORD_CODART = M.WCOD
   M.ORD_DESART = M.WDES
   M.ORD_DES2   = SPACE(40)
   M.ORD_QTAORD = M.WQTALL
   M.ORD_PREZZO = M.WPRZ
   XVPRE        = M.ORD_PREZZO
   XPRZNET      = XVPRE
   XPRZNET      = ROUND(XPRZNET,2)
   M.ORD_PRZNET = XPRZNET
   M.ORD_VALORE = ROUND((M.ORD_PRZNET * M.ORD_QTAORD),2)
   M.ORD_UM     = M.WUM

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + M.ORD_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CUR_ARTICOLI")
      RETURN .F.
   ENDIF
   SELECT CUR_ARTICOLI
   GO TOP
   IF !EOF()
      X_RIPCOM     = ART_RIPCOM
      M.ORD_DESART = ART_DESCR
      M.ORD_DES2   = ART_DESEST
      M.ORD_IVA    = ART_CODIVA
   ENDIF
      
   IF X_RIPCOM = 'S'
   ELSE
      SELECT WEXPLODE
      SKIP +1 
      LOOP
   ENDIF
          
   M.ORD_QTAORD = M.WQTALL
   M.ORD_VALORE = M.ORD_PRZNET * M.ORD_QTAORD
   M.DAGGANCIO  = X_UNCINO
   M.ORS_NUMORD = X_NUMORD
   M.ORS_DATORD = RIBALTA2(DTOC(DATE()))
   M.ORD_QTAEV  = 0
   M.ORD_QTADEV = 0
   M.ORD_CHIUSO = .F.
   M.ORD_FLGSCP = .T.
   
   * AGGIORNA I DETTAGLI
   SELECT CUR_BOL_DD
   APPEND BLANK
   GATHER MEMVAR MEMO     

   SELECT CU_BOL_DD
   APPEND BLANK
   GATHER MEMVAR MEMO     
    
   CIVA = X_CODIVA
 
   v_seek	= 'IVA' + CIVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      VIVA = VAL(SUBSTR(LIBERA,1,3))
   ELSE
      VIVA = 0  
   ENDIF

   SELECT U_BOL_DD

   IF ORD_PUBBLI = "S"
      MATPUBX = MATPUBX + ORD_VALORE
   ENDIF 

   M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE
   M.T_IMPOSTA = M.T_IMPOSTA + (ORD_VALORE * (VIVA/100))

   SELECT WEXPLODE
   SKIP +1 
   
ENDDO
   
SELECT &SS1

RETURN(OUT)


**************************************************************************
PROCEDURE PROSCMAG  && SCARICA IL MAGAZZINO
**************************************************************************

SELECT CU_BOL_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGSCP
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   H_DADOVE = 'PROSCMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = M.ORD_CAUS
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = 0
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = ""
   H_NOTE   = ""
   H_CSC    = CSC
   H_SAC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)

   SELECT CU_BOL_DD
   SKIP +1

ENDDO

RETURN


***********************************************************************************************
*  SERVE PER DETERMINARE IL CODICE ARTICOLO NUOVO DA DUPLICARE                                *
***********************************************************************************************
FUNCTION PROMAKEA    
***********************************************************************************************

PARA _LINEA,_RAGSOC

IF EMPTY(_LINEA) .OR. _LINEA = SPACE(02)
   _LINEA = '9'
ENDIF

ZZZ=SELECT()

CREATE CURSOR LETTERE (LET_SEQU N(02), LET_ALFA C(01), LET_NUME C(02))
INDEX ON LET_ALFA TAG I_LETTERE ADDITIVE
INDEX ON LET_SEQU TAG I_SEQUENZ ADDITIVE

SELECT LETTERE
SET ORDER TO I_LETTERE

_CAMPO   = ""
_SEQU    = 0
_IND     = 1
_LEN     = LEN(_RAGSOC)

DO WHILE .T.

   IF _IND > _LEN
      EXIT
   ENDIF
   
   _RICE = SUBSTR(_RAGSOC,_IND,1)
  
   v_SEEK = 'DLN' + _RICE
   IF seek_std('PARA',v_seek,'CODICE','CUR_PARA')
      SELECT CUR_PARA
      _TROV = SUBSTR(LIBERA,1,2)
   ELSE
      _TROV = SPACE(02)
   ENDIF
   
   IF _TROV = SPACE(02)
      _IND = _IND + 1
      LOOP
   ENDIF

   _SEQU = _SEQU + 1

   SELECT LETTERE
   APPEND BLANK
   REPLACE LET_SEQU WITH _SEQU
   REPLACE LET_ALFA WITH _RICE
   REPLACE LET_NUME WITH _TROV
   
   _IND  = _IND + 1
   
ENDDO

IF _SEQU > 2
ELSE
   IF _SEQU = 0
      SELECT LETTERE
      APPEND BLANK
      REPLACE LET_SEQU WITH 1
      REPLACE LET_ALFA WITH 'A'
      REPLACE LET_NUME WITH '00'
      APPEND BLANK
      REPLACE LET_SEQU WITH 2
      REPLACE LET_ALFA WITH 'A'
      REPLACE LET_NUME WITH '00'
      APPEND BLANK
      REPLACE LET_SEQU WITH 3
      REPLACE LET_ALFA WITH 'A'
      REPLACE LET_NUME WITH '00'
   ENDIF
   IF _SEQU = 1
      SELECT LETTERE
      APPEND BLANK
      REPLACE LET_SEQU WITH 2
      REPLACE LET_ALFA WITH 'A'
      REPLACE LET_NUME WITH '00'
      APPEND BLANK
      REPLACE LET_SEQU WITH 3
      REPLACE LET_ALFA WITH 'A'
      REPLACE LET_NUME WITH '00'
   ENDIF
   IF _SEQU = 2
      SELECT LETTERE
      APPEND BLANK
      REPLACE LET_SEQU WITH 3
      REPLACE LET_ALFA WITH 'A'
      REPLACE LET_NUME WITH '00'
   ENDIF
ENDIF

_LETTE = ""
_ARTI  = SUBSTR(_LINEA,1,1)
_IND   = 0
SELECT LETTERE
SET ORDER TO I_SEQUENZ
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF LET_SEQU = 1
      _LETTE = _LETTE + LET_ALFA
      _ARTI  = _ARTI  + LET_NUME + '.'
   ENDIF
   IF LET_SEQU = 2
      _LETTE = _LETTE + LET_ALFA
      _ARTI  = _ARTI  + LET_NUME 
   ENDIF
   IF LET_SEQU = 3
      _LETTE = _LETTE + LET_ALFA
      _ARTI  = _ARTI  + SUBSTR(LET_NUME,1,1) + '.' + SUBSTR(LET_NUME,2,1)
      EXIT
   ENDIF
   SKIP +1
ENDDO

RELEASE V_TRCLI
PUBLIC  V_TRCLI
V_TRCLI = 0

CREATE CURSOR CU_ARTCLI (ART_RAGSOC C(40))
INDEX ON ART_RAGSOC TAG I_ARTCLI ADDITIVE

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_ragsoc = '" + ALLTRIM(_RAGSOC) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   V_TRCLI = VAL(SUBSTR(ART_CODPRI,10,1))
ELSE
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "substring(art_ragsoc,1,3) = '" + SUBSTR(_RAGSOC,1,3) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CU_ART_PR")
      return(.f.)
   ENDIF
   SELECT CU_ART_PR
   GO TOP
   IF EOF()
   ELSE
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         S_RAGSOC = ART_RAGSOC
         SELECT CU_ARTCLI 
         SET ORDER TO I_ARTCLI
         SEEK S_RAGSOC
         IF FOUND()
         ELSE
            APPEND BLANK
            REPLACE ART_RAGSOC WITH S_RAGSOC
            V_TRCLI = V_TRCLI + 1
         ENDIF
         SELECT CU_ART_PR
         SKIP +1
      ENDDO            
   ENDIF      
ENDIF

_ARTI = _ARTI + STR(V_TRCLI,1,0)

V_PROGRE = '00'

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "substring(art_codpri,1,10) = '" + _ARTI + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"CU_ART_PR")
   return(.f.)
ENDIF
SELECT CU_ART_PR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   V_PROGRE = SUBSTR(ART_CODPRI,10,3)
   SKIP +1
ENDDO

V_NUMERO = VAL(V_PROGRE) + 1
V_PROGRE = ALLTRIM(STR(V_NUMERO,3,0))
V_LEN    = LEN(V_PROGRE)
IF V_LEN = 1
   V_PROGRE = '00' + V_PROGRE
ENDIF
IF V_LEN = 2
   V_PROGRE = '0' + V_PROGRE
ENDIF

_ARTI = _ARTI + SUBSTR(V_PROGRE,2,2)

SELECT(ZZZ)

RETURN(_ARTI)


********************************************************
** CREO CURSORE PER GESTIONE DISTINTA BASE SU GRIGLIA **
********************************************************
PROCEDURE DIS000G
*****************

x_codi = "daggancio = '" + XXX_AGGANCIO + "'"
x_cond = x_codi
Csql   = "select * from u_dis_dd where " + x_cond + " order by daggancio,dis_sequen"
IF !ExecCommand(cSql,"cu_dis_dd")
   return(.f.)
ENDIF

SELECT CU_DIS_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   REPLACE DIS_NOTEAL WITH SUBSTR(DIS_NOTE,1,200)
   
   SKIP +1
   
ENDDO

SELECT CU_DIS_DD
GO TOP

RETURN


*************************************************
** CREO CURSORE PER GESTIONE CICLO SU GRIGLIA **
*************************************************
PROCEDURE CIC000G
*****************

x_codi = "daggancio = '" + XXX_AGGANCIO + "'"
x_cond = x_codi
Csql   = "select * from u_cic_dd where " + x_cond + " order by daggancio,cic_sequen"
IF !ExecCommand(cSql,"cu_cic_dd")
   return(.f.)
ENDIF
SELECT CU_CIC_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   REPLACE CIC_NOTEAL WITH SUBSTR(CIC_NOTVAR,1,200)
   
   SKIP +1
   
ENDDO

SELECT CU_CIC_DD
INDEX ON CIC_SEQUEN TAG SEQUEN ADDITIVE
SET ORDER TO SEQUEN
GO TOP

RETURN


***************************************************************************
PROCEDURE PROINIZ
***************************************************************************

RELEASE CMAT,CLAV,TLAV,MTU,MPM,STU,SPM,TMATU,TMATU1,TLAVU,VARIAZ,TUSERIE,TORELAV,MDCP,MDCQ,SIMACC,TCU, ;
        ZLOTTO,XLOTTO,WLOT,V_ERRORE,V_FINE
PUBLIC  CMAT,CLAV,TLAV,MTU,MPM,STU,SPM,TMATU,TMATU1,TLAVU,VARIAZ,TUSERIE,TORELAV,MDCP,MDCQ,SIMACC,TCU, ;
        ZLOTTO,XLOTTO,WLOT,V_ERRORE,V_FINE
CMAT     = 0.00
CLAV     = 0.00
TLAV     = 0.00
MTU      = 0.00
MPM      = 0.00
STU      = 0.00
SPM      = 0.00
TMATU    = 0.00
TMATU1   = 0.00
TLAVU    = 0.00
VARIAZ   = 0.00
TUSERIE  = 0.00
TORELAV  = 0.00
MDCP     = 0.00
MDCQ     = 0.00
SIMACC   = 0.00
TCU      = 0.00
ZLOTTO   = 0
XLOTTO   = 0
WLOT     = 0
V_ERRORE = 0
V_FINE   = .F.
        
RELEASE M.G1110,M.G100,M.G101,M.G103,M.G106,M.G107,M.G108,M.G110,M.E112,M.E114,M.E115,M.E117,M.E119,   ;
        M.E121,M.E122,M.E123,M.E125,M.E126,M.E129,M.E131,M.E121B,M.G70,M.G71,M.G72,m.e121beuro
PUBLIC  M.G1110,M.G100,M.G101,M.G103,M.G106,M.G107,M.G108,M.G110,M.E112,M.E114,M.E115,M.E117,M.E119,   ;
        M.E121,M.E122,M.E123,M.E125,M.E126,M.E129,M.E131,M.E121B,M.G70,M.G71,M.G72,m.e121beuro
M.G1110 = 0.00
M.G100  = 0.00
M.G101  = 0.00
M.G103  = 0.00
M.G106  = 0.00
M.G107  = 0.00
M.G108  = 0.00
M.G110  = 0.00
M.E112  = 0.00
M.E114  = 0.00
M.E115  = 0.00
M.E117  = 0.00
M.E119  = 0.00
M.E121  = 0.00
M.E122  = 0.00
M.E123  = 0.00
M.E125  = 0.00
M.E126  = 0.00
M.E129  = 0.00
M.E131  = 0.00
M.E121B = 0.00
M.G70   = 0.00
M.G71   = 0.00
M.G72   = 0.00
m.e121beuro = 0.00

RELEASE TMATU2,M.G099,M.G10099   		&&  01/07/2003
PUBLIC  TMATU2,M.G099,M.G10099   		&&  01/07/2003
TMATU2   = 0.00							&&  12/06/2003
M.G099   = 0.00							&&  12/06/2003
M.G10099 = 0.00							&&  12/06/2003

RETURN


***************************************************************************
PROCEDURE PROERROR
***************************************************************************

PARA _ERRORE
 
IF _ERRORE = 1 
   PUB_ERRORE=MESSAGEBOX('Prodotto senza distinta base',64,'*** ATTENZIONE ***') 
   RETURN(.F.)
ENDIF

IF _ERRORE = 2
   PUB_ERRORE=MESSAGEBOX("Componente " + Y_COMPON + " con quantità a zero",64,'*** ATTENZIONE ***') 
   RETURN(.F.)
ENDIF

IF _ERRORE = 3
   PUB_ERRORE=MESSAGEBOX("Mancano i parametri generali MDC",64,'*** ATTENZIONE ***') 
   RETURN(.F.)
ENDIF

RETURN(.T.)


***************************************************************************
PROCEDURE PROAPRIR
***************************************************************************

CREATE CURSOR RICETTE (TIPO C(01), STIPO C(01), SEQUE N(04), LINEA C(200))

SELECT RICETTE

APPEND BLANK
replace tipo   with 'A'
replace stipo  with 'A'
*RIGA = space(30)+'Componenti con lavorazione interna'						  &&  01/07/2003	   
RIGA = space(30)+'Componenti con lavorazione interna/esterna'    			  &&  01/07/2003
RIGA = RIGA+space(25)+'COSTO TOT.'+space(27)+'MATERIALE'+space(7)+'MATERIALE' &&  01/07/2003
replace linea  with RIGA
replace seque  with 0

append blank
replace tipo   with 'A'
replace stipo  with 'A'
RIGA = 'Seq.'+space(4)+'Codice'+space(7)+'Disegno'+space(7)
*riga = riga+'Descrizione'+space(42)+'Q.ta'+space(1)								&&  12/06/2003
riga = riga+'Descrizione'+space(27)+'Q.ta'+space(1)									&&  12/06/2003
riga = riga+'Lotto'+space(2)+'Data'+space(8)+'Mdc Q.F.'
*riga = riga+space(3)+'    '+space(4)+'Mat+LE Unit.'								&&  12/06/2003
riga = riga+space(3)+'    '+space(4)+'Cst.Unitario'+space(3)+'Cst.Tot+Ric.'			&&  12/06/2003
*riga = riga+SPACE(3)+'Mat.+LE Tot.'												&&  12/06/2003
riga = riga+SPACE(4)+'Cst. Totale'													&&  12/06/2003
replace linea  with RIGA
replace seque  with 1

append blank
replace tipo   with 'A'
replace stipo  with 'C'
*RIGA = space(30)+'Componenti da Commercio e Lav. Esterne'							&&  01/07/2003
RIGA = space(30)+'Componenti da Commercio'											&&  01/07/2003
RIGA = RIGA+space(44)+'COSTO TOT.'+space(27)+'MATERIALE'+space(7)+'MATERIALE' 		&&  01/07/2003
replace linea  with RIGA
replace seque  with 0

append blank
replace tipo   with 'A'
replace stipo  with 'C'
RIGA = 'Seq.'+space(4)+'Codice'+space(7)+'Disegno'+space(7)
*riga = riga+'Descrizione'+space(42)+'Q.ta'+space(1)								&&  12/06/2003
riga = riga+'Descrizione'+space(27)+'Q.ta'+space(1)									&&  12/06/2003
riga = riga+'Lotto'+space(2)+'Data'+space(8)+'Mdc Q.F.'
*riga = riga+space(3)+'    '+space(4)+'Mat+LE Unit.'								&&  12/06/2003
riga = riga+space(3)+'    '+space(4)+'Cst.Unitario'+space(3)+'Cst.Tot+Ric.'			&&  12/06/2003
*riga = riga+SPACE(3)+'Mat.+LE Tot.'												&&  12/06/2003
riga = riga+SPACE(4)+'Cst. Totale'													&&  12/06/2003
replace linea  with RIGA
replace seque  with 1

append blank
replace tipo   with 'B'
replace stipo  with 'A'
RIGA = space(30)+'Lavorazioni'
riga = riga+space(10)+'TM         PM            Costi Interni per Operazione'
replace linea  with RIGA
replace seque  with 0

append blank
replace tipo   with 'B'
replace stipo  with 'A'
RIGA = 'Seq.'+space(3)+'Cod.'+space(2)
riga = riga+'Descrizione'+space(27)+'h.         h.           TM+PM/n        TP       PM/n      Totale'
riga = riga+' Note'
replace linea  with RIGA
replace seque  with 1

RELEASE T1D,T2D,T3D,T4D,T1B,T2B,T3B,T4B,WSTIPO,TESTA1,TESTA2,TESTA3,WSCELTA,XTOTPM,XTOTTM
public  T1D,T2D,T3D,T4D,T1B,T2B,T3B,T4B,WSTIPO,TESTA1,TESTA2,TESTA3,WSCELTA,XTOTPM,XTOTTM
T1D    = 0.0
T2D    = 0.0
T3D    = 0.0
T4D    = 0.0
T1B    = 0.0
T2B    = 0.0
T3B    = 0.0
T4B    = 0.0
WSTIPO = ' '
TESTA1  = .T.
TESTA2  = .T.
TESTA3  = .T.
WSCELTA = ' '
xtotpm  = 0.0
xtottm  = 0.0

RELEASE T5D,T5B				&&  12/06/2003
public  T5D,T5B				&&  12/06/2003
T5D    = 0.0				&&  12/06/2003
T5B    = 0.0				&&  12/06/2003

RETURN


***************************************************************************
FUNCTION PROCOSTI
***************************************************************************

PARA _CODART,_TIPO

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "dit_gruppo = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"cur_diba")
   return(.f.)
ENDIF
SELECT cur_diba
GO TOP
IF EOF()
   V_ERRORE = 1
   RETURN(V_ERRORE)
ENDIF

RELEASE _SWS_
PUBLIC  _SWS_	
_SWS_=SELECT()

SI_DB	 = .T.
SI_VIDEO = .F.
DO ALBERELLO  WITH SI_VIDEO,_CODART   && ESPLODE LA DISTINTA BASE NON A VIDEO

SELECT WEXPLODE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF WQTA = 0
      V_ERRORE = 2
      Y_COMPIN = WCOD
      EXIT
   ENDIF
   SKIP +1
ENDDO

**==>  14/06/2002 INIZIO
*IF V_ERRORE = 2
*   RETURN(V_ERRORE)
*ENDIF
IF V_ERRORE = 2
   PUB_ERRORE=MESSAGEBOX("Componente con quantità a zero"+CHR(13)+ ;
                         "Vuoi lo stesso calcolare i costi ?",292,"*** ATTENZIONE ***") 
   DO CASE
      CASE PUB_ERRORE= 7  && RISPOSTA NO
           RETURN(V_ERRORE)
   ENDCASE
ENDIF
**==>  14/06/2002 INIZIO

x_codi = "mdc_codice = '" + PUB_CODSOC + "'"
x_cond = x_codi
Csql   = "select * from u_mdc_an where " + x_cond + " order by mdc_codice"
IF !ExecCommand(cSql,"cur_parametri")
   return(.f.)
ENDIF
SELECT cur_parametri
GO TOP
IF !EOF()
   SCATTER MEMVAR
ELSE
   V_ERRORE = 3
   RETURN(V_ERRORE)   
ENDIF

DO PROINIZ

DO PROAPRIR

M.G1110 = 0.0
V_FINE  = .F.

SELECT WEXPLODE
GO BOTTOM
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF WTIP = 'T'
      IF V_FINE
         EXIT
      ELSE
         V_FINE = .T.
      ENDIF
   ENDIF
   SCATTER MEMVAR
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.WCOD) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"cur_articoli")
      return(.f.)
   ENDIF
   SELECT cur_articoli
   GO TOP
   IF EOF()
      WAIT 'Elemento non trovato ' + M.WCOD WINDOW
      SKIP -1
      LOOP
   ENDIF
   DO PRORICA3
   DO PRORICA4
   V_AGGIORNA = .T.
   IF V_FINE
      IF _TIPO = 'CALC' .OR. _TIPO = 'STAM'
         V_AGGIORNA = .F.
      ENDIF
   ENDIF
   IF V_AGGIORNA
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + ALLTRIM(M.WCOD) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecRW(cSql,"u_art_pr","R")
         return(.f.)
      ENDIF
      SELECT u_art_pr
      GO TOP
      IF !EOF()
         REPLACE ART_MDCPER WITH M.E131
         REPLACE ART_MDCQF  WITH M.E121B
         REPLACE ART_DATINS WITH RIBALTA2(DTOC(DATE()))
      ENDIF
      IF !ExecRW(cSql,"u_art_pr","W")
         return(.f.)
      ENDIF
   ENDIF
   SELECT WEXPLODE
   SKIP -1
ENDDO

M.G10099 = T5B      + T5D								  &&  01/07/2003
M.E112   = M.G10099 + M.G110 							  &&  01/07/2003
M.E121   = M.E112   + M.E119							  &&  01/07/2003
M.E122   = M.E121   - M.E112							  &&  01/07/2003

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   IF _TIPO = 'STAM'
      WCOD      = ALLTRIM(ART_CODPRI)
      WDES      = ALLTRIM(ART_DESCR)
      WNOTE     = ALLTRIM(ART_NOTE)			&&  12/06/2003
      WZUG      = ALLTRIM(str(ART_NUMDEN))
      WMUG      = ALLTRIM(str(ART_MODULO))
      WINTERASS = ALLTRIM(str(ART_INTERA))
      WDIS      = ART_CODDIS
      WCLI      = ART_RAGSOC
      WLOT      = ART_LOTTO
      W2LOT     = ART_LOTTO
      *Wvar      = SUBSTR(RIBALTA2(ART_DATINS),1,6) + SUBSTR(RIBALTA2(ART_DATINS),9,2)		&&  12/06/2003
      Wvar      = RIBALTA2(ART_DATINS)			&&  12/06/2003
      wper      = ART_MDCPER
      wpqf      = ART_MDCQF
      WLOT      = Y_LOTTO
      wdes      = STRTRAN(wdes, '"', ' ')
      wdes      = STRTRAN(wdes, "'", " ")
      wtit      = 'Calcolo MDC prod.: '+wcod+' '+alltrim(wdes)
      SELECT RICETTE
      INDEX ON TIPO + STIPO + STR(SEQUE,4,0) TAG I_RICETTE ADDITIVE
      SELECT RICETTE
      SET ORDER TO I_RICETTE
      GO TOP
      IF !EOF() 
         IF DVD_TIPO = 'P'              && PREVIEW
            _V_PREVIEW = .T.
            _V_STAMPA  = .F.
         ELSE							&& STAMPA
            _V_PREVIEW = .F.
            _V_STAMPA  = .T.
         ENDIF  
         DO PRG\MENUSTA WITH "RICETTE",_V_PREVIEW,_V_STAMPA,"XXX","PROSTAR3","PROSTAR3.FRX"
      ENDIF
   ENDIF
ENDIF

V_ERRORE = 0
RETURN(V_ERRORE)


***************************************************************************
PROCEDURE PRORICA3
***************************************************************************

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.WCOD) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP

WLOT    = XLOTTO
CMAT    = 0.0
CLAV    = 0.0
TLAV    = 0.0
TMATU   = ART_CSTMAT
TMATU1  = ART_CSTMAT
TMATU2  = (ART_CSTMAT * RICACQ) / 100        &&  12/06/2003
TLAVU   = ART_CSTLAV
VARIAZ  = ART_DATINS
TUSERIE = 0.0
TORELAV = 0.0
MDCP    = 0.0
MDCQ    = 0.0
SIMACC  = 0
TCU     = ART_PRZCOS
ZLOTTO  = Y_LOTTO * M.WQTA

IF V_FINE
   SWSEQUE = 0
ENDIF

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "dit_gruppo = '" + ALLTRIM(M.WCOD) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"u_dis_tt")
   return(.f.)
ENDIF
SELECT U_DIS_TT
GO TOP
IF !EOF()
   AGGA   = TAGGANCIO
   x_codi = "daggancio = '" + AGGA + "'"
   cSql   = "SELECT * FROM U_DIS_DD WHERE " + x_codi + " order by daggancio,dis_sequen"
   IF !ExecCommand(cSql,"U_DIS_DD")
      return(.f.)
   ENDIF
   SELECT U_DIS_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF DAGGANCIO = AGGA
      ELSE
         EXIT
      ENDIF
      **==>  14/06/2002 INIZIO
      IF DIS_QTA = 0
         SKIP +1
         LOOP
      ENDIF
      **==>  14/06/2002 FINE
      X_CODART = DIS_CODART
      X_QTA    = DIS_QTA
      X_NOTDET = ALLTRIM(DIS_NOTE)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + X_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         MDCP = MDCP + ART_MDCPER        
         MDCQ = MDCQ + (ART_MDCQF * X_QTA)
         WSTIPO = 'B'
         IF ART_MDCPER = 0
            WSTIPO = 'D'
            CMAT = CMAT + ((X_QTA * ART_CSTMAT) * Y_LOTTO)
         ENDIF
         CLAV = CLAV + ((X_QTA * ART_CSTLAV) * Y_LOTTO)
         TLAV = TLAV + (X_QTA * ART_TMPLAV)
         IF V_FINE
            K_CSTOT  = X_QTA*ART_CSTMAT              				&&  12/06/2003
            K_CSTOTR = K_CSTOT + (K_CSTOT * RICACQ / 100)       				&&  12/06/2003
            *riga=SUBSTR(ART_CODPRI,1,12)+' '+ART_CODDIS+' '+ART_DESCR+' '+str(X_QTA,5,2)
            riga=SUBSTR(ART_CODPRI,1,12)+' '+ART_CODDIS+' '+SUBSTR(ART_DESCR,1,35)+' '+str(X_QTA,5,2)		&&  12/06/2003
            riga=riga+' '+str(ART_LOTTO,4)+' '+SUBSTR(RIBALTA2(ART_DATINS),1,6) + SUBSTR(RIBALTA2(ART_DATINS),9,2)+' '+str((ART_MDCQF*X_QTA),12,2)+' '+space(11)
            riga=riga+' '+str(ART_CSTMAT,10,2)+' '+space(04)+str((X_QTA*ART_CSTMAT),10,2)  
            riga=riga+' '+space(04)+str((K_CSTOTR),10,2)  	&&  12/06/2003
            IF WSTIPO = 'D'
               T1D=T1D+ART_CSTMAT
               T2D=T2D+ART_MDCPER
               T3D=T3D+(ART_MDCQF*X_QTA)
               T4D=T4D+(X_QTA*ART_CSTMAT)
               T5D=T5D+K_CSTOTR										&&  12/06/2003
            ELSE
               T1B=T1B+ART_CSTMAT
               T2B=T2B+ART_MDCPER
               T3B=T3B+(ART_MDCQF*X_QTA)
               T4B=T4B+(X_QTA*ART_CSTMAT)
               T5B=T5B+K_CSTOTR										&&  12/06/2003
            ENDIF
            SWSEQUE = SWSEQUE + 5
            select RICETTE
            append blank
            replace tipo   with 'A'
            replace stipo  with WSTIPO
            replace linea  with RIGA
            replace seque  with SWSEQUE
            IF SUBSTR(X_NOTDET,1,5) = SPACE(05) .OR. EMPTY(X_NOTDET) 
            ELSE
               select RICETTE
               append blank
               replace tipo   with 'A'
               replace stipo  with WSTIPO
               replace linea  with X_NOTDET
               replace seque  with SWSEQUE
            ENDIF
         ENDIF
      ENDIF
      SELECT U_DIS_DD
      SKIP +1
   ENDDO
ENDIF

IF V_FINE
   *  01/07/2003 - INIZIO
   select RICETTE
   append blank																
   replace tipo   with 'A'
   replace stipo  with 'B'
   replace linea  with SPACE(06)+SPACE(80)+' '+'----------'+' '+space(11)+' '+space(10)+' '+space(04)+'----------'+' '+space(04)+'----------'	
   replace seque  with 998
   *  01/07/2003 - FINE
   select RICETTE
   append blank
   replace tipo   with 'A'
   replace stipo  with 'B'
   *replace linea  with 'TOTALI'+SPACE(95)+' '+STR(T3B,10,2)+' '+space(11)+' '+STR(T1B,10,2)+' '+space(04)+STR(T4B,10,2)						&&  12/06/2003
   replace linea  with 'TOTALI'+SPACE(80)+' '+STR(T3B,10,2)+' '+space(11)+' '+space(10)+' '+space(04)+STR(T4B,10,2)+' '+space(04)+STR(T5B,10,2)	&&  12/06/2003
   replace seque  with 999
   *  01/07/2003 - INIZIO
   select RICETTE
   append blank
   replace tipo   with 'A'
   replace stipo  with 'D'
   replace linea  with SPACE(06)+SPACE(80)+' '+'----------'+' '+space(11)+' '+space(10)+' '+space(04)+'----------'+' '+space(04)+'----------'
   replace seque  with 998
   *  01/07/2003 - FINE
   select RICETTE
   append blank
   replace tipo   with 'A'
   replace stipo  with 'D'
   *replace linea  with 'TOTALI'+SPACE(95)+' '+STR(T3D,10,2)+' '+space(11)+' '+STR(T1D,10,2)+' '+space(04)+STR(T4D,10,2)						&&  12/06/2003
   replace linea  with 'TOTALI'+SPACE(80)+' '+STR(T3D,10,2)+' '+space(11)+' '+space(10)+' '+space(04)+STR(T4D,10,2)+' '+space(04)+STR(T5D,10,2)	&&  12/06/2003
  replace seque  with 999
ENDIF

MTU     = CLAV
MPM     = 0.0
STU     = TLAV
SPM     = 0.0

x_soci = "cit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cit_gruppo = '" + ALLTRIM(M.WCOD) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cic_tt where " + x_cond + " order by cit_codsoc,cit_gruppo"
IF !ExecCommand(cSql,"u_cic_tt")
   return(.f.)
ENDIF
SELECT u_cic_tt
GO TOP
IF !EOF()
   SIMACC = 1
   AGGA   = TAGGANCIO
   x_codi = "daggancio = '" + AGGA + "'"
   cSql   = "SELECT * FROM U_CIC_DD WHERE " + x_codi + " order by daggancio,cic_sequen"
   IF !ExecCommand(cSql,"U_CIC_DD")
      return(.f.)
   ENDIF
   SELECT U_CIC_DD
   GO TOP
   IF !EOF()
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         X_MACCHI = CIC_MACCHI
         X_CSTPM  = CIC_CSTPM
         X_CSTTM  = CIC_CSTTM
         x_codi = "mac_codice = " + ALLTRIM(STR(X_MACCHI,3,0)) 
         x_cond = x_codi
         Csql   = "select * from u_mac_an where " + x_cond + " order by mac_codice"
         IF !ExecCommand(cSql,"cur_macchine")
            return(.f.)
         ENDIF
         SELECT cur_macchine
         GO TOP
         IF !EOF()
            MTU = MTU + ((X_CSTPM * MAC_CSTMTM) * ZLOTTO)
            MPM = MPM + (X_CSTTM * MAC_CSTMPM)
            STU = STU + (X_CSTPM * ZLOTTO)
            SPM = SPM + X_CSTTM
         ENDIF
         SELECT U_CIC_DD
         SKIP +1
      ENDDO
   ENDIF
ENDIF

IF ZLOTTO = 0
   TMATU  = 0.0
   TLAVU  = 0.0
   TUSERIE= 0.0
   TMATU2 = 0.0 				  	&&  12/06/2003
ELSE
   TMATU  = CMAT / ZLOTTO
   TLAVU  = (MTU + MPM) / ZLOTTO
   TUSERIE= (STU + SPM) / ZLOTTO
   TMATU2 = (TMATU * RICACQ) / 100   &&  12/06/2003
ENDIF

TORELAV = STU + SPM
TCU     = TMATU + TLAVU
IF ZLOTTO = 0
   STU    = 0.0
   MTU    = 0.0
ELSE
   STU    = STU / ZLOTTO
   MTU    = MTU / ZLOTTO
ENDIF

TMATU = CMAT / Y_LOTTO
TMATU2 = (TMATU * RICACQ) / 100			&&  12/06/2003

V_AGGIORNA = .T.
IF V_FINE
   IF _TIPO = 'CALC' .OR. _TIPO = 'STAM'
      V_AGGIORNA = .F.
   ENDIF
ENDIF
IF V_AGGIORNA
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.WCOD) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecRW(cSql,"u_art_pr","R")
      return(.f.)
   ENDIF
   SELECT u_art_pr
   GO TOP
   IF !EOF()
      IF ART_MDCPER > 0
         REPLACE ART_CSTMAT WITH TMATU
         REPLACE ART_CSTLAV WITH TLAVU
         REPLACE ART_DATINS WITH RIBALTA2(DTOC(DATE()))
         REPLACE ART_PRZCOS WITH TCU
         REPLACE ART_TMPLAV WITH TLAV
         REPLACE ART_LOTTO  WITH ZLOTTO 
      ENDIF
   ENDIF 
   IF !ExecRW(cSql,"u_art_pr","W")
      return(.f.)
   ENDIF
ENDIF

RETURN


***************************************************************************
PROCEDURE PRORICA4
***************************************************************************

M.G099  = TMATU2				&&  12/06/2003
M.G100  = TMATU 
M.G101  = 0.0 
M.G103  = 0.0 
M.G106  = 0.0 
M.G107  = 0.0 
M.G108  = 0.0 
M.G110  = 0.0 
M.E112  = 0.0 
M.E114  = 0.0 
M.E115  = 0.0 
M.E117  = 0.0 
M.E119  = 0.0 
M.E121  = 0.0 
M.E122  = 0.0 
M.E123  = 0.0 
M.E125  = 0.0 
M.E126  = 0.0 
M.E129  = M.MDC_PERIVC
M.E131  = 0.0 
M.E121B = 0.0 
M.G70   = M.MDC_QTFIHH 
M.G71   = M.MDC_PERCEN 
M.G72   = M.MDC_RAPCST
*XCOERIC = M.MDC_RICACQ			&&  12/06/2003

x_soci = "cit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cit_gruppo = '" + ALLTRIM(M.WCOD) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cic_tt where " + x_cond + " order by cit_codsoc,cit_gruppo"
IF !ExecCommand(cSql,"u_cic_tt")
   return(.f.)
ENDIF
SELECT u_cic_tt
GO TOP
IF !EOF()
   AGGA = TAGGANCIO
   x_codi = "daggancio = '" + AGGA + "'"
   cSql   = "SELECT * FROM U_CIC_DD WHERE " + x_codi + " order by daggancio,cic_sequen"
   IF !ExecCommand(cSql,"U_CIC_DD")
      return(.f.)
   ENDIF
   SELECT U_CIC_DD
   GO TOP
   IF !EOF()
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         x_codi = "mac_codice = " + ALLTRIM(STR(M.CIC_MACCHI,3,0)) 
         x_cond = x_codi
         Csql   = "select * from u_mac_an where " + x_cond + " order by mac_codice"
         IF !ExecCommand(cSql,"cur_macchine")
            return(.f.)
         ENDIF
         SELECT cur_macchine
         GO TOP
         IF !EOF()
            M.CIC_HTP    = MAC_COEFPO * M.CIC_CSTPM
            M.CIC_TP     = MAC_CSTOTP * M.CIC_HTP  
            M.CIC_LHTP   = MAC_CSTOTP
            M.CIC_LHTM   = MAC_CSTOTM
            M.CIC_LHPM   = MAC_CSTOPM
            M.CIC_TMPMN  = 0
            M.CIC_PMN    = 0
            IF ZLOTTO    > 0
               M.CIC_TMPMN = M.CIC_LHTM * (M.CIC_CSTPM + (M.CIC_CSTTM / ZLOTTO))
               M.CIC_PMN   = M.CIC_LHPM * M.CIC_CSTTM / ZLOTTO
            ENDIF
            SELECT U_CIC_DD
            GATHER MEMVAR MEMO
            IF V_FINE
               xtotpm  = xtotpm + M.CIC_CSTTM
               xtottm  = xtottm + M.CIC_CSTPM
               SWSEQUE = M.CIC_SEQUEN
               riga=str(M.CIC_MACCHI,3)+' '+SUBSTR(M.CIC_DESCRI,1,32)+' '+str(M.CIC_CSTPM,10,2)
               riga=riga+' '+str(M.CIC_CSTTM,10,2)+space(6)
               riga=riga+' '+str(M.CIC_TMPMN,10,2)
               riga=riga+' '+str(M.CIC_TP,10,2)
               riga=riga+' '+str(M.CIC_PMN,10,2)
               riga=riga+' '+str((M.CIC_TMPMN+M.CIC_TP+M.CIC_PMN),10,2)+' '+ALLTRIM(M.CIC_NOTVAR)
               select RICETTE
               append blank
               replace tipo   with 'B'
               replace stipo  with 'B'
               replace linea  with RIGA
               replace seque  with SWSEQUE
            ENDIF
         ENDIF
         SELECT U_CIC_DD
         M.G106 = M.G106 + M.CIC_TMPMN
         M.G107 = M.G107 + M.CIC_TP
         M.G108 = M.G108 + M.CIC_PMN
         M.E114 = M.E114 + M.CIC_CSTTM
         M.E115 = M.E115 + M.CIC_HTP
         SKIP +1
      ENDDO
   ENDIF
ENDIF

IF V_FINE
   *  01/07/2003 - INIZIO
   select RICETTE
   append blank
   replace tipo   with 'B'
   replace stipo  with 'B'
   replace linea  with SPACE(03) + '                 ' + SPACE(17) + '----------' + ' ' + '----------'
   replace seque  with 998
   *  01/07/2003 - FINE
   select RICETTE
   append blank
   replace tipo   with 'B'
   replace stipo  with 'B'
   replace linea  with SPACE(03) + '  TOTALI TM e PM ' + SPACE(17) + STR(xtotTm,10,2) + ' ' + STR(xtotPm,10,2)
   replace seque  with 999
ENDIF

IF ZLOTTO = 0
ELSE
   M.E114 = M.E114 / ZLOTTO
ENDIF

M.G103  = M.G100  + M.G101
M.G110  = M.G106  + M.G107 + M.G108
*M.G1110 = M.G1110 + M.G110
*M.E112  = M.G103  + M.G110
M.G099   = M.G100 + ((M.G100 * RICACQ) / 100)			&&  01/07/2003
M.E112   = M.G099  + M.G110 							&&  01/07/2003
M.E117  = M.E114  + M.E115
M.E119  = M.G70   * M.E117
M.E121  = M.E112  + M.E119
M.E122  = M.E121  - M.E112
M.E123  = (M.E122 / M.E121) * 100
M.E125  = M.E121  * M.G71 / 100
M.E126  = M.E112  / ((100 - M.G71) / 100)
M.E131  = M.E126  + (M.E126 * M.E129 / 100)
M.E131  = M.E131  + MDCP
M.E121B = MDCQ    + (M.E121 + (M.E121 * M.E129 / 100))
*M.E121C = M.E121B * XCOERIC						&&  12/06/2003
M.E121C = (M.E121B * XCOERIC) / 100					&&  12/06/2003
M.E121B = M.E121C + M.E121B
M.G10099 = M.G099									&&  01/07/2003


RETURN


*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _DADOVE = NOME DELLA FUNZIONE O FORM O PRG DA CUI VIENE CHIAMATA
*           => 'ACQ' 'BFO'         = PROVENIENTE DA OPERAZIONI DI CARICO DA FORNITORE
*           => 'VEN' 'ECASH' 'BOL' = PROVENIENTE DA OPERAZIONI DI SCARICO PER VENDITA A CLIENTI
* _GENMOV = GENERAZIONE DEL MOVIMENTO
*           => 'SI' = GENERA IL MOVIMENTO (U_MAG_MO)
* _TIPO   = TIPO DI PROVENIENZA (DA COMPONENTI)
*           => 'GIA' = TOCCA LA GIACENZA
* _IMPE   = FLAG DI GESTIONE IMPEGNATO
*           => 'X' = GESTISCE CAMPI IMPEGNATO
* _MAGSCA = CODICE DEL MAGAZZINO DA CUI SCARICARE
* _MAGCAR = CODICE DEL MAGAZZINO SU CUI CARICARE
* _CODART = CODICE DELL'ARTICOLO DA MOVIMENTARE
* _TOPSCA = CODICE CAUSALE PER LO SCARICO
* _TOPCAR = CODICE CAUSALE PER IL CARICO
* _QUANTI = QUANTITA' DA MOVIMENTARE
* _NUMDOC = NUMERO DEL DOCUMENTO CHE HA GENERATO IL MOVIMENTO
* _DATDOC = DATA DEL DOCUMENTO CHE HA GENERATO IL MOVIMENTO
* _DATREG = DATA IN CUI E' AVVENUTA LA REGISTRAZIONE
* _ORAMOV = ORA IN CUI E' AVVENUTA LA REGISTRAZIONE DEL MOVIMENTO
* _CLIFOR = CODICE DEL CLIENTE/FORNITORE CHE HA GENERATO IL MOVIMENTO
* _PRZACQ = PREZZO DI ACQUISTO (SIGNIFICATIVO SOLO PER OPERAZIONI DI CARICO DA ACQUISTI)
* _PRZVEN = PREZZO DI VENDITA (SIGNIFICATIVO SOLO PER OPERAZIONI DI SCARICO PER VENDITA)
* _CODIVA = CODICE IVA
* _SCONTO = PERCENTUALE DI SCONTO
* _VALUTA = CODICE VALUTA
* _NOTE   = NOTE VARIE
* _CSC    = BOOOO
* _SAC    = ROTTURA PEZZO IN AVANZAMENTO LAVORI (PRODUZIONE)
* _GGG    = GESTISCE IL MAGAZZINO RIEPILOGATO PER GIORNO
* _FORNIT = CODICE FORNITORE DA CUI E' STATO SCARICATO IN FASE DI INCASSO
* _FLGTRA = FLAG CHE INDICA SE IL RECORD MOVIMENTO E' STATO TRASMESSO OPPURE NO
*
*******************************************************************************

FUNCTION MOVIMAGA
PARAMETERS _DADOVE,_GENMOV,_TIPO,_IMPE,_MAGSCA,_MAGCAR,_CODART,_TOPSCA,_TOPCAR,_QUANTI,_NUMDOC,_DATDOC,_DATREG,_ORAMOV,_CLIFOR,_PRZACQ,_PRZVEN,_CODIVA,_SCONTO,_VALUTA,_NOTE,_CSC,_SAC,_GGG,_FORNIT,_FLGTRA

_N_PAR = PARAMETERS()											
IF _N_PAR  = 24											
   _FORNIT = ""													
ENDIF														

IF SUBSTR(_DATDOC,3,1) = '/'
   _DATDOC = RIBALTA2(_DATDOC)
ENDIF
IF SUBSTR(_DATREG,3,1) = '/'
   _DATREG = RIBALTA2(_DATREG)
ENDIF

PRIMA=SELECT()

v_seek   = 'TOP'+_TOPSCA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   M.NAT  = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
   M.LIB  = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
   M.TMOV = SUBSTR(LIBERA,33,2)				
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF M.NAT = 'C' .OR. M.NAT = 'S'
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF M.NAT = 'C'									
   X_SEGNO = '+'								
ELSE
   X_SEGNO = '-'								
ENDIF												

A_DESART = SPACE(45)
A_UNIMIS = SPACE(02)
A_PRZCOS = 0
A_PRZVEN = 0
A_CODIVA = SPACE(03)
A_CODTAG = SPACE(03)
A_DESTAG = SPACE(30)
A_CODCOL = SPACE(03)
A_DESCOL = SPACE(30)
A_COORD  = SPACE(30)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF RECCOUNT() <> 0
   IF ART_NONMOV
      RETURN
   ENDIF
   SCATTER MEMVAR MEMO
   IF X_SEGNO = '+'
      IF _DADOVE = 'ACQ' .OR. SUBSTR(_DADOVE,1,3) = 'BFO'
         IF _PRZACQ > 0
            REPLACE ART_PRZCOS WITH _PRZACQ
         ENDIF
         IF ART_ULDCAR < _DATDOC .OR. (ART_ULDCAR = _DATDOC .AND. ART_ULNCAR < _NUMDOC)
            REPLACE ART_ULDCAR WITH _DATDOC
            REPLACE ART_ULNCAR WITH _NUMDOC
            REPLACE ART_ULQCAR WITH _QUANTI
            REPLACE ART_ULPCAR WITH _PRZACQ
         ENDIF
         IF ART_CODF1 = _CLIFOR .OR. ART_CODF2 = _CLIFOR .OR. ART_CODF3 = _CLIFOR
            IF ART_CODF1 = _CLIFOR
               REPLACE ART_PRZCO1 WITH _PRZACQ
            ENDIF
            IF ART_CODF2 = _CLIFOR
               REPLACE ART_PRZCO2 WITH _PRZACQ
            ENDIF
            IF ART_CODF3 = _CLIFOR
               REPLACE ART_PRZCO3 WITH _PRZACQ
            ENDIF
         ELSE
            IF ART_CODF1 = SPACE(10) .OR. EMPTY(ART_CODF1)
               REPLACE ART_CODF1  WITH _CLIFOR
               REPLACE ART_PRZCO1 WITH _PRZACQ
            ELSE
               IF ART_CODF2 = SPACE(10) .OR. EMPTY(ART_CODF2)
                  REPLACE ART_CODF2  WITH _CLIFOR
                  REPLACE ART_PRZCO2 WITH _PRZACQ
               ELSE
                  IF ART_CODF3 = SPACE(10) .OR. EMPTY(ART_CODF3)
                     REPLACE ART_CODF3  WITH _CLIFOR
                     REPLACE ART_PRZCO3 WITH _PRZACQ
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         REPLACE ART_TOTCAR WITH ART_TOTCAR + _QUANTI
         x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
         x_maga   = "fpr_codmag = '" + ALLTRIM(_MAGSCA) + "'"
         x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
         x_forn   = "fpr_codfor = '" + ALLTRIM(_CLIFOR) + "'"
         x_cond   = x_soci + " and " + x_maga + " and " + x_codi + " and " + x_forn
         Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_codfor"
         IF !ExecRW(cSql,"U_FOR_PR","R")
            return(.f.)
         ENDIF
         SELECT U_FOR_PR
         GO TOP
         IF !EOF()
            IF FPR_DATUCA > _DATDOC
            ELSE
               REPLACE FPR_DATUCA WITH _DATDOC
               REPLACE FPR_NUMUCA WITH _NUMDOC
               REPLACE FPR_QTAUCA WITH _QUANTI
               REPLACE FPR_PRZUCA WITH _PRZACQ
            ENDIF
         ELSE
            F_RAGSOC = ""
            F_INDIRI = ""
            F_LOCALI = ""
            F_CAP    = ""
            F_PROVIN = ""
            F_TELEFO = ""
            x_soci   = "for_codsoc = '" + PUB_CODSOC + "'"
            x_codi   = "for_codcli = '" + ALLTRIM(_CLIFOR) + "'"
            x_cond   = x_soci + " and " + x_codi
            Csql     = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
            IF !ExecCommand(cSql,"u_for_an")
               return(.f.)
            ENDIF
            SELECT u_for_an
            GO TOP
            IF !EOF()
               F_RAGSOC = FOR_RAGSOC
               F_INDIRI = FOR_INDIR
               F_LOCALI = FOR_LOCALI
               F_CAP    = FOR_CAP
               F_PROVIN = FOR_PROVIN
               F_TELEFO = FOR_TELEFO
            ENDIF
            SELECT U_FOR_PR
            APPEND BLANK
            REPLACE FPR_CODSOC WITH PUB_CODSOC
            REPLACE FPR_CODMAG WITH _MAGSCA
            REPLACE FPR_CODART WITH _CODART
            REPLACE FPR_DESART WITH M.ART_DESCR 
            REPLACE FPR_CODFOR WITH _CLIFOR 
            REPLACE FPR_RAGFOR WITH F_RAGSOC 
            REPLACE FPR_INDIRI WITH F_INDIRI 
            REPLACE FPR_LOCALI WITH F_LOCALI 
            REPLACE FPR_CAP    WITH F_CAP 
            REPLACE FPR_PROVIN WITH F_PROVIN 
            REPLACE FPR_TELEFO WITH F_TELEFO 
            REPLACE FPR_DATUCA WITH _DATDOC
            REPLACE FPR_NUMUCA WITH _NUMDOC
            REPLACE FPR_QTAUCA WITH _QUANTI
            REPLACE FPR_PRZUCA WITH _PRZACQ
            REPLACE FPR_PRZCON WITH _PRZACQ
            REPLACE FPR_SEQPRI WITH 999
         ENDIF
         IF !ExecRW(cSql,"U_FOR_PR","W")
            return(.f.)
         ENDIF
      ENDIF
   ELSE
      IF _DADOVE = 'VEN' .OR. _DADOVE = 'ECASH' .OR. SUBSTR(_DADOVE,1,3) = 'BOL'
         IF ART_ULDSCA < _DATDOC .OR. (ART_ULDSCA = _DATDOC .AND. ART_ULNSCA < _NUMDOC)
            REPLACE ART_ULDSCA WITH _DATDOC
            REPLACE ART_ULNSCA WITH _NUMDOC
            REPLACE ART_ULQSCA WITH _QUANTI
            REPLACE ART_ULPSCA WITH _PRZVEN
            REPLACE ART_TOTSCA WITH ART_TOTSCA + _QUANTI
         ENDIF
      ENDIF
   ENDIF
   A_DESART = ART_DESCR
   A_UNIMIS = ART_UNIMIS
   A_PRZCOS = ART_PRZCOS
   A_PRZVEN = ART_PRZVEN
   A_CODIVA = ART_CODIVA
   A_CODTAG = ART_CODTAG
   A_DESTAG = ART_DESTAG
   A_CODCOL = ART_CODCOL
   A_DESCOL = ART_DESCOL
   A_COORD  = ART_COORD
   IF !ExecRW(cSql,"U_ART_PR","W")
      return(.f.)
   ENDIF
ELSE
   RETURN
ENDIF   

*-->> RICERCA DELL'ANAGRAFICA FORNITORE/CLIENTE  ----------------------------

RELEASE M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV,M_GIAFOR,M_PRZUCA
PUBLIC  M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV,M_GIAFOR,M_PRZUCA
M_CLIFOR = _CLIFOR
M_RAGSOC = ""
M_FORNIT = ""
M_DESFOR = ""
M_PRIMOF = _CLIFOR
M_QTAFOR = 0
M_QUANTI = _QUANTI
M_GENMOV = _GENMOV
M_GIAFOR = 0
M_PRZUCA = 0

*==> OPERAZIONI SUL MAGAZZINO PRINCIPALE
=MAGAMOVI(_MAGSCA,_TOPSCA)

XYZ_FORNIT = M_FORNIT
XYZ_RAGSOC = M_RAGSOC
XYZ_PRZUCA = M_PRZUCA

* INIZIO -  PER MAGAZZINO VIAGGIANTE
IF _TOPSCA = PUB_CAUTRA .OR. (_TOPSCA = PUB_CAURES .AND. _CLIFOR = PUB_CFDEF)
   _MAGCAR = 'VIAGGI'
ENDIF
IF _DADOVE = 'BFOSCMAG' .OR. _DADOVE = 'BFOCAMAG'
   IF ZZZ_FLGTIP = 0
   ELSE
      H_MAGCAR = "VIAGGI"
   ENDIF
ENDIF
* FINE -  PER MAGAZZINO VIAGGIANTE

IF EMPTY(ALLTRIM(_MAGCAR)) 
ELSE
   *==> OPERAZIONI SUL MAGAZZINO COLLEGATO
   v_seek   = 'TOP'+_TOPSCA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      _TOPCAR = SUBSTR(LIBERA,35,3)
   ENDIF
   IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
      IF X_SEGNO = '+' 
         _TOPCAR = '200'
         X_SEGNO = '-'
      ELSE
         _TOPCAR = '100'
         X_SEGNO = '+'
      ENDIF  
   ENDIF
   =MAGAMOVI(_MAGCAR,_TOPCAR)
ENDIF

RETURN


*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _MAG = MAGAZZINO (DI CARICO/SCARICO)
* _TOP = CAUSALE   (DI CARICO/SCARICO) 
*
*******************************************************************************

FUNCTION MAGAMOVI
PARAMETERS _MAG,_TOP

*SET STEP ON 

v_seek   = 'TOP'+_TOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   M.NAT  = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
   M.LIB  = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
   M.TMOV = SUBSTR(LIBERA,33,2)				
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF EMPTY(M_CLIFOR) .OR. M_CLIFOR = SPACE(10)
ELSE
   IF X_SEGNO = '+'
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
      IF !EOF()
         M_RAGSOC = FOR_RAGSOC
      ELSE
         x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "cli_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
         x_cond = x_soci + " and " + x_codi
         Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
         IF !ExecCommand(cSql,"u_cli_an")
            return(.f.)
         ENDIF
         SELECT u_cli_an
         GO TOP
         IF !EOF()
            M_RAGSOC = CLI_RAGSOC
         ENDIF
      ENDIF
   ELSE
      x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "cli_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
      IF !ExecCommand(cSql,"u_cli_an")
         return(.f.)
      ENDIF
      SELECT u_cli_an
      GO TOP
      IF !EOF()
         M_RAGSOC = CLI_RAGSOC
      ELSE
         x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "for_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
         x_cond = x_soci + " and " + x_codi
         Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
         IF !ExecCommand(cSql,"u_for_an")
            return(.f.)
         ENDIF
         SELECT u_for_an
         GO TOP
         IF !EOF()
            M_RAGSOC = FOR_RAGSOC
         ENDIF
      ENDIF
   ENDIF
ENDIF

*-->> RICERCA DEL FORNITORE PRINCIPALE CON AGGIORNAMENTO GIACENZE PER FORNITORE E MOVIMENTI --

IF _GGG = "SI"

   IF _DADOVE = 'VEN' .OR. _DADOVE = 'ECASH' .OR. SUBSTR(_DADOVE,1,3) = 'BOL'
    IF X_SEGNO = '+'
    ELSE
      M_PRIMOF = ""
      IF EMPTY(_FORNIT) .OR. _FORNIT = SPACE(10)
         x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
         x_maga   = "fpr_codmag = '" + ALLTRIM(_MAG) + "'"
         x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
         x_cond   = x_soci + " and " + x_maga + " and " + x_codi 
         Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_seqpri"
         IF !ExecCommand(cSql,"U_FOR_PR")
            return(.f.)
         ENDIF
      ELSE
         x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
         x_maga   = "fpr_codmag = '" + ALLTRIM(_MAG) + "'"
         x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
         x_forn   = "fpr_codfor = '" + ALLTRIM(_FORNIT) + "'"
         x_cond   = x_soci + " and " + x_maga + " and " + x_codi + " and " + x_forn
         Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_codfor,fpr_seqpri"
         IF !ExecCommand(cSql,"U_FOR_PR")
            return(.f.)
         ENDIF
      ENDIF
      SELECT U_FOR_PR
      GO TOP
      IF EOF()
         SELECT U_FOR_PR
         APPEND BLANK
         REPLACE FPR_CODFOR WITH _FORNIT
      ENDIF
                
      M_PRIMOF = FPR_CODFOR

      M_QUANTI = _QUANTI

      DO WHILE .T.

         IF EOF()
            EXIT
         ENDIF

         M_FORNIT = FPR_CODFOR
         M_DESFOR = ""
         M_PRZUCA = FPR_PRZUCA

         *-->> RICERCA DELLA RAGIONE SOCIALE DEL FORNITORE DI CARICO
         x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "for_codcli = '" + ALLTRIM(M_FORNIT) + "'"
         x_cond = x_soci + " and " + x_codi
         Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
         IF !ExecCommand(cSql,"u_for_an")
            return(.f.)
         ENDIF
         SELECT u_for_an
         GO TOP
         IF !EOF()
            M_DESFOR = FOR_RAGSOC
         ELSE 
            M_DESFOR = ""
         ENDIF

         *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
         x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
         x_data   = "mag_datagg = '" + SPACE(10) + "'"
         x_codi   = "mag_codart = '" + ALLTRIM(_CODART) + "'"
         x_maga   = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
         x_forn   = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
         x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
         Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
         IF !ExecRW(cSql,"U_MAG_GG","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_GG

         IF RECCOUNT() = 0
            APPEND BLANK
            REPLACE MAG_CODSOC WITH PUB_CODSOC
            REPLACE MAG_DATAGG WITH SPACE(10)
            REPLACE MAG_CODMAG WITH _MAG
            REPLACE MAG_CODART WITH _CODART
            REPLACE MAG_DESART WITH A_DESART
            REPLACE MAG_CODPDV WITH PUB_CODBUN
            REPLACE MAG_FORNIT WITH M_FORNIT
            REPLACE MAG_DESFOR WITH M_DESFOR
            REPLACE MAG_GIACEN WITH 0
         ENDIF

         IF X_SEGNO = '+'
            REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QUANTI
            M_QTAFOR = M_QUANTI
            M_QUANTI = 0
         ELSE
            IF MAG_GIACEN > 0
               IF MAG_GIACEN > M_QUANTI
                  REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QUANTI
                  M_QTAFOR = M_QUANTI
                  M_QUANTI = 0
               ELSE
                  M_QUANTI = M_QUANTI - MAG_GIACEN
                  M_QTAFOR = MAG_GIACEN
                  REPLACE MAG_GIACEN WITH 0
               ENDIF
            ELSE
               IF !ExecRw(cSql,"U_MAG_GG","W")
                  return(.f.)
               ENDIF
               SELECT U_FOR_PR
               SKIP +1
               LOOP
            ENDIF
         ENDIF
         M_GIAFOR = MAG_GIACEN
         IF !ExecRw(cSql,"U_MAG_GG","W")
            return(.f.)
         ENDIF

         *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
         x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
         x_data = "mag_datagg = '" + _DATREG + "'"
         x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
         x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
         x_forn = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
         x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
         Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
         IF !ExecRW(cSql,"U_MAG_GG","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_GG
         IF RECCOUNT() <> 0
            IF X_SEGNO = '+'
               REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
            ELSE
               REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE MAG_CODSOC WITH PUB_CODSOC
            REPLACE MAG_DATAGG WITH _DATREG
            REPLACE MAG_CODMAG WITH _MAG
            REPLACE MAG_CODART WITH _CODART
            REPLACE MAG_DESART WITH A_DESART
            REPLACE MAG_CODPDV WITH PUB_CODBUN
            REPLACE MAG_FORNIT WITH M_FORNIT
            REPLACE MAG_DESFOR WITH M_DESFOR
            REPLACE MAG_GIACEN WITH M_GIAFOR
         ENDIF
         IF !ExecRW(cSql,"U_MAG_GG","W")
            return(.f.)
         ENDIF

         IF _GENMOV = "SI"
            * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO ---------------------------
            Csql   = "select * from u_mag_mo"
            IF !ExecRW(cSql,"U_MAG_MO","R")
               return(.f.)
            ENDIF
            SELECT U_MAG_MO
            APPEND BLANK
            REPLACE MOV_CODSOC WITH PUB_CODSOC
            REPLACE MOV_CODMAG WITH _MAG
            REPLACE MOV_CODART WITH _CODART
            REPLACE MOV_DESART WITH A_DESART
            REPLACE MOV_TOP    WITH _TOP
            REPLACE MOV_QTAMOV WITH M_QTAFOR
            IF _PRZVEN = 0
               REPLACE MOV_PREVEN WITH A_PRZVEN
            ELSE
               REPLACE MOV_PREVEN WITH _PRZVEN
            ENDIF
            IF _PRZACQ = 0
               REPLACE MOV_PREACQ WITH A_PRZCOS
            ELSE
               REPLACE MOV_PREACQ WITH _PRZACQ
            ENDIF
            IF EMPTY(_CODIVA)
               REPLACE MOV_IVAVEN WITH A_CODIVA
            ELSE
               REPLACE MOV_IVAVEN WITH _CODIVA
            ENDIF
            IF EMPTY(_VALUTA)
               REPLACE MOV_VALUTA WITH PUB_VALRIF
            ELSE
               REPLACE MOV_VALUTA WITH _VALUTA
            ENDIF
            REPLACE MOV_SCONTO WITH _SCONTO
            REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
            REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
            REPLACE MOV_NUMDOC WITH _NUMDOC
            REPLACE MOV_DTDOCU WITH _DATDOC
            REPLACE MOV_CODFOR WITH M_CLIFOR
            REPLACE MOV_RAGSOC WITH M_RAGSOC
            REPLACE MOV_DTREGI WITH _DATREG
            REPLACE MOV_CODTAG WITH A_CODTAG
            REPLACE MOV_DESTAG WITH A_DESTAG
            REPLACE MOV_CODCOL WITH A_CODCOL
            REPLACE MOV_DESCOL WITH A_DESCOL
            REPLACE MOV_NOTVAR WITH _NOTE
            REPLACE MOV_UM     WITH A_UNIMIS
            REPLACE MOV_CODPDV WITH PUB_CODBUN				
            REPLACE MOV_ORAMOV WITH _ORAMOV					
            REPLACE MOV_SEGNO  WITH X_SEGNO					
            REPLACE MOV_TIPMOV WITH M.TMOV				
            REPLACE MOV_FORNIT WITH M_FORNIT
            REPLACE MOV_DESFOR WITH M_DESFOR
            REPLACE MOV_COORD  WITH A_COORD
            REPLACE MOV_FLGTRA WITH _FLGTRA
            REPLACE MOV_UNIQUE WITH SYS(2015)
            IF _CSC = 'X'
               scatter memvar
            ENDIF
            IF !ExecRW(cSql,"U_MAG_MO","W")
               return(.f.)
            ENDIF
         ENDIF

         **==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
         IF _PRZVEN = 0
            R_PRZVEN = A_PRZVEN
         ELSE
            R_PRZVEN = _PRZVEN
         ENDIF
         IF _PRZACQ = 0
            R_PRZCOS = A_PRZCOS
         ELSE 
            R_PRZCOS = _PRZACQ
         ENDIF
         *=MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATDOC,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_CLIFOR)

         IF M_QUANTI = 0
            EXIT
         ENDIF

         SELECT U_FOR_PR
         SKIP +1

      ENDDO

      SELECT U_FOR_PR
      USE
      
    ENDIF

   ENDIF

   IF M_QUANTI = 0
   ELSE
      M_QTAFOR = M_QUANTI
      M_FORNIT = M_PRIMOF
      M_DESFOR = ""

      *-->> RICERCA DELLA RAGIONE SOCIALE DEL FORNITORE DI CARICO
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(M_FORNIT) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
      IF !EOF()
         M_DESFOR = FOR_RAGSOC
      ELSE 
         M_DESFOR = ""
      ENDIF

      *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
      x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_data   = "mag_datagg = '" + SPACE(10) + "'"
      x_codi   = "mag_codart = '" + ALLTRIM(_CODART) + "'"
      x_maga   = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
      x_forn   = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
      x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
      Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
      IF !ExecRW(cSql,"U_MAG_GG","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_GG
      IF RECCOUNT() <> 0
         IF X_SEGNO = '+'
            REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
         ELSE
            REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE MAG_CODSOC WITH PUB_CODSOC
         REPLACE MAG_CODMAG WITH _MAG
         REPLACE MAG_CODART WITH _CODART
         REPLACE MAG_DESART WITH A_DESART
         REPLACE MAG_CODPDV WITH PUB_CODBUN
         REPLACE MAG_FORNIT WITH M_FORNIT
         REPLACE MAG_DESFOR WITH M_DESFOR
         IF X_SEGNO = '+'
            REPLACE MAG_GIACEN WITH M_QTAFOR
         ELSE
            REPLACE MAG_GIACEN WITH M_QTAFOR * (-1)
         ENDIF 
      ENDIF
      M_GIAFOR = MAG_GIACEN
      IF !ExecRw(cSql,"U_MAG_GG","W")
         return(.f.)
      ENDIF

      *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_data = "mag_datagg = '" + _DATREG + "'"
      x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
      x_forn = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
      Csql   = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
      IF !ExecRW(cSql,"U_MAG_GG","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_GG
      IF RECCOUNT() <> 0
         IF X_SEGNO = '+'
            REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
         ELSE
            REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
         ENDIF
      ELSE
         APPEND BLANK
         REPLACE MAG_CODSOC WITH PUB_CODSOC
         REPLACE MAG_DATAGG WITH _DATREG
         REPLACE MAG_CODMAG WITH _MAG
         REPLACE MAG_CODART WITH _CODART
         REPLACE MAG_DESART WITH A_DESART
         REPLACE MAG_CODPDV WITH PUB_CODBUN
         REPLACE MAG_FORNIT WITH M_FORNIT
         REPLACE MAG_DESFOR WITH M_DESFOR
         REPLACE MAG_GIACEN WITH M_GIAFOR
      ENDIF
      IF !ExecRW(cSql,"U_MAG_GG","W")
         return(.f.)
      ENDIF

      IF _GENMOV = "SI"
         * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO ---------------------------
         Csql   = "select * from u_mag_mo"
         IF !ExecRW(cSql,"U_MAG_MO","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_MO
         APPEND BLANK
         REPLACE MOV_CODSOC WITH PUB_CODSOC
         REPLACE MOV_CODMAG WITH _MAG
         REPLACE MOV_CODART WITH _CODART
         REPLACE MOV_DESART WITH A_DESART
         REPLACE MOV_TOP    WITH _TOP
         REPLACE MOV_QTAMOV WITH M_QTAFOR
         IF _PRZVEN = 0
            REPLACE MOV_PREVEN WITH A_PRZVEN
         ELSE
            REPLACE MOV_PREVEN WITH _PRZVEN
         ENDIF
         IF _PRZACQ = 0
            REPLACE MOV_PREACQ WITH A_PRZCOS
         ELSE
            REPLACE MOV_PREACQ WITH _PRZACQ
         ENDIF
         IF EMPTY(_CODIVA)
            REPLACE MOV_IVAVEN WITH A_CODIVA
         ELSE
            REPLACE MOV_IVAVEN WITH _CODIVA
         ENDIF
         IF EMPTY(_VALUTA)
            REPLACE MOV_VALUTA WITH PUB_VALRIF
         ELSE
            REPLACE MOV_VALUTA WITH _VALUTA
         ENDIF
         REPLACE MOV_SCONTO WITH _SCONTO
         REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
         REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
         REPLACE MOV_NUMDOC WITH _NUMDOC
         REPLACE MOV_DTDOCU WITH _DATDOC
         REPLACE MOV_CODFOR WITH M_CLIFOR
         REPLACE MOV_RAGSOC WITH M_RAGSOC
         REPLACE MOV_DTREGI WITH _DATREG
         REPLACE MOV_CODTAG WITH A_CODTAG
         REPLACE MOV_DESTAG WITH A_DESTAG
         REPLACE MOV_CODCOL WITH A_CODCOL
         REPLACE MOV_DESCOL WITH A_DESCOL
         REPLACE MOV_NOTVAR WITH _NOTE
         REPLACE MOV_UM     WITH A_UNIMIS
         REPLACE MOV_CODPDV WITH PUB_CODBUN				
         REPLACE MOV_ORAMOV WITH _ORAMOV					
         REPLACE MOV_SEGNO  WITH X_SEGNO					
         REPLACE MOV_TIPMOV WITH M.TMOV				
         REPLACE MOV_FORNIT WITH M_FORNIT
         REPLACE MOV_DESFOR WITH M_DESFOR
         REPLACE MOV_COORD  WITH A_COORD
         REPLACE MOV_FLGTRA WITH _FLGTRA
         REPLACE MOV_UNIQUE WITH SYS(2015)
         IF _CSC = 'X'
            scatter memvar
         ENDIF
         IF !ExecRW(cSql,"U_MAG_MO","W")
            return(.f.)
         ENDIF
      ENDIF

      **==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
      IF _PRZVEN = 0
         R_PRZVEN = A_PRZVEN
      ELSE
         R_PRZVEN = _PRZVEN
      ENDIF
      IF _PRZACQ = 0
         R_PRZCOS = A_PRZCOS
      ELSE 
         R_PRZCOS = _PRZACQ
      ENDIF
      =MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATDOC,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_CLIFOR)
 
   ENDIF
   M_GENMOV = "NO"
ENDIF

*-->> SCARICA/CARICA LA GIACENZA DI MAGAZZINO ----------------------------
x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_codi
Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
IF RECCOUNT() <> 0
   IF X_SEGNO = '+'
      IF _TIPO = "GIA"	
         REPLACE MAG_GIACEN WITH MAG_GIACEN + _QUANTI
      ENDIF
      IF _IMPE  = "X"
	     REPLACE MAG_IMPORD WITH MAG_IMPORD + _QUANTI
      ENDIF
      IF _DADOVE = 'PRODISBA'
         IF _SAC = 'R'	
         ELSE 					
            REPLACE MAG_QTAIMG WITH MAG_QTAIMG + _QUANTI
         ENDIF
      ENDIF 				
   ELSE
      IF _TIPO = "GIA"
         REPLACE MAG_GIACEN WITH MAG_GIACEN - _QUANTI
      ENDIF
      IF _IMPE  = "X"
	     REPLACE MAG_IMPORD WITH MAG_IMPORD - _QUANTI
      ENDIF
      IF _DADOVE = 'PRODISBA'
         IF _SAC = 'R'	
         ELSE 					
            REPLACE MAG_QTAIMG WITH MAG_QTAIMG - _QUANTI
         ENDIF
      ENDIF 				
   ENDIF
ELSE
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH _MAG
   REPLACE MAG_CODART WITH _CODART
   REPLACE MAG_DESART WITH A_DESART
   IF X_SEGNO = '+'
      IF _TIPO = "GIA"	
         REPLACE MAG_GIACEN WITH _QUANTI
      ENDIF
      IF _IMPE  = "X"
	     REPLACE MAG_IMPORD WITH _QUANTI
      ENDIF
      IF _DADOVE = 'PRODISBA'
         IF _SAC = 'R'	
         ELSE 					
            REPLACE MAG_QTAIMG WITH _QUANTI
         ENDIF
      ENDIF 				
   ELSE
      IF _TIPO = "GIA"	
         REPLACE MAG_GIACEN WITH _QUANTI * (-1)
      ENDIF
      IF _IMPE  = "X"
	     REPLACE MAG_IMPORD WITH _QUANTI * (-1)
      ENDIF
      IF _DADOVE = 'PRODISBA'
         IF _SAC = 'R'	
         ELSE 					
            REPLACE MAG_QTAIMG WITH _QUANTI * (-1)
         ENDIF
      ENDIF 				
   ENDIF
   REPLACE MAG_CODFOR WITH M_CLIFOR
   REPLACE MAG_COSTO  WITH A_PRZCOS
   REPLACE MAG_UNIMIS WITH A_UNIMIS
   REPLACE MAG_DTCREA WITH _DATREG
   REPLACE MAG_CODTAG WITH A_CODTAG
   REPLACE MAG_DESTAG WITH A_DESTAG
   REPLACE MAG_CODCOL WITH A_CODCOL
   REPLACE MAG_DESCOL WITH A_DESCOL
   REPLACE MAG_CODPDV WITH PUB_CODBUN	
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

IF M_GENMOV = "SI"
   * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO ---------------------------
   Csql   = "select * from u_mag_mo"
   IF !ExecRW(cSql,"U_MAG_MO","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_MO
   APPEND BLANK
   REPLACE MOV_CODSOC WITH PUB_CODSOC
   REPLACE MOV_CODMAG WITH _MAG
   REPLACE MOV_CODART WITH _CODART
   REPLACE MOV_DESART WITH A_DESART
   REPLACE MOV_TOP    WITH _TOP
   REPLACE MOV_QTAMOV WITH _QUANTI
   IF _PRZVEN = 0
      REPLACE MOV_PREVEN WITH A_PRZVEN
   ELSE
      REPLACE MOV_PREVEN WITH _PRZVEN
   ENDIF
   IF _PRZACQ = 0
      REPLACE MOV_PREACQ WITH A_PRZCOS
   ELSE
      REPLACE MOV_PREACQ WITH _PRZACQ
   ENDIF
   IF EMPTY(_CODIVA)
      REPLACE MOV_IVAVEN WITH A_CODIVA
   ELSE
      REPLACE MOV_IVAVEN WITH _CODIVA
   ENDIF
   IF EMPTY(_VALUTA)
      REPLACE MOV_VALUTA WITH PUB_VALRIF
   ELSE
      REPLACE MOV_VALUTA WITH _VALUTA
   ENDIF
   REPLACE MOV_SCONTO WITH _SCONTO
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_NUMDOC WITH _NUMDOC
   REPLACE MOV_DTDOCU WITH _DATDOC
   REPLACE MOV_CODFOR WITH M_CLIFOR
   REPLACE MOV_RAGSOC WITH M_RAGSOC
   REPLACE MOV_DTREGI WITH _DATREG
   REPLACE MOV_CODTAG WITH A_CODTAG
   REPLACE MOV_DESTAG WITH A_DESTAG
   REPLACE MOV_CODCOL WITH A_CODCOL
   REPLACE MOV_DESCOL WITH A_DESCOL
   REPLACE MOV_NOTVAR WITH _NOTE
   REPLACE MOV_UM     WITH A_UNIMIS
   REPLACE MOV_CODPDV WITH PUB_CODBUN				
   REPLACE MOV_ORAMOV WITH _ORAMOV					
   REPLACE MOV_SEGNO  WITH X_SEGNO					
   REPLACE MOV_TIPMOV WITH M.TMOV				
   REPLACE MOV_FORNIT WITH ""
   REPLACE MOV_DESFOR WITH ""
   REPLACE MOV_COORD  WITH A_COORD
   REPLACE MOV_FLGTRA WITH _FLGTRA
   REPLACE MOV_UNIQUE WITH SYS(2015)
   IF _CSC = 'X'
      scatter memvar
   ENDIF
   IF !ExecRW(cSql,"U_MAG_MO","W")
      return(.f.)
   ENDIF
ENDIF
   
RETURN



*!*	*************************************************************************
*!*	Funzione per calcolare in codice di controllo nel codice a barre 
*!*	EAN13.
*!*	Bisogna passare una stringa di NUMERI (e ripeto solo numeri) della 
*!*	lunghezza di 12 byte (ovverro il codice a barre senza l'ultimo carattere)
*!*	e questo ritorna il carattere di controllo che alla fine va aggiunto
*!*	alla stringa di 12 byte.

*!*	Esempio di controllo esattezza codice a barre
*!*	----------------------------------------------
*!*	IF RIGHT(art_barcode,1) = CalcolaCheckDigit(SUBSTR(art_barcod,1,12))
*!*		WAIT WINDOW "Codice a barre corretto" NOWAIT 
*!*	ELSE
*!*		WAIT WINDOW "Codice a barre errato" NOWAIT 
*!*	ENDIF 

*!*	Esempio di creazione codice a barre
*!*	----------------------------------------------
*!*	_clmerc="978"			&& settore merciologica editoria
*!*	_barcod=_clmerc+_isbn+CalcolaCheckDigit(_clmerc+_isbn)
*************************************************************************
FUNCTION CalcolaCheckDigit
*************************************************************************
PARAMETERS cBarcode
LOCAL i, nSommaPari, nSommaDisp, cCheckDigit, cNewCheck
nSommaPari = 0
nSommaDisp = 0
FOR i=1 TO 6
 nSommaPari = nSommaPari + val(substr(cBarcode, 14-(i*2), 1))
 nSommaDisp = nSommaDisp + val(substr(cBarcode, 13-(i*2), 1))
ENDFOR 
nRestoMod   = MOD(nSommaPari*3 + nSommaDisp, 10)
cCheckDigit = IIF(nRestoMod == 0, '0', ALLTRIM(STR(10-nRestoMod)))

RETURN (cCheckDigit)


*!*	**************************************************************************
*!*	Funzione che dato un codice isbn, ritorna il codice ean => codice articolo
******************************************************************************
FUNCTION ISBNEAN
*************************************************************************
PARAMETERS _CODART

IF PUB_EAISBN
ELSE
   RETURN(_CODART)
ENDIF

V_LEN = LEN(ALLTRIM(_CODART))
V_OK  = .F.

*IF V_LEN = 13
*   V_CHECK1 = RIGHT(ALLTRIM(_CODART),1)
*   V_CHECK2 = CalcolaCheckDigit(SUBSTR(_CODART,1,12))
*   IF V_CHECK1 = V_CHECK2
*      *WAIT WINDOW "Codice a barre corretto" NOWAIT 
*      V_OK = .T.
*   ELSE
*      *WAIT WINDOW "Codice a barre errato" NOWAIT 
*      V_OK = .F.
*   ENDIF
*ELSE
*   V_OK = .F.
*ENDIF

IF V_OK
ELSE
   IF V_LEN = 10
      * Creazione codice a barre
      PUB_CDISBN = _CODART
      _CLMERC    = "978"								&& settore merciologica editoria
      _ISBN      = _CLMERC + SUBSTR(_CODART,1,9)
      _CHECK     = CalcolaCheckDigit(_ISBN)
      _CODART    = _CLMERC + SUBSTR(_CODART,1,9) + _CHECK
   ENDIF
ENDIF

RETURN (_CODART)


*!*	******************************************************
*!*	Funzione che individua il codice articolo da ricercare
**********************************************************
FUNCTION CERCARTI
**********************************************************
PARAMETERS _CODART

V_TROV = .F.

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF
SELECT ECASH_U_ART_PR
GO TOP
IF EOF()
ELSE
   V_TROV = .T.
   X_ARTI = ART_CODPRI
   RETURN (X_ARTI)
ENDIF

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_cdisbn = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF
SELECT ECASH_U_ART_PR
GO TOP
IF EOF()
ELSE
   V_TROV = .T.
   X_ARTI = ART_CODPRI
   RETURN (X_ARTI)
ENDIF

X_ARTI = ISBNTOEAN(_CODART)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(X_ARTI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"ECASH_U_ART_PR")
   return(.f.)
ENDIF

RETURN (X_ARTI)


* PROCEDURA PER CONVERSIONE DA CODICE ISBN A CODICE EAN
*******************************************************
PROCEDURE ISBNTOEAN
********************

PARAMETERS _ISBN

RELEASE V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA
PUBLIC  V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA

V_ISBN = _ISBN

V_LEN = LEN(ALLTRIM(V_ISBN))
IF V_LEN = 10
ELSE
   RETURN (V_ISBN)
ENDIF

* CONTROLLO ESATTEZZA CODICE ISBN
XXX_SOMMA = 0
K = 10
FOR I=1 TO 9
    XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_ISBN,I,1))*K
    K = K - 1
ENDFOR
IF SUBSTR(V_ISBN,10,1) <> 'X'
   XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_ISBN,10,1))
ELSE
   XXX_SOMMA = XXX_SOMMA + 10
ENDIF
IF (XXX_SOMMA % 11) = 0
ELSE
   RETURN (V_ISBN)
ENDIF

* CONVERSIONE DA ISBN AD EAN
V_EAN  = '978' + SUBSTR(V_ISBN,1,9)

XXX_SOMMA = 0
XXX_CIFRA = SPACE(01)

FOR I=1 TO 12 
    IF (I % 2) = 1
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))
    ELSE
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))*3
    ENDIF
ENDFOR

XXX_CIFRA = STR(10 - (XXX_SOMMA % 10))

V_EAN = V_EAN + ALLTRIM(XXX_CIFRA)

RETURN (V_EAN)


* PROCEDURA PER CONVERSIONE DA CODICE EAN A CODICE ISBN
******************************************************
PROCEDURE EANTOISBN
********************

PARAMETERS _EAN

RELEASE V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA
PUBLIC  V_ISBN,V_EAN,XXX_SOMMA,XXX_CONTROLLO,XXX_CIFRA

V_EAN = _EAN

V_LEN = LEN(ALLTRIM(V_EAN))
IF V_LEN = 13
ELSE
   V_EAN = SPACE(16)
   RETURN (V_EAN)
ENDIF

* CONTROLLO ESATTEZZA CODICE EAN
XXX_SOMMA = 0
XXX_CIFRA = SPACE(01)
FOR I=1 TO 12 
    IF (I % 2) = 1
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))
    ELSE
       XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_EAN,I,1))*3
    ENDIF
ENDFOR
XXX_CIFRA = ALLTRIM(STR(10 - (XXX_SOMMA % 10)))
IF XXX_CIFRA = '10'
   XXX_CIFRA = '0'
ENDIF
IF (XXX_CIFRA = SUBSTR(V_EAN,13,1))
ELSE
   V_EAN = SPACE(16)
   RETURN (V_EAN)
ENDIF

* CONVERSIONE DA EAN AD ISBN
XXX_SOMMA     = 0
XXX_CONTROLLO = 0
XXX_CIFRA     = SPACE(01)
K = 10

V_ISBN = SUBSTR(V_EAN,4,9)

FOR I=1 TO 9
    XXX_SOMMA = XXX_SOMMA + VAL(SUBSTR(V_ISBN,I,1))*K
    K = K - 1
ENDFOR

FOR I=0 TO 10
    XXX_CONTROLLO = XXX_SOMMA + I
    IF (XXX_CONTROLLO % 11 = 0)
       EXIT
    ENDIF
ENDFOR

IF I <> 10
   XXX_CIFRA = ALLTRIM(STR(I))
ELSE
   XXX_CIFRA = 'X'
ENDIF

V_ISBN = V_ISBN + XXX_CIFRA

RETURN (V_ISBN)


* PROCEDURA PER ANNULLARE UNO SCONTRINO EMESSEO
***********************************************
PROCEDURE ANNULLO_SCONTRINO
***************************

PARAMETERS _CURSORE

SELECT &_CURSORE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   REPLACE CAS_QUANTI WITH CAS_QUANTI * -1
   REPLACE CAS_PREZZO WITH CAS_PREZZO * -1
   REPLACE CAS_IMPORT WITH CAS_IMPORT * -1
   REPLACE CAS_TOTALE WITH CAS_TOTALE * -1
   REPLACE CAS_RESTO  WITH CAS_RESTO * -1
   REPLACE CAS_VALSCO WITH CAS_VALSCO * -1
   REPLACE CAS_QTA    WITH CAS_QTA * -1
   REPLACE CAS_VAL    WITH CAS_VAL * -1
   REPLACE CAS_SEQUEN WITH CAS_SEQUEN * 10

   SELECT &_CURSORE
   SKIP +1

ENDDO
IF !ExecRW('','u_pdv_ca','I','',_CURSORE)
   return(.f.)
ENDIF

RETURN


***********************************************************
* SOSTITUISCE UN APICE (ACCENTO) CON UNA LETTERA ACCENTATA ED
* UN APICE (APOSTROFO) CON UN ACCENTO
***********************************************************
PROCEDURE APITOSPA
***********************************************************

PARA _STRINGA

RELEASE XXX_STRINGA,XXX_LUNG,XXX_NUOVA
PUBLIC  XXX_STRINGA,XXX_LUNG,XXX_NUOVA

XXX_STRINGA = _STRINGA
XXX_LUNG    = LEN(XXX_STRINGA)
XXX_NUOVA   = ""

FOR I=1 TO XXX_LUNG
   
   IF SUBSTR(XXX_STRINGA,I,1) = "'"
      X_ACCENTO = .F.
      IF SUBSTR(XXX_STRINGA,I-1,1) = "A" .OR. SUBSTR(XXX_STRINGA,I-1,1) = "a"
         XXX_LETTERA = 'à'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,I-1,1) = "E" .OR. SUBSTR(XXX_STRINGA,I-1,1) = "e"
         XXX_LETTERA = 'è'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,I-1,1) = "I" .OR. SUBSTR(XXX_STRINGA,I-1,1) = "i"
         XXX_LETTERA = 'ì'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,I-1,1) = "O" .OR. SUBSTR(XXX_STRINGA,I-1,1) = "o"
         XXX_LETTERA = 'ò'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,I-1,1) = "U" .OR. SUBSTR(XXX_STRINGA,I-1,1) = "u"
         XXX_LETTERA = 'ù'
         X_ACCENTO   = .T.
      ENDIF
      IF X_ACCENTO
         XXX_LETTERA = UPPER(XXX_LETTERA)
         XXX_LEN     = LEN(XXX_NUOVA) - 1
         XXX_NUOVA   = SUBSTR(XXX_NUOVA,1,XXX_LEN) + XXX_LETTERA
      ELSE
         XXX_NUOVA = XXX_NUOVA + "^"
      ENDIF
   ELSE
      XXX_NUOVA = XXX_NUOVA + SUBSTR(XXX_STRINGA,I,1)
   ENDIF
      
ENDFOR

RETURN XXX_NUOVA

***********************************************************************************
*****                 LIBRERIA PERSONALE DI DAVIDE PER LO SVILUPPO            *****
***********************************************************************************
*****	TUTTE LE MODIFICHE O LE NUOVE ROUTINE, FUNZIONI O PROCEDURE O .....   *****
*****   NUOVE O MODIFICATE ESISTENTI (E PER QUELLE ESISTENTI MODIFICATE		  *****
*****   PRELEVARLE DALLA LIBRERIA ORIGINALE CON IL TAGLIA , COPIARLE IN		  *****
*****                     CODESTA LIBRERIA E MODIFICARLA 					  *****
***********************************************************************************


******************************************************************
FUNCTION ProcessiExe
******************************************************************
* -->> Funzione per gestire i processi attivi
* -->> sulla macchina e nella sessione in cui 
* -->> viene eseguita
*
* -->> Esempio: ProcessiExe("V","cmd.exe")
* -->>			verifica se è attivo un processo
* -->>			dal nome "cmd.exe" e ritorna .T.
* -->>			se è attivo e .F. se non attivo
*
* -->> Esempio: ProcessiExe("C","cmd.exe")
* -->>			chiude, se esiste, il processo
* -->>			dal nome "cmd.exe"
*
* -->> Esempio: ProcessiExe("H","-")
* -->>			chiude il processo corrente
* -->>			ovvero la procedura da cui
* -->> 			è chiamata la funzione
* 
* -->> Esempio: ProcessiExe("-","-")
* -->>			esegue solo la lettura dei processi
* -->>			attivi creando il cursore "csModules"
* -->> 			di utilizzo libero
******************************************************************


PARAMETERS _TipoComando,_NomeProcesso

IF PARAMETERS() < 2
	RETURN (.f.)
ENDIF 

DO CASE 
	CASE _TipoComando = "V"	&& verifica esistenza processo attivo
		=LeggiProcessi()
		SELECT * from csModules WHERE UPPER(_NomeProcesso) $ UPPER(basename) INTO CURSOR _tmp_process
		IF _tally = 0
			RETURN (.f.)
		ELSE
			RETURN (.t.)
		ENDIF

	CASE _TipoComando = "S"	&& verifica esistenza processo attivo
		=LeggiProcessi()
		SELECT * from csModules WHERE UPPER(_NomeProcesso) $ UPPER(basename) INTO CURSOR _tmp_process
		IF _tally = 0
			RETURN (.f.)
		ELSE
			IF RECCOUNT() >1
				RETURN (.t.)
			ELSE
				RETURN (.f.)
			ENDIF 
		ENDIF

	CASE _TipoComando = "C"	&& chiude il processo attivo richiesto
		=LeggiProcessi()
		DECLARE ExitProcess IN kernel32 INTEGER uExitCode 
		SELECT * from csModules WHERE UPPER(_NomeProcesso) $ UPPER(basename) INTO CURSOR _tmp_process
		IF _tally <> 0
		    hProcess = OpenProcess(1, 0, _tmp_process.procid) 
		    IF hProcess <> 0 
		        = TerminateProcess(hProcess, 0) 
		        = CloseHandle(hProcess) 
		    ENDIF 

**			ExitProcess (_tmp_process.procid)
		ENDIF

	CASE _TipoComando = "H"	&& chiude processo attivo corrente
		ExitProcess (ProcessoCorrente())

	OTHERWISE
		=LeggiProcessi()

ENDCASE 

RETURN (.t.)



******************************************************************
FUNCTION LeggiProcessi
******************************************************************

#DEFINE PROCESS_VM_READ               16 
#DEFINE PROCESS_QUERY_INFORMATION   1024 
#DEFINE DWORD                          4 
DO dav_decl 
     
LOCAL lcProcBuf, lnBufSize, lnProcessBufRet, lnProcNo, lnProcId,; 
    hProcess, lcModBuf, lnModBufRet, lnModNo, lcFilename, lcBasename 

lnBufSize = 4096  && should be large enough 
lcProcBuf = Repli(Chr(0), lnBufSize) 
lnProcessBufRet = 0 

IF EnumProcesses (@lcProcBuf, lnBufSize, @lnProcessBufRet) = 0 
    RETURN 
ENDIF 
     
SELECT 0 
CREATE CURSOR csProcesses (procId N(16), hProc N(16), errcode N(6)) 

SELECT 0 
CREATE CURSOR csModules (procId N(16), hMod N(16),; 
    basename C(30), filename C(250)) 

FOR lnProcNo=1 TO lnProcessBufRet/DWORD 
    lnProcId = buf2dword(SUBSTR(lcProcBuf, (lnProcNo-1)*DWORD+1, DWORD)) 

    hProcess = OpenProcess (PROCESS_QUERY_INFORMATION +; 
        PROCESS_VM_READ, 0, lnProcId) 

    IF hProcess <> 0 
        INSERT INTO csProcesses VALUES (lnProcId, hProcess, 0) 

        * retrieving handles to the modules participating in the process 
        lnBufSize = 4096  && should be large enough 
        lcModBuf = Repli(Chr(0), lnBufSize) 
        lnModBufRet = 0 

        IF EnumProcessModules(hProcess, @lcModBuf,; 
            lnBufSize, @lnModBufRet) <> 0 

            FOR lnModNo=1 TO lnModBufRet/DWORD 
                hModule = buf2dword(SUBSTR(lcModBuf,; 
                    (lnModNo-1)*DWORD+1, DWORD)) 

                lcFilename = SPACE(250) 
                lnBufSize = GetModuleFileNameEx (hProcess, hModule,; 
                    @lcFilename, Len(lcFilename)) 
                lcFilename = Left(lcFilename, lnBufSize) 
                     
                lcBasename = SPACE(250) 
                lnBufSize = GetModuleBaseName (hProcess, hModule,; 
                    @lcBasename, Len(lcBasename)) 
                lcBasename = Left (lcBasename, lnBufSize) 

                INSERT INTO csModules VALUES (; 
                    lnProcId, hModule, lcBasename, lcFilename) 
            ENDFOR  && lnModNo 
        ENDIF 
        * releasing the handle - it does not mean closing the process 
        = CloseHandle (hProcess) 
    ELSE 
        *  5 = Access is denied 
        * 87 = The parameter is incorrect 
        INSERT INTO csProcesses VALUES (; 
            lnProcId, hProcess, GetLastError()) 
    ENDIF 
ENDFOR  && lnProcNo 



******************************************************************
FUNCTION  buf2dword (lcBuffer) 
******************************************************************
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ; 
    Asc(SUBSTR(lcBuffer, 2,1)) * 256 +; 
    Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +; 
    Asc(SUBSTR(lcBuffer, 4,1)) * 16777216 

******************************************************************
PROCEDURE  dav_decl 
******************************************************************
    DECLARE INTEGER GetLastError IN kernel32 

    DECLARE INTEGER CloseHandle IN kernel32 INTEGER Handle 

    DECLARE INTEGER OpenProcess IN kernel32; 
        INTEGER dwDesiredAccessas, INTEGER bInheritHandle,; 
        INTEGER dwProcId 

    DECLARE INTEGER EnumProcesses IN psapi; 
        STRING @ lpidProcess, INTEGER cb,; 
        INTEGER @ cbNeeded 

    DECLARE INTEGER GetModuleFileNameEx IN psapi; 
        INTEGER hProcess, INTEGER hModule,; 
        STRING ModuleName, INTEGER nSize 

    DECLARE INTEGER GetModuleBaseName IN psapi; 
        INTEGER hProcess, INTEGER hModule,; 
        STRING @ lpBaseName, INTEGER nSize 

    DECLARE INTEGER EnumProcessModules IN psapi; 
        INTEGER hProcess, STRING @ lphModule,; 
        INTEGER cb, INTEGER @ cbNeeded 
 
    DECLARE INTEGER TerminateProcess IN kernel32; 
        INTEGER hProcess, INTEGER uExitCode 
 


***********************************************
FUNCTION ProcessoCorrente
***********************************************
DECLARE INTEGER GetCurrentProcessId IN kernel32 
DECLARE INTEGER GetProcessVersion IN kernel32;
	    INTEGER ProcessId 
#DEFINE _FFFF       65535  && 0x0000ffff 
#DEFINE FFFF_  4294901760  && 0xffff0000 

LOCAL lnProcId, lnProcVer 
lnProcId = GetCurrentProcessId() 
lnProcVer = GetProcessVersion (lnProcId) 
   
*    ? "Process Id:", lnProcId 
*    ? "Process Version:", lnProcVer 
return(lnProcId)



*!*	*************************************************************************
*!*	Funzione per calcolare in codice di controllo nel codice a barre 
*!*	EAN13.
*!*	Bisogna passare una stringa di NUMERI (e ripeto solo numeri) della 
*!*	lunghezza di 12 byte (ovverro il codice a barre senza l'ultimo carattere)
*!*	e questo ritorna il carattere di controllo che alla fine va aggiunto
*!*	alla stringa di 12 byte.

*!*	Esempio di controllo esattezza codice a barre
*!*	----------------------------------------------
*!*	IF RIGHT(art_barcode,1) = CalcolaCheckDigit(SUBSTR(art_barcod,1,12))
*!*		WAIT WINDOW "Codice a barre corretto" NOWAIT 
*!*	ELSE
*!*		WAIT WINDOW "Codice a barre errato" NOWAIT 
*!*	ENDIF 

*!*	Esempio di creazione codice a barre
*!*	----------------------------------------------
*!*	_clmerc="978"			&& settore merciologica editoria
*!*	_barcod=_clmerc+_isbn+CalcolaCheckDigit(_clmerc+_isbn)
*************************************************************************
FUNCTION CalcolaCheckDigit
*************************************************************************
PARAMETERS cBarcode
LOCAL i, nSommaPari, nSommaDisp, cCheckDigit, cNewCheck
nSommaPari = 0
nSommaDisp = 0
FOR i=1 TO 6
 nSommaPari = nSommaPari + val(substr(cBarcode, 14-(i*2), 1))
 nSommaDisp = nSommaDisp + val(substr(cBarcode, 13-(i*2), 1))
ENDFOR 
nRestoMod   = MOD(nSommaPari*3 + nSommaDisp, 10)
cCheckDigit = IIF(nRestoMod == 0, '0', ALLTRIM(STR(10-nRestoMod)))

RETURN (cCheckDigit)


*************************************************************************
* OPERAZIONI SUL FILE DELLE PROPOSTE D'ORDINE DA INVIARE AI PDV
* _TIPO =>  1 = INIZIALIZZAZIONE AD 'A' DI ANNULLO DEI RECORDS
*           2 = VERIFICA DEI CAMPI AGGIORNATI SULL'ORDINE A FORNITORE
*               CON RELATIVO AGGIORNAMENTO SUL RECORDS U_ORF_PO
* _ANNO =>  ANNO DI RIFERIMENTO
* _NUME =>  NUMERO ORDINE FORNITORE
* _CSYS =>  CODICE SYS CHE LEGA L'ORDINE FORNIATORE AL FILE U_ORF_PO
* _QUAN =>  QUANTITA' DELL'ORDINE A FORNITORE
* _PREZ =>  PREZZO DELL'ORDINE A FORNITORE
* _DATC =>  DATA CONSEGNA DELLA RIGA ORDINE A FORNITORE
* _DATA =>  DATA DELL'ORDINE A FORNITORE
* _FLGC =>  FLAG DI CONFERMA PER LA TRASMISSIONE
*************************************************************************
FUNCTION GESTIONE_U_ORF_PO
*************************************************************************

PARAMETERS _TIPO,_ANNO,_NUME,_CSYS,_QUAN,_PREZ,_DATC,_DATA,_FLGCON

DO CASE

   CASE _TIPO = 1

        x_anno = "orf_anno = '" + _ANNO + "'"
        x_nume = "orf_numord = '" + ALLTRIM(_NUME) + "'"
        x_cond = x_anno + " and " + x_nume
        cSql   = "select * from u_orf_po where " + x_cond
        IF !ExecRW(cSql,"U_ORF_PO","R")
           RETURN .F.
        ENDIF
        SELECT U_ORF_PO
        GO TOP
        IF EOF()
        ELSE 
           DO WHILE .T.
              IF EOF()
                 EXIT
              ENDIF
              REPLACE ORF_TIPAGG WITH 'A'
              REPLACE ORF_FLGTRA WITH .F.
              REPLACE ORF_FLGCON WITH _FLGCON
              SKIP +1
           ENDDO
        ENDIF
        IF !ExecRW(cSql,"U_ORF_PO","W")
           RETURN .F.  
        ENDIF

    CASE _TIPO = 2
 
         x_csys = "orf_syssys = '" + _CSYS + "'"
         x_cond = x_csys
         cSql   = "select * from u_orf_po where " + x_cond
         IF !ExecRW(cSql,"U_ORF_PO","R")
            RETURN .F.
         ENDIF
         SELECT U_ORF_PO
         GO TOP
         IF EOF()
         ELSE 
            SUM ORF_QTADOR TO X_QTADOR
            GO TOP
            IF _QUAN = X_QTADOR
               X_QTA  = .F.
               X_DIFF = 0
            ELSE
               X_QTA = .T.
               IF _QUAN < X_QTADOR
                  X_DIFF = X_QTADOR - _QUAN
               ELSE
                  X_DIFF = _QUAN - X_QTADOR
               ENDIF
            ENDIF
            DO WHILE .T.
               IF EOF()
                  EXIT
               ENDIF
               REPLACE ORF_TIPAGG WITH ' '
               IF X_DIFF < 1
                  X_QTA = .F.
               ENDIF 
               IF X_QTA
                  IF _QUAN < X_QTADOR
                     IF ORF_QTADOR < X_DIFF
                        REPLACE ORF_QTAAGG WITH ORF_QTADOR
                        X_DIFF = X_DIFF - ORF_QTADOR
                        REPLACE ORF_QTADOR WITH 0
                     ELSE
                        REPLACE ORF_QTAAGG WITH X_DIFF
                        REPLACE ORF_QTADOR WITH ORF_QTADOR - X_DIFF
                        X_DIFF = 0
                        REPLACE ORF_TIPAGG WITH '-'
                     ENDIF
                  ELSE
                     REPLACE ORF_QTAAGG WITH X_DIFF
                     REPLACE ORF_QTADOR WITH ORF_QTADOR + X_DIFF
                     REPLACE ORF_TIPAGG WITH '+'
                     X_DIFF = 0
                  ENDIF
               ENDIF
               IF ORF_QTADOR < 1
                  REPLACE ORF_TIPAGG WITH 'A'
                  REPLACE ORF_FLGTRA WITH .F.
               ENDIF 
               IF ORF_PREZZO = _PREZ
               ELSE
                  REPLACE ORF_PREZZO WITH _PREZ
                  REPLACE ORF_FLGTRA WITH .F.
               ENDIF
               IF ORF_DATCON = _DATC
               ELSE
                  REPLACE ORF_DATCON WITH _DATC
                  REPLACE ORF_FLGTRA WITH .F.
               ENDIF
               IF ORF_DATORD = _DATA
               ELSE
                  REPLACE ORF_DATORD WITH _DATA
                  REPLACE ORF_FLGTRA WITH .F.
               ENDIF
               REPLACE ORF_FLGCON WITH _FLGCON
               SKIP +1
            ENDDO      
         ENDIF
         IF !ExecRW(cSql,"U_ORF_PO","W")
            RETURN .F.
         ENDIF
   
    CASE _TIPO = 3
    
         x_anno = "orf_anno = '" + _ANNO + "'"
         x_nume = "orf_numord = '" + ALLTRIM(_NUME) + "'"
         x_cond = x_anno + " and " + x_nume
         cSql   = "select * from u_orf_po where " + x_cond
         IF !ExecRW(cSql,"U_ORF_PO","R")
            RETURN .F.
         ENDIF
         SELECT U_ORF_PO
         GO TOP
         IF EOF()
         ELSE 
            DO WHILE .T.
               IF EOF()
                  EXIT
               ENDIF
               REPLACE ORF_FLGCON WITH _FLGCON
               IF ORF_TIPAGG = 'A'
                  REPLACE ORF_FLGTRA WITH .F.
                  X_QTADOR = ORF_QTADOR
                  x_csys = "ord_codsys = '" + ORF_CODSYS + "'"
                  x_cond = x_csys
                  cSql   = "select * from u_orf_dd where " + x_cond
                  IF !ExecRW(cSql,"U_ORF_DD","R")
                     RETURN .F.
                  ENDIF
                  SELECT U_ORF_DD
                  GO TOP
                  IF EOF()
                  ELSE
                     REPLACE ORD_QTAEV WITH ORD_QTAEV - X_QTADOR 
                     IF ORD_QTAEV < 1
                        REPLACE ORD_QTAEV WITH 0
                     ENDIF
                     x_agga = "taggancio = '" + DAGGANCIO + "'"
                     x_cond = x_agga
                     cSqlT  = "select * from u_orf_tt where " + x_cond
                     IF !ExecRW(cSqlT,"U_ORF_TT","R")
                        RETURN .F.
                     ENDIF
                     SELECT U_ORF_TT
                     GO top
                     IF EOF()
                     ELSE
                        REPLACE ORD_CHIUSO WITH .F.
                     ENDIF
                     IF !ExecRW(cSqlT,"U_ORF_TT","W")
                        RETURN .F.
                     ENDIF
                  ENDIF
                  IF !ExecRW(cSql,"U_ORF_DD","W")
                     RETURN .F.
                  ENDIF
               ENDIF
               SELECT U_ORF_PO
               IF ORF_TIPAGG = '+'
                  REPLACE ORF_TIPAGG WITH ' '
                  REPLACE ORF_FLGTRA WITH .F.
                  X_QTADOR = ORF_QTADOR
                  X_QTAAGG = ORF_QTAAGG
                  x_csys = "ord_codsys = '" + ORF_CODSYS + "'"
                  x_cond = x_csys
                  cSql   = "select * from u_orf_dd where " + x_cond
                  IF !ExecRW(cSql,"U_ORF_DD","R")
                     RETURN .F.
                  ENDIF
                  SELECT U_ORF_DD
                  GO TOP
                  IF EOF()
                  ELSE
                     REPLACE ORD_QTAEV WITH ORD_QTAEV + X_QTAAGG 
                  ENDIF
                  IF !ExecRW(cSql,"U_ORF_DD","W")
                     RETURN .F.
                  ENDIF
               ENDIF
               SELECT U_ORF_PO
               IF ORF_TIPAGG = '-'
                  REPLACE ORF_TIPAGG WITH ' '
                  REPLACE ORF_FLGTRA WITH .F.
                  X_QTADOR = ORF_QTADOR
                  X_QTAAGG = ORF_QTAAGG
                  x_csys = "ord_codsys = '" + ORF_CODSYS + "'"
                  x_cond = x_csys
                  cSql   = "select * from u_orf_dd where " + x_cond
                  IF !ExecRW(cSql,"U_ORF_DD","R")
                     RETURN .F.
                  ENDIF
                  SELECT U_ORF_DD
                  GO TOP
                  IF EOF()
                  ELSE
                     REPLACE ORD_QTAEV WITH ORD_QTAEV - X_QTAAGG 
                     IF ORD_QTAEV < 1
                        REPLACE ORD_QTAEV WITH 0
                     ENDIF
                     x_agga = "taggancio = '" + DAGGANCIO + "'"
                     x_cond = x_agga
                     cSqlT  = "select * from u_orf_tt where " + x_cond
                     IF !ExecRW(cSqlT,"U_ORF_TT","R")
                        RETURN .F.
                     ENDIF
                     SELECT U_ORF_TT
                     GO top
                     IF EOF()
                     ELSE
                        REPLACE ORD_CHIUSO WITH .F.
                     ENDIF
                     IF !ExecRW(cSqlT,"U_ORF_TT","W")
                        RETURN .F.
                     ENDIF
                  ENDIF
                  IF !ExecRW(cSql,"U_ORF_DD","W")
                     RETURN .F.
                  ENDIF
               ENDIF
               SELECT U_ORF_PO
               SKIP +1
            ENDDO
         ENDIF
         IF !ExecRW(cSql,"U_ORF_PO","W")
            RETURN .F.
         ENDIF

ENDCASE

RETURN(.T.)

*************************************************************************
* FUNZIONE PER RICERCARE E/O FAR SELEZIONARE ALL'UTENTE LA GIACENZA A 
* LIVELLO DI ARTICOLO, DATA E FORNITORE
* _FLAG =>  .T. INDICA CHE DEVE DARE LA POSSIBILITA' ALL'UTENTE DI SELEZIONARE 
*               LA GIACENZA SUL FORNITORE
* _SOCI =>  CODICE SOCIETA'
* _DATA =>  DATA DI GIACENZA
* _ARTI =>  CODICE ARTICOLO
* _MAGA =>  CODICE MAGAZZINO
* _FORN =>  CODICE FORNITORE
*************************************************************************
FUNCTION CERCA_GIAADF
*************************************************************************

PARAMETERS _FLAG,_SOCI,_DATA,_ARTI,_MAGA,_FORN

x_soci    = "mag_codsoc = '" + _SOCI + "'"
IF _DATA  = 'RIC.PREZZO'
   x_data = "mag_datagg <> '" + SPACE(10) + "'"
ELSE
   x_data = "mag_datagg = '" + _DATA + "'"
ENDIF
x_codi    = "mag_codart = '" + ALLTRIM(_ARTI) + "'"
x_maga    = "mag_codmag = '" + ALLTRIM(_MAGA) + "'"
x_forn    = "mag_fornit = '" + ALLTRIM(_FORN) + "'"
x_giac    = "mag_giacen > 0"

IF _DATA = 'RIC.PREZZO'
   IF EMPTY(_FORN) .OR. _FORN = SPACE(10)
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_giac
   ELSE
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac
   ENDIF
ELSE
   IF EMPTY(_FORN) .OR. _FORN = SPACE(10)
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga
   ELSE
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
   ENDIF
ENDIF

IF _DATA = 'RIC.PREZZO'
   Csql = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit,mag_codacq,mag_przcon"
ELSE
   Csql = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
ENDIF
IF !ExecCommand(cSql,"CUX_MAG_GG")
   return(.f.)
ENDIF

SELECT CUX_MAG_GG
GO TOP
IF EOF()
   USE
   RETURN
ENDIF

IF _FLAG
   IF RECCOUNT() = 1
      FF_GIACENZA = MAG_GIACEN
      FF_CODFOR   = MAG_FORNIT
      FF_DESFOR   = MAG_DESFOR
      FF_PRZCON   = MAG_PRZCON 
      FF_CODACQ   = MAG_CODACQ 
   ELSE
      RELEASE FFF_GIACENZA,FFF_CODFOR,FFF_DESFOR,FFF_PRZCON,FFF_CODACQ
      PUBLIC  FFF_GIACENZA,FFF_CODFOR,FFF_DESFOR,FFF_PRZCON,FFF_CODACQ
      IF _DATA = 'RIC.PREZZO'
         DO FORM FORM\GIAC_ADFX LINKED
      ELSE
         DO FORM FORM\GIAC_ADF LINKED
      ENDIF
      FF_GIACENZA = FFF_GIACENZA
      FF_CODFOR   = FFF_CODFOR
      FF_DESFOR   = FFF_DESFOR
      FF_PRZCON   = FFF_PRZCON
      FF_CODACQ   = FFF_CODACQ
   ENDIF
ELSE
   FF_GIACENZA = MAG_GIACEN
   FF_CODFOR   = MAG_FORNIT
   FF_DESFOR   = MAG_DESFOR
   FF_PRZCON   = MAG_PRZCON
   FF_CODACQ   = FFF_CODACQ
ENDIF

IF _DATA = 'RIC.PREZZO'
ELSE
   FF_PRZCON = 0
   FF_CODACQ = SPACE(03)
ENDIF

SELECT CUX_MAG_GG
USE

RETURN



*==> INIZIO MODIFICHE SUL MAGAZZINO RINO 21/01/2004 


**************************************************************************
PROCEDURE BFOCAMAGA  && CARICA IL MAGAZZINO
**************************************************************************

IF U_AGGIORNA
ELSE
   RETURN
ENDIF

SELECT CU_BFO_DD
SET FILTER TO ORD_FLGMOD <> 'A'
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'M' .OR. ORD_FLGMOD = 'I'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   RELEASE WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON
   PUBLIC  WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON
   WWW_LEGAME = M.ORD_LEGAME
   WWW_CODSYS = M.ORD_CODSYS
   WWW_CODART = M.ORD_CODART
   WWW_CODMAG = M.ORD_MAGA
   WWW_DATCON = M.ORD_DATCON
   
   x_codi = "codice = 'TCA" + ALLTRIM(M.ORS_CODACQ) + "'"
   x_cond = x_codi
   cSql   = "SELECT * FROM PARA WHERE " + x_cond
   IF !ExecCommand(cSql,"PARA")
      return(.f.)
   ENDIF 
   SELECT PARA
   GO TOP
   IF EOF()
      X_DESACQ = SPACE(03)
   ELSE
      X_DESACQ = DESCRI
   ENDIF

   RELEASE ZZZ_LEGAME
   PUBLIC  ZZZ_LEGAME
   ZZZ_LEGAME = SYS(2015)
   
   x_dove = "alt_dadove = 'BFOCAMAG'"
   x_maga = "alt_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"
   x_csys = "alt_legame = '" + ZZZ_LEGAME + "'"
   x_cond = x_dove + " and " + x_maga + " and " + x_csys
   cSql   = "SELECT * FROM U_ALT_DA WHERE " + x_cond
   IF !ExecRW(cSql,"U_ALT_DA","R")
      return(.f.)
   ENDIF 
   SELECT U_ALT_DA
   GO TOP
   IF EOF()
      APPEND BLANK
      REPLACE ALT_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE ALT_DADOVE WITH 'BFOCAMAG'
   REPLACE ALT_CODMAG WITH M.ORD_MAGA
   REPLACE ALT_LEGAME WITH ZZZ_LEGAME
   REPLACE ALT_NUMORF WITH M.ORS_NUMORC
   IF M.ORS_DATORC = SPACE(10) .OR. M.ORS_DATORC = '  /  /    ' .OR. EMPTY(M.ORS_DATORC)
      REPLACE ALT_DATORF WITH SPACE(10)
   ELSE
      IF SUBSTR(M.ORS_DATORC,3,1) = '/'
         REPLACE ALT_DATORF WITH RIBALTA2(M.ORS_DATORC)
      ELSE
         REPLACE ALT_DATORF WITH M.ORS_DATORC
      ENDIF
   ENDIF
   REPLACE ALT_PAGAME WITH M.ORS_CODCPA
   REPLACE ALT_CODACQ WITH M.ORS_CODACQ
   REPLACE ALT_DESACQ WITH X_DESACQ
   REPLACE ALT_SC1    WITH M.ORD_SC1
   REPLACE ALT_SC2    WITH M.ORD_SC2
   REPLACE ALT_SC3    WITH M.ORD_SC3
   REPLACE ALT_NUMIDE WITH M.ORS_NUMIDE
   REPLACE ALT_CODBUN WITH M.ORS_CODBUN
   REPLACE ALT_ANNO   WITH M.ORS_ANNO
   REPLACE ALT_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_ALT_DA","W")
      return(.f.)
   ENDIF 
 
   H_DADOVE = 'BFOCAMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = M.ORD_CAUS
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   IF ZZZ_FLGTIP = 0
   ELSE
      H_CLIFOR = M.ORD_CODFOR
      IF EMPTY(H_CLIFOR) .OR. H_CLIFOR = SPACE(10)
         H_CLIFOR = M.ORD_CODCLI
      ENDIF
   ENDIF
   H_PRZACQ = M.ORD_PRZNET
   H_PRZVEN = 0
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   H_LEGSYS = M.ORD_LEGSYS
   H_LEGAME = ZZZ_LEGAME
   =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS,H_LEGAME)

   IF ZZZ_FLGTIP = 0
      RELEASE V_TTDD
      PUBLIC  V_TTDD
      V_TTDD = .F.
      x_agga = "daggancio = '" + M.ORD_LEGAME + "'"
      x_csys = "ord_codsys = '" + M.ORD_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_DD","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_DD
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORD_QTAEV WITH ORD_QTAEV + M.ORD_QTAORD
         V_TTDD = .T.
      ENDIF
      IF !ExecRW(cSql,"U_ORF_DD","W")
         return(.f.)
      ENDIF 
      x_agga = "daggancio = '" + WWW_LEGAME + "'"
      x_cond = x_agga
      cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
      IF !ExecCommand(cSql,"U_ORF_DD")
         return(.f.)
      ENDIF 
      V_TROV = .F.
      SELECT U_ORF_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ORD_QTAEV < ORD_QTAORD
            V_TROV = .T.
            EXIT
         ENDIF
         SKIP +1
      ENDDO
      x_agga = "taggancio = '" + WWW_LEGAME + "'"
      x_cond = x_agga 
      cSql   = "SELECT * FROM U_ORF_TT WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_TT","R")
         return(.f.) 
      ENDIF 
      SELECT U_ORF_TT
      GO TOP
      IF EOF()
      ELSE
         IF V_TROV
            REPLACE ORD_CHIUSO WITH .F.
         ELSE
            REPLACE ORD_CHIUSO WITH .T.
         ENDIF
      ENDIF
      IF !ExecRW(cSql,"U_ORF_TT","W")
         return(.f.)
      ENDIF 
      IF V_TTDD
      ELSE
         x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
         x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
         x_cond = x_agga + " and " + x_csys
         cSql   = "SELECT * FROM U_ORF_PO WHERE " + x_cond
         IF !ExecRW(cSql,"U_ORF_PO","R")
            return(.f.)
         ENDIF 
         SELECT U_ORF_PO
         GO TOP
         IF EOF()
            V_DDT = .F.
         ELSE
            REPLACE ORF_QTAEV WITH ORF_QTAEV + M.ORD_QTAORD
            IF ORF_QTADOR > ORF_QTAEV
               REPLACE ORF_CHIUSO WITH .F.
            ELSE
               REPLACE ORF_CHIUSO WITH .T.
            ENDIF
            SCATTER MEMVAR MEMO 
            V_DDT = .T.
            WWW_NUMPRO = ORF_NUMPRO
            WWW_NUMORD = ORF_NUMORD
            WWW_NUMDDT = M.ORD_NUMORD
         ENDIF
         IF !ExecRW(cSql,"U_ORF_PO","W")
            return(.f.)
         ENDIF 
         IF V_DDT
            x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
            x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
            x_npro = "orf_numpro = '" + WWW_NUMPRO + "'"
            x_nord = "orf_numord = '" + WWW_NUMORD + "'"
            x_nddt = "orf_numddt = '" + WWW_NUMDDT + "'"
            x_cond = x_agga + " and " + x_csys + " and " + x_npro + " and " + x_nord + " and " + x_nddt
            cSql   = "SELECT * FROM U_ORF_DT WHERE " + x_cond
            IF !ExecRW(cSql,"U_ORF_DT","R")
               return(.f.)
            ENDIF 
            SELECT U_ORF_DT
            GO TOP
            IF EOF()
               APPEND BLANK
            ENDIF
            *GATHER MEMVAR
            M.ID_UNIQUE = " "
            DO U_ORF_DT
            REPLACE ORF_FLGTRA WITH .F.
            REPLACE SELEZIONE  WITH SPACE(10)
            REPLACE ORF_TIPAGG WITH SPACE(01)
            REPLACE ORF_CHIUSO WITH .F.
            REPLACE ORF_QTAEV  WITH 0
            REPLACE ORF_NUMDDT WITH M.ORD_NUMORD
            REPLACE ORF_DATDDT WITH M.ORD_DATORD
            REPLACE ORF_QTADDT WITH M.ORD_QTAORD
            REPLACE ORF_FLGCON WITH M.ORD_FLGCON
            IF !ExecRW(cSql,"U_ORF_DT","W")
               return(.f.)
            ENDIF 
         ENDIF
      ENDIF
   ENDIF

   IF ZZZ_FLGTIP = 1
      x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
      x_csys = "orf_unique = '" + WWW_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_CO WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_CO","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_CO
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE + M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_CO","W")
         return(.f.)
      ENDIF 
   ENDIF

   IF ZZZ_FLGTIP = 2
      x_uniq = "orf_unique = '" + ALLTRIM(WWW_CODSYS) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(WWW_LEGAME) + "'"
      x_cond = x_uniq + " and " + x_lega
      cSql   = "SELECT * FROM U_BOL_RE WHERE " + x_cond
      IF !ExecRW(cSql,"U_BOL_RE","R")
         return(.f.)
      ENDIF 
      SELECT U_BOL_RE
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE + M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_BOL_RE","W")
         return(.f.)
      ENDIF 
   ENDIF
   
   SELECT CU_BFO_DD
   SKIP +1

ENDDO

RETURN


************************************************************************************
PROCEDURE BFOSCMAGA  && SCARICA IL MAGAZZINO (FASE DI AGGIORNAMENTO GESTIONALE)
************************************************************************************

SELECT CU_BFO_DD
SET FILTER TO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'A' .OR. ORD_FLGMOD = 'M'
   ELSE
      IF ORD_FLGMOD = 'I' 
         U_AGGIORNA = .T.
      ENDIF
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   RELEASE WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON,WWW_LEGSYS
   PUBLIC  WWW_LEGAME,WWW_CODSYS,WWW_CODART,WWW_CODMAG,WWW_DATCON,WWW_LEGSYS
   WWW_LEGAME = M.ORD_LEGAME
   WWW_CODSYS = M.ORD_CODSYS
   WWW_CODART = M.ORD_CODART
   WWW_CODMAG = M.ORD_MAGA
   WWW_DATCON = M.ORD_DATCON
   WWW_LEGSYS = M.ORD_LEGSYS

   DO MAG_IN_AGG WITH "CU_BFO_DD","U_BFO_DD","-","BFO"

   SELECT CU_BFO_DD
   SCATTER MEMVAR MEMO

   IF ZZZ_FLGTIP = 0
      RELEASE V_TTDD
      PUBLIC  V_TTDD
      V_TTDD = .F.
      x_agga = "daggancio = '" + M.ORD_LEGAME + "'"
      x_csys = "ord_codsys = '" + M.ORD_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_DD","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_DD
      GO TOP
      IF EOF()
      ELSE
         V_TTDD = .T.
         REPLACE ORD_QTAEV WITH ORD_QTAEV - M.ORD_QTAORD
         x_agga = "taggancio = '" + WWW_LEGAME + "'"
         x_cond = x_agga 
         cSql   = "SELECT * FROM U_ORF_TT WHERE " + x_cond
         IF !ExecRW(cSql,"U_ORF_TT","R")
            return(.f.)
         ENDIF 
         SELECT U_ORF_TT
         GO TOP
         IF EOF()
         ELSE
            REPLACE ORD_CHIUSO WITH .F.
         ENDIF
         IF !ExecRW(cSql,"U_ORF_TT","W")
            return(.f.)
         ENDIF 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_DD","W")
         return(.f.)
      ENDIF 
      IF V_TTDD
      ELSE
         x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
         x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
         x_cond = x_agga + " and " + x_csys
         cSql   = "SELECT * FROM U_ORF_PO WHERE " + x_cond
         IF !ExecRW(cSql,"U_ORF_PO","R")
            return(.f.)
         ENDIF 
         SELECT U_ORF_PO
         GO TOP
         IF EOF()
            V_DDT = .F.
         ELSE
            REPLACE ORF_QTAEV WITH ORF_QTAEV - M.ORD_QTAORD
            IF ORF_QTADOR > ORF_QTAEV
               REPLACE ORF_CHIUSO WITH .F.
            ELSE
               REPLACE ORF_CHIUSO WITH .T.
            ENDIF
            V_DDT = .T.
            WWW_NUMPRO = ORF_NUMPRO
            WWW_NUMORD = ORF_NUMORD
            WWW_NUMDDT = M.ORD_NUMORD
         ENDIF
         IF !ExecRW(cSql,"U_ORF_PO","W")
            return(.f.)
         ENDIF 
         IF V_DDT
            x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
            x_csys = "orf_syssys = '" + WWW_CODSYS + "'"
            x_npro = "orf_numpro = '" + WWW_NUMPRO + "'"
            x_nord = "orf_numord = '" + WWW_NUMORD + "'"
            x_nddt = "orf_numddt = '" + WWW_NUMDDT + "'"
            x_cond = x_agga + " and " + x_csys + " and " + x_npro + " and " + x_nord + " and " + x_nddt
            cSql   = "SELECT * FROM U_ORF_DT WHERE " + x_cond
            IF !ExecRW(cSql,"U_ORF_DT","R")
               return(.f.)
            ENDIF 
            SELECT U_ORF_DT
            GO TOP
            DO WHILE .T.
               IF EOF()
                  EXIT
               ENDIF
               DELETE
               SKIP +1
            ENDDO
            *IF EOF()
            *ELSE
            *   REPLACE ORF_TIPAGG WITH 'A'
            *   REPLACE ORF_FLGTRA WITH .F.
            *   REPLACE ORF_FLGCON WITH M.ORD_FLGCON
            *ENDIF
            IF !ExecRW(cSql,"U_ORF_DT","W")
               return(.f.)
            ENDIF 
         ENDIF
      ENDIF
   ENDIF

   IF ZZZ_FLGTIP = 1
      x_agga = "orf_agganc = '" + WWW_LEGAME + "'"
      x_csys = "orf_unique = '" + WWW_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_CO WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_CO","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_CO
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE - M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_CO","W")
         return(.f.)
      ENDIF 
   ENDIF

   IF ZZZ_FLGTIP = 2
      x_uniq = "orf_unique = '" + ALLTRIM(WWW_CODSYS) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(WWW_LEGAME) + "'"
      x_cond = x_uniq + " and " + x_lega
      cSql   = "SELECT * FROM U_BOL_RE WHERE " + x_cond
      IF !ExecRW(cSql,"U_BOL_RE","R")
         return(.f.)
      ENDIF 
      SELECT U_BOL_RE
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE - M.ORD_QTAORD
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_BOL_RE","W")
         return(.f.)
      ENDIF 
   ENDIF
   
   SELECT CU_BFO_DD
   SKIP +1
   
ENDDO

RETURN


**************************************************************************
PROCEDURE BFOCANCI  && CANCELLAZIONE FISICA DEI RECORDS BOLLE FORNITORE
**************************************************************************

IF ZTB.ININSERIMENTO 
   RETURN
ENDIF

IF U_CANCELLA
ELSE
   RETURN
ENDIF

SWS=SELECT()

_DELETE = BOL_RECNO
CSQL    = "DELETE FROM U_BFO_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_BFO_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE BOLSCMAGA  && SCARICA IL MAGAZZINO
**************************************************************************

IF U_AGGIORNA
ELSE
   RETURN
ENDIF

IF ZTB.ININSERIMENTO
   IF M.ORD_CAUS = PUB_CTLO .AND. M.ORD_MAGD <> SPACE(06)
      x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
      x_anno = "ord_anno = '" + SUBSTR(M.ORD_DATCTL,1,4) + "'"
      x_nord = "ord_numord = '" + ALLTRIM(M.ORD_NUMCTL) + "'"
      x_cond = x_soci + " and " + x_anno + " and " + x_nord 
      Csql   = "select * from u_ctl_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord"
      IF !ExecCommand(cSql,"CUR_CTL_TT")
         return(.f.)
      ENDIF
      SELECT CUR_CTL_TT
      IF RECCOUNT() = 0
         V_ESISTECTL = 'NO'
         * PRELEVA IL N.DI ORDINE CONTO LAVORO
         v_seek   = 'NUMCTL'+PUB_CODSOC
         v_chiave = "codice"
         cSql     ="select * from para where " + v_chiave + " = '" + v_seek + "'"
         IF !ExecRW(cSql,"PARA","R")
            return(.f.)
         ENDIF
         SELECT PARA
         IF RECCOUNT() <> 0
            V2=VAL(ALLTRIM(SUBSTR(LIBERA,2,7))) + 1
            REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),2,7)
            M.ORD_NUMCTL = ALLTRIM(SUBSTR(LIBERA,2,7))
            M.ORD_DATCTL = DTOC(DATE())
         ELSE
            RIT = MSGBOX('Parametro numero ordine c/lavoro non trovato','ATTENZIONE',31)
            RETURN
         ENDIF
         IF !ExecRW(cSql,"PARA","W")
            return(.f.)
         ENDIF
         PUB_LNO      = 6
         M.ORD_NUMCTL = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMCTL))
         M.ORD_DATCTL = RIBALTA2(M.ORD_DATCTL)
         * PRELEVA UNCINO PER LEGARE TESTATA/DETTAGLIO
         X_TAGGANCIO = STR(NEWPROG('NUMCTL'),10)
         X_UNCINO    = X_TAGGANCIO
         * AGGIUNGE RECORD TESTATA SU DB
         SELECT CUR_CTL_TT
         APPEND BLANK
         GATHER MEMVAR 
         REPLACE TAGGANCIO  WITH X_TAGGANCIO
         REPLACE TNUMERO    WITH M.ORD_NUMCTL
         REPLACE ORD_CODSOC WITH PUB_CODSOC
         REPLACE ORD_NUMORD WITH M.ORD_NUMCTL
         REPLACE ORD_DATORD WITH M.ORD_DATCTL
         REPLACE ORD_ORA    WITH TIME()
         REPLACE ORD_CAUS   WITH PUB_CTLO
         REPLACE ORD_CODOPE WITH PUB_CODOPE
         REPLACE ORD_NUMBOL WITH M.ORD_NUMORD
         IF SUBSTR(M.ORD_DATORD,3,1) = '/'
            REPLACE ORD_DATBOL WITH ribalta2(M.ORD_DATORD)
         ELSE
            REPLACE ORD_DATBOL WITH M.ORD_DATORD
         ENDIF
         IF !ExecRW('','u_ctl_tt','I','','CUR_CTL_TT')
            return(.f.)
         ENDIF
      ELSE
         V_ESISTECTL = 'SI'
      ENDIF
   ENDIF
ENDIF

SELECT CU_BOL_DD
SET FILTER TO ORD_FLGMOD <> 'A'
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT CU_BOL_DD
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'M' .OR. ORD_FLGMOD = 'I'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   IF ZTB.ININSERIMENTO
      IF M.ORD_CAUS = PUB_CTLO .AND. M.ORD_MAGD <> SPACE(06)
         IF V_ESISTECTL = 'NO'
            cSql="select * from u_ctl_dd where 1=0"
            IF !ExecCommand(cSql,"CUR_CTL_DD")
               return(.f.)
            ENDIF
            SELECT CUR_CTL_DD
            APPEND BLANK
            GATHER MEMVAR
            REPLACE DAGGANCIO  WITH X_TAGGANCIO
            REPLACE ORD_MAGA   WITH M.ORD_MAGD
            REPLACE ORD_DATCON WITH RIBALTA2(M.ORD_DATCON)
            IF !ExecRW('','u_ctl_dd','I','','CUR_CTL_DD')
               return(.f.)
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   SELECT CU_BOL_DD
   SCATTER MEMVAR MEMO
   
   RELEASE XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   PUBLIC  XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   XYZ_FORNIT = M.ORD_FORNIT
   XYZ_RAGSOC = M.ORD_RAGFOR 
   XYZ_PRZUCA = M.ORD_PRZULC
   XYZ_RAGFOR = M.ORD_RAGFOR

   IF EMPTY(ALLTRIM(M.ORD_LEGSYS))
      M.ORD_LEGSYS = SYS(2015)
      REPLACE ORD_LEGSYS WITH M.ORD_LEGSYS
   ENDIF

   _TOPSCA = M.ORD_CAUS   

   v_seek   = 'TOP'+M.ORD_CAUS
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      _TOPCAR = SUBSTR(CODICE,4,3)   
   ELSE
      _TOPCAR = '100 '  
   ENDIF
   IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
      _TOPCAR = '100 '  
   ENDIF
  
   H_DADOVE = 'BOLSCMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = M.ORD_MAGD
   H_CODART = M.ORD_CODART
   H_TOPSCA = _TOPSCA
   H_TOPCAR = _TOPCAR
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = M.ORD_PRZCON
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = CSC
   H_GGG    = "SI"
   H_FORNIT = M.ORD_FORNIT
   H_FLGTRA = .F.
   H_LEGSYS = M.ORD_LEGSYS
   H_LEGAME = M.ORD_CODACQ
   =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS,H_LEGAME)

   *SELECT CU_BOL_DD
   *REPLACE ORD_FORNIT WITH XYZ_FORNIT 
   *REPLACE ORD_RAGFOR WITH XYZ_RAGSOC 
   *REPLACE ORD_PRZULC WITH XYZ_PRZUCA

   **==> Gestione del file delle bolle di reso da pdv a sede
   IF M.ORD_CAUS = PUB_CAUREF
      Csql   = "select * from u_bol_re where 1=0"
      IF !ExecRW(Csql,"U_BOL_RE","R")
         return(.f.)
      ENDIF
      SELECT U_BOL_RE
      APPEND BLANK
      REPLACE ORF_CODPDV WITH M.ORD_CODBUN
      REPLACE ORF_DESPDV WITH M.ORD_DESBUN
      REPLACE ORF_CODMAG WITH M.ORD_MAGA
      REPLACE ORF_CODART WITH M.ORD_CODART
      REPLACE ORF_DESART WITH M.ORD_DESART
      REPLACE ORF_UNITAM WITH M.ORD_UM
      REPLACE ORF_NUMPRO WITH M.ORS_NUMORC
      REPLACE ORF_DATPRO WITH M.ORS_DATORC
      REPLACE ORF_QTAPRO WITH M.ORD_QTAOLD
      REPLACE ORF_QTAORD WITH 0
      REPLACE ORF_QTADOR WITH 0
      REPLACE ORF_CODFOR WITH M.ORD_CODCLI
      REPLACE ORF_RAGSOC WITH M.ORD_RAGSOC
      REPLACE ORF_NUMORD WITH SPACE(06)
      REPLACE ORF_DATORD WITH SPACE(10)
      REPLACE ORF_PREZZO WITH M.ORD_PRZNET
      REPLACE ORF_DATCON WITH M.ORD_DATCON
      REPLACE ORF_CODSYS WITH SPACE(10)
      REPLACE ORF_FLGTRA WITH .F.
      REPLACE ORF_GIACEN WITH 0
      REPLACE ORF_QTAORF WITH 0
      REPLACE ORF_QUANTI WITH 0
      REPLACE ORF_SYSCOD WITH SPACE(10)
      REPLACE SELEZIONE  WITH SPACE(10)
      REPLACE ORF_AGGANC WITH M.DAGGANCIO
      REPLACE ORF_SYSSYS WITH SPACE(10)
      REPLACE ORF_ANNO   WITH M.ORD_ANNO
      REPLACE ORF_QTAAGG WITH 0
      REPLACE ORF_UNIQUE WITH M.ORD_CODSYS
      REPLACE ORF_TIPAGG WITH SPACE(01)
      REPLACE ORF_CHIUSO WITH .F.
      REPLACE ORF_QTAEV  WITH 0
      REPLACE ORF_DESTIN WITH 'SEDE'
      REPLACE ORF_NUMDDT WITH M.ORD_NUMORD
      REPLACE ORF_DATDDT WITH M.ORD_DATORD
      REPLACE ORF_QTADDT WITH M.ORD_QTAORD
      REPLACE ORF_FLGCON WITH .T.
      REPLACE ORF_QTASPE WITH 0
      REPLACE ORF_QTADSP WITH M.ORD_QTAORD
      REPLACE ORF_CODMIT WITH PUB_CLISOC
      REPLACE ORF_RAGMIT WITH PUB_RAGSOC
      REPLACE ORF_CDFORN WITH XYZ_FORNIT
      REPLACE ORF_DSFORN WITH XYZ_RAGFOR
      IF !ExecRW(Csql,"U_BOL_RE","W")
         return(.f.)
      ENDIF
   ENDIF

   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'S'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "BOL"
      ENDIF
      SELECT(SSSS)
   ENDIF

   SELECT CU_BOL_DD
   SKIP +1

ENDDO

RETURN


********************************************************************************
PROCEDURE BOLRIMAGA  && RICARICA IL MAGAZZINO (FASE DI AGGIORNAMENTO GESTIONALE)
********************************************************************************

SELECT CU_BOL_DD
SET FILTER TO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'A' .OR. ORD_FLGMOD = 'M'
   ELSE
      IF ORD_FLGMOD = 'I' 
         U_AGGIORNA = .T.
      ENDIF
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   DO MAG_IN_AGG WITH "CU_BOL_DD","U_BOL_DD","+","BOL"

   SELECT CU_BOL_DD
   SCATTER MEMVAR MEMO

   **==> Gestione del file delle bolle trasferite per i pdv
   x_uniq = "orf_unique = '" + ALLTRIM(M.ORD_CODSYS) + "'"
   x_lega = "orf_agganc = '" + ALLTRIM(M.ORD_LEGAME) + "'"
   x_cond = x_uniq + " and " + x_lega
   Csql   = "select * from u_orf_po where " + x_cond
   IF !ExecRW(Csql,"U_ORF_PO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_PO
   IF EOF()
   ELSE
      REPLACE ORF_QTASPE WITH ORF_QTASPE - M.ORD_QTAORD
   ENDIF
   IF !ExecRW(Csql,"u_orf_po","W")
      return(.f.)
   ENDIF
   
   **==> Gestione del file delle bolle di reso da pdv a sede
   IF M.ORD_CAUS = PUB_CAUREF
      x_uniq = "orf_unique = '" + ALLTRIM(M.ORD_CODSYS) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(M.DAGGANCIO) + "'"
      x_cond = x_uniq + " and " + x_lega
      Csql   = "select * from u_bol_re where " + x_cond
      IF !ExecRW(Csql,"U_BOL_RE","R")
         return(.f.)
      ENDIF
      SELECT U_BOL_RE
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         DELETE
         SKIP +1
      ENDDO
      IF !ExecRW(Csql,"U_BOL_RE","W")
         return(.f.)
      ENDIF
   ENDIF
   
   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'C'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "BOL"
      ENDIF
      SELECT(SSSS)
   ENDIF

   SELECT CU_BOL_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE BOLCANCI  && ANNULLO BOLLE IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

IF U_CANCELLA
ELSE
   RETURN
ENDIF

SWS=SELECT()

_DELETE = BOL_RECNO
CSQL    = "DELETE FROM U_BOL_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_BOL_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE BOLRESICA     && CARICA IL MAGAZZINO DA RESI CLIENTE
**************************************************************************

IF U_AGGIORNA
ELSE
   RETURN
ENDIF

SELECT CU_BOL_DD
SET FILTER TO ORD_FLGMOD <> 'A'
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'M' .OR. ORD_FLGMOD = 'I'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   IF EMPTY(ALLTRIM(M.ORD_LEGSYS))
      M.ORD_LEGSYS = SYS(2015)
      REPLACE ORD_LEGSYS WITH M.ORD_LEGSYS
   ENDIF
   
   *H_DADOVE = 'BFOCAMAG'
   H_DADOVE = 'RESO'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = ""
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = M.ORD_CAUS
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = M.ORD_PRZCON
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_GGG    = "SI"
   H_FORNIT = ""
   H_FLGTRA = .F.
   H_LEGSYS = M.ORD_LEGSYS
   =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS)
   
   SELECT CU_BOL_DD
   SKIP +1

ENDDO

RETURN


************************************************************************************
PROCEDURE BOLRESISC  && SCARICA IL MAGAZZINO (FASE DI AGGIORNAMENTO GESTIONALE)
************************************************************************************

SELECT CU_BOL_DD
SET FILTER TO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'A' .OR. ORD_FLGMOD = 'M'
   ELSE
      IF ORD_FLGMOD = 'I' 
         U_AGGIORNA = .T.
      ENDIF
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   DO MAG_IN_AGG WITH "CU_BOL_DD","U_BOL_DD","-","RES"

   SELECT CU_BOL_DD
   SKIP +1
   
ENDDO

RETURN


**************************************************************************
PROCEDURE ORDCAIMPE  && CARICA IMPEGNATO
**************************************************************************

IF U_AGGIORNA
ELSE
   RETURN
ENDIF

SELECT CU_ORD_DD
SET FILTER TO ORD_FLGMOD <> 'A'
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'M' .OR. ORD_FLGMOD = 'I'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   IF EMPTY(ALLTRIM(M.ORD_LEGSYS))
      M.ORD_LEGSYS = SYS(2015)
      REPLACE ORD_LEGSYS WITH M.ORD_LEGSYS
   ENDIF

   H_DADOVE = 'ORDCAIMP'
   H_GENMOV = "" 
   H_TIPO   = ""
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = "100"
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = ""
   H_PRZACQ = 0
   H_PRZVEN = 0
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = ""
   H_GGG    = ""
   H_FORNIT = ""
   H_FLGTRA = .F.
   H_LEGSYS = M.ORD_LEGSYS
   =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS)
   
   SELECT CU_ORD_DD
   SKIP +1

ENDDO

RETURN


****************************************************************************
PROCEDURE ORDSCIMPE  && SCARICA IMPEGNATO (FASE DI AGGIORNAMENTO GESTIONALE)
****************************************************************************

SELECT CU_ORD_DD
SET FILTER TO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'A' .OR. ORD_FLGMOD = 'M'
   ELSE
      IF ORD_FLGMOD = 'I' 
         U_AGGIORNA = .T.
      ENDIF
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   DO MAG_IN_AGG WITH "CU_ORD_DD","U_ORD_DD","-","ORD"

   SELECT CU_ORD_DD
   SKIP +1
   
ENDDO

RETURN


**************************************************************************
PROCEDURE ORDCANCI  && ANNULLO ORDINI CLIENTI IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

IF U_CANCELLA
ELSE
   RETURN
ENDIF

SWS=SELECT()

_DELETE = ORD_RECNO
CSQL    = "DELETE FROM U_ORD_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_ORD_DD")
   RETURN (.f.)
ENDIF 

RETURN


**************************************************************************
PROCEDURE FATSCMAGA  && SCARICA IL MAGAZZINO
**************************************************************************

IF U_AGGIORNA
ELSE
   RETURN
ENDIF

SELECT CU_FAT_DD
SET FILTER TO ORD_FLGMOD <> 'A'
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'M' .OR. ORD_FLGMOD = 'I'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   IF EMPTY(ALLTRIM(M.ORD_LEGSYS))
      M.ORD_LEGSYS = SYS(2015)
      REPLACE ORD_LEGSYS WITH M.ORD_LEGSYS
   ENDIF

   H_DADOVE = 'BOLSCMAG'
   H_GENMOV = 'SI' 
   H_TIPO   = 'GIA'
   H_IMPE   = IMPE
   H_MAGSCA = M.ORD_MAGA
   H_MAGCAR = ""
   H_CODART = M.ORD_CODART
   H_TOPSCA = '200'
   H_TOPCAR = ""
   H_QUANTI = M.ORD_QTAORD
   H_NUMDOC = M.ORD_NUMORD
   H_DATDOC = M.ORD_DATORD
   H_DATREG = RIBALTA2(DTOC(DATE()))
   H_ORAMOV = TIME()
   H_CLIFOR = M.ORD_CODCLI
   H_PRZACQ = M.ORD_PRZCON
   H_PRZVEN = M.ORD_PRZNET
   H_CODIVA = M.ORD_IVA
   H_SCONTO = M.ORD_SC1
   H_VALUTA = M.ORD_VALUTA
   H_NOTE   = ""
   H_CSC    = CSC
   H_GGG    = "SI"
   H_FORNIT = M.ORD_FORNIT
   H_FLGTRA = .F.
   H_LEGSYS = M.ORD_LEGSYS
   H_LEGAME = M.ORD_CODACQ
   =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS,H_LEGAME)

   SELECT CU_FAT_DD
   SKIP +1

ENDDO

RETURN


********************************************************************************
PROCEDURE FATRIMAGA  && RICARICA IL MAGAZZINO (FASE DI AGGIORNAMENTO GESTIONALE)
********************************************************************************

SELECT CU_FAT_DD
SET FILTER TO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'A' .OR. ORD_FLGMOD = 'M'
   ELSE
      IF ORD_FLGMOD = 'I' 
         U_AGGIORNA = .T.
      ENDIF
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   SCATTER MEMVAR MEMO	 	

   DO MAG_IN_AGG WITH "CU_FAT_DD","U_FAT_DD","+","BOL"

   SELECT CU_FAT_DD
   SKIP +1

ENDDO

RETURN


**************************************************************************
PROCEDURE FATCANCI  && ANNULLO FATTURE CLIENTI IN FASE DI VARIAZIONE
**************************************************************************

IF ZTB.ININSERIMENTO       
   RETURN
ENDIF

IF U_CANCELLA
ELSE
   RETURN
ENDIF

SWS=SELECT()

_DELETE = FAT_RECNO
CSQL    = "DELETE FROM U_FAT_DD WHERE DAGGANCIO = ?_DELETE"
IF !ExecCommand(CSQL,"U_FAT_DD")
   RETURN (.f.)
ENDIF 

RETURN


************************************************************************************
PROCEDURE MAG_IN_AGG  && AGGIORNAMENTO MAGAZZINO IN FASE DI AGGIORNAMENTO GESTIONALE
************************************************************************************

PARAMETERS _CURSORE,_TABELLA,_SEGNO,_DADOVE

*==> ACCESSO ALLA TABELLA SQL SUL RECORD LEGATO AL CURSORE

x_maga = "ord_maga = '" + ALLTRIM(M.ORD_MAGA) + "'"
x_lega = "ord_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
x_cond = x_maga + " and " + x_lega
cSql   = "SELECT * FROM " + ALLTRIM(_TABELLA) + " WHERE " + x_cond
IF !ExecCommand(cSql,"&_TABELLA")
   return(.f.)
ENDIF 
SELECT &_TABELLA
GO TOP
IF EOF()
   RETURN
ENDIF
    
*==> GESTIONE DEL CASO DI MODIFICA FATTA DALL'UTENTE :
*==> - SE E' STATA MODIFICATA LA SEQUENZA (NUMERO DI RIGA), VIENE ALZATO UN FLAG CHE INDICHERA'
*==>   ALLA FUNZIONE DI CANCELLAZIONE DEI RECORD DI TABELLA CHE DEVE CANCELLARLI TUTTI PERCHE'
*==>   POI VERRANNO REINSERITI CON LA NUOVA SEQUENZA.
*==> - VIENE AGGIORNATO IL RECORD DELLA TABELLA SQL (TRANNE LA SEQUENZA)
*==> - SE NON E' STATO MODIFICATO ALCUN CAMPO "CHIAVE", NON FA NIENTE, ALTRIMENTI VA AVANTI
*==>   PER CONTRAGGIORNARE GLI ARCHIVI DI MAGAZZINO

U_QTA    = ORD_QTAORD
U_LEGAME = ORD_LEGAME 
U_CODSYS = ORD_CODSYS

IF M.ORD_FLGMOD = 'M'
   U_ESCI = .F.
   IF ORD_SEQUEN = M.ORD_SEQUEN
   ELSE
      U_CANCELLA = .T.
   ENDIF
   IF ORD_CODART = M.ORD_CODART .AND. ;
      ORD_MAGA = M.ORD_MAGA .AND. ;
      ORD_QTAORD = M.ORD_QTAORD .AND. ;
      ORD_PRZNET = M.ORD_PRZNET .AND. ;
      ORD_IVA = M.ORD_IVA
      U_ESCI = .T.
   ENDIF
   IF U_CANCELLA
   ELSE
      IF !ExecRW(cSql,"&_TABELLA","R")
         return(.f.)
      ENDIF 
      SELECT &_TABELLA
      M.ORD_SEQUEN = ORD_SEQUEN
      M.ORD_FLGMOD = SPACE(01)
      DO &_TABELLA
      IF !ExecRW(cSql,"&_TABELLA","W")
         return(.f.)
      ENDIF 
   ENDIF
   IF U_ESCI
      RETURN
   ENDIF
ENDIF

*==> GESTIONE DEL CASO DI CANCELLAZIONE FATTA DALL'UTENTE :
*==> - VIENE CANCELLATO IL RECORD SULLA TABELLA SQL E POI VA AVANTI PER CONTRAGGIORNARE 
*==>   GLI ARCHIVI DI MAGAZZINO

IF M.ORD_FLGMOD = 'A'
   IF !ExecRW(cSql,"&_TABELLA","R")
      return(.f.)
   ENDIF 
   SELECT &_TABELLA
   DELETE
   IF !ExecRW(cSql,"&_TABELLA","W")
      return(.f.)
   ENDIF 
ENDIF

IF _DADOVE = 'BFO'
   IF ZZZ_FLGTIP = 1
      x_agga = "orf_agganc = '" + U_LEGAME + "'"
      x_csys = "orf_unique = '" + U_CODSYS + "'"
      x_cond = x_agga + " and " + x_csys
      cSql   = "SELECT * FROM U_ORF_CO WHERE " + x_cond
      IF !ExecRW(cSql,"U_ORF_CO","R")
         return(.f.)
      ENDIF 
      SELECT U_ORF_CO
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORF_QTASPE WITH ORF_QTASPE - U_QTA
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         SCATTER MEMVAR 
      ENDIF
      IF !ExecRW(cSql,"U_ORF_CO","W")
         return(.f.)
      ENDIF 
   ENDIF
ENDIF

IF _DADOVE = 'ORD'
   IF IMPE  = "X"
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
      x_maga = "mag_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"  
      x_codi = "mag_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecRW(cSql,"U_MAG_AN","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF RECCOUNT() <> 0
         REPLACE MAG_IMPORD WITH MAG_IMPORD - U_QTA
         REPLACE MAG_FLGTRA WITH .F.
         U_AGGIORNA = .T.
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF
   RETURN
ENDIF

*==> ACCESSO ALLA ANAGRAFICA ARTICOLI PER VERIFICARE SE TRATTASI DI ARTICOLO CHE MOVIMENTA 
*==> LA GIACENZA O MENO

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF EOF()
   RETURN
ENDIF
IF ART_NONMOV
   RETURN
ENDIF
IF _DADOVE = 'ACQ' .OR. SUBSTR(_DADOVE,1,3) = 'BFO'
   IF _SEGNO = '+'
      REPLACE ART_TOTCAR WITH ART_TOTCAR + U_QTA
   ELSE
      REPLACE ART_TOTCAR WITH ART_TOTCAR - U_QTA
   ENDIF
ENDIF
IF _DADOVE = 'VEN' .OR. SUBSTR(_DADOVE,1,3) = 'BOL'
   IF _SEGNO = '+'
      REPLACE ART_TOTSCA WITH ART_TOTSCA - U_QTA
   ELSE
      REPLACE ART_TOTSCA WITH ART_TOTSCA + U_QTA
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF

*==> LOOP SU TUTTI I MOVIMENTI DI MAGAZZINO CHE SONO LEGATI AL RECORD DEL GESTIONALE

x_maga = "mov_codpdv = '" + ALLTRIM(M.ORD_MAGA) + "'"
x_lega = "mov_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
x_cond = x_maga + " and " + x_lega
cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecRW(cSql,"U_MAG_MO","R")
   return(.f.)
ENDIF 
   
SELECT U_MAG_MO
GO TOP
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   IF M.MOV_SEGNO = '+'
      _SEGNO = '-'
   ELSE
      IF M.MOV_SEGNO = '-'
         _SEGNO = '+'
      ENDIF
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data   = "mag_datagg = '" + SPACE(10) + "'"
   x_codi   = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga   = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn   = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
   Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRw(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_tipo +  " and " + x_prez 
   Csql       = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH M.MOV_DTDOCU
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_LEGAME WITH M.MOV_LEGAME
      REPLACE MAG_CODACQ WITH M.MOV_CODACQ
      REPLACE MAG_PAGAME WITH M.MOV_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   QWE_FORNIT = MAG_FORNIT
   QWE_DESFOR = MAG_DESFOR
   QWE_CODACQ = MAG_CODACQ
   QWE_DESACQ = MAG_DESACQ
   QWE_PRZCON = MAG_PRZCON
   QWE_PAGAME = MAG_PAGAME
   QWE_LEGAME = MAG_LEGAME 
   QWE_NUMIDE = MAG_NUMIDE
   QWE_CODBUN = MAG_CODBUN
   QWE_ANNO   = MAG_ANNO
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF


   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "mag_datagg = '" + SPACE(10) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_tipo +  " and " + x_prez 
   Csql       = "select * from u_mag_da where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_DA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_DA
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH SPACE(10)
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_PRZCON WITH XXX_PRZACQ
      REPLACE MAG_CODACQ WITH QWE_CODACQ
      REPLACE MAG_DESACQ WITH QWE_DESACQ
      REPLACE MAG_PRZUFF WITH XXX_PRZACQ
      REPLACE MAG_PAGAME WITH QWE_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   M_GIAFOR = MAG_GIACEN
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_DA","W")
      return(.f.)
   ENDIF

   _DATAOGGI = RIBALTA2(DTOC(DATE()))
   
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "mag_datagg = '" + ALLTRIM(_DATAOGGI) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_tipo +  " and " + x_prez 
   Csql       = "select * from u_mag_da where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_DA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_DA
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH _DATAOGGI
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M_GIAFOR
      ELSE
         REPLACE MAG_GIACEN WITH M_GIAFOR * -1
      ENDIF
      REPLACE MAG_PRZCON WITH XXX_PRZACQ
      REPLACE MAG_CODACQ WITH QWE_CODACQ
      REPLACE MAG_DESACQ WITH QWE_DESACQ
      REPLACE MAG_PRZUFF WITH XXX_PRZACQ
      REPLACE MAG_PAGAME WITH QWE_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_DA","W")
      return(.f.)
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO E MAGAZZINO (STANDARD)
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecRW(cSql,"U_MAG_AN","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_AN
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV 
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_CODFOR WITH M.MOV_FORNIT
      REPLACE MAG_COSTO  WITH M.MOV_PREACQ
      REPLACE MAG_UNIMIS WITH M.MOV_UM
      REPLACE MAG_DTCREA WITH M.MOV_DTDOCU
      REPLACE MAG_CODTAG WITH M.MOV_CODTAG
      REPLACE MAG_DESTAG WITH M.MOV_DESTAG
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV	
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF

   * CREA IL MOVIMENTO DI CANCELLATO SU NUOVO ARCHIVIO ---------------------------
   Csql   = "select * from u_mag_ca where 1=0"
   IF !ExecRW(cSql,"U_MAG_CA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_CA
   APPEND BLANK
   DO U_MAG_MO
   REPLACE MOV_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_CA","W")
      return(.f.)
   ENDIF

   * CANCELLA IL MOVIMENTO ---------------------------
   SELECT U_MAG_MO
   DELETE

   U_AGGIORNA = .T.
      
   SKIP +1
      
ENDDO

IF !ExecRW(cSql,"U_MAG_MO","W")
   return(.f.)
ENDIF 

*==> LOOP SU TUTTI I MOVIMENTI DI TRASFERIMENTO CHE SONO LEGATI AL RECORD DEL GESTIONALE

x_maga = "orf_codbun = '" + ALLTRIM(M.ORD_MAGA) + "'"
x_lega = "orf_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
x_cond = x_maga + " and " + x_lega
cSql   = "SELECT * FROM U_ORF_CO WHERE " + x_cond
IF !ExecRW(cSql,"U_ORF_CO","R")
   return(.f.)
ENDIF 
   
SELECT U_ORF_CO
GO TOP
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR MEMO

   * CREA IL MOVIMENTO DI CANCELLATO SU NUOVO ARCHIVIO ---------------------------
   Csql   = "select * from u_can_co where 1=0"
   IF !ExecRW(cSql,"U_CAN_CO","R")
      return(.f.)
   ENDIF
   SELECT U_CAN_CO
   APPEND BLANK
   DO U_ORF_CO
   REPLACE ORF_FLGTRA WITH .F.
   REPLACE ORF_DATCAN WITH RIBALTA2(DTOC(DATE()))
   REPLACE ORF_ORACAN WITH TIME()
   IF !ExecRW(cSql,"U_CAN_CO","W")
      return(.f.)
   ENDIF

   * CANCELLA IL MOVIMENTO ---------------------------
   SELECT U_ORF_CO
   DELETE

   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_ORF_CO","W")
   return(.f.)
ENDIF

RETURN



*******************************************************************************************
PROCEDURE MAG_IN_AGG_RESO  && AGGIORNAMENTO MAGAZZINO IN FASE DI RESO RICHIAMATO DA MAGA000
*******************************************************************************************

PARAMETERS _ARTICOLO,_QUANTITA,_MAGAZZINO,_LEGAME

_LEGSYS = SYS(2015)

*==> ACCESSO ALLA ANAGRAFICA ARTICOLI PER VERIFICARE SE TRATTASI DI ARTICOLO CHE MOVIMENTA 
*==> LA GIACENZA O MENO

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_ARTICOLO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF EOF()
   RETURN
ENDIF
IF ART_NONMOV
   RETURN
ENDIF
REPLACE ART_TOTSCA WITH ART_TOTSCA - _QUANTITA
IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF

*==> LOOP SU TUTTI I MOVIMENTI DI MAGAZZINO CHE SONO LEGATI AL RECORD DEL GESTIONALE
   
x_maga = "mov_codmag = '" + ALLTRIM(_MAGAZZINO) + "'"
x_lega = "mov_legsys = '" + ALLTRIM(_LEGAME) + "'"
x_cond = x_maga + " and " + x_lega
cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecCommand(cSql,"U_MAG_MO")
   return(.f.)
ENDIF 
   
SELECT U_MAG_MO
GO TOP
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF _QUANTITA < 1
      EXIT
   ENDIF
   
   SCATTER MEMVAR MEMO

   IF M.MOV_QTAMOV > _QUANTITA
      M.MOV_QTAMOV = _QUANTITA
      _QUANTITA = 0
   ENDIF
   
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data   = "mag_datagg = '" + SPACE(10) + "'"
   x_codi   = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga   = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn   = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
   Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRw(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_giac = "mag_giacen > 0"
   x_tipo = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac +  " and " + x_tipo +  " and " + x_prez 
   Csql       = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH M.MOV_DTDOCU
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV 
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_LEGAME WITH M.MOV_LEGAME
      REPLACE MAG_CODACQ WITH M.MOV_CODACQ
      REPLACE MAG_PAGAME WITH M.MOV_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME
   PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME
   QWE_FORNIT = MAG_FORNIT
   QWE_DESFOR = MAG_DESFOR
   QWE_CODACQ = MAG_CODACQ
   QWE_DESACQ = MAG_DESACQ
   QWE_PRZCON = MAG_PRZCON
   QWE_PAGAME = MAG_PAGAME
   QWE_LEGAME = MAG_LEGAME 
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF


   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "mag_datagg = '" + SPACE(10) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_tipo +  " and " + x_prez 
   Csql       = "select * from u_mag_da where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_DA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_DA
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH SPACE(10)
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV 
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_PRZCON WITH XXX_PRZACQ
      REPLACE MAG_CODACQ WITH QWE_CODACQ
      REPLACE MAG_DESACQ WITH QWE_DESACQ
      REPLACE MAG_PRZUFF WITH XXX_PRZACQ
      REPLACE MAG_PAGAME WITH QWE_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   M_GIAFOR = MAG_GIACEN
   IF !ExecRW(cSql,"U_MAG_DA","W")
      return(.f.)
   ENDIF

   _DATAOGGI = RIBALTA2(DTOC(DATE()))
   
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "mag_datagg = '" + ALLTRIM(_DATAOGGI) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_tipo +  " and " + x_prez 
   Csql       = "select * from u_mag_da where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_DA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_DA
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH _DATAOGGI
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV 
      REPLACE MAG_PRZCON WITH XXX_PRZACQ
      REPLACE MAG_CODACQ WITH QWE_CODACQ
      REPLACE MAG_DESACQ WITH QWE_DESACQ
      REPLACE MAG_PRZUFF WITH XXX_PRZACQ
      REPLACE MAG_PAGAME WITH QWE_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_DA","W")
      return(.f.)
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO E MAGAZZINO (STANDARD)
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecRW(cSql,"U_MAG_AN","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_AN
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV 
      REPLACE MAG_CODFOR WITH M.MOV_FORNIT
      REPLACE MAG_COSTO  WITH M.MOV_PREACQ
      REPLACE MAG_UNIMIS WITH M.MOV_UM
      REPLACE MAG_DTCREA WITH M.MOV_DTDOCU
      REPLACE MAG_CODTAG WITH M.MOV_CODTAG
      REPLACE MAG_DESTAG WITH M.MOV_DESTAG
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV	
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF
   
   SELECT CUY_MAG_MOV
   APPEND BLANK
   GATHER MEMVAR MEMO

   SELECT CUR_MAG_MOV
   GO TOP
   SCATTER MEMVAR MEMO

   SELECT CUY_MAG_MOV
   REPLACE ID_UNIQUE  WITH ""
   REPLACE MOV_TOP    WITH M.MOV_TOP
   REPLACE MOV_NUMDOC WITH M.MOV_NUMDOC
   REPLACE MOV_DTDOCU WITH M.MOV_DTDOCU
   REPLACE MOV_DTREGI WITH M.MOV_DTREGI
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_ORAMOV WITH TIME()					
   REPLACE MOV_SEGNO  WITH '+'					
   REPLACE MOV_FLGTRA WITH .F.
   REPLACE MOV_TRASME WITH .F.
   REPLACE MOV_LEGSYS WITH _LEGSYS
   REPLACE MOV_TIPORI WITH M.MOV_TIPORI
   REPLACE MOV_NUMORI WITH M.MOV_NUMORI
   REPLACE MOV_DATORI WITH M.MOV_DATORI
   REPLACE MOV_FLGTRA WITH .F.
   REPLACE MOV_UNIQUE WITH SYS(2015)
      
   SELECT U_MAG_MO
   SKIP +1
      
ENDDO

SELECT CUY_MAG_MOV
GO TOP

IF !ExecRW('','u_mag_mo','I','','CUY_MAG_MOV')
   return(.f.)
ENDIF

RETURN


   
*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _DADOVE = NOME DELLA FUNZIONE O FORM O PRG DA CUI VIENE CHIAMATA
*           => 'ACQ' 'BFO'         = PROVENIENTE DA OPERAZIONI DI CARICO DA FORNITORE
*           => 'VEN' 'ECASH' 'BOL' = PROVENIENTE DA OPERAZIONI DI SCARICO PER VENDITA A CLIENTI
* _GENMOV = GENERAZIONE DEL MOVIMENTO
*           => 'SI' = GENERA IL MOVIMENTO (U_MAG_MO)
* _TIPO   = TIPO DI PROVENIENZA (DA COMPONENTI)
*           => 'GIA' = TOCCA LA GIACENZA
* _IMPE   = FLAG DI GESTIONE IMPEGNATO
*           => 'X' = GESTISCE CAMPI IMPEGNATO
* _MAGSCA = CODICE DEL MAGAZZINO DA CUI SCARICARE
* _MAGCAR = CODICE DEL MAGAZZINO SU CUI CARICARE
* _CODART = CODICE DELL'ARTICOLO DA MOVIMENTARE
* _TOPSCA = CODICE CAUSALE PER LO SCARICO
* _TOPCAR = CODICE CAUSALE PER IL CARICO
* _QUANTI = QUANTITA' DA MOVIMENTARE
* _NUMDOC = NUMERO DEL DOCUMENTO CHE HA GENERATO IL MOVIMENTO
* _DATDOC = DATA DEL DOCUMENTO CHE HA GENERATO IL MOVIMENTO
* _DATREG = DATA IN CUI E' AVVENUTA LA REGISTRAZIONE
* _ORAMOV = ORA IN CUI E' AVVENUTA LA REGISTRAZIONE DEL MOVIMENTO
* _CLIFOR = CODICE DEL CLIENTE/FORNITORE CHE HA GENERATO IL MOVIMENTO
* _PRZACQ = PREZZO DI ACQUISTO (SIGNIFICATIVO SOLO PER OPERAZIONI DI CARICO DA ACQUISTI)
* _PRZVEN = PREZZO DI VENDITA (SIGNIFICATIVO SOLO PER OPERAZIONI DI SCARICO PER VENDITA)
* _CODIVA = CODICE IVA
* _SCONTO = PERCENTUALE DI SCONTO
* _VALUTA = CODICE VALUTA
* _NOTE   = NOTE VARIE
* _CSC    = BOO
* _SAC    = ROTTURA PEZZO IN AVANZAMENTO LAVORI (PRODUZIONE)
* _GGG    = GESTISCE IL MAGAZZINO RIEPILOGATO PER GIORNO
* _FORNIT = CODICE FORNITORE DA CUI E' STATO SCARICATO IN FASE DI INCASSO
* _FLGTRA = FLAG CHE INDICA SE IL RECORD MOVIMENTO E' STATO TRASMESSO OPPURE NO
* _LEGSYS = CODSYS CHE SERVIRA' A LEGARE LA RIGA DOCUMENTO AL/AI MOVIMENTI DI MAGAZZINO
* _LEGAME = CODSYS CHE LEGA IN MODO UNIVOCO IL U_MAG_GG A TUTTI I SUOI MOVIMENTI U_MAG_MO,
*           OPPURE IL CODICE TIPO CONTRATTO DI ACQUISTO NEL CASO DI SCARICO CON BOLLA
*
*******************************************************************************

FUNCTION MOVIMAGAZ
PARAMETERS _DADOVE,_GENMOV,_TIPO,_IMPE,_MAGSCA,_MAGCAR,_CODART,_TOPSCA,_TOPCAR,_QUANTI,_NUMDOC,_DATDOC,_DATREG,_ORAMOV,_CLIFOR,_PRZACQ,_PRZVEN,_CODIVA,_SCONTO,_VALUTA,_NOTE,_CSC,_GGG,_FORNIT,_FLGTRA,_LEGSYS,_LEGAME

_N_PAR = PARAMETERS()
IF _N_PAR  = 23											
   _FORNIT = ""
   _FLGTRA = .F.
   _LEGSYS = SPACE(10)   
   _LEGAME = SPACE(10)
ENDIF														
IF _N_PAR  = 24
   _FLGTRA = .F.
   _LEGSYS = SPACE(10)
   _LEGAME = SPACE(10)   
ENDIF														
IF _N_PAR  = 25
   _LEGSYS = SPACE(10)
   _LEGAME = SPACE(10)   
ENDIF														

IF SUBSTR(_DATDOC,3,1) = '/'
   _DATDOC = RIBALTA2(_DATDOC)
ENDIF
IF SUBSTR(_DATREG,3,1) = '/'
   _DATREG = RIBALTA2(_DATREG)
ENDIF

RELEASE V_NAT,V_LIB,V_TMOV,X_SEGNO,V_NAT1,V_LIB1,V_TMOV1,X_SEGNO1
PUBLIC  V_NAT,V_LIB,V_TMOV,X_SEGNO,V_NAT1,V_LIB1,V_TMOV1,X_SEGNO1
V_NAT    = ""
V_LIB    = ""
V_TMOV   = ""
X_SEGNO  = ""
V_NAT1   = ""
V_LIB1   = ""
V_TMOV1  = ""
X_SEGNO1 = ""

PRIMA=SELECT()

v_seek   = 'TOP'+_TOPSCA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   M.NAT   = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
   M.LIB   = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
   M.TMOV  = SUBSTR(LIBERA,33,2)				
   _TOPCAR = SUBSTR(LIBERA,35,3)  && CAUSALE CONTRARIA A QUELLA DIGITATA
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF M.NAT = 'C' .OR. M.NAT = 'S'
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF _TOPSCA = PUB_CAUTRA
   IF EMPTY(ALLTRIM(_MAGCAR))
      _MAGCAR = 'VIAGGI'
   ENDIF
   v_seek   = 'TOP'+_TOPCAR
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_NAT1  = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
      V_LIB1  = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
      V_TMOV1 = SUBSTR(LIBERA,33,2)				
   ENDIF
   IF EMPTY(ALLTRIM(V_NAT1))
      V_NAT1   = 'C'
   ENDIF
   IF EMPTY(ALLTRIM(V_LIB1))
      V_LIB1   = M.LIB
   ENDIF
   IF EMPTY(ALLTRIM(V_TMOV1))
      V_TMOV1  = M.TMOV
   ENDIF
   IF V_NAT1 = 'C'
      X_SEGNO1 = '+'								
   ELSE 
      X_SEGNO1 = '-'
   ENDIF
   IF EMPTY(ALLTRIM(_TOPCAR))
      IF V_NAT1 = 'C'
         _TOPCAR = '100'								
      ELSE 
         _TOPCAR = '200'								
      ENDIF
   ENDIF
ENDIF

V_NAT  = M.NAT
V_LIB  = M.LIB
V_TMOV = M.TMOV

IF M.NAT = 'C'									
   X_SEGNO = '+'								
ELSE
   X_SEGNO = '-'								
ENDIF												

A_DESART = SPACE(45)
A_UNIMIS = SPACE(02)
A_PRZCOS = 0
A_PRZVEN = 0
A_CODIVA = SPACE(03)
A_CODTAG = SPACE(03)
A_DESTAG = SPACE(30)
A_CODCOL = SPACE(03)
A_DESCOL = SPACE(30)
A_COORD  = SPACE(30)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF RECCOUNT() <> 0
   IF ART_NONMOV
      RETURN
   ENDIF
   SCATTER MEMVAR MEMO
   IF X_SEGNO = '+'
      IF _DADOVE = 'ACQ' .OR. SUBSTR(_DADOVE,1,3) = 'BFO'
         IF _PRZACQ > 0
            REPLACE ART_PRZCOS WITH _PRZACQ
         ENDIF
         IF ART_ULDCAR < _DATDOC .OR. (ART_ULDCAR = _DATDOC .AND. ART_ULNCAR < _NUMDOC)
            REPLACE ART_ULDCAR WITH _DATDOC
            REPLACE ART_ULNCAR WITH _NUMDOC
            REPLACE ART_ULQCAR WITH _QUANTI
            REPLACE ART_ULPCAR WITH _PRZACQ
         ENDIF
         IF ART_CODF1 = _CLIFOR .OR. ART_CODF2 = _CLIFOR .OR. ART_CODF3 = _CLIFOR
            IF ART_CODF1 = _CLIFOR
               REPLACE ART_PRZCO1 WITH _PRZACQ
            ENDIF
            IF ART_CODF2 = _CLIFOR
               REPLACE ART_PRZCO2 WITH _PRZACQ
            ENDIF
            IF ART_CODF3 = _CLIFOR
               REPLACE ART_PRZCO3 WITH _PRZACQ
            ENDIF
         ELSE
            IF ART_CODF1 = SPACE(10) .OR. EMPTY(ART_CODF1)
               REPLACE ART_CODF1  WITH _CLIFOR
               REPLACE ART_PRZCO1 WITH _PRZACQ
            ELSE
               IF ART_CODF2 = SPACE(10) .OR. EMPTY(ART_CODF2)
                  REPLACE ART_CODF2  WITH _CLIFOR
                  REPLACE ART_PRZCO2 WITH _PRZACQ
               ELSE
                  IF ART_CODF3 = SPACE(10) .OR. EMPTY(ART_CODF3)
                     REPLACE ART_CODF3  WITH _CLIFOR
                     REPLACE ART_PRZCO3 WITH _PRZACQ
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         REPLACE ART_TOTCAR WITH ART_TOTCAR + _QUANTI
         x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
         x_maga   = "fpr_codmag = '" + ALLTRIM(_MAGSCA) + "'"
         x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
         x_forn   = "fpr_codfor = '" + ALLTRIM(_CLIFOR) + "'"
         x_cond   = x_soci + " and " + x_maga + " and " + x_codi + " and " + x_forn
         Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_codfor"
         IF !ExecRW(cSql,"U_FOR_PR","R")
            return(.f.)
         ENDIF
         SELECT U_FOR_PR
         GO TOP
         IF !EOF()
            IF FPR_DATUCA > _DATDOC
            ELSE
               REPLACE FPR_DATUCA WITH _DATDOC
               REPLACE FPR_NUMUCA WITH _NUMDOC
               REPLACE FPR_QTAUCA WITH _QUANTI
               REPLACE FPR_PRZUCA WITH _PRZACQ
            ENDIF
         ELSE
            F_RAGSOC = ""
            F_INDIRI = ""
            F_LOCALI = ""
            F_CAP    = ""
            F_PROVIN = ""
            F_TELEFO = ""
            x_soci   = "for_codsoc = '" + PUB_CODSOC + "'"
            x_codi   = "for_codcli = '" + ALLTRIM(_CLIFOR) + "'"
            x_cond   = x_soci + " and " + x_codi
            Csql     = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
            IF !ExecCommand(cSql,"u_for_an")
               return(.f.)
            ENDIF
            SELECT u_for_an
            GO TOP
            IF !EOF()
               F_RAGSOC = FOR_RAGSOC
               F_INDIRI = FOR_INDIR
               F_LOCALI = FOR_LOCALI
               F_CAP    = FOR_CAP
               F_PROVIN = FOR_PROVIN
               F_TELEFO = FOR_TELEFO
            ENDIF
            SELECT U_FOR_PR
            APPEND BLANK
            REPLACE FPR_CODSOC WITH PUB_CODSOC
            REPLACE FPR_CODMAG WITH _MAGSCA
            REPLACE FPR_CODART WITH _CODART
            REPLACE FPR_DESART WITH M.ART_DESCR 
            REPLACE FPR_CODFOR WITH _CLIFOR 
            REPLACE FPR_RAGFOR WITH F_RAGSOC 
            REPLACE FPR_INDIRI WITH F_INDIRI 
            REPLACE FPR_LOCALI WITH F_LOCALI 
            REPLACE FPR_CAP    WITH F_CAP 
            REPLACE FPR_PROVIN WITH F_PROVIN 
            REPLACE FPR_TELEFO WITH F_TELEFO 
            REPLACE FPR_DATUCA WITH _DATDOC
            REPLACE FPR_NUMUCA WITH _NUMDOC
            REPLACE FPR_QTAUCA WITH _QUANTI
            REPLACE FPR_PRZUCA WITH _PRZACQ
            REPLACE FPR_PRZCON WITH _PRZACQ
            REPLACE FPR_SEQPRI WITH 999
         ENDIF
         IF !ExecRW(cSql,"U_FOR_PR","W")
            return(.f.)
         ENDIF
      ENDIF
   ELSE
      IF _DADOVE = 'VEN' .OR. _DADOVE = 'ECASH' .OR. SUBSTR(_DADOVE,1,3) = 'BOL'
         IF _TOPSCA = PUB_CAUTRA
         ELSE
            IF ART_ULDSCA < _DATDOC .OR. (ART_ULDSCA = _DATDOC .AND. ART_ULNSCA < _NUMDOC)
               REPLACE ART_ULDSCA WITH _DATDOC
               REPLACE ART_ULNSCA WITH _NUMDOC
               REPLACE ART_ULQSCA WITH _QUANTI
               REPLACE ART_ULPSCA WITH _PRZVEN
               REPLACE ART_TOTSCA WITH ART_TOTSCA + _QUANTI
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   A_DESART = ART_DESCR
   A_UNIMIS = ART_UNIMIS
   A_PRZCOS = ART_PRZCOS
   A_PRZVEN = ART_PRZVEN
   A_CODIVA = ART_CODIVA
   A_CODTAG = ART_CODTAG
   A_DESTAG = ART_DESTAG
   A_CODCOL = ART_CODCOL
   A_DESCOL = ART_DESCOL
   A_COORD  = ART_COORD
   IF !ExecRW(cSql,"U_ART_PR","W")
      return(.f.)
   ENDIF
ELSE
   RETURN
ENDIF   

*-->> RICERCA DELL'ANAGRAFICA FORNITORE/CLIENTE  ----------------------------

RELEASE M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_PRZUCA,M_CODPDV,M_CODACQ,_CODCAS
PUBLIC  M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_PRZUCA,M_CODPDV,M_CODACQ,_CODCAS
M_CLIFOR = _CLIFOR
M_RAGSOC = ""
M_FORNIT = ""
M_DESFOR = ""
M_PRIMOF = _CLIFOR
M_QTAFOR = 0
M_QUANTI = _QUANTI
M_GENMOV = _GENMOV
M_GIAFOR = 0
M_PRZUCA = 0
M_CODPDV = PUB_CODBUN
M_CODACQ = _LEGAME
_CODCAS  = SPACE(03)

*==> OPERAZIONI SUL MAGAZZINO PRINCIPALE
=MAGAMOVIM(_MAGSCA,_MAGCAR,_TOPSCA,_TOPCAR)

XYZ_FORNIT = M_FORNIT
XYZ_RAGSOC = M_RAGSOC
XYZ_PRZUCA = M_PRZUCA

RELEASE M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_PRZUCA,M_CODPDV,_CODCAS
PUBLIC  M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_PRZUCA,M_CODPDV,_CODCAS
M_CLIFOR = _CLIFOR
M_RAGSOC = ""
M_FORNIT = ""
M_DESFOR = ""
M_PRIMOF = _CLIFOR
M_QTAFOR = 0
M_QUANTI = _QUANTI
M_GENMOV = _GENMOV
M_GIAFOR = 0
M_PRZUCA = 0
M_CODPDV = PUB_CODBUN
_CODCAS  = SPACE(03)

* INIZIO -  PER MAGAZZINO VIAGGIANTE
IF _TOPSCA = PUB_CAUTRA .OR. (_DADOVE = 'BOLRIMAG' .AND. _TOPCAR = PUB_CAUTRA)
   _MAGCAR = SPACE(06)
ENDIF
IF(_TOPSCA = PUB_CAUREF .AND. _CLIFOR = PUB_CFDEF) .OR. ;
  (_TOPCAR = PUB_CAUREF .AND. ALLTRIM(_NOTE) = ALLTRIM(PUB_CFDEF))  
   _MAGCAR = 'VIAGGI'
ENDIF
IF _DADOVE = 'BFOSCMAG' .OR. _DADOVE = 'BFOCAMAG'
   IF ZZZ_FLGTIP = 0 .OR. ZZZ_FLGTIP = 1 
   ELSE
      _MAGCAR = "VIAGGI"
      IF ZZZ_FLGTIP = 2
         _CLIFOR  = PUB_CFDEF
         M_CLIFOR = _CLIFOR
         M_PRIMOF = _CLIFOR
      ENDIF
   ENDIF
ENDIF
* FINE -  PER MAGAZZINO VIAGGIANTE

IF EMPTY(ALLTRIM(_MAGCAR)) 
ELSE
   *==> OPERAZIONI SUL MAGAZZINO COLLEGATO
   _TOPCAR  = SPACE(03)
   v_seek   = 'TOP'+_TOPSCA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      _TOPCAR = SUBSTR(LIBERA,35,3)
      M.NAT   = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
      IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
         IF M.NAT = 'C'									
            _TOPCAR = '200'
            X_SEGNO = '-'								
         ELSE
            _TOPCAR = '100'
            X_SEGNO = '+'								
         ENDIF
      ELSE
         IF M.NAT = 'C'									
            X_SEGNO = '-'								
         ELSE
            X_SEGNO = '+'								
         ENDIF
      ENDIF				
   ELSE
      IF X_SEGNO = '+' 
         _TOPCAR = '200'
         X_SEGNO = '-'
      ELSE
         _TOPCAR = '100'
         X_SEGNO = '+'
      ENDIF  
   ENDIF
   =MAGAMOVIM(_MAGSCA,_MAGCAR,_TOPSCA,_TOPCAR)
ENDIF

RETURN


*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _MAG = MAGAZZINO (DI CARICO/SCARICO)
* _TOP = CAUSALE   (DI CARICO/SCARICO) 
*
*******************************************************************************

FUNCTION MAGAMOVIM
PARAMETERS _MAG,_MAG1,_TOP,_TOP1

IF EMPTY(M_CLIFOR) .OR. M_CLIFOR = SPACE(10)
ELSE
   IF X_SEGNO = '+'
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
      IF !EOF()
         M_RAGSOC = FOR_RAGSOC
      ELSE
         x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "cli_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
         x_cond = x_soci + " and " + x_codi
         Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
         IF !ExecCommand(cSql,"u_cli_an")
            return(.f.)
         ENDIF
         SELECT u_cli_an
         GO TOP
         IF !EOF()
            M_RAGSOC = CLI_RAGSOC
         ENDIF
      ENDIF
   ELSE
      x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "cli_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
      IF !ExecCommand(cSql,"u_cli_an")
         return(.f.)
      ENDIF
      SELECT u_cli_an
      GO TOP
      IF !EOF()
         M_RAGSOC = CLI_RAGSOC
      ELSE
         x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "for_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
         x_cond = x_soci + " and " + x_codi
         Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
         IF !ExecCommand(cSql,"u_for_an")
            return(.f.)
         ENDIF
         SELECT u_for_an
         GO TOP
         IF !EOF()
            M_RAGSOC = FOR_RAGSOC
         ENDIF
      ENDIF
   ENDIF
ENDIF

*-->> RICERCA DEL FORNITORE PRINCIPALE CON AGGIORNAMENTO GIACENZE PER FORNITORE E MOVIMENTI --

IF _GGG = "SI"

   IF _DADOVE = 'VEN' .OR. _DADOVE = 'ECASH' .OR. SUBSTR(_DADOVE,1,3) = 'BOL' .OR. _DADOVE = 'SCARICO'

      *IF EMPTY(_FORNIT) .OR. _FORNIT = SPACE(10)
         IF PUB_FORPRE
            DO GESTIONE_FORN_PREF
         ELSE
            DO GESTIONE_NOFORN_PREF
         ENDIF
      *ELSE
      *   DO GESTIONE_FORN_SING
      *ENDIF
      
   ELSE

      DO GESTIONE_CARICA_MAGA

   ENDIF

   M_GENMOV = "NO"

ENDIF

*-->> SCARICA LA GIACENZA DI MAGAZZINO ----------------------------

DO MAGAZZINO_STANDARD

RETURN



