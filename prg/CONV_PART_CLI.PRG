WAIT WINDOWS PUB_DIR

RIT = MESSAGEBOX("Procedo con la conversione COVERTEC "+CHR(13)+"dei partitari  clienti ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

*!*	cSql = "delete from part_cli where 99=99"
*!*	IF !ExecCommand(cSql,"part_cli")
*!*	   return(.f.)
*!*	ENDIF

*!*	cSql = "delete from saldi_cli where 99=99"
*!*	IF !ExecCommand(cSql,"saldi_cli")
*!*	   return(.f.)
*!*	ENDIF

RELEASE   _BROWSE 
PUBLIC   _BROWSE 
_BROWSE = .f.

RELEASE    _TDARE,_TAVERE,___CODCLI,_DATACONV  
PUBLIC     _TDARE,_TAVERE,___CODCLI,_DATACONV 
_TDARE=0
_TAVERE=0
___CODCLI = 0
_DATACONV = "2004/12/31"

RELEASE _CREA_RECORD_100
PUBLIC _CREA_RECORD_100
RELEASE _CREA_RECORD_100T
PUBLIC _CREA_RECORD_100T

RELEASE		   SAVE_PAR_TMOV     
RELEASE		   SAVE_PAR_TOTIM    
PUBLIC		   SAVE_PAR_TMOV     
PUBLIC		   SAVE_PAR_TOTIM    



SAVE_PAR_TMOV      = ''									
SAVE_PAR_TOTIM     = 0

_CREA_RECORD_100T = .T.
_CREA_RECORD_100 = .T.


RELEASE ___FAT,___PAG,___GEN,M.PAR_TIPFAT,M.PAR_CODPAG
PUBLIC ___FAT,___PAG,___GEN,M.PAR_TIPFAT,M.PAR_CODPAG 
___FAT = 'VEN'
___PAG = 'ICL'
___GEN = 'GEN'
M.PAR_TIPFAT = SPACE(03)
M.PAR_CODPAG = SPACE(03)

RELEASE M.PAR_CODICE,M.PAR_CODCLI,M.PAR_RAGSOC,M.PAR_TEL,M.PAR_IVA
PUBLIC  M.PAR_CODICE,M.PAR_CODCLI,M.PAR_RAGSOC,M.PAR_TEL,M.PAR_IVA
M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)


RELEASE V_CAMPO,Y_CAMPO,V_DATA,_CTR,V_PRIMA,V_NUMREG,V_PRIMA,V_CLIFOR,V_TIPIVA,V_VALTOT, ;
        V_VALIVA,XXX_CODIVA,XXX_NUMIVA,XXX_NOIVA,V_TOTALE,V_TROV,V_NPROG
PUBLIC  V_CAMPO,Y_CAMPO,V_DATA,_CTR,V_PRIMA,V_NUMREG,V_PRIMA,V_CLIFOR,V_TIPIVA,V_VALTOT, ;
        V_VALIVA,XXX_CODIVA,XXX_NUMIVA,XXX_NOIVA,V_TOTALE,V_TROV,V_NPROG
V_CAMPO    = ""
Y_CAMPO    = ""
V_DATA     = ""
_CTR       = 0
V_PRIMA    = .T.
V_NUMREG   = ""
V_PRIMA    = .T.
V_CLIFOR   = 0
V_TIPIVA   = 0
V_VALTOT   = 0
V_VALIVA   = 0
XXX_CODIVA = '20 '
XXX_NUMIVA = 20
XXX_NOIVA  = 'FC '
V_TOTALE   = 0
V_TROV     = .F.
V_NPROG    = 0


CREATE CURSOR TRANSITO (TRA_CODCLI C(10),TRA_RECORD C(200),TRA_LUNGH N(5),SELEZIONE C(3))
CREATE CURSOR TRANSITO1 (TRA_RECORD C(200))

*!*	=OPENDB("PERCORSO")
*!*	SELECT PERCORSO
*!*	SET ORDER TO I_TIPO
*!*	SEEK 'PCL'
*!*	IF FOUND()
*!*	    V_PATH = ALLTRIM(PER_PATH)
*!*	    SELECT TRANSITO1
*!*	    APPEND FROM &V_PATH SDF
*!*	ELSE

