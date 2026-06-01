
*************************************************************
**** STATISTICA MENSILE IVA CLIENTI/FORNITORI          ******
*************************************************************

RELEASE WWS_TOTIVA 
PUBLIC WWS_TOTIVA 
WWS_TOTIVA = 0

RELEASE __VERIFICA_SE_STO_STAMPAMDO_SU_MESI_DIVERSI 
PUBLIC __VERIFICA_SE_STO_STAMPAMDO_SU_MESI_DIVERSI 
__VERIFICA_SE_STO_STAMPAMDO_SU_MESI_DIVERSI  = 0

** SERGIO 16/04/2006 INIZIO 
RELEASE EXTRAI 
PUBLIC EXTRAI 
EXTRAI  = 0
** SERGIO 16/04/2006 FINE 

RELEASE IVADARIPORTARE
PUBLIC IVADARIPORTARE
IVADARIPORTARE = 0


PUBLIC V_TOTFAT,V_NUMPRO,V_DTULSC,WWC_TOTIVA,WWF_TOTIVA
V_TOTFAT   = 0
V_NUMPRO   = SPACE(13)
V_DTULSC   = SPACE(10)
WWC_TOTIVA = 0
WWF_TOTIVA = 0

CREATE CURSOR LIQUIDA;
 (W_PERI C(6), ;
 W_CIVA C(3), ;
 W_DESIVA C(35), ;
 WC_TOTIMP N(17,3), ;
 WC_TOTIVA N(17,3), ;
 WE_TOTIMP N(17,3), ;
 WE_TOTIVA N(17,3), ;
 WR_TOTIMP N(17,3), ;
 WR_TOTIVA N(17,3), ;
 WF_NOTIVA N(17,3), ;
 WF_NOTIMP N(17,3), ;
 WF_TOTIMP N(17,3), ;
 WP_TOTIMP N(17,3), ;
 WF_IMP100 N(17,3), ;
 WS_TOTIMP N(17,3), ;		&& IMPONIBILE IN SOSPENSIONE LIQUIDATA
 WS_TOTIVA N(17,3), ;		&& IMPOSTA IN SOSPENSIONE LIQUIDATA
 WF_TOTIVA N(17,3))

CREATE CURSOR LIQUIRIE;
 (W_PERI  C(6), ;
 W_CIVA   C(3), ;
 W_DESIVA  C(35), ;
 W_TOTIMP  N(17,3), ;
 W_TOTIVA  N(17,3))

SELECT LIQUIDA 
ZAP
SELECT LIQUIDA 
******** > INDICE PER STAMPA
INDEX ON W_PERI + W_CIVA TAG  LIQUIDA

SELECT LIQUIRIE
ZAP
SELECT LIQUIRIE
******** > INDICE PER STAMPA
INDEX ON W_PERI + W_CIVA TAG  LIQUIRIE

SELECT LIQUIDA

IF !EMPTY(__dtdal)
   R_DTDAL =RIBALTA2(__dtdal)
ENDIF
  
IF EMPTY(__dtal)
   =MSGBOX("Senza data non puoi avere nessuna liquidazione","******* ATTENZIONE *******",21)
   RETURN  
ELSE
   R_DTAL  =RIBALTA2(__dtal)
ENDIF  

WAIT window 'Elaborazione dati in corso .....Attendere...' nowait

***************************************************************************
***** ESTRAGGO DA U_IVA_TO IL TOTALE CLIENTI \ FORNITORI DEL PERIODO SCELTO
***************************************************************************

DO CREALIQ

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
   DO PRG\MENUSTA WITH "LIQUIDA ",_V_PREVIEW,_V_STAMPA,"XXX","LIQUIMM","LIQUIMM.FRX"
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
x_mes1 = "ito_mese >= '" + SUBSTR(__dtdal,4,2) + "'"
x_mes2 = "ito_mese <= '" + SUBSTR(__dtal,4,2) + "'"
x_tipo = "(ito_clifor = 'C' or ito_clifor = 'R' or ito_clifor = 'D')"
x_cond = x_soci + " and " + x_anno + " and " + x_mes1 + " and " + x_mes2 + " and " + x_tipo
CSQL   = "select * from u_iva_ts where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_clifor" 
IF !ExecCommand(CSQL,"IVASOS_INCASSATA")
   RETURN (.f.)
