**********************************************************
* Procedura per la scrittura di un file excel formattato
*
* Parametri passati:
*		_WTBL	= alias della tabella /cursore dati
*		_WFILE	= nome completo del file in cui scrivere
*				  i dati
*		_WEXCEL = comando per lanciare EXCEL
**********************************************************
PARA _WTBL,_WFILE,_WEXCEL

PUBLIC canale,w_pas1,w_pas2
w_pas1=.f.
w_pas2=.f.

SET EXACT ON
* -->> apro excel e file in background
* -------------------------------------
run /n7 &_WEXCEL &_WFILE

* -->> apro canale di comunicazione con excel
* --------------------------------------------
canale = DDEInitiate('Excel', 'Foglio1')

* -->> errore di apertura canale
* --------------------------------
IF canale = -1
   ERASE &_WFILE
   _WFILE="ERRORE"
   RETURN
ENDIF

* -->> PROCEDURA DI SCRITTURA
* -----------------------------
DO XLS_SCRIVI

* -->> chiusura e salvataggio file
* -->> chiusura excel
* ----------------------------------
=DDEEXECUTE(canale,'[Close("Yes")][Quit()]')

* -->> chiusura canale di comunicazione
* ---------------------------------------
=DDETerminate(canale)

RELEASE CANALE,w_pas1,w_pas2
RETURN




*************************
PROCEDURE XLS_SCRIVI
*************************
SELECT &_WTBL

_LINE = 4				  && NUMERO DI RIGHE DI TESTATA DEL FOGLIO EXCEL
MAX   = afield(xxx)       && NUMERO DI COLONNE UTILIZZATE NEL FOGLIO EXCEL
_FINE = 0

DIMENSION TABCOL[MAX]

SELECT &_WTBL
_NREC = RECCOUNT()
GO TOP
SCATTER MEMVAR MEMO

* -->> scrivo testata
=DDEpoke(canale, 'R1C1', 'Elenco piano dei conti') 
=DDEpoke(canale, 'R1C5', alltrim(PUB_DESSOC)) 
=DDEpoke(canale, 'R2C1', 'Anno contabile: '+pub_anno) 
=DDEpoke(canale, 'R2C5', 'Stampa del '+dtoc(date())) 

IF MAX < 5
   =DDEpoke(canale, 'R4C1', 'Conto') 
   =DDEpoke(canale, 'R4C2', 'Descrizione') 
   =DDEpoke(canale, 'R4C3', 'Saldo') 
else
   =DDEpoke(canale, 'R4C1', 'Conto') 
   =DDEpoke(canale, 'R4C2', 'Descrizione') 
   =DDEpoke(canale, 'R4C3', 'Dare') 
   =DDEpoke(canale, 'R4C4', 'Avere') 
   =DDEpoke(canale, 'R4C5', 'Saldo') 
endif

* -->> scrivo dettagli
DO WHILE !EOF()  
   SCATTER MEMVAR MEMO
   * -->> genero i puntatori a riga-colona
   FOR H=1 TO MAX
       TABCOL[H]="R"+ALLTRIM(STR(RECNO()+_LINE))+"C"+ALLTRIM(STR(H))
   NEXT 
   * -->> scrivo le righe
   IF EMPTY(M.CONTO)
      =DDEpoke(canale, TABCOL[2], M.RISO) 
      _FINE=(RECNO()-1)+_LINE
      SKIP+1
      LOOP
   ENDIF
  
   * scrive le colonne nel foglio excell (SOLO PER I CAMPI DI UN RECORD)

   DO WHILE .T.
      * anno contabile
      IF !DDEpoke(canale, TABCOL[1], M.CONTO) 
         DO ERRO_DDE        
      ENDIF
      IF !DDEpoke(canale, TABCOL[2], M.DESCRIZIONE) 
         DO ERRO_DDE        
      ENDIF
      IF MAX < 5
         IF !DDEpoke(canale, TABCOL[3], STR(M.SALDO,17,3)) 
            DO ERRO_DDE        
         ENDIF
      ELSE
         IF !DDEpoke(canale, TABCOL[3], STR(M.DARE,17,3)) 
            DO ERRO_DDE        
         ENDIF
         IF !DDEpoke(canale, TABCOL[4], STR(M.AVERE,17,3)) 
            DO ERRO_DDE        
         ENDIF
         IF !DDEpoke(canale, TABCOL[5], STR(M.SALDO,17,3)) 
            DO ERRO_DDE        
         ENDIF
      ENDIF
      EXIT
   ENDDO
   SKIP+1
ENDDO

*= DDEpoke(canale, 'R9C2', 'VALORE CALCOLATO SOMMANDO LA COLONNA L')
*= DDEpoke(canale, 'R9C12', '=SOMMA(L3:L6)')
*= DDEpoke(canale, 'R10C2', 'VALORE PER DIFFERENZA COLONNE D-E')
*= DDEpoke(canale, 'R10C12', '=SOMMA(D3:D6)-SOMMA(E3:E6)')
    
RETURN


PROCEDURE ERRO_DDE

WAIT WINDOW "CODICE ERRORE: "+ALLTRIM(STR(DDELastError( )))

RETURN