WAIT windows "ok parto"
    SELECT TRANSITO  
    gcTable = GETFILE('', 'Seleziona file movimenti contabili da convertire', 'Converti',0)
    IF empty(gcTable) .or. gcTable = ""
       =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
       RETURN
    ENDIF
    SELECT TRANSITO1
    APPEND FROM &gcTable SDF
*!*	ENDIF


x_cond = "codice = 'GEN" + PUB_CODSOC + "'"
cSql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0
   PUB_CC=SUBSTR(LIBERA,1,pub_sottog-1)
   PUB_FF=SUBSTR(LIBERA,18,pub_sottog-1)
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   RETURN
ENDIF


V_CONTA = 0
V_SALTA = .T.

___CODCLI = SPACE(10)





*** BONIFICA
_CARATTERI_VALIDI=131
_CARATTERE_APERTURA='|'
_CARATTERE_APERTURA='|'
_FLAG_RIGA_TRONCATA=.F.
_PARTE_TRONCATA_DA_AGGIUNGERE=SPACE(0)
SELECT TRANSITO1
GO TOP


DO WHILE !EOF()

    IF _FLAG_RIGA_TRONCATA
        SELECT TRANSITO1
        _PARTE_TRONCATA_DA_AGGIUNGERE=TRA_RECORD
        _LUNGH_PARTE_TRONCATA_DA_AGGIUNGERE=LEN(ALLTRIM(_PARTE_TRONCATA_DA_AGGIUNGERE))
        IF _LUNGH_PARTE_TRONCATA_DA_AGGIUNGERE<_CARATTERI_VALIDI
            DELETE
            SKIP -1    
            _LUNGH_RECORD=LEN(ALLTRIM(TRA_RECORD))
            _LUNGH_PARTE_TRONCATA_DA_AGGIUNGERE=LEN(ALLTRIM(_PARTE_TRONCATA_DA_AGGIUNGERE))
            _LUNGH_MANCANTE=_CARATTERI_VALIDI-_LUNGH_RECORD-_LUNGH_PARTE_TRONCATA_DA_AGGIUNGERE
            REPLACE TRA_RECORD WITH ALLTRIM(TRA_RECORD)+SPACE(_LUNGH_MANCANTE)+ALLTRIM(_PARTE_TRONCATA_DA_AGGIUNGERE)
            _PARTE_TRONCATA_DA_AGGIUNGERE=SPACE(0)
            _FLAG_RIGA_TRONCATA=.F.
        ELSE
            *** RIGA CONTIENE TABULATORE CHR(9)
            SKIP -1
            IF CHR(9) $ TRA_RECORD
                STRTRAN(TRA_RECORD,CHR(9),SPACE(4))
            ENDIF
            SKIP +1
            _PARTE_TRONCATA_DA_AGGIUNGERE=SPACE(0)
            _FLAG_RIGA_TRONCATA=.F.
        ENDIF
    ENDIF

    IF SUBSTR(TRA_RECORD,1,1)!=_CARATTERE_APERTURA 
        SELECT TRANSITO1
        SKIP
        LOOP
    ENDIF
    
    IF LEN(ALLTRIM(TRA_RECORD))<_CARATTERI_VALIDI
        _FLAG_RIGA_TRONCATA=.T.
    ELSE
        _FLAG_RIGA_TRONCATA=.F.
    ENDIF

    SELECT TRANSITO1
    SKIP
    
ENDDO
*** FINE BONIFICA



SELECT TRANSITO1
GO TOP



DO WHILE NOT eof()

   IF EOF()
      EXIT
   ENDIF

   IF EMPTY(TRA_RECORD) 
      DELETE
      SKIP +1
      LOOP
   ENDIF




   IF EMPTY(SUBSTR(TRA_RECORD,1,40))
       IF !EMPTY(SUBSTR(TRA_RECORD,42,5))


    	  ___CODCLI = ALLTRIM(SUBSTR(TRA_RECORD,43,4))			&& decodifica codice cli/for da testata tabulato

		  ___CODCLI  = TRC(PUB_LCL,ALLTRIM(___CODCLI ))

         
          DELETE

	      SKIP +1
    	  LOOP

       ENDIF
   ENDIF

   IF SUBSTR(TRA_RECORD,1,1) = '|' AND SUBSTR(TRA_RECORD,131,1) = '|' 
   ELSE
	      DELETE
	      SKIP +1
	      LOOP
   ENDIF