ENDIF 


x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mes1 = "ito_mese >= '" + SUBSTR(__dtdal,4,2) + "'"
x_mes2 = "ito_mese <= '" + SUBSTR(__dtal,4,2) + "'"
x_tipo = "(ito_clifor = 'C' or ito_clifor = 'R' or ito_clifor = 'D')"
x_cond = x_soci + " and " + x_anno + " and " + x_mes1 + " and " + x_mes2 + " and " + x_tipo
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_clifor" 
IF !ExecCommand(CSQL,"IVACLI")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mes1 = "ito_mese >= '" + SUBSTR(__dtdal,4,2) + "'"
x_mes2 = "ito_mese <= '" + SUBSTR(__dtal,4,2) + "'"

*==>> CRI 
x_tipo = "(ito_clifor = 'F' or ito_clifor = 'E'or ito_clifor = 'R')"
*==>> CRI 
x_cond = x_soci + " and " + x_anno + " and " + x_mes1 + " and " + x_mes2 + " and " + x_tipo
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_clifor" 
IF !ExecCommand(CSQL,"IVAFOR")
   RETURN (.f.)
ENDIF 


******* SEZIONE IVA IN SOSPENSIONE INCASSATA

SELECT IVASOS_INCASSATA
INDEX ON ITO_CODIVA   TAG IVACLIS
SET ORDER TO IVACLIS
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
         M.ITS_IMPONI=M.ITS_IMPONI*(-1)                
         M.ITS_IMPOST=M.ITS_IMPOST*(-1)                
      ENDIF
      
      WWS_TOTIVA = WWS_TOTIVA+M.ITS_IMPOST          
      REPLACE WS_TOTIMP WITH WS_TOTIMP+M.ITS_IMPONI
      REPLACE WS_TOTIVA WITH WS_TOTIVA+M.ITS_IMPOST          

      
      IF M.ITO_CLIFOR="R"       
         REPLACE WR_TOTIMP WITH WR_TOTIMP+M.ITS_IMPONI
         REPLACE WR_TOTIVA WITH WR_TOTIVA+M.ITS_IMPOST
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
         M.ITS_IMPONI=M.ITS_IMPONI*(-1)                
         M.ITS_IMPOST=M.ITS_IMPOST*(-1)                
      ENDIF
      
      WWS_TOTIVA = WWS_TOTIVA+M.ITS_IMPOST          
      REPLACE WS_TOTIMP WITH WS_TOTIMP+M.ITS_IMPONI
      REPLACE WS_TOTIVA WITH WS_TOTIVA+M.ITS_IMPOST          

  
      IF M.ITO_CLIFOR="R"
         REPLACE WR_TOTIMP WITH WR_TOTIMP+M.ITS_IMPONI
         REPLACE WR_TOTIVA WITH WR_TOTIVA+M.ITS_IMPOST          
	  ENDIF	


   ENDIF 

   SELECT IVASOS_INCASSATA
   SKIP

