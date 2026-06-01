*****************************************************************************
* 				PROCEDURA PER L'ANNULLO DELLE REGISTRAZIONI CONTABILI       *
*****************************************************************************

************************** RILASCIO VARIABILI PUBBLICHE *********************
RELEASE COMPENSAZIONE_CLIENTE_FORNITORE 
PUBLIC COMPENSAZIONE_CLIENTE_FORNITORE 
COMPENSAZIONE_CLIENTE_FORNITORE  = .F.

RELEASE CONTO
RELEASE NOTE

RELEASE XVALUTA,XDATAVAL,XCAMBIO,XX_XVALUTA,XX_XDATAVAL,XX_XCAMBIO
RELEASE GUARDA
RELEASE IV
RELEASE M.DARE
RELEASE M.AVERE
RELEASE DARE
RELEASE AVERE
RELEASE DOVE_SONO
RELEASE X_CONTOP
RELEASE PUB_OK,RECX,M.NOTE,M.SOLOIVA,M.CONTO
RELEASE REC_COR    && USATO PER I CENTRI DI COSTO (IN MODIFICA LISTA)
RELEASE CCOD01,CCOD02,CCOD03,CCOD04,CCOD05,VDE
RELEASE TCOD01,TCOD02,TCOD03,TCOD04
RELEASE WCOD01,WCOD02,WCOD03,WCOD04,WCOD05,WCOD06,WCOD07,WCOD08,WCOD09,WCOD10,NUM_INT
RELEASE XCCLI,XCFOR
RELEASE NOTE
RELEASE M.COD01,M.DESCR01,M.SALDO01
RELEASE M.COD02,M.DESCR02,M.SALDO02
RELEASE M.COD03,M.DESCR03,M.SALDO03
RELEASE M.COD04,M.DESCR04,M.SALDO04
RELEASE M.COD05,M.DESCR05,M.SALDO05
RELEASE M.COD06,M.DESCR06,M.SALDO06
RELEASE M.COD07,M.DESCR07,M.SALDO07
RELEASE M.COD08,M.DESCR08,M.SALDO08
RELEASE M.COD09,M.DESCR09,M.SALDO09
RELEASE M.COD10,M.DESCR10,M.SALDO10
RELEASE PAR_CF,CCO,DESCCO,CECOS
RELEASE XXX_TIPODO,XXX_NPROG,XXX_DATPAG,XXX_NREG,XXX_DATSCA,F_CPA
RELEASE V_FR,TP,M.CECO
RELEASE M.DESCRIC,M.IMPOSTA,DARE,AVERE,M.T_DARE,M.T_AVERE,CONTROLLO
RELEASE M.N_CONTO,M.NDESCRI,MODIFY,TP,ACCODA,NPART,NPROT,DESPAG
RELEASE M.DOCU,NATURA,VERO,TOPX,NREG,PN_C,NATURA,OK_QUADRA,CON,CONIVAX
RELEASE DA,AV,V_CONPAG,DATADOC,FATTURA,VER_CONTO,X_NREG,X_NPROT
RELEASE DTREG
RELEASE NUM_REC,M.CODICE3
RELEASE XXTIPOCO

