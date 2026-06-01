*******************************************************************
*    CREAZIONE DEL DOCUMENTO DI TRASPORTO PER RESO A FORNITORE    *
*******************************************************************
RELEASE XXX_NUMRES,NR_PREBOL,DT_PREBOL,XXX_SEQUEN
PUBLIC  XXX_NUMRES,NR_PREBOL,DT_PREBOL,XXX_SEQUEN
XXX_NUMRES = 0
XXX_SEQUEN = 0
NR_PREBOL  = ""
DT_PREBOL  = ""

IF !ExecCommand("select * from u_bol_tt where 0=1","cu_bol_tt")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_bol_dd where 0=1","cu_bol_dd")
   return(.f.)
ENDIF


   
   * ###########################################################  IMPOSTA LE VARIABILI PER LA TESTATA DELLA DDT

   	M.TAGGANCIO  	= STR(NEWPROG('NUMBOL'),10)
    X_UNCINO    	= M.TAGGANCIO

   	M.ORD_ITAEXP 	= " "
	M.ORD_CODSOC	= PUB_CODSOC



   * PRELEVA IL N° DI BOLLA
    v_seek   = ACCESS_YEAR('NUMBOL'+PUB_CODSOC)
    v_chiave = "codice"
    cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
    IF !ExecRW(cSql,"PARA","R")
       return(.f.)
    ENDIF
    SELECT PARA
    IF RECCOUNT() <> 0
       V2=VAL(SUBSTR(LIBERA,1,7)) + 1
       REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
       M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
    ELSE
       RIT = MSGBOX('Parametro numero bolla non trovato','ATTENZIONE',31)
       RETURN
    ENDIF
    IF !ExecRW(cSql,"PARA","W")
       return(.f.)
    ENDIF



	M.TNUMERO		= M.ORD_NUMORD
    M.ORD_CODCLI	= _V_CODFOR
    
	* PRELEVA I DATI DEL FORNITORE

	x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "for_codcli = '" + M.ORD_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi   
	cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
	IF !ExecCommand(cSql,"CUR_FORNITORI")
	   RETURN .F.
	ENDIF
	SELECT CUR_FORNITORI
	GO TOP   
	IF EOF()
	   M.ORD_RAGSOC	="***********************"
	   M.ORD_INDIRI	="**************"
	   M.ORD_CAP	="*****"
	   M.ORD_LOCALI	="**************"
	   M.ORD_PARIVA ="***********"
	   M.ORD_VALUTA ="EUR"
	   M.ORD_CAMBIO =PUB_CAMBIO
       M.ORD_DATORD =RIBALTA2(DTOC(DATE()))
       M.ORD_CPA    =PUB_CPA
       M.ORD_BANCA  ="*****"
       M.ORD_CODNAZ ="ITA"
       M.ORD_PROVIN ="PV"
	ELSE
	   M.ORD_RAGSOC	=ALLTRIM(FOR_RAGSOC)
	   M.ORD_INDIRI	=ALLTRIM(FOR_INDIR)
	   M.ORD_CAP	=FOR_CAP
	   M.ORD_LOCALI	=ALLTRIM(FOR_LOCALI)
	   M.ORD_PARIVA =FOR_PARIVA
	   M.ORD_VALUTA =FOR_VALUTA
	   M.ORD_CAMBIO =PUB_CAMBIO
       M.ORD_DATORD =RIBALTA2(DTOC(DATE()))
       M.ORD_CPA    =FOR_CONPAG
       M.ORD_BANCA  =FOR_BAE
       M.ORD_CODNAZ =FOR_NAZION
       M.ORD_PROVIN =FOR_PROVIN
	ENDIF
	
	
	M.ORD_CAUS = "REF"			&& RESO A FORNITORI
	M.ORD_VALORE = 0  && ????????????????????????????????????????
    M.ORD_DTCONS =RIBALTA2(DTOC(DATE()))	
    M.ORD_MAGS   =PUB_CODM
    M.ORD_ANNO   =PUB_ANNO
    
   
   XXX_AGGA = M.TAGGANCIO
   
   
  
   *==> Rino 26/03/2003