ENDDO



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
   SEEK M.ITO_ANNO+M.ITO_MESE+M.ITO_CODIVA
   IF FOUND()
      IF M.ITO_FATNOT="N"
         M.ITO_IMPONI=M.ITO_IMPONI*(-1)                
         M.ITO_IMPOST=M.ITO_IMPOST*(-1)                
      ENDIF

      WWC_TOTIVA = WWC_TOTIVA+M.ITO_IMPOST          
      REPLACE WC_TOTIMP WITH WC_TOTIMP+M.ITO_IMPONI
   	  REPLACE WC_TOTIVA WITH WC_TOTIVA+M.ITO_IMPOST          

      IF M.ITO_CLIFOR="R"
         REPLACE WR_TOTIMP WITH WR_TOTIMP+M.ITO_IMPONI
         REPLACE WR_TOTIVA WITH WR_TOTIVA+M.ITO_IMPOST          
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
      REPLACE W_PERI    WITH M.ITO_ANNO + M.ITO_MESE
      REPLACE W_CIVA    WITH M.ITO_CODIVA
      REPLACE W_DESIVA  WITH V_DESIVA
      IF M.ITO_FATNOT="N"
         M.ITO_IMPONI=M.ITO_IMPONI*(-1)                
         M.ITO_IMPOST=M.ITO_IMPOST*(-1)                
      ENDIF


      WWC_TOTIVA = WWC_TOTIVA+M.ITO_IMPOST          
      REPLACE WC_TOTIMP WITH WC_TOTIMP+M.ITO_IMPONI
      REPLACE WC_TOTIVA WITH WC_TOTIVA+M.ITO_IMPOST          

      IF M.ITO_CLIFOR="R"
         REPLACE WR_TOTIMP WITH WR_TOTIMP+M.ITO_IMPONI
         REPLACE WR_TOTIVA WITH WR_TOTIVA+M.ITO_IMPOST          
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
   SEEK M.ITO_ANNO+M.ITO_MESE+M.ITO_CODIVA
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
      IF SUBSTR(__dtdal,4,2)="12" .OR. SUBSTR(__dtal,4,2)="12"
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
		 IF M.ITO_IND100 = 'S'    && IVA INDEDUCIBILE AL 100%
		 ELSE
		    REPLACE WP_TOTIMP WITH WP_TOTIMP+M.ITO_IMPONI  && IMPONIBILE DA DETRARRE
		    WWF_TOTIVA = WWF_TOTIVA+M.ITO_IMPOST          
		 ENDIF		
      ENDIF			 	

      IF M.ITO_CLIFOR="E"
         REPLACE WE_TOTIMP WITH WE_TOTIMP+M.ITO_IMPONI
         REPLACE WE_TOTIVA WITH WE_TOTIVA+M.ITO_IMPOST          
	     WWF_TOTIVA = WWF_TOTIVA-M.ITO_IMPOST    
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
      REPLACE W_PERI    WITH M.ITO_ANNO + M.ITO_MESE
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
      IF SUBSTR(__dtdal,4,2)="12" .OR. SUBSTR(__dtal,4,2)="12"
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
      IF SI_INDE 								 && RECORD IVA INDEDUCIBILE PARZIALE
         REPLACE WF_TOTIMP WITH WF_TOTIMP-M.ITO_IMPONI
         REPLACE WF_TOTIVA WITH WF_TOTIVA-M.ITO_IMPOST          
         REPLACE WF_NOTIMP WITH WF_NOTIMP+M.ITO_IMPONI
         REPLACE WF_NOTIVA WITH WF_NOTIVA+M.ITO_IMPOST          
      ELSE	
	     IF M.ITO_IND100 = 'S'    && IVA INDEDUCIBILE AL 100%
		 ELSE
		    REPLACE WP_TOTIMP WITH WP_TOTIMP+M.ITO_IMPONI  && IMPONIBILE DA DETRARRE
		    WWF_TOTIVA = WWF_TOTIVA+M.ITO_IMPOST          
		 ENDIF		
 	  ENDIF			 	

      IF M.ITO_CLIFOR="E"
         REPLACE WE_TOTIMP WITH WE_TOTIMP+M.ITO_IMPONI
         REPLACE WE_TOTIVA WITH WE_TOTIVA+M.ITO_IMPOST          
	     WWF_TOTIVA = WWF_TOTIVA-M.ITO_IMPOST    
      ENDIF


   ENDIF 

   SELECT IVAFOR
   SKIP +1

ENDDO
           