************************** DEFINIZIONE VARIABILI PUBBLICHE ******************
PUBLIC XVALUTA,XDATAVAL,XCAMBIO,XX_XVALUTA,XX_XDATAVAL,XX_XCAMBIO
PUBLIC GUARDA
PUBLIC IV
PUBLIC M.CONTO
PUBLIC M.DARE
PUBLIC M.AVERE
PUBLIC DARE
PUBLIC AVERE
PUBLIC DOVE_SONO
PUBLIC X_CONTOP
PUBLIC PUB_OK,RECX,M.NOTE,M.SOLOIVA
PUBLIC REC_COR    && USATO PER I CENTRI DI COSTO (IN MODIFICA LISTA)
PUBLIC CCOD01,CCOD02,CCOD03,CCOD04,CCOD05,VDE
PUBLIC TCOD01,TCOD02,TCOD03,TCOD04
PUBLIC WCOD01,WCOD02,WCOD03,WCOD04,WCOD05,WCOD06,WCOD07,WCOD08,WCOD09,WCOD10,NUM_INT
PUBLIC XCCLI,XCFOR
PUBLIC NOTE
PUBLIC M.COD01,M.DESCR01,M.SALDO01
PUBLIC M.COD02,M.DESCR02,M.SALDO02
PUBLIC M.COD03,M.DESCR03,M.SALDO03
PUBLIC M.COD04,M.DESCR04,M.SALDO04
PUBLIC M.COD05,M.DESCR05,M.SALDO05
PUBLIC M.COD06,M.DESCR06,M.SALDO06
PUBLIC M.COD07,M.DESCR07,M.SALDO07
PUBLIC M.COD08,M.DESCR08,M.SALDO08
PUBLIC M.COD09,M.DESCR09,M.SALDO09
PUBLIC M.COD10,M.DESCR10,M.SALDO10
PUBLIC PAR_CF,CCO,DESCCO,CECOS
PUBLIC XXX_TIPODO,XXX_NPROG,XXX_DATPAG,XXX_NREG,XXX_DATSCA,F_CPA
PUBLIC V_FR,TP,M.CECO
PUBLIC M.DESCRIC,M.IMPOSTA,DARE,AVERE,M.T_DARE,M.T_AVERE,CONTROLLO
PUBLIC M.N_CONTO,M.NDESCRI,MODIFY,TP,ACCODA,NPART,NPROT,DESPAG
PUBLIC M.DOCU,NATURA,VERO,TOPX,NREG,PN_C,NATURA,OK_QUADRA,CON,CONIVAX
PUBLIC DA,AV,V_CONPAG,DATADOC,FATTURA,VER_CONTO,X_NREG,X_NPROT
PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2],DTREG
PUBLIC NUM_REC,M.CODICE3
PUBLIC XXTIPOCO
M.CONTO = SPACE(13)
M.CECO  = SPACE(13)

************************** ULTERIORE CONTROLLO CONTABILE ********************

v_seek	= 'ANN' + PUB_CODSOC + PUB_ANNO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,1,6)=='APERTO'
   ELSE
      PUB_ERRORE=MESSAGEBOX('Anno contabile :'+PUB_ANNO+CHR(13)+'non aperto',64,'*** ATTENZIONE ***')
      RETURN
   ENDIF 