****************************


   IF SUBSTR(TRA_RECORD,1,5) = '|Tipo'
      DELETE
      SKIP +1
      LOOP
   ENDIF


   IF SUBSTR(TRA_RECORD,1,7) = '|TOTALE'
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,13) = '|     Scaduto'
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,13) = '|     S.B.F. '
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,15) = '|     A scadere'
      DELETE
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(TRA_RECORD) = "|Rim.Dir.                                                                                                                         |"
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   IF ALLTRIM(TRA_RECORD) = "|TOTALE                                                                                                                           |"
      DELETE
      SKIP +1
      LOOP
   ENDIF


   IF SUBSTR(TRA_RECORD,1,15) = "|              "
      DELETE
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(TRA_RECORD) = "|    TOTALE     Lit."
      DELETE
      SKIP +1
      LOOP
   ENDIF



*!*	*************************************** TEST PER GESTIONE DI CASI SINGOLI
*!*	IF ___CODCLI    = "000000002"
*!*	  _BROWSE = .T.
*!*	ELSE                
*!*	   SELECT TRANSITO1      
*!*	   SKIP +1
*!*	   LOOP
*!*	ENDIF
***************************************

   SCATTER MEMVAR MEMO
   
   SELECT TRANSITO
   APPEND BLANK 
   GATHER MEMVAR MEMO
   REPLACE TRA_CODCLI   WITH  ___CODCLI      

   REPLACE TRA_LUNGH     WITH LEN(ALLTRIM(TRA_RECORD)) 
    
   IF SUBSTR(TRA_RECORD,1,1)='|'
       REPLACE SELEZIONE WITH '==>'
   ELSE
       REPLACE SELEZIONE WITH ''
   ENDIF      

   SELECT TRANSITO1      
   SKIP +1

ENDDO



SELECT TRANSITO
GO TOP
DO prg\browseview WITH "TRANSITO","FILE PARTITARIO CLIENTI DA CONVERTIRE","TRA_LUNGH:LUNGH.,W:5;TRA_CODCLI:CLIENTE,W:10;TRA_RECORD:RIGA FILE,W:132;",600,800



RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei partitari clienti ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF



SELECT TRANSITO      
GO TOP
IF   _BROWSE 
  BROWSE NORMAL
ENDIF


DO WHILE .NOT.EOF()
   

****** CAMPI CERTIFICATI ******************************
*******************************************************


   SELECT TRANSITO

    IF DELETED()
      SKIP +1
      LOOP 
    ENDIF   


   ___CODCLI      = TRA_CODCLI

*!*	IF ___CODCLI = "000000002"
*!*	BROWSE NORMAL 
*!*		SET STEP ON 
*!*	ENDIF


   IF !EMPTY(SUBSTR(TRA_RECORD,2,2))
     
     DO GESTIONE_PRIMO_LIVELLO			&& RIFERIMENTI DOCUMENTO PRINCIPALE

     DO GESTIONE_SECONDO_LIVELLO		&& TRANCHE RIFERITE AL DOCUMENTO PRINCIPALE

     DO CREA_PARTITARIO					&& CREA IL PARTITARIO 

   ENDIF


   SELECT TRANSITO      

   IF !EOF()
    SKIP +1
   ENDIF
   