PUBLIC TT_TOTIMP,TT_TOTIVA,TT_NOTIMP,TT_NOTIVA
TT_TOTIMP = 0
TT_TOTIVA = 0
TT_NOTIMP = 0
TT_NOTIVA = 0

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
   DO CASE
	  CASE WF_IMP100 <> 0    && IVA INDEDUCIBILE AL 100%
           TT_NOTIMP = TT_NOTIMP +WF_TOTIMP
	       TT_NOTIVA = TT_NOTIVA +WF_IMP100
      CASE WF_NOTIVA <> 0    && RECORD IVA INDEDUCIBILE PARZIALMENTE
	       TT_NOTIMP = TT_NOTIMP +WF_NOTIMP
	       TT_NOTIVA = TT_NOTIVA +WF_NOTIVA
      OTHERWISE
 	       TT_TOTIMP = TT_TOTIMP +WF_TOTIMP
	       TT_TOTIVA = TT_TOTIVA +WF_TOTIVA
   ENDCASE
   SELECT LIQUIDA
   SKIP +1
ENDDO


**=> ERASMO - INIZIO 24/02/2011
RELEASE IVA_PRORATA_DETRAIBILE
PUBLIC IVA_PRORATA_DETRAIBILE
IVA_PRORATA_DETRAIBILE = 0
**=> ERASMO - FINE 24/02/2011

IF PUB_PRORATA 
	=CALCOLA_IVA_DETRAIBILE_PRORATA()
ENDIF



SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

RETURN

****************************************
FUNCTION CALCOLA_IVA_DETRAIBILE_PRORATA
****************************************


RELEASE IVA_PRORATA_DETRAIBILE
PUBLIC IVA_PRORATA_DETRAIBILE
IVA_PRORATA_DETRAIBILE = 0

RELEASE TT_TOTIMP_PRO,TT_TOTIVA_PRO,TT_NOTIMP_PRO,TT_NOTIVA_PRO
PUBLIC TT_TOTIMP_PRO,TT_TOTIVA_PRO,TT_NOTIMP_PRO,TT_NOTIVA_PRO
TT_TOTIMP_PRO = 0
TT_TOTIVA_PRO = 0
TT_NOTIMP_PRO = 0
TT_NOTIVA_PRO = 0

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


   V_SEEK	 = 'IVA'+ALLTRIM(W_CIVA)
   V_CHIAVE = "CODICE"
   IF SEEK_STD('PARA',V_SEEK,V_CHIAVE,'XXX_PARA')
	   SELECT XXX_PARA
	   KK_NO_IMPOSTA = SUBSTR(LIBERA,128,1)
   ELSE
	   KK_NO_IMPOSTA = ""
   ENDIF

   SELECT LIQUIDA

   IF KK_NO_IMPOSTA = "S"		&& SCARTA LE IVE NON CONTEMPLATE NELLA SOMMA DELL'IVA PRORATA DETRAIBILE
      SKIP +1
      LOOP
   ENDIF
	

   * CALCOLO TOTALI 

   DO CASE
	  CASE WF_IMP100 <> 0    && IVA INDEDUCIBILE AL 100%
           TT_NOTIMP_PRO = TT_NOTIMP_PRO +WF_TOTIMP
	       TT_NOTIVA_PRO = TT_NOTIVA_PRO +WF_IMP100
      CASE WF_NOTIVA <> 0    && RECORD IVA INDEDUCIBILE PARZIALMENTE
		   TT_NOTIMP_PRO = TT_NOTIMP_PRO +WF_NOTIMP
		   TT_NOTIVA_PRO = TT_NOTIVA_PRO +WF_NOTIVA
      OTHERWISE
 	       TT_TOTIMP_PRO = TT_TOTIMP_PRO +WF_TOTIMP
	       TT_TOTIVA_PRO = TT_TOTIVA_PRO +WF_TOTIVA
   ENDCASE

   SELECT LIQUIDA
   SKIP +1
  
ENDDO




IVA_PRORATA_DETRAIBILE = TT_TOTIVA_PRO
IVA_PRORAT = ((TT_TOTIVA_PRO * PERC_PRORATA) / 100)

IVA_PRORATA =	ROUND((IVA_PRORAT+.0000),2)





SELECT LIQUIDA
SET ORDER TO LIQUIDA
GO TOP

RETURN



RETURN


*******************
FUNCTION CERCA
*******************

SS= SELECT()

**.SER


__VERIFICA_SE_STO_STAMPAMDO_SU_MESI_DIVERSI  = VAL(__DTAL) -  VAL(__DTDAL)

