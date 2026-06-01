******DO EUR_PAPF WITH 'C','PAR_CODCLI',CLIDAL,CLIAL,C_TUTTI

_NC='PAR_CODCLI'
_DA=CLIDAL
_AL=CLIAL
_FI=C_TUTTI

WAIT WINDOW "Elaborazione In Corso  -- Prego Attendere --" nowait

=DEF_EURO()		&& DEFINISCE IL CURSORE PER LA GESTIONE DEI PARTITARI


**------
CREATE CURSOR NAZIONI (CODCLI C(10),CODNAZ C(3),DESNAZ C(40))
INDEX ON CODCLI TAG CODCLI
**------
PUBLIC V_GO,S_SEL,XXCODNAZ,XXDESNAZ,PRECLI
PUBLIC PRECLI, JCONTO, PARTITA

v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   
   ** SERGIO 18/12/2021 INIZIO
   IF PUB_CONTOSIMILCEE 
	   PRECLI = SUBSTR(LIBERA,18,PUB_GRUPPOCF)
   ELSE
	   PRECLI = SUBSTR(LIBERA,18,PUB_SOTTOG-1)
   ENDIF
   ** SERGIO 18/12/2021 FINE     
   
   
ELSE
   PRECLI = ""
ENDIF



*!*	 ______FORNITORE DAL __________________________________________________________________
  XX_CODCLI = ALLTRIM(_DA)
  XX_CODCLI = TRC(PUB_LCL,ALLTRIM(XX_CODCLI))

  x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
  x_codi = "for_codcli = '" + XX_CODCLI + "'"
  x_cond = x_soci + " and " + x_codi   
  cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
  IF !ExecCommand(cSql,"CUR_FORNITORI")
     RETURN .F.
  ENDIF
  SELECT CUR_FORNITORI
  GO TOP   
  IF EOF()
     XXCODNAZ = SPACE(03)
  ELSE
     XXCODNAZ = FOR_NAZION
  ENDIF
  
  V_ER=SOTTOGEN(XXCODNAZ)
  IF !V_ER
	  PRECLI  = PUB_FF 
  ENDIF 

  DALCLI   = PRECLI+ALLTRIM(XX_CODCLI)  



*!*	 ______FORNITORE AL ___________________________________________________________________
  XX_CODCLI = ALLTRIM(_AL)
  XX_CODCLI = TRC(PUB_LCL,ALLTRIM(XX_CODCLI))

  x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
  x_codi = "for_codcli = '" + XX_CODCLI + "'"
  x_cond = x_soci + " and " + x_codi   
  cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
  IF !ExecCommand(cSql,"CUR_FORNITORI")
     RETURN .F.
  ENDIF
  SELECT CUR_FORNITORI
  GO TOP   
  IF EOF()
     XXCODNAZ = SPACE(03)
  ELSE
     XXCODNAZ = FOR_NAZION
  ENDIF
  
  V_ER=SOTTOGEN(XXCODNAZ)
  IF !V_ER
	  PRECLI  = PUB_FF 
  ENDIF 

  ALCLI    = PRECLI+ALLTRIM(XX_CODCLI)  



NUMMOV   = 0
NUMFAT   = 0
V_GO     = 0
XXCODNAZ = ""
XXDESNAZ = ""

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
** COUGAR 15/11/2005
*x_clie = "par_codcli between '" + ALLTRIM(DALCLI) + "' and '" + ALLTRIM(ALCLI) + "'"
** END COUGAR 
x_dt1  = RIBALTA2(_DATADAL)
x_dt2  = RIBALTA2(_DATAAL)
x_data = "par_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_prog = "par_nprog <> 100"
x_cond = x_soci + " and " + x_prog
** COUGAR 15/11/2005

x_clie = "par_codcli between '" + ALLTRIM(DALCLI) + "' and '" + ALLTRIM(ALCLI) + "'"

IF _FI = 1
ELSE
   x_cond = x_cond + " and " + x_clie
ENDIF

x_cond = x_cond + " and " + x_data

cSql="SELECT * FROM PART_FOR WHERE " + x_cond + " order by par_codsoc,par_codcli,par_npart"
IF !ExecCommand(cSql,"CUR_PART_FORN")
   return(.f.)