ENDDO


   
WAIT WINDOWS "RECORDS SCRITTI : "+STR(V_CONTA ,10,0) 

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN
   
   
************************************
PROCEDURE GESTIONE_PRIMO_LIVELLO
************************************


   IF !ExecCommand("select * from part_cli where 1=0","cur_partcli")
	   return
   ENDIF
   SELECT cur_partcli
   =DEFPUB(SELECT())

   SELECT TRANSITO
   
   M.PAR_CODSOC  = PUB_CODSOC

   IF VAL(SUBSTR(TRA_RECORD,79,02)) < 10
      M.PAR_ANNO    = "20"+SUBSTR(TRA_RECORD,79,02)
   ELSE
      M.PAR_ANNO    = "19"+SUBSTR(TRA_RECORD,79,02)
   ENDIF
   
   
   IF SUBSTR(TRA_RECORD,2,03) = "FAT"   
	   M.PAR_TIPODO  = "FAT"
   ELSE
	   M.PAR_TIPODO  = "PAG"
   ENDIF

   M.PAR_NREG    = ALLTRIM(SUBSTR(TRA_RECORD,64,06))

   ** PRELEVA IL NUMERO DI PARTITA DEL CLIENTE 
   
   M.PAR_NPART = SPACE(06)
   v_seek  = 'NUMPRC'+PUB_CODSOC
   v_chiave= "codice"
   cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"PARA","R")
      return(.f.)
   ENDIF
   SELECT PARA
   IF RECCOUNT() <> 0
	  V2=VAL(SUBSTR(LIBERA,1,7)) + 1
	  REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
	  M.PAR_NPART = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   ELSE
      RIT = MSGBOX('Parametro numero protocollo non trovato','ATTENZIONE',31)
 	  RETURN
   ENDIF
   IF !ExecRW(cSql,"PARA","W")
      return(.f.)
   ENDIF


   M.PAR_NUMPRO  = SYS(2015)

   DO CERCA_CLIFOR

   SELECT TRANSITO
   
   
   V_DATA        = SUBSTR(TRA_RECORD,73,8)
   DO TROVA_DATA
   M.PAR_DTREG   = V_DATA
   M.PAR_DTFAT   = V_DATA

   M.PAR_NUMFAT  = ALLTRIM(SUBSTR(TRA_RECORD,64,06))
   M.PAR_NPROT   = ALLTRIM(SUBSTR(TRA_RECORD,64,06))
   
   DO DECODIFICA_TOP

   ___VALUTA        = ALLTRIM(SUBSTR(TRA_RECORD,82,03))
   

   M.PAR_NPROG    = '100'			&& record 100
   M.ID_UNIQUE    = SPACE(10)
   M.PAR_DESMOV   = ALLTRIM(SUBSTR(TRA_RECORD,2,35))
   M.PAR_DESMO1   = SPACE(35)

   IF UPPER(___VALUTA)   = "LIT"
     M.PAR_VALUTA   = "ITL"
   ELSE
     M.PAR_VALUTA   = "EUR"
   ENDIF


   M.PAR_SYS      				= SPACE(10)
   M.PAR_CODACQ   				= SPACE(03)
   M.PAR_COSATRATTA 			= SPACE(05)
   M.PAR_GRADOIMPORTANZA 		= SPACE(05)
   M.PAR_FORMAPAGAMENTO 		= SPACE(05)	
   M.PAR_TIPOCONTRATTO 			= SPACE(05)
   M.PAR_PRIPAGA				= SPACE(05)
   M.PAR_ANOMAX 				= SPACE(05)
   M.PAR_CONTABILITA_PREVISIONALE = " "
   
   
   
RETURN



**************************************
PROCEDURE GESTIONE_SECONDO_LIVELLO
**************************************
 


AXABBSZ    = SELECT()
_CREA_RECORD_100 = .T.


SELECT TRANSITO
SKIP +1												&& SONO SUL SECONDO LIVELLO


IF !EOF()


	DO WHILE .NOT.EOF()


	   IF !EMPTY(SUBSTR(TRA_RECORD,2,2))			&& SONO SUL RECORD DI PRIMO LIVELLO 

			SELECT TRANSITO
			SKIP -1
		    EXIT

	   ENDIF