IF  __VERIFICA_SE_STO_STAMPAMDO_SU_MESI_DIVERSI  = 0
	=CERCA_IVA_EXTRAIVA_NEL_MESE_TRIMESTRE()
ELSE
	=CERCA_IVA_EXTRAIVA_NEL_PERIODO()
ENDIF



SELECT(SS)

RETURN


**********************************************
FUNCTION CERCA_IVA_EXTRAIVA_NEL_MESE_TRIMESTRE
**********************************************

SS= SELECT()



* >>>>>>> PRELIEVO DELL'IVA DA RECUPERARE NEL MESE

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = " + PUB_ANNO
x_cond = x_soci + " and " + x_anno
CSQL   = "select * from u_iva_cr where " + x_cond + " order by iva_codsoc,iva_anno" 
IF !ExecCommand(CSQL,"u_iva_cr")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_CR
GO TOP
IF !EOF()
   IF OK_TRIM = 0
      IF VAL(SUBSTR(__dtdal,4,2)) = 1
         CRED_DEB = IVA_GENNAI
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 2
         CRED_DEB = IVA_FEBBRA
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 3
         CRED_DEB = IVA_MARZO
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 4
         CRED_DEB = IVA_APRILE
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 5
         CRED_DEB = IVA_MAGGIO
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 6
         CRED_DEB = IVA_GIUGNO
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 7
         CRED_DEB = IVA_LUGLIO
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 8
         CRED_DEB = IVA_AGOSTO
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 9
         CRED_DEB = IVA_SETTEM
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 10
         CRED_DEB = IVA_OTTOBR
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 11
         CRED_DEB = IVA_NOVEMB
      ENDIF
      IF VAL(SUBSTR(__dtdal,4,2)) = 12
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


* >>>>>>> SE CRED_DEB E' NEGATIVO L'IVA E' DA PAGARE

IF CRED_DEB >= 0
   OUT= .T.
   CRED_DEB=CRED_DEB*(-1) 
ELSE
   OUT= .F.
ENDIF


* >>>>>>> CARICA L'IVA GIA' RECUPERATA NEL MESE
IF !EOF()

    IF OK_TRIM = 0																			&& IVA MENSILE

	      IF VAL(SUBSTR(__dtdal,4,2)) = 1
	         IVADARIPORTARE  = IVA_01RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 2
	         IVADARIPORTARE  = IVA_02RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 3
	         IVADARIPORTARE  = IVA_03RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 4
	         IVADARIPORTARE  = IVA_04RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 5
	         IVADARIPORTARE  = IVA_05RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 6
	         IVADARIPORTARE  = IVA_06RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 7
	         IVADARIPORTARE  = IVA_07RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 8
	         IVADARIPORTARE  = IVA_08RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 9
	         IVADARIPORTARE  = IVA_09RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 10
	         IVADARIPORTARE  = IVA_10RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 11
	         IVADARIPORTARE  = IVA_11RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 12
	         IVADARIPORTARE  = IVA_12RECU
	      ENDIF

		  ** SERGIO 16/04/2006 INIZIO 
	      IF VAL(SUBSTR(__dtdal,4,2)) = 1
	         EXTRAI  = IVA_01EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 2
	         EXTRAI  = IVA_02EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 3
	         EXTRAI  = IVA_03EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 4
	         EXTRAI  = IVA_04EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 5
	         EXTRAI  = IVA_05EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 6
	         EXTRAI  = IVA_06EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 7
	         EXTRAI  = IVA_07EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 8
	         EXTRAI  = IVA_08EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 9
	         EXTRAI  = IVA_09EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 10
	         EXTRAI  = IVA_10EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 11
	         EXTRAI  = IVA_11EXTR
	      ENDIF
	      IF VAL(SUBSTR(__dtdal,4,2)) = 12
	         EXTRAI  = IVA_12EXTR
	      ENDIF
		  ** SERGIO 16/04/2006 FINE 
	
	ELSE																				&& IVA TRIMESTRALE
	   
		   IF OK_TRIM = 1
		     IVADARIPORTARE   = IVA_01RECU + IVA_02RECU + IVA_03RECU
		   ENDIF
		   IF OK_TRIM = 2
		      IVADARIPORTARE  = IVA_04RECU + IVA_05RECU + IVA_06RECU
		   ENDIF
		   IF OK_TRIM = 3
		      IVADARIPORTARE  = IVA_07RECU + IVA_08RECU + IVA_09RECU
		   ENDIF
		   IF OK_TRIM = 4
		      IVADARIPORTARE  = IVA_10RECU + IVA_11RECU + IVA_12RECU
		   ENDIF

		   ** SERGIO 16/04/2006 INIZIO 
		   IF OK_TRIM = 1
		     EXTRAI   = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR
		   ENDIF
		   IF OK_TRIM = 2
		      EXTRAI  = IVA_04EXTR + IVA_05EXTR + IVA_06EXTR
		   ENDIF
		   IF OK_TRIM = 3
		      EXTRAI  = IVA_07EXTR + IVA_08EXTR + IVA_09EXTR
		   ENDIF
		   IF OK_TRIM = 4
		      EXTRAI  = IVA_10EXTR + IVA_11EXTR + IVA_12EXTR
		   ENDIF
		   ** SERGIO 16/04/2006 FINE 
	
	ENDIF

ELSE
   IVADARIPORTARE  = 0 
** SERGIO 16/04/2006 INIZIO 
   EXTRAI  = 0 
** SERGIO 16/04/2006 FINE
ENDIF 


IF IVADARIPORTARE >= 0
   IVADARIPORTARE=IVADARIPORTARE*(-1) 
ENDIF

** SERGIO 16/04/2006 INIZIO 
IF EXTRAI >= 0
   EXTRAI=EXTRAI*(-1) 
ENDIF
** SERGIO 16/04/2006 FINE




SELECT(SS)

RETURN


***************************************
FUNCTION CERCA_IVA_EXTRAIVA_NEL_PERIODO
***************************************

SS= SELECT()

CRED_DEB = 0

* >>>>>>> PRELIEVO DELL'IVA DA RECUPERARE NEL MESE

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = " + PUB_ANNO
x_cond = x_soci + " and " + x_anno
CSQL   = "select * from u_iva_cr where " + x_cond + " order by iva_codsoc,iva_anno" 
IF !ExecCommand(CSQL,"u_iva_cr")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_CR
GO TOP
IF !EOF()
   IF OK_TRIM = 0
   
      IF VAL(SUBSTR(__dtal,4,2)) = 12
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO + IVA_LUGLIO + IVA_AGOSTO + IVA_SETTEM + IVA_OTTOBR + IVA_NOVEMB + IVA_DICEMB
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 11
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO + IVA_LUGLIO + IVA_AGOSTO + IVA_SETTEM + IVA_OTTOBR + IVA_NOVEMB 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 10
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO + IVA_LUGLIO + IVA_AGOSTO + IVA_SETTEM + IVA_OTTOBR 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 9
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO + IVA_LUGLIO + IVA_AGOSTO + IVA_SETTEM 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 8
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO + IVA_LUGLIO + IVA_AGOSTO 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 7
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO + IVA_LUGLIO 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 6
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO + IVA_GIUGNO 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 5
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE + IVA_MAGGIO 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 4
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO + IVA_APRILE 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 3
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA + IVA_MARZO 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 2
         CRED_DEB =  IVA_GENNAI + IVA_FEBBRA 
      ENDIF

      IF VAL(SUBSTR(__dtal,4,2)) = 1
         CRED_DEB =  IVA_GENNAI 
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


* >>>>>>> SE CRED_DEB E' NEGATIVO L'IVA E' DA PAGARE

IF CRED_DEB >= 0
   OUT= .T.
   CRED_DEB=CRED_DEB*(-1) 
ELSE
   OUT= .F.
ENDIF