ENDIF

SELECT CUR_PART_FORN
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP + 1
      LOOP
   ENDIF


   XXCODNAZ = ""
   XXDESNAZ = ""
   XXRAGSOC  = PAR_RAGSOC


   IF _FI <> 1


		** SERGIO 18/12/2021 INIZIO
		IF PUB_CONTOSIMILCEE 

		   IF SUBSTR(ALLTRIM(&_NC),1,PUB_GRUPPOCF-1) < PRECLI
		      SKIP + 1
		      LOOP
		   ENDIF

		   IF SUBSTR(ALLTRIM(&_NC),1,PUB_GRUPPOCF-1) > PRECLI
		      EXIT
		   ENDIF

		ELSE

		   IF SUBSTR(ALLTRIM(&_NC),1,PUB_SOTTOG-1) < PRECLI
		      SKIP + 1
		      LOOP
		   ENDIF

		   IF SUBSTR(ALLTRIM(&_NC),1,PUB_SOTTOG-1) > PRECLI
		      EXIT
		   ENDIF

		ENDIF
		** SERGIO 18/12/2021 FINE  



   ENDIF

   WAIT WINDOWS "Sto elaborando il fornitore : "+PAR_CODCLI  NOWAIT

   SCATTER MEMVAR

   S_SEL=SELECT()
   V_GO = RECNO()

   JCONTO   = PAR_CODCLI	 && CODICE DEL FORNITORE
   JPARTITA = PAR_NPART		 && PARTITA FORNITORE
   JCURSORE = "PARTIFOR"	 && NOME DEL CURSORE DI LAVORO
   JRAGGR   = .T.         	 && .T. RAGGRUPPA RITORNA UN RECORD CON IL SALDO DI TUTTI I MOVIMENTI DARE-AVERE
   JDIFFAR  = .F.			 && .T. CREA UN RECORD PER CHIUDERE LA PARTITA NEL CASO DI DIFFERENZA DOVUTA ALL'EURO DI 0,02 CENTESIMI
   JTIPO    = 'F'			 && C= CLIENTE F= FORNITORE	
   V_CHIUSO = EUR_PART(JTIPO,"PART_FOR",JCONTO,JPARTITA,JCURSORE,JRAGGR,JDIFFAR)

   SELECT CUR_PART_FORN
   
   IF V_CHIUSO
   		DELETE
   		SKIP
   		LOOP
   ENDIF

   XXANOMAX	= PAR_ANOMAX


   SELECT CUR_PART_FORN
   SKIP + 1

ENDDO

***************************************************************************************************************



SELECT CUR_PART_FORN
GO TOP


_V_SELECT  = "CUR_PART_FORN"
CONDIZIONE = " !EMPTY(PAR_ANOMAX)"


IF O_ORDINE = 1
   SELECT *, RECNO() AS N_REC;
 	         FROM (ALIAS(_V_SELECT));
	         WHERE &CONDIZIONE;
	         ORDER BY PAR_CODCLI,PAR_DTFAT,PAR_NUMFAT;
	         INTO CURSOR WINQUERY
ELSE
   SELECT *, RECNO() AS N_REC;
	         FROM (ALIAS(_V_SELECT));
	         WHERE &CONDIZIONE;
	         ORDER BY PAR_RAGSOC,PAR_DTFAT,PAR_NUMFAT;
	         INTO CURSOR WINQUERY
ENDIF

SELECT WINQUERY
SET FILTER TO 
GO TOP
IF EMPTY(CODANOMAX)
ELSE
   SET FILTER TO PAR_ANOMAX = CODANOMAX
   GO TOP
ENDIF 
IF EOF()
   =MESSAGEBOX("Nessuna partita da evidenziare (forse già saldate)",62,"ATTENZIONE")
ELSE
   DO PRG\MENUSTA WITH "WINQUERY",FLAG_PREVIEW,FLAG_STAMPA,"XXX","PARTFOR_X_FORNITORE","PART_ALLEGATO_ANOMALIE.FRX"
ENDIF

USE

SELECT CUR_PART_FORN
USE

SELECT NAZIONI
USE