*!*	       SELECT TRANSITO								&& VERIFICA UN TERZO LIVELLO SUCCESSIVO E LO GESTISCE SCARTANDO QUINDI IL SECONDO LIVELLO CORRENTE
*!*	       SKIP +1
*!*	       IF !EOF()
*!*			   IF EMPTY(SUBSTR(TRA_RECORD,4,2))			&& SCARTO IL SECONDO LIVELLO E GESTISCO SOLO IL TERZO LIVELLO
*!*		     		DO GESTIONE_TERZO_LIVELLO			&& CONFERMA DI OGNI TRANCE 
*!*			        LOOP								&& VERIFICA SE ESISTE DI NUOVO UN SECONDO LIVELLO
*!*			   ENDIF
*!*	           SKIP -1									&& RITORNO A GESTIRE IL SECONDO LIVELLO PROSEGUENDO NELLA ROUTINE IN QUANTO NON ESISTONO TERZI LIVELLI
*!*	       ELSE
*!*	           SKIP -1									&& RITORNO A GESTIRE IL SECONDO LIVELLO PROSEGUENDO NELLA ROUTINE IN QUANTO NON ESISTONO TERZI LIVELLI
*!*	       ENDIF


 
	   IF EMPTY(SUBSTR(TRA_RECORD,4,2))			&& GESTISCO SOLO IL TERZO LIVELLO
     		DO GESTIONE_TERZO_LIVELLO			&& CONFERMA DI OGNI TRANCE 
	        LOOP								&& 
	   ENDIF
       
  
       Y_CAMPO          = 0
	   V_CAMPO         	= ALLTRIM(SUBSTR(TRA_RECORD,91,17))		   && IMPORTO 
	   V_SEGNO         	= ALLTRIM(SUBSTR(TRA_RECORD,108,1))		   && SEGNO

	   DO TOGLI_PUNTI

	   _DARE  = 0
	   _AVERE = 0

	   IF V_SEGNO = '-'
		   _AVERE     		= VAL(STR(VAL(Y_CAMPO),14,2))
           _AVERE           = TEURO(M.PAR_VALUTA,_AVERE,_DATACONV)
	   ELSE
		   _DARE     		= VAL(STR(VAL(Y_CAMPO),14,2))
           _DARE            = TEURO(M.PAR_VALUTA,_DARE,_DATACONV)
	   ENDIF


	   _TDARE  = _TDARE  + _DARE
	   _TAVERE = _TAVERE + _AVERE

	   IF _DARE <> 0
   	       M.PAR_TIPFAT = ___FAT
		   M.PAR_TMOV      = 'D'									&& DARE
		   M.PAR_TOTIM     = _DARE
		   M.PAR_FATT      = _DARE
		   M.PAR_IMPO1     = _DARE									&& VERIFICARE
		   M.PAR_TOT1      = _DARE									&& VERIFICARE
		   SAVE_PAR_TMOV      = 'D'									&& DARE
		   SAVE_PAR_TOTIM     = _DARE

	   ELSE
   	       M.PAR_TIPFAT = ___PAG
		   M.PAR_TMOV      = 'A'									&& AVERE
		   M.PAR_TOTIM     = _AVERE
		   M.PAR_FATT      = _AVERE
		   M.PAR_IMPO1     = _AVERE									&& VERIFICARE
		   M.PAR_TOT1      = _AVERE									&& VERIFICARE
		   SAVE_PAR_TMOV      = 'A'									&& AVERE
		   SAVE_PAR_TOTIM     = _AVERE

	   ENDIF



	   M.PAR_CIVA1    = '20'
	   M.PAR_CIVA2    = SPACE(02) 
	   M.PAR_CIVA3    = SPACE(02)
	   M.PAR_CIVA4    = SPACE(02)      
	   M.PAR_CIVA5    = SPACE(02)
	   
	   V_DATA         = SUBSTR(TRA_RECORD,73,8)
	   DO TROVA_DATA
	   M.PAR_DTSCAD   = V_DATA
	   M.PAR_DATPAG   = V_DATA
	   M.PAR_DTVAL    = V_DATA
	 
	   M.PAR_CAMBIO   = 1
    
 	   M.PAR_TIPODO  = "FAT"

	   
	   IF _CREA_RECORD_100 
	   
	       _CREA_RECORD_100  = .F.
	       
			IF	M.PAR_TIPFAT = ___FAT			&& TRATTA FATTURE

  	           M.PAR_NPROG   = '100'			&& record 100

			   SELECT cur_partcli

			   APPEND BLANK
			   GATHER MEMVAR

               REPLACE   PAR_VALUTA  WITH "EUR"


		   	   _CTR = _CTR +1
		       M.PAR_NPROG   = '200'			&& record 200
			   SELECT cur_partcli
			   APPEND BLANK
			   GATHER MEMVAR

               REPLACE   PAR_VALUTA  WITH "EUR"
               
		   	   _CTR = _CTR +1

			   V_CONTA     = V_CONTA + 1

		    ELSE

		

		       _NPROG   	 = VAL(M.PAR_NPROG) + 10
		       M.PAR_NPROG   = STR(_NPROG,3,0) 	&& record incrementato di 10 in 10
			   SELECT cur_partcli
			   APPEND BLANK
			   GATHER MEMVAR

               REPLACE   PAR_VALUTA  WITH "EUR"


		   	   _CTR = _CTR +1

			   V_CONTA     = V_CONTA + 1

		    ENDIF

	   ELSE
	   
	   
	       _NPROG   	 = VAL(M.PAR_NPROG) + 10
	       M.PAR_NPROG   = STR(_NPROG,3,0) 	&& record incrementato di 10 in 10
		   SELECT cur_partcli
		   APPEND BLANK
		   GATHER MEMVAR

           REPLACE   PAR_VALUTA  WITH "EUR"


	   	   _CTR = _CTR +1
    
    	   V_CONTA     = V_CONTA + 1
	   
	   
	   ENDIF   
	   
	   SELECT TRANSITO      
	   SKIP +1


	ENDDO WHILE .NOT.EOF()
ENDIF

SELECT(AXABBSZ)   



RETURN


**************************************
PROCEDURE GESTIONE_TERZO_LIVELLO
**************************************



AXABBSZ    = SELECT()
_CREA_RECORD_100T = .T.


DO WHILE .NOT.EOF()


   IF !EMPTY(SUBSTR(TRA_RECORD,4,2))
     EXIT
   ENDIF



   V_CAMPO         	= ALLTRIM(SUBSTR(TRA_RECORD,91,17))		   && IMPORTO 
   V_SEGNO         	= ALLTRIM(SUBSTR(TRA_RECORD,108,1))		   && SEGNO

   DO TOGLI_PUNTI

   _DARE  = 0
   _AVERE = 0
   IF V_SEGNO = '-'
	   _AVERE     		= VAL(STR(VAL(Y_CAMPO),14,2))
       _AVERE           = TEURO(M.PAR_VALUTA,_AVERE,_DATACONV)
   ELSE
	   _DARE     		= VAL(STR(VAL(Y_CAMPO),14,2))
       _DARE            = TEURO(M.PAR_VALUTA,_DARE,_DATACONV)
   ENDIF



   _TDARE  = _TDARE  + _DARE
   _TAVERE = _TAVERE + _AVERE

   IF _DARE <> 0
	   M.PAR_TIPFAT = ___FAT				
	   M.PAR_TMOV      = 'D'									&& DARE
	   M.PAR_TOTIM     = _DARE
	   M.PAR_FATT      = _DARE
	   M.PAR_IMPO1     = _DARE									&& VERIFICARE
	   M.PAR_TOT1      = _DARE									&& VERIFICARE
   ELSE
	   M.PAR_TIPFAT = ___PAG
	   M.PAR_TMOV      = 'A'									&& AVERE
	   M.PAR_TOTIM     = _AVERE
	   M.PAR_FATT      = _AVERE
	   M.PAR_IMPO1     = _AVERE									&& VERIFICARE
	   M.PAR_TOT1      = _AVERE									&& VERIFICARE
   ENDIF

