******************************************************
*      CREA SCADENZE ESPLODENDOLE IN UN CURSORE      *
******************************************************
* elabora il cursore in input con la stringa TRANCHE
* ESPLODE le scadenze e le salva nel cursore di output
* cancellando il record correte del cursore di input

FUNCTION CREA_SCADENZE_IN_CURSORE
PARAMETERS _cursore_input,_cursore_output,_tranche


AXABBSS    = SELECT()

*!*	SI SALVA LE VARIABILI DEL RECORD IN INPUT

SELECT &_cursore_input
SCATTER MEMVAR MEMO


IF SCAD_SPE = "S"	&& CONDIZIONI DI PAGAMENTO SPECIALI		
   SELECT &_cursore_output
   APPEND BLANK
   GATHER MEMVAR memo
   SELECT(AXABBSS)
   RETURN
ENDIF



TOT_RIC= 0 

SELECT CU_TRANK
GO TOP
DO WHILE .NOT. EOF()


    DATA_SCAD = TK_DSCAD
    IMP_TRANK = TK_IMP_SCAD 

    TOT_RIC = TOT_RIC + IMP_TRANK
	
    ** ESPLODE TRANCHE
    SELECT &_cursore_output
    APPEND BLANK
    GATHER MEMVAR memo
    REPLACE ORD_TRANCHE  	WITH CAMBIO(M.ORD_VALUTA,IMP_TRANK,M.ORD_CAMBIO)
    REPLACE ORD_DTSCAD   	WITH RIBALTA2(DATA_SCAD)
    REPLACE SCADENZA_ESPLOSA WITH 'S'
	
	SELECT CU_TRANK
	SKIP +1

ENDDO



SELECT(AXABBSS)

RETURN
