*************************************************************
**** PROCEDURA DI CREAZIONE LIQUIDAZIONE PERIODICA IVA ******
*************************************************************

PUBLIC V_TOTFAT,V_NUMPRO,V_DTULSC,WWC_TOTIVA,WWF_TOTIVA
V_TOTFAT=0
V_NUMPRO=SPACE(13)
V_DTULSC=SPACE(10)
WWC_TOTIVA=0
WWF_TOTIVA=0

CREATE CURSOR LIQUIDA;
 (W_CIVA C(3), ;
 W_DESIVA C(35), ;
 WC_TOTIMP N(17,3), ;
 WC_TOTIVA N(17,3), ;
 WF_NOTIMP N(17,3), ;
 WF_NOTIVA N(17,3), ;
 WF_TOTIMP N(17,3), ;
 WF_ACQINT N(17,3), ;
 WF_ACQIVA N(17,3), ;
 WF_IMP100 N(17,3), ;
 WF_TOTIVA N(17,3))

CREATE CURSOR LIQUIRIE;
 (W_CIVA   C(3), ;
 W_DESIVA  C(35), ;
 W_TOTIMP  N(17,3), ;
 W_TOTIVA  N(17,3))

CREATE CURSOR _TEMPO;
 (CAMPO   C(5))

SELECT _TEMPO
ZAP
APPEND BLANK

SELECT LIQUIDA 
ZAP
SELECT LIQUIDA 
******** > INDICE PER STAMPA
INDEX ON W_CIVA TAG  LIQUIDA

SELECT LIQUIRIE
ZAP
SELECT LIQUIRIE
******** > INDICE PER STAMPA
INDEX ON W_CIVA TAG  LIQUIRIE

SELECT LIQUIDA

IF !EMPTY(M.DTDAL)
   R_DTDAL =RIBALTA2(M.DTDAL)
ENDIF
  
IF EMPTY(M.DTAL)
   =MSGBOX("Senza data non puoi avere nessuna liquidazione","******* DIMENTICANZA GRAVE *******",21)
   RETURN  
ELSE
   R_DTAL  =RIBALTA2(M.DTAL)
ENDIF  

WAIT window 'Elaborazione dati in corso .....Attendere...' nowait

***************************************************************************
***** ESTRAGGO DA U_IVA_TO IL TOTALE CLIENTI \ FORNITORI DEL PERIODO SCELTO
***************************************************************************

DO CREALIQ
DO PREVAR

IF F_STAMPA = 1
   _V_PREVIEW = .T.
ELSE
   _V_PREVIEW = .F.
ENDIF
    
IF F_STAMPA = 2
   _V_STAMPA  = .T.
ELSE
   _V_STAMPA  = .F.
ENDIF

SELECT LIQUIDA
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun dato da stampare",62,"ATTENZIONE")
ELSE
   DO PRG\MENUSTA WITH "LIQUIDA ",_V_PREVIEW,_V_STAMPA,"XXX","DICHIARA","DICHIARA.FRX"
ENDIF

RETURN


***********************
PROCEDURE CREALIQ
***********************

PUBLIC V_DESIVA,W_IMP100
V_DESIVA = SPACE(35)
W_IMP100 = 0 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mes1 = "ito_mese >= '" + SUBSTR(M.DTDAL,4,2) + "'"
x_mes2 = "ito_mese <= '" + SUBSTR(M.DTAL,4,2) + "'"
x_tipo = "(ito_clifor = 'C' or ito_clifor = 'E' or ito_clifor = 'D')"
x_cond = x_soci + " and " + x_anno + " and " + x_mes1 + " and " + x_mes2 + " and " + x_tipo
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_clifor" 
IF !ExecCommand(CSQL,"IVACLI")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mes1 = "ito_mese >= '" + SUBSTR(M.DTDAL,4,2) + "'"
x_mes2 = "ito_mese <= '" + SUBSTR(M.DTAL,4,2) + "'"
x_tipo = "ito_clifor = 'F'"
x_cond = x_soci + " and " + x_anno + " and " + x_mes1 + " and " + x_mes2 + " and " + x_tipo
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_clifor" 
IF !ExecCommand(CSQL,"IVAFOR")
   RETURN (.f.)
ENDIF 

******* SEZIONE IVA CLIENTI