* >>>>>>> CARICA L'IVA GIA' RECUPERATA NEL MESE
IF !EOF()

    IF OK_TRIM = 0																			&& IVA MENSILE

	      IF VAL(SUBSTR(__dtal,4,2)) = 12
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU + IVA_07RECU + IVA_08RECU + IVA_09RECU + IVA_10RECU + IVA_11RECU + IVA_12RECU
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 11
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU + IVA_07RECU + IVA_08RECU + IVA_09RECU + IVA_10RECU + IVA_11RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 10
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU + IVA_07RECU + IVA_08RECU + IVA_09RECU + IVA_10RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 9
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU + IVA_07RECU + IVA_08RECU + IVA_09RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 8
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU + IVA_07RECU + IVA_08RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 7
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU + IVA_07RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 6
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU + IVA_06RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 5
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU + IVA_05RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 4
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU + IVA_04RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 3
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU + IVA_03RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 2
	         IVADARIPORTARE  = IVA_01RECU + IVA_02RECU 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 1
	         IVADARIPORTARE  = IVA_01RECU 
	      ENDIF




		  ** SERGIO 16/04/2006 INIZIO 
	      IF VAL(SUBSTR(__dtal,4,2)) = 12
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR + IVA_07EXTR + IVA_08EXTR + IVA_09EXTR + IVA_10EXTR + IVA_11EXTR + IVA_12EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 11
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR + IVA_07EXTR + IVA_08EXTR + IVA_09EXTR + IVA_10EXTR + IVA_11EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 10
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR + IVA_07EXTR + IVA_08EXTR + IVA_09EXTR + IVA_10EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 9
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR + IVA_07EXTR + IVA_08EXTR + IVA_09EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 8
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR + IVA_07EXTR + IVA_08EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 7
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR + IVA_07EXTR  
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 6
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR + IVA_06EXTR  
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 5
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR + IVA_05EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 4
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR + IVA_04EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 3
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 2
	         EXTRAI  = IVA_01EXTR + IVA_02EXTR 
	      ENDIF
	      IF VAL(SUBSTR(__dtal,4,2)) = 1
	         EXTRAI  = IVA_01EXTR 
	      ENDIF
		  ** SERGIO 16/04/2006 FINE 
	
	ELSE																				&& IVA TRIMESTRALE
	   
		   IF OK_TRIM = 1
		     IVADARIPORTARE   = IVA_01RECU + IVA_02RECU + IVA_03RECU
		   ENDIF
		   IF OK_TRIM = 2
		      IVADARIPORTARE  = IVA_04RECU + IVA_05RECU + IVA_06RECU
		   ENDIF
		   IF OK_TRIM = 3
		      IVADARIPORTARE  = IVA_07RECU + IVA_08RECU + IVA_09RECU
		   ENDIF
		   IF OK_TRIM = 4
		      IVADARIPORTARE  = IVA_10RECU + IVA_11RECU + IVA_12RECU
		   ENDIF

		   ** SERGIO 16/04/2006 INIZIO 
		   IF OK_TRIM = 1
		     EXTRAI   = IVA_01EXTR + IVA_02EXTR + IVA_03EXTR
		   ENDIF
		   IF OK_TRIM = 2
		      EXTRAI  = IVA_04EXTR + IVA_05EXTR + IVA_06EXTR
		   ENDIF
		   IF OK_TRIM = 3
		      EXTRAI  = IVA_07EXTR + IVA_08EXTR + IVA_09EXTR
		   ENDIF
		   IF OK_TRIM = 4
		      EXTRAI  = IVA_10EXTR + IVA_11EXTR + IVA_12EXTR
		   ENDIF
		   ** SERGIO 16/04/2006 FINE 
	
	ENDIF

ELSE
   IVADARIPORTARE  = 0 
** SERGIO 16/04/2006 INIZIO 
   EXTRAI  = 0 
** SERGIO 16/04/2006 FINE
ENDIF 


IF IVADARIPORTARE >= 0
   IVADARIPORTARE=IVADARIPORTARE*(-1) 
ENDIF

** SERGIO 16/04/2006 INIZIO 
IF EXTRAI >= 0
   EXTRAI=EXTRAI*(-1) 
ENDIF
** SERGIO 16/04/2006 FINE




SELECT(SS)

RETURN