ELSE
   PUB_ERRORE=MESSAGEBOX('Anno contabile :'+PUB_ANNO+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN
ENDIF

************************** INIZIALIZZO VARIABILI PRIMA NOTA *****************



************************** VALORIZZA VALUTA DI RIFERIMENTO  ********************

XDATAVAL = ""
XCAMBIO  = 0
XVALUTA  = PUB_VALRIF

************************** VALORIZZA VALUTA DI RIFERIMENTO  ********************

GUARDA = .F.

X_CONTOP  = SPACE(13)
DOVE_SONO = 0
M.DARE    = 0
M.AVERE   = 0
DARE      = 0
AVERE     = 0

PUB_MODIFICA = .F.
PUB_CANCELLA = .F.
PUB_BLOCCA   = .T.

RECX   = 0
M.NOTE = SPACE(1)
M.SOLOIVA = 0

REC_COR = 0
VDE    = SPACE(20)
XCCLI  = SPACE(10)
XCFOR  = SPACE(10)

PUB_OK = .F.   && VERIFICA SE EFFETTIVAMENTE AGGIORNA GLI ARCHIVI
M.COD01=SPACE(13)
M.COD02=SPACE(13)
M.COD03=SPACE(13)
M.COD04=SPACE(13)
M.COD05=SPACE(13)
M.COD06=SPACE(13)
M.COD07=SPACE(13)
M.COD08=SPACE(13)
M.COD09=SPACE(13)
M.COD10=SPACE(13)

M.DESCR01=SPACE(13)
M.DESCR02=SPACE(13)
M.DESCR03=SPACE(13)
M.DESCR04=SPACE(13)
M.DESCR05=SPACE(13)
M.DESCR06=SPACE(13)
M.DESCR07=SPACE(13)
M.DESCR08=SPACE(13)
M.DESCR09=SPACE(13)
M.DESCR10=SPACE(13)

NUM_INT = SPACE(13)
WCOD01  = SPACE(13)
WCOD02  = SPACE(13)
WCOD03  = SPACE(13)
WCOD04  = SPACE(13)
WCOD05  = SPACE(13)
WCOD06  = SPACE(13)
WCOD07  = SPACE(13)
WCOD08  = SPACE(13)
WCOD09  = SPACE(13)
WCOD10  = SPACE(13)

CCOD01  = SPACE(13)
CCOD02  = SPACE(13)
CCOD03  = SPACE(13)
CCOD04  = SPACE(13)
CCOD05  = SPACE(13)

TCOD01  = SPACE(13)
TCOD02  = SPACE(13)
TCOD03  = SPACE(13)
TCOD04  = SPACE(13)

M.SALDO01=0
M.SALDO02=0
M.SALDO03=0
M.SALDO04=0
M.SALDO05=0
M.SALDO06=0
M.SALDO07=0
M.SALDO08=0
M.SALDO09=0
M.SALDO10=0

CECOS  = SPACE(13)
CCO    = SPACE(13)
DESCCO = SPACE(20)
PAR_CF = 0
DES    = ""
DATAREG= SPACE(10)
******************************** GESTIONE DATA DI REGISTRAZIONE ***********************


  
IF EMPTY(DATAREG)
   DT=DTOC(DATE())
   DT2=RIBALTA2(DT)
   D=SUBSTR(DT2,1,4)
   T3=SUBSTR(DT2,6,2)
   DAT=D+T3

   v_seek	= 'APE' + DAT + PUB_CODSOC
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      IF SUBSTR(LIBERA,1,6)='CHIUSO'
	     PUB_ERRORE=MESSAGEBOX('Anno contabile chiuso',292,'*** ATTENZIONE ***')   
         RETURN     
      ELSE
         DATAREG=DTOC(DATE())
      ENDIF
   ENDIF  
   
ENDIF

******************************** GESTIONE DATA DI REGISTRAZIONE ***********************

NUM_REC   = 0
M.CODICE3 = SPACE(13)
M.IMPOSTA = 0   
DESPAG    = SPACE(30)
VET_DAL[1]= "0000"      
VET_DAL[2]= "0000"
VET_AL[1] = "0000"
VET_AL[2] = "0000" 
VET_DAY[1]= "0000" 
VET_DAY[2]= "0000"
 
F_CPA=.F.
V_FR =.F.  
TP   = " " 
   
XXX_TIPODO  = SPACE(03)
XXX_DATPAG  = SPACE(10) 
XXX_NPROG   = 0
XXX_NREG    = SPACE(10)
XXX_DATSCA  = SPACE(10)
XX_XVALUTA  = SPACE(3)
XX_XDATAVAL = SPACE(10)
XX_XCAMBIO  = 0
 
DTREG      = SPACE(10)  
X_NREG     = SPACE(6)
X_NPROT    = SPACE(10)
VER_CONTO  = SPACE(1)
DATADOC    = SPACE(10)  
FATTURA    = SPACE(1) 
DA = 0
AV = 0
CONIVAX    = SPACE(10)
V_CONPAG   = SPACE(03)
CON        = SPACE(13)
OK_QUADRA  = .F.
NATURA     = SPACE(01)
NPROT      = SPACE(6)
PN_C       = SPACE(6)
TOPX       = SPACE(03)
VERO       = .F.
NATURA     = SPACE(1)
TOTDOCU    = 0
NPART      = 0
ACCODA     = .T.
TP         = SPACE(1)
MODIFY     = .F.
M.N_CONTO  = SPACE(20)
M.N_DESCRI = SPACE(40)
CPA        = SPACE(03)
DESPAG     = SPACE(30)
DATASCAD   = SPACE(10)

IF PUB_VOLTE = 0     && VARIABILE INIZIALIZZATA IN BEG... PRIMO PGM
   PUB_VOLTE = 1     && VARIABILE INIZIALIZZATA IN BEG... PRIMO PGM
   M.IMPOSTA = 0
ENDIF
	
DES        = SPACE(40) 
M.DARE     = 0
M.AVERE    = 0
M.T_DARE   = 0
M.T_AVERE  = 0
M.T_IMPOSTA= 0
M.DESCRIC  = SPACE(25)
NREG       = SPACE(10)

*SELECT CONTI

=DEF_CGE()

DO CASE

   CASE PUB_VARPN
        PUB_DESBAR="VARIAZIONE PRIMA NOTA ANNO CONTABILE :"+PUB_ANNO  
   CASE PUB_RICPN
        PUB_DESBAR="RICERCA PRIMA NOTA ANNO CONTABILE : "+PUB_ANNO   
   CASE PUB_ANNPN  
        PUB_DESBAR="ANNULLO PRIMA NOTA ANNO CONTABILE : "+PUB_ANNO   
   OTHERWISE
        PUB_DESBAR="INSERIMENTO PRIMA NOTA ANNO CONTABILE : "+PUB_ANNO
ENDCASE

IF PUB_RICPN
   PUB_DESBAR="RICERCA PRIMA NOTA ANNO CONTABILE : "+PUB_ANNO   
ENDIF

**************************************************************************
*             ===>>>  CASO DI VARIAZIONE PN  <<<===                      *  
**************************************************************.SER********
   
IF (PUB_VARPN=.T.) .OR. (PUB_ANNPN=.T.)

   M.TOTDOCU = 0

   x_soci = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno = "mov_anno = '" + PUB_ANNO + "'"
   x_nume = "mov_numpro = '" + PUB_REGIN + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_nume
   cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(cSql,"CUR_MOVCONT")
      RETURN .F.
   ENDIF
   SELECT CUR_MOVCONT
   GO TOP		

   DO WHILE .T.
   
      IF EOF()
         EXIT
      ENDIF

      IF DELETED()
         SKIP +1
         LOOP
      ENDIF  

      *===>> SCARTA I RECORD IVA DETERMINATI AUTOMATICAMENTE 
      IF  (MOV_IVA<>'NO ') .AND. (MOV_IMPOST=0)

          **--> VERIFICA SE IVA E' INDEDUCIBILE O MOVIMENTO ESENTE IVA

          XXCONTO=MOV_CONTO
          SS=STR(SELECT())

         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_cont = "con_conto = '" + XXCONTO + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_cont
         cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(cSql,"CUR_CONTI")
            RETURN .F.
         ENDIF
         SELECT CUR_CONTI
         GO TOP   
         IF !EOF()
            XXTIPOCO=CON_TIPOCO
         ELSE
            RIT=MSGBOX('Non esiste il conto '+XXCONTO+' su;piano dei conti','ATTENZIONE',31)
            XXTIPOCO='I'
         ENDIF
         SELECT &SS
      
         SELECT CUR_MOVCONT

         IF XXTIPOCO='I'
            SKIP +1
            LOOP
         ENDIF  
      ENDIF
   
      WCONTO     = MOV_CONTO
      WDESCRIZ   = MOV_DESMOV
      WDARE      = 0
      WAVERE     = 0 
      WCCAGE     = MOV_CEE 
	
      IF MOV_TMOV='D'
         WDARE=MOV_IMP
         *M.TOTDOCU = M.TOTDOCU + MOV_IMP
      ELSE  
         WAVERE=MOV_IMP
      ENDIF

      WCOD01  = SPACE(13)
      WCOD02  = SPACE(13)
      WCOD03  = SPACE(13)
      WCOD04  = SPACE(13)
      WCOD05  = SPACE(13)
      WCOD06  = SPACE(13)
      WCOD07  = SPACE(13)
      WCOD08  = SPACE(13)
      WCOD09  = SPACE(13)
      WCOD10  = SPACE(13)

      WIVA       = MOV_IVA
      WIMPOSTA   = MOV_IMPOST
      WIMPOSTA_D = 0
      WIMPOSTA_A = 0
      WNATURA    = MOV_TMOV 
      M.CECO     = MOV_CCO
      M.CCLI     = MOV_CCLI	
      M.CFOR     = MOV_CFOR	
      M.NOTE     = MOV_NOTE
      NUM_INT    = MOV_NUMPRO	
      WCOD01     = MOV_CCO
      X_CONTOP   = ALLTRIM(MOV_CONTOP)

      XVALUTA    = MOV_VALUTA
      XDATAVAL   = RIBALTA2(MOV_DTVAL)
      XCAMBIO    = MOV_CAMBIO

      M.SALDO01=0
      M.SALDO02=0
      M.SALDO03=0
      M.SALDO04=0
      M.SALDO05=0
      M.SALDO06=0
      M.SALDO07=0
      M.SALDO08=0
      M.SALDO09=0
      M.SALDO10=0
   
      DO CERCA_CCO        && CERCA I CENTRI DI COSTO PER QUESTA RIGA DI PRIMANOTA

      SELECT CUR_MOVCONT
     
      *===>>> VA SU ARCHIVIO CONTI PER IDENTIFICARE IL CONTO (CLI/FOR)
      XXCONTO=MOV_CONTO
      SS=STR(SELECT())
 
      x_soci = "con_soc = '" + PUB_CODSOC + "'"
      x_anno = "con_anno = '" + PUB_ANNO + "'"
      x_cont = "con_conto = '" + XXCONTO + "'"
      x_cond = x_soci + " and " + x_anno + " and " + x_cont
      cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
      IF !ExecCommand(cSql,"CUR_CONTI")
         RETURN .F.
      ENDIF
      SELECT CUR_CONTI
      GO TOP   
      IF !EOF()
         XXTIPOCO=CON_TIPOCO
      ELSE
         RIT=MSGBOX('Non esiste il conto '+XXCONTO+' su;piano dei conti','ATTENZIONE',31)
         XXTIPOCO=' '
      ENDIF
     
      SELECT &SS

      SELECT CUR_MOVCONT
    
      *===>>> CARICA VARIABILI DI TESTATA

      DATAREG  = RIBALTA2(MOV_DTREG)
      DATADOC  = RIBALTA2(MOV_DTDOC)
      NDOC     = MOV_NDOC
      NPROT    = MOV_NPROT    
      NREG     = MOV_NREGIS
      M.TOP    = MOV_TOP
      V_FR     = MOV_FATRI
      WSOLOIVA = MOV_IMPORT

      v_seek	= 'TOP' + M.TOP
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         DES=DESCRI     
      ELSE
         DES=SPACE(20)
      ENDIF
     
      M.TOTDOCU   = 0   
     
      x_soci = "con_soc = '" + PUB_CODSOC + "'"
      x_anno = "con_anno = '" + PUB_ANNO + "'"
      x_cont = "con_conto = '" + ALLTRIM(WCONTO) + "'"
      x_cond = x_soci + " and " + x_anno + " and " + x_cont
      cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
      IF !ExecCommand(cSql,"CUR_CONTI")
         RETURN .F.
      ENDIF
      SELECT CUR_CONTI
      GO TOP   
      IF !EOF()
         WDESCRI  =  CON_DESCR
      ELSE
         WDESCRI  =  SPACE(35)  
      ENDIF
   
      SELECT CORPO_MOV
      APPEND BLANK
      REPLACE CONTO     WITH WCONTO
      REPLACE DESCRIC   WITH WDESCRI
      REPLACE DESCRIZ   WITH WDESCRIZ
      REPLACE DARE      WITH WDARE
      REPLACE AVERE     WITH WAVERE 
      REPLACE IVA       WITH WIVA
      REPLACE IMPOSTA   WITH WIMPOSTA
      REPLACE IMPOSTA_D WITH WIMPOSTA_D
      REPLACE IMPOSTA_A WITH WIMPOSTA_A
      REPLACE NATURA    WITH WNATURA
      REPLACE SOLOIVA   WITH WSOLOIVA
      REPLACE CECO      WITH M.CECO
      REPLACE COD01     WITH WCOD01
      REPLACE COD02     WITH WCOD02
      REPLACE COD03     WITH WCOD03
      REPLACE COD04     WITH WCOD04
      REPLACE COD05     WITH WCOD05
      REPLACE COD06     WITH WCOD06
      REPLACE COD07     WITH WCOD07
      REPLACE COD08     WITH WCOD08
      REPLACE COD09     WITH WCOD09
      REPLACE COD10     WITH WCOD10
      REPLACE NOTE      WITH M.NOTE 
      REPLACE SALDO01   WITH M.SALDO01
      REPLACE SALDO02   WITH M.SALDO02
      REPLACE SALDO03   WITH M.SALDO03
      REPLACE SALDO04   WITH M.SALDO04
      REPLACE SALDO05   WITH M.SALDO05
      REPLACE SALDO06   WITH M.SALDO06
      REPLACE SALDO07   WITH M.SALDO07
      REPLACE SALDO08   WITH M.SALDO08
      REPLACE SALDO09   WITH M.SALDO09
      REPLACE SALDO10   WITH M.SALDO10
      REPLACE CCLI      WITH M.CCLI	
      REPLACE CFOR      WITH M.CFOR	
      REPLACE CCAGE     WITH WCCAGE
      REPLACE CONTOP    WITH X_CONTOP
      REPLACE OK_PMULT  WITH "N"

      *** =CERCA_PART()     && CERCA LA PARTITA DEL CLIENTE/FORNITORE
   
      SELECT CUR_MOVCONT
      SKIP +1
   ENDDO 
 
   SS=SELECT()
   * RIPUNTA SUI PARTITARI PER PRELEVARE N.PROT (ERRORI INIZIALI SW)
   IF EMPTY(NPROT)
      *** 
      *** ACCESSO PRIMA AL PARTITARIO CLIENTI 
      *** PER NON TROVATO ACCESSO AL PARTITARIO FORNITORI
  
      XXX_TROVATO = .F.

      x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
      x_anno = "par_anno = '" + PUB_ANNO + "'"
      x_nume = "par_numpro = '" + ALLTRIM(PUB_REGIN) + "'"
      x_cond = x_soci + " and " + x_anno + " and " + x_nume
      cSql = "select * from part_cli where " + x_cond + " order by par_codsoc,par_anno,par_numpro"
      IF !ExecCommand(cSql,"CUR_PARTCLI")
         RETURN .F.
      ENDIF
      SELECT CUR_PARTCLI
      GO TOP
      IF !EOF()
         XXX_TROVATO=.T.
      ELSE
         x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
         x_anno = "par_anno = '" + PUB_ANNO + "'"
         x_nume = "par_numpro = '" + ALLTRIM(PUB_REGIN) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_nume
         cSql = "select * from part_for where " + x_cond + " order by par_codsoc,par_anno,par_numpro"
         IF !ExecCommand(cSql,"CUR_PARTFOR")
            RETURN .F.
         ENDIF
         SELECT CUR_PARTFOR
         GO TOP
         IF !EOF()    
            XXX_TROVATO=.T.
         ENDIF    
      ENDIF
  
      IF XXX_TROVATO  
         NPROT = STR(PAR_NPART)    
      ELSE
         *WAIT WINDOW "NON TROVATO N.PROTOCOLLO (?)"
      ENDIF

   ENDIF  
    
   SELECT(SS)
  
   M.CECO    = SPACE(13) 
   M.CONTO   = SPACE(13) 
   M.DESCRIC = SPACE(40)
   M.DARE	 = 0  
   M.AVERE	 = 0
   M.IVA	 = SPACE(3)
   M.IMPOSTA = 0
   M.DESCRIZ = SPACE(40)
   MODIFY    = .T.
  
   SELECT CORPO_MOV
   GO TOP

   DO QUAD_VAR

ENDIF

*************************************************************************      
* 				INIZIO ANNULLO ARCHIVI CONTABILI						*
*************************************************************************

SELECT CORPO_MOV
GO TOP

* VERIFICA SE TOP CHI E ANNO PRECEDENTE APERTO
IF M.TOP = "CHI"
   v_seek	= 'ANN' + PUB_CODSOC + PUB_ANNO
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      IF SUBSTR(LIBERA,1,6)=='APERTO'
	  ELSE
	     PUB_ERRORE=MESSAGEBOX('Esercizio contabile precedente :'+PUB_ANNOP+CHR(13)+'non aperto',64,'*** ATTENZIONE ***')
         RETURN 
	  ENDIF 
   ELSE
	  PUB_ERRORE=MESSAGEBOX('Anno contabile :'+PUB_ANNOP+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
	  RETURN 
   ENDIF
ENDIF

* VERIFICA SE MESE CONTABILE CHIUSO
MMCLO = SUBSTR(DATAREG,4,2)
v_seek	= 'MES' + PUB_ANNO + MMCLO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,1,1) = "S"
  	  =MSGBOX("Mese contabile "+PUB_ANNO+"/"+MMCLO+" chiuso"+CHR(13)+"Registrazione impossibile",'ATTENZIONE',31)
      RETURN
   ENDIF	
ENDIF

* VERIFICA SE ESISTE VALUTA/CAMBIO

IF EMPTY(XVALUTA)     && NON E' POSSIBILE REGISTRARE SE MANCA VALUTA
   PUB_ERRORE=MESSAGEBOX("E' indispensabile digitare la valuta"+CHR(13)+"annullo impossibile",64,"*** ATTENZIONE ***")
   RETURN
ENDIF	
IF XCAMBIO = 0     && NON E' POSSIBILE REGISTRARE SE MANCA CAMBIO
   PUB_ERRORE=MESSAGEBOX("E' indispensabile digitare il cambio"+CHR(13)+"annullo impossibile",64,"*** ATTENZIONE ***")
   RETURN
ENDIF	

*********************************************************************************************
**==> Cursore per gestire i centri di costo illimitati (MINERVA)
CREATE CURSOR CORPO_CCO ;
       (CCO_CODSYS C(10),   CCO_CODGRU C(10),  CCO_DESGRU C(50),  CCO_CODCCO C(13),   ;
        CCO_DESCCO C(50),   CCO_NATURA C(01),  CCO_PERCEN N(6,2), CCO_VALORE N(17,2), ;
        CCO_MOVGRU C(10),   CCO_MOVCCO C(13))
INDEX ON CCO_CODSYS                           TAG I_CORPO1 ADDITIVE
INDEX ON CCO_CODSYS + CCO_CODGRU + CCO_CODCCO TAG I_CORPO2 ADDITIVE
INDEX ON CCO_CODSYS + CCO_MOVGRU + CCO_MOVCCO TAG I_CORPO3 ADDITIVE

ANNULLO = .T.
DO REG_RIAGGI
DO REG_CLEAR

********************************************************************************************* 

DO REG_CLEAR             && AZZERAMENTO VARIABILI PN

IF (PUB_VARPN=.T.) .OR. (PUB_ANNPN=.T.) .OR. (PUB_RICPN=.T.)
   PUB_REGIN		=SPACE(15)
   PUB_RICPN		=.F.
   PUB_ANNPN		=.F.
   PUB_VARPN		=.F.
ENDIF

CREATE CURSOR CORPO_MOV ;
  	(CONTO C(13), DESCRIC C(40),CECO C(13), DESCRIZ C(45), DESCRI1 C(45), DARE N(14,3), AVERE N(14,3), ;
		IVA C(3),IMPOSTA N(13,3),IMPOSTA_D N(16,3),IMPOSTA_A N(16,3),NATURA C(1), ;
		SALDO01 N(16,3),SALDO02 N(16,3),SALDO03 N(16,3),SALDO04 N(16,3),SALDO05 N(16,3), ;
		SALDO06 N(16,3),SALDO07 N(16,3),SALDO08 N(16,3),SALDO09 N(16,3),SALDO10 N(16,3), ;
		COD01 C(13),COD02 C(13),COD03 C(13),COD04 C(13),COD05 C(13),ABBUONO N(16,3), ;
		COD06 C(13),COD07 C(13),COD08 C(13),COD09 C(13),COD10 C(13), JTIPOCO C(1),NOTE M,CCLI C(10),CFOR C(10),OK_PAG C(1),OK_PMULT C(1),;
		CNUMFAT C(6),CFATAGE C(6),CDATFAT C(10),CDTSCAD C(10),CPROTO N(10),CCAGE C(3),SOLOIVA N(14,3),CONTOP C(13))

RETURN