*!*	   PUB_LNO      = 6
   M.ORD_NUMORD = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMORD))
   M.ORD_ANNO   = PUB_ANNO
   *==> Rino 26/03/2003
  
  
   * AGGIORNA TESTATA
   SELECT CU_BOL_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE TAGGANCIO  WITH M.TAGGANCIO
   REPLACE ORD_NUMORD WITH M.ORD_NUMORD      
   REPLACE ORD_DATORD WITH RIBALTA2(DTOC(DATE()))
   REPLACE ORD_FLBOL  WITH SPACE(1)
   REPLACE ORD_CHIUSO WITH .F. 
   REPLACE SELEZIONE  WITH SPACE(10)
   REPLACE ORD_FORNI  WITH .F.
   REPLACE ORD_FLGAGG WITH SPACE(1)
   REPLACE ORD_CODSYS WITH SYS(2015)
   REPLACE ORD_FLGSTA WITH .F.
   REPLACE ORD_DATSTA WITH SPACE(10)
   REPLACE ORD_FLTRAS WITH SPACE(01)
   REPLACE ORD_TRAPDV WITH .F.
   REPLACE ORD_TRASME WITH .F.
   REPLACE ORD_SCAR   WITH SPACE(01)
   IF ORD_VALUTA = PUB_VALRIF
      REPLACE ORD_CAMBIO WITH 1
   ENDIF
   REPLACE ORD_FORNI  WITH .T.
   REPLACE ORD_FLGCON WITH .F.
   REPLACE ORD_FLGTRA WITH .F.
   REPLACE ORD_SCAR   WITH ' '
   
   WAIT WINDOW "Bolla di reso n. "+M.ORD_NUMORD+" creata" NOWAIT
   
   * ###########################################################  IMPOSTA LE VARIABILI PER I DETTAGLI DELLA DDT

   SELECT CUK_MAG_RI
   GO TOP

   DO WHILE .NOT.EOF()


      IF MAG_QTDARE	> 0				
	  ELSE	
	    SELECT CUK_MAG_RI		&& NIENTE DA RENDERE
		SKIP +1
		LOOP
      ENDIF

	  SCATTER MEMVAR MEMO
         
	  XXX_SEQUEN  = 0

      * AGGIORNA I DETTAGLI
      SELECT CU_BOL_DD
      APPEND BLANK
      GATHER MEMVAR MEMO
      XXX_SEQUEN = XXX_SEQUEN + 10

      REPLACE DAGGANCIO  WITH M.TAGGANCIO
      REPLACE ORD_CODART WITH M.MAG_CODART
      REPLACE ORD_DESART WITH M.MAG_DESART
      REPLACE ORD_MAGA   WITH M.MAG_CODMAG
      REPLACE ORD_QTAORD WITH M.MAG_QTDARE
      REPLACE ORD_PREZZO WITH _PRZCOS
      REPLACE ORD_PRZNET WITH _PRZCOS
      REPLACE ORD_VALORE WITH ORD_PRZNET * ORD_QTAORD
      REPLACE ORD_DATCON WITH RIBALTA2(DTOC(DATE()))
      REPLACE ORD_CODSYS WITH SYS(2015)
      REPLACE ORD_MAGS   WITH M.MAG_CODMAG
      REPLACE ORS_CODCLI WITH _V_CODFOR
      REPLACE ORS_RAGSOC WITH M.ORD_RAGSOC
      REPLACE ORS_NUMORD WITH M.ORD_NUMORD	     
      REPLACE ORS_DATORD WITH RIBALTA2(DTOC(DATE()))
      REPLACE ORD_CODACQ WITH M.MAG_CODACQ
      
      

      REPLACE ORD_QTAEV  WITH 0
      REPLACE ORD_QTADEV WITH 0	    
      REPLACE ORD_FLARTC WITH 0
      REPLACE ORD_CHIUSO WITH .F.	    
      REPLACE ORS_NUMORC WITH SPACE(10)
      REPLACE ORS_DATORC WITH SPACE(10)
      REPLACE SELEZIONE  WITH SPACE(10)
      REPLACE ORD_FLGSCP WITH .F.     
      REPLACE ORD_TRASMD WITH .F.
      REPLACE ORD_SEQUEN WITH XXX_SEQUEN
      REPLACE ORD_LEGAME WITH M.TAGGANCIO
      REPLACE ORD_FORNIT WITH _V_CODFOR
      REPLACE ORD_RAGFOR WITH M.ORD_RAGSOC
      
      H_DADOVE = 'CRERES1'
      H_GENMOV = 'SI' 
      H_TIPO   = 'GIA'
      H_IMPE   = ""
      H_MAGSCA = M.ORD_MAGA
      H_MAGCAR = ""
      H_CODART = M.ORD_CODART
      H_TOPSCA = PUB_CAUREF
      H_TOPCAR = ""
      H_QUANTI = M.ORD_QTAORD
      H_NUMDOC = M.ORD_NUMORD
      H_DATDOC = RIBALTA2(DTOC(DATE()))
      H_DATREG = RIBALTA2(DTOC(DATE()))
      H_ORAMOV = TIME()
      H_CLIFOR = M.ORS_CODCLI
      H_PRZACQ = M.ORD_PREZZO
      H_PRZVEN = 0
      H_CODIVA = M.ORD_IVA
      H_SCONTO = 0
      H_VALUTA = M.ORS_VALUTA
      H_NOTE   = ""
      H_CSC    = ""
      H_SAC    = ""
      H_GGG    = "SI"
      *=MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG)
      
      SELECT CUK_MAG_RI
      SKIP +1
     
   ENDDO
    
   
*** ################################################### AGGIORNAMENTO ARCHIVI


IF !ExecRW('','u_bol_tt','I','','CU_BOL_TT')
   return(.f.)
ENDIF
IF !ExecRW('','u_bol_dd','I','','CU_BOL_DD')
   return(.f.)
ENDIF

SELECT CU_BOL_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   X_UNCINO = M.TAGGANCIO
   _ESENZI  = .F.
   DO BOLCAVOL WITH X_UNCINO
   SELECT CU_BOL_TT
   SKIP +1
ENDDO

RETURN