*!*	   IF SAVE_PAR_TMOV      = M.PAR_TMOV AND  SAVE_PAR_TOTIM     = M.PAR_TOTIM		&& HO GIA CREATO ILMOVIMENTO
*!*	     EXIT
*!*	   ENDIF


   M.PAR_CIVA1    = '20'
   M.PAR_CIVA2    = SPACE(02) 
   M.PAR_CIVA3    = SPACE(02)
   M.PAR_CIVA4    = SPACE(02)      
   M.PAR_CIVA5    = SPACE(02)
   
   V_DATA         = SUBSTR(TRA_RECORD,73,8)
   DO TROVA_DATA
   M.PAR_DTSCAD   = V_DATA
   M.PAR_DATPAG   = V_DATA
   M.PAR_DTVAL    = V_DATA

 
   M.PAR_CAMBIO   = 1

	   
   IF _CREA_RECORD_100T 
   
       _CREA_RECORD_100T  = .F.
       
		IF	M.PAR_TIPFAT = ___FAT			&& TRATTA FATTURE

	       M.PAR_NPROG   = '100'			&& record 100

		   SELECT cur_partcli

		   APPEND BLANK
		   GATHER MEMVAR

           REPLACE   PAR_VALUTA  WITH "EUR"


	   	   _CTR = _CTR +1
	       M.PAR_NPROG   = '200'			&& record 200
		   SELECT cur_partcli
		   APPEND BLANK
		   GATHER MEMVAR

           REPLACE   PAR_VALUTA  WITH "EUR"
           
	   	   _CTR = _CTR +1

		   V_CONTA     = V_CONTA + 1

	    ELSE

	

	       _NPROG   	 = VAL(M.PAR_NPROG) + 10
	       M.PAR_NPROG   = STR(_NPROG,3,0) 	&& record incrementato di 10 in 10
		   SELECT cur_partcli
		   APPEND BLANK
		   GATHER MEMVAR

           REPLACE   PAR_VALUTA  WITH "EUR"


	   	   _CTR = _CTR +1

		   V_CONTA     = V_CONTA + 1

	    ENDIF

   ELSE
   
   
       _NPROG   	 = VAL(M.PAR_NPROG) + 10
       M.PAR_NPROG   = STR(_NPROG,3,0) 	&& record incrementato di 10 in 10
	   SELECT cur_partcli
	   APPEND BLANK
	   GATHER MEMVAR

       REPLACE   PAR_VALUTA  WITH "EUR"


   	   _CTR = _CTR +1

	   V_CONTA     = V_CONTA + 1
   
   
   ENDIF   

 
   
   
   
   SELECT TRANSITO      
   SKIP +1


ENDDO WHILE .NOT.EOF()

SELECT(AXABBSZ)   



RETURN



*********************
PROCEDURE TOGLI_PUNTI
*********************

YY      = LEN(V_CAMPO)
XX      = 1
Y_CAMPO =  ' '
DO WHILE .T.
   IF XX > YY
      EXIT
   ENDIF
   IF SUBSTR(V_CAMPO,XX,1) = '.' 
   ELSE
      Y_CAMPO = Y_CAMPO + SUBSTR(V_CAMPO,XX,1) 
   ENDIF
   XX = XX + 1
ENDDO

RETURN


********************
PROCEDURE TROVA_DATA
********************

IF V_DATA = SPACE(08) .OR. V_DATA = '  /  /  ' .OR. EMPTY(V_DATA)
   V_DATA = SPACE(10)
   RETURN
ENDIF

IF SUBSTR(V_DATA,1,1) = ' '
   V_DATA = '0' + SUBSTR(V_DATA,2,7)
ENDIF

IF SUBSTR(V_DATA,4,1) = ' '
   V_DATA = SUBSTR(V_DATA,1,3) + '0' + SUBSTR(V_DATA,5,4)
ENDIF

IF VAL(SUBSTR(V_DATA,7,2)) > 50
   V_DATA = SUBSTR(V_DATA,1,6) + '19' + SUBSTR(V_DATA,7,2)
ELSE
   V_DATA = SUBSTR(V_DATA,1,6) + '20' + SUBSTR(V_DATA,7,2)
ENDIF

V_DATA = RIBALTA2(V_DATA)

RETURN


***********************
PROCEDURE GESTIONE_CONT
***********************

V_TROV = .F.


RETURN    


**********************
PROCEDURE CERCA_CLIFOR
**********************

M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)
M.PAR_CODPAG = SPACE(03)
___NAZION    = SPACE(03)


SELECT TRANSITO



   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ___CODCLI  + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   
   SELECT CUR_CLIENTI
   GO TOP

   IF !EOF()
      M.PAR_RAGSOC = cli_RAGSOC
      M.PAR_CODPAG = cli_CONPAG
      M.PAR_TEL    = cli_TELEFO
      M.PAR_IVA    = cli_PARIVA
	  M.PAR_BANCA  = cli_BAE
	  ___NAZION    = cli_NAZION
   ENDIF


V_ER = SOTTOGEN(___NAZION)
IF !V_ER
    CC = PUB_cc
ELSE
    CC = "0123"
ENDIF 

M.PAR_CODCLI = CC + ___CODCLI 



RETURN



************************
PROCEDURE DECODIFICA_TOP
************************

M.PAR_TIPFAT = SPACE(03)


DO CASE

   CASE M.PAR_TIPODO = 'FAT'				&& FATTURA
	   M.PAR_TIPFAT = ___FAT
   
   CASE M.PAR_TIPODO = 'PAG'				&& PAGAMENTO
	   M.PAR_TIPFAT = ___PAG				
   
   OTHERWISE
	   M.PAR_TIPFAT = ___GEN				&& GENERICO
ENDCASE



RETURN



***************************
PROCEDURE CREA_PARTITARIO
***************************

  

   
   
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(V_CONTA ,10,0) NOWAIT



	SELECT cur_partcli
	GO TOP


	IF !ExecRW('','part_cli','I','','cur_partcli')
	   return(.f.)
	ENDIF


    =CREA_SALDI_CF("C",M.PAR_CODCLI,M.PAR_NPART,"XXXXXXXXXX","CREA")
    


RETURN



***************************************TEST PER SCARTARE RECORD DEL FILE

***************************

*!*	   IF SUBSTR(TRA_RECORD,3,15) = 'COVERTEC S.R.L.'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,3,15) = 'STR.PRO.CELLOLE'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,3,15) = '81037 SESSA AUR'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF


*!*	   IF SUBSTR(TRA_RECORD,3,15) = 'P.I.: 022670406'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,3,5) = 'Tel.:'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,48,8) = 'Spett.le'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,48,8) <> SPACE(08)
*!*	       IF EMPTY(SUBSTR(TRA_RECORD,1,47))
*!*	          DELETE
*!*		      SKIP +1
*!*	    	  LOOP
*!*	       ENDIF
*!*	   ENDIF
*!*	   

*!*	   IF SUBSTR(TRA_RECORD,2,8) = 'Estratto'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,42,9) = 'Riepilogo'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,2,10) = '----------'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,1,5) = '|Tipo'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF


*!*	   IF SUBSTR(TRA_RECORD,1,7) = '|TOTALE'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,1,13) = '|     Scaduto'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,1,13) = '|     S.B.F. '
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF SUBSTR(TRA_RECORD,1,15) = '|     A scadere'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,9,7) = 'scadere'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,92,6) = 'TOTALE'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   IF SUBSTR(TRA_RECORD,87,6) = ' -----'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF ALLTRIM(TRA_RECORD) = '-'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,92,6) = 'TOTALE'
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF EMPTY(SUBSTR(TRA_RECORD,1,86)) 
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF ALLTRIM(TRA_RECORD) = "--------------------- ---------------------" 
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF


*!*	   
*!*	   IF ALLTRIM(TRA_RECORD) = "|    TOTALE     EURO"
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   


*!*	   IF ALLTRIM(TRA_RECORD) = "|    TOTALE     Lit."
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   

*!*	   IF SUBSTR(TRA_RECORD,1,1) = ":"
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF


*!*	   IF ALLTRIM(TRA_RECORD) = "|Rim.Dir.                                                                                                                         |"
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   
*!*	   IF ALLTRIM(TRA_RECORD) = "|TOTALE                                                                                                                           |"
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF


*!*	   IF SUBSTR(TRA_RECORD,1,17) = "    TOTALE    |  "
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,1,25) = "                         "
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   IF SUBSTR(TRA_RECORD,1,15) = "|              "
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF SUBSTR(TRA_RECORD,1,11) = "---------  "
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF ALLTRIM(TRA_RECORD) = "|Ric.Banc.                                                                                                                        |"
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF



*!*	***------
*!*	   IF EMPTY(SUBSTR(TRA_RECORD,1,12)) 			&&  scarta movimenti non di dettaglio
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	***------