SELECT IVACLI
INDEX ON ITO_CODIVA   TAG IVACLI
SET ORDER TO IVACLI
GO TOP 
        
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR

   SELECT LIQUIDA
   SET ORDER TO LIQUIDA
   SEEK M.ITO_CODIVA
   IF FOUND()
      IF M.ITO_FATNOT="N"
         M.ITO_IMPONI=M.ITO_IMPONI*(-1)                
         M.ITO_IMPOST=M.ITO_IMPOST*(-1)                
      ENDIF
      REPLACE WC_TOTIMP WITH WC_TOTIMP+M.ITO_IMPONI
      REPLACE WC_TOTIVA WITH WC_TOTIVA+M.ITO_IMPOST          
      WWC_TOTIVA = WWC_TOTIVA+M.ITO_IMPOST          
      IF M.ITO_CLIFOR="E"
         REPLACE WF_ACQINT WITH WF_ACQINT+M.ITO_IMPONI
         REPLACE WF_ACQIVA WITH WF_ACQIVA+M.ITO_IMPOST
      ENDIF	
   ELSE
      v_seek   = 'IVA' + ALLTRIM(M.ITO_CODIVA)
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         V_DESIVA = DESCRI
      ELSE
         V_DESIVA = "MANCA PARAMETRO IVA"
      ENDIF  
      SELECT LIQUIDA 
      APPEND BLANK
      REPLACE W_CIVA    WITH M.ITO_CODIVA
      REPLACE W_DESIVA  WITH V_DESIVA
      IF M.ITO_FATNOT="N"
         M.ITO_IMPONI=M.ITO_IMPONI*(-1)                
         M.ITO_IMPOST=M.ITO_IMPOST*(-1)                
      ENDIF
      REPLACE WC_TOTIMP WITH WC_TOTIMP+M.ITO_IMPONI
      REPLACE WC_TOTIVA WITH WC_TOTIVA+M.ITO_IMPOST          
      WWC_TOTIVA = WWC_TOTIVA+M.ITO_IMPOST          
      IF M.ITO_CLIFOR="E"
         REPLACE WF_ACQINT WITH WF_ACQINT+M.ITO_IMPONI
         REPLACE WF_ACQIVA WITH WF_ACQIVA+M.ITO_IMPOST
      ENDIF	
   ENDIF 

   SELECT IVACLI
   SKIP +1

ENDDO
           
******* SEZIONE IVA FORNITORI

SELECT IVAFOR
INDEX ON ITO_CODIVA   TAG IVAFOR
SET ORDER TO IVAFOR
GO TOP 
        
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR

   IF M.ITO_IND100 = 'S'    && IVA INDEDUCIBILE AL 100%
  	  W_IMP100    = M.ITO_IMPOST 
 	  M.ITO_IMPOST = 0
   ELSE
      W_IMP100=0	 
   ENDIF  	

   * VERIFICA IVE INDEDUCIBILI
		   
   IF "*" $ M.ITO_CODIVA
	  SI_INDE = .T.
   ELSE
	  SI_INDE = .F.
   ENDIF

   SELECT LIQUIDA
   SET ORDER TO LIQUIDA
   SEEK M.ITO_CODIVA
   IF FOUND()
      IF M.ITO_FATNOT="N"
         M.ITO_IMPONI=M.ITO_IMPONI*(-1)                
         M.ITO_IMPOST=M.ITO_IMPOST*(-1)                
      ENDIF
      REPLACE WF_IMP100  WITH WF_IMP100 + W_IMP100
      **** <<<<<<  SOMMA LE FATTURE FORNITORE ARRIVATE IN RITARDO SEMPRE
      **** <<<<<<  MA SOLO SUL MESE DI DICEMBRE RICHIESTO SONO ATTIVATE 
      REPLACE WF_TOTIMP  WITH WF_TOTIMP + M.ITO_IMPONR
      REPLACE WF_TOTIVA  WITH WF_TOTIVA + M.ITO_IMPOSR
      WWF_TOTIVA = WWF_TOTIVA           + M.ITO_IMPOSR          
      IF SUBSTR(M.DTDAL,4,2)="12" .OR. SUBSTR(M.DTAL,4,2)="12"
      ELSE 
         ** PER ALTRI MESI LE FATTURE IN RIARDO SONO TOLTE
         REPLACE WF_TOTIMP  WITH WF_TOTIMP - M.ITO_IMPONR
         REPLACE WF_TOTIVA  WITH WF_TOTIVA - M.ITO_IMPOSR
         WWF_TOTIVA = WWF_TOTIVA           - M.ITO_IMPOSR          
      ENDIF
      REPLACE WF_TOTIMP WITH WF_TOTIMP+M.ITO_IMPONI
      REPLACE WF_TOTIVA WITH WF_TOTIVA+M.ITO_IMPOST          
      IF M.ITO_IND100 = 'S'    && IVA INDEDUCIBILE AL 100%
         REPLACE WF_TOTIMP  WITH WF_TOTIMP + W_IMP100
	  ENDIF	
	  IF SI_INDE 								 && RECORD IVA INDEDUCIBILE
         REPLACE WF_TOTIMP WITH WF_TOTIMP-M.ITO_IMPONI
         REPLACE WF_TOTIVA WITH WF_TOTIVA-M.ITO_IMPOST          
         REPLACE WF_NOTIMP WITH WF_NOTIMP+M.ITO_IMPONI
         REPLACE WF_NOTIVA WITH WF_NOTIVA+M.ITO_IMPOST          
	  ELSE	
         WWF_TOTIVA = WWF_TOTIVA+M.ITO_IMPOST          
	  ENDIF			 	
   ELSE
      v_seek   = 'IVA' + ALLTRIM(M.ITO_CODIVA)
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         V_DESIVA = DESCRI
      ELSE
         V_DESIVA = "MANCA PARAMETRO IVA"
      ENDIF  
      SELECT LIQUIDA 
      APPEND BLANK
      REPLACE W_CIVA    WITH M.ITO_CODIVA
      REPLACE W_DESIVA  WITH V_DESIVA
      IF M.ITO_FATNOT="N"
         M.ITO_IMPONI=M.ITO_IMPONI*(-1)                
         M.ITO_IMPOST=M.ITO_IMPOST*(-1)                
      ENDIF
      REPLACE WF_IMP100  WITH W_IMP100
      **** <<<<<<  SOMMA LE FATTURE FORNITORE ARRIVATE IN RITARDO SEMPRE
      **** <<<<<<  MA SOLO SUL MESE DI DICEMBRE RICHIESTO SONO ATTIVATE 
      REPLACE WF_TOTIMP  WITH WF_TOTIMP + M.ITO_IMPONR
      REPLACE WF_TOTIVA  WITH WF_TOTIVA + M.ITO_IMPOSR
      WWF_TOTIVA = WWF_TOTIVA           + M.ITO_IMPOSR          
      IF SUBSTR(M.DTDAL,4,2)="12" .OR. SUBSTR(M.DTAL,4,2)="12"
      ELSE 
         ** PER ALTRI MESI LE FATTURE IN RIARDO SONO TOLTE
         REPLACE WF_TOTIMP  WITH WF_TOTIMP - M.ITO_IMPONR
         REPLACE WF_TOTIVA  WITH WF_TOTIVA - M.ITO_IMPOSR
         WWF_TOTIVA = WWF_TOTIVA           - M.ITO_IMPOSR          
      ENDIF
      REPLACE WF_TOTIMP WITH WF_TOTIMP+M.ITO_IMPONI
      REPLACE WF_TOTIVA WITH WF_TOTIVA+M.ITO_IMPOST          
	  IF M.ITO_IND100 = 'S'    && IVA INDEDUCIBILE AL 100%
         REPLACE WF_TOTIMP  WITH WF_TOTIMP + W_IMP100
	  ENDIF	
	  IF SI_INDE 								 && RECORD IVA INDEDUCIBILE
         REPLACE WF_TOTIMP WITH WF_TOTIMP-M.ITO_IMPONI
         REPLACE WF_TOTIVA WITH WF_TOTIVA-M.ITO_IMPOST          
         REPLACE WF_NOTIMP WITH WF_NOTIMP+M.ITO_IMPONI
         REPLACE WF_NOTIVA WITH WF_NOTIVA+M.ITO_IMPOST          
	  ELSE	
         WWF_TOTIVA = WWF_TOTIVA+M.ITO_IMPOST          
	  ENDIF			 	
   ENDIF 

   SELECT IVAFOR
   SKIP +1

ENDDO
           
PUBLIC TT_TOTIMP,TT_TOTIVA,TT_NOTIMP,TT_NOTIVA,TT_IMPONI
TT_TOTIMP = 0
TT_TOTIVA = 0
TT_NOTIMP = 0
TT_NOTIVA = 0
TT_IMPONI = 0

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
    ENDIF
              
    * CALCOLO TOTALI 

    IF SUM_IMP3(W_CIVA) 
 	   IF WF_IMP100 <> 0    && IVA INDEDUCIBILE AL 100%
		  TT_NOTIMP = TT_NOTIMP +WF_TOTIMP
	      TT_NOTIVA = TT_NOTIVA +WF_IMP100
       ENDIF     		    
    ENDIF	

    IF SUM_IMP3(W_CIVA) 
       IF WF_NOTIVA <> 0    && RECORD IVA INDEDUCIBILE PARZIALMENTE
		  TT_NOTIMP = TT_NOTIMP +WF_NOTIMP
		  TT_NOTIVA = TT_NOTIVA +WF_NOTIVA
          TT_IMPONI = TT_IMPONI +WF_NOTIMP
       ENDIF     		    
    ENDIF
   		    
    IF SUM_IMP3(W_CIVA) 
	   TT_IMPONI = TT_IMPONI +WF_TOTIMP
	   TT_TOTIVA = TT_TOTIVA +WF_TOTIVA
	ENDIF	

    SELECT LIQUIDA
    SKIP +1
  
ENDDO 

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

RETURN

*******************
FUNCTION CERCA
*******************

SS= SELECT()

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = " + SUBSTR(M.DTDAL,7,4)
x_cond = x_soci + " and " + x_anno
CSQL   = "select * from u_iva_cr where " + x_cond + " order by iva_codsoc,iva_anno" 
IF !ExecCommand(CSQL,"u_iva_cr")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_CR
GO TOP
IF !EOF()
   IF OK_TRIM = 0
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 1
         CRED_DEB = IVA_GENNAI
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 2
         CRED_DEB = IVA_FEBBRA
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 3
         CRED_DEB = IVA_MARZO
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 4
         CRED_DEB = IVA_APRILE
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 5
         CRED_DEB = IVA_MAGGIO
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 6
         CRED_DEB = IVA_GIUGNO
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 7
         CRED_DEB = IVA_LUGLIO
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 8
         CRED_DEB = IVA_AGOSTO
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 9
         CRED_DEB = IVA_SETTEM
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 10
         CRED_DEB = IVA_OTTOBR
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 11
         CRED_DEB = IVA_NOVEMB
      ENDIF
      IF VAL(SUBSTR(M.DTDAL,4,2)) = 12
         CRED_DEB = IVA_DICEMB
      ENDIF
   ENDIF
   IF OK_TRIM = 1
      CRED_DEB = IVA_GENNAI + IVA_FEBBRA + IVA_MARZO
   ENDIF
   IF OK_TRIM = 2
      CRED_DEB = IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO
   ENDIF
   IF OK_TRIM = 3
      CRED_DEB = IVA_LUGLIO + IVA_AGOSTO + IVA_SETTEM
   ENDIF
   IF OK_TRIM = 4
      CRED_DEB = IVA_OTTOBR + IVA_NOVEMB + IVA_DICEMB
   ENDIF
ELSE
   CRED_DEB  = 0 
ENDIF 

SELECT(SS)
OUT = .T.

RETURN(OUT)


*********************************
PROCEDURE PREVAR
*********************************
=CERCA()

V_CESINT=0						&& CESSIONI INTRACOMUNITARIE 
V_ACQINT=0						&& IMPONIBILE ACQUISTI INTRACOMUNITARI
V_ACQIVA=0						&& IVA ACQUISTI INTRACOMUNITARI
V_CREIMP=0						&& CREDITO D'IMPOSTA
V_INTLIQ=0						&& INTERESSI PER VERSAMENTI TRIMESTRALI

PUBLIC CC_TOTIMP,CC_TOTIVA
CC_TOTIMP = 0
CC_TOTIVA = 0

=SOMMAV1()						&& SOMMA IMPONIBILE/IVA VENDITE SU VOCI IVA INTERESSATE
=SOMMAV2()						&& SOMMA IMPONIBILE SU CESSIONI INTRACOMUNITARIE

V_AMOPAT  = CC_TOTIMP		    && IMPONIBILE VENDITE
V_IVADEB  = CC_TOTIVA			&& IVA VENDITE

=SOMMAV4()						&& SOMMA IMPONIBILE/IVA ACQUISTI INTRACOMUNITARI

V_IVADEB = V_IVADEB + V_ACQIVA	&& IVA VENDITE
V_AMOPPA = TT_IMPONI				&& IMPONIBILE ACQUISTI
V_IVACRE = TT_TOTIVA				&& IVA ACQUISTI
V_IVAPRE = CRED_DEB				&& CREDITO PRECEDENTE
_TOTIVA  = (V_IVADEB-(V_IVACRE+V_IVAPRE+V_CREIMP))+V_INTLIQ

IF _TOTIVA < 0
   V_IVATCR= ABS(_TOTIVA)		&& IVA CREDITO
   V_RIMBO = ABS(_TOTIVA)		&& RICHIESTA RIMBORSO
ELSE
   V_IVAVER= _TOTIVA				&& IVA DA VERSARE
   V_VERSA = _TOTIVA				&& VERSAMENTO
ENDIF

*  ARROTONDAMENTI ALLE 1000 LIRE SUPERIORI SE ITL

IF _ARROTA
   V_AMOPAT = OK_ARROT2(V_AMOPAT,PUB_VALRIF)
   V_CESINT = OK_ARROT2(V_CESINT,PUB_VALRIF)
   V_AMOPPA = OK_ARROT2(V_AMOPPA,PUB_VALRIF)
   V_ACQINT = OK_ARROT2(V_ACQINT,PUB_VALRIF)
   V_IVADEB = OK_ARROT2(V_IVADEB,PUB_VALRIF)
   V_IVACRE = OK_ARROT2(V_IVACRE,PUB_VALRIF)
   V_IVAPRE = OK_ARROT2(V_IVAPRE,PUB_VALRIF)
   V_CREIMP = OK_ARROT2(V_CREIMP,PUB_VALRIF)
   V_INTLIQ = OK_ARROT2(V_INTLIQ,PUB_VALRIF)
   V_IVAVER = OK_ARROT2(V_IVAVER,PUB_VALRIF)
   V_IVATCR = OK_ARROT2(V_IVATCR,PUB_VALRIF)
   V_RIMBO  = OK_ARROT2(V_RIMBO,PUB_VALRIF)
   V_VERSA  = OK_ARROT2(V_VERSA,PUB_VALRIF)
ENDIF

RETURN


********************
FUNCTION SOMMAV1			&& DETERMINA IMPONIBILE/IVA VENDITE PER CODICI IVE INTERESSATE
********************

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   IF SUM_IMP1(W_CIVA) 
      CC_TOTIMP  = CC_TOTIMP +WC_TOTIMP
      CC_TOTIVA  = CC_TOTIVA +WC_TOTIVA
   ENDIF
   SELECT LIQUIDA
   SKIP +1
ENDDO

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

RETURN


********************
FUNCTION SOMMAV2			&& DETERMINA IMPONIBILE SU CESSIONI INTRACOMUNITARIE
********************

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   IF SUM_IMP2(W_CIVA) 
      V_CESINT  = V_CESINT +WC_TOTIMP
   ENDIF
   SELECT LIQUIDA
   SKIP +1
ENDDO 

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

RETURN


********************
FUNCTION SOMMAV4			&& DETERMINA IMPONIBILE/IVA SU ACQUISTI INTRACOMUNITARIE
********************

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   IF SUM_IMP4(W_CIVA) 
      V_ACQINT  = V_ACQINT +WF_ACQINT
      V_ACQIVA  = V_ACQIVA +WF_ACQIVA
   ENDIF
   SELECT LIQUIDA
    SKIP +1
ENDDO

SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

RETURN


********************
FUNCTION SUM_IMP1
********************
PARA _COD_IVA

OUT=.F.
IVA_SEL=SELECT()

v_seek   = 'IVA' + ALLTRIM(_COD_IVA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,123,1) = "S"
      OUT=.T.
   ENDIF	  
ENDIF  

SELECT(IVA_SEL)

RETURN(OUT)


********************
FUNCTION SUM_IMP2
********************
PARA _COD_IVA

OUT=.F.
IVA_SEL=SELECT()

v_seek   = 'IVA' + ALLTRIM(_COD_IVA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,124,1) = "S"
      OUT=.T.
   ENDIF	  
ENDIF  

SELECT(IVA_SEL)

RETURN(OUT)


********************
FUNCTION SUM_IMP3
********************
PARA _COD_IVA

OUT=.F.
IVA_SEL=SELECT()

v_seek   = 'IVA' + ALLTRIM(_COD_IVA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,120,1) = "S"
      OUT=.T.
   ENDIF	  
ENDIF  

SELECT(IVA_SEL)

RETURN(OUT)


********************
FUNCTION SUM_IMP4
********************
PARA _COD_IVA

OUT=.F.
IVA_SEL=SELECT()

v_seek   = 'IVA' + ALLTRIM(_COD_IVA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,125,1) = "S"
      OUT=.T.
   ENDIF	  
ENDIF  

SELECT(IVA_SEL)

RETURN(OUT)
