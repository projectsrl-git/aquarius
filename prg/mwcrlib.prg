*******************************************************************************
* -->> libreria per la scrittura degli scontrini della cassa MWCR
*******************************************************************************

*******************************************************************************
* -->> Apertura canale di comunicazione con la stampante fiscale
*******************************************************************************
FUNCTION ApriConnessione
*******************************************************************************
PARAMETERS _IdCanale
IF EMPTY(_IdCanale)
	_IdCanale=10
ENDIF

IF _IdCanale=100
	RETURN(.T.)
ENDIF

Declare Long OpenConnection      in w32ecash.dll long@hwnd

_out=OpenConnection(_IdCanale)

IF _out <> 0
	*=MESSAGEBOX("Impossibile connettersi alla stampante fiscale",16,"*** ATTENZIONE ***")
    V_TESTO = "Impossibile connettersi alla stampante fiscale"
	V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
	&V_FORM
	DescrErrore(_out)
	RETURN (.f.)
ENDIF

RETURN (.t.)



*******************************************************************************
* -->> Decodifica messaggi di errore
*******************************************************************************
FUNCTION DescrErrore
*******************************************************************************
PARAMETERS _IdErrore
IF EMPTY(_IdErrore)
	_IdErrore=0
ENDIF

Declare String GetErrorDescription in w32ecash.dll long@NumError

_lResult=GetErrorDescription(_IdErrore)

*=MESSAGEBOX(_lResult,16,"*** ATTENZIONE ***")
V_TESTO = _lResult
V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
&V_FORM

RETURN (.t.)




********************************************************************************************
* -->>  Interroga il misuratore fiscale sui seguenti punti:
*		codice da inviare				cosa ritorna
* ------------------------------------------------------------------------------------------
*		0	stato del sistema 			0 se scontrino chiuso e cassa non in errore
*										1 se scontrino aperto e cassa non in errore
*										2 se scontrino chiuso e cassa in errore
*										3 se scontrino aperto e cassa in errore
* ------------------------------------------------------------------------------------------
*		1	matricola 					numero di matricola del registratore di cassa
* ------------------------------------------------------------------------------------------
*		2	n.scontrini fiscale			numero di scontrini fiscali emessi(escluso quello aperto)
* ------------------------------------------------------------------------------------------
*		3	posizione chiave			0  se posizione OFF
*										1  se posizione SET chiave P
*										2  se posizione CHIUSURA chiave Z
*										3  se posizione REG chiave R
*										9  se posizione VENDITA chiave X
*										10 se posizione MGR (Non utilizzato)
* ------------------------------------------------------------------------------------------
*		4	memoria fiscale				testa la presenza della memoria fiscale
* ------------------------------------------------------------------------------------------
*		5	importo resto				importo del resto con decimali impliciti
*										es. 267 equivale a 2,67
* ------------------------------------------------------------------------------------------
*		6	subtotale					importo del subtotale con decimali impliciti
*										es 2309 equivale a 23,09
* ------------------------------------------------------------------------------------------
*		7	data-ora 					data ora del misuratore fiscale nel formato
*										AAMMGGHHMMSS
* ------------------------------------------------------------------------------------------
*		8	totale ultimo scontrino		importo ultimo scontrino emesso con decimali impliciti
*										es 2309 equivale a 23,09
* ------------------------------------------------------------------------------------------
*		9	contatore doc.fiscali		numero documenti fiscali emessi (classe II)
* ------------------------------------------------------------------------------------------
*		10	totale doc.fiscali			importo totale dei documenti fiscali emessi con decimali impliciti
*										es 2309 equivale a 23,09
* ------------------------------------------------------------------------------------------
*		11	contatore doc.non fiscali	numero documenti non fiscali emessi (classe I)
* ------------------------------------------------------------------------------------------
*		12	contatore doc.non fiscali	numero documenti non fiscali emessi (classe III)
********************************************************************************************
FUNCTION InterrogaMf
********************************************************************************************
PARAMETERS _IdCodice
IF EMPTY(_IdCodice)
	_Idcodice=0
ENDIF

Declare Long GetEcrData          in w32ecash.dll string DataType, String@Buffer, Long@Size

_IdValore = SPACE(250)
_IdSize  = 0

_out=GetEcrData(_IdCodice,@_IdValore,@_IdSize)

IF _out < 0
	DescrErrore(_out)
	RETURN (_out)
ENDIF

*? "ID-VALORE   "+_IdValore
*? "ID-SIZE     "+ALLTRIM(STR(_IdSize))

RETURN (_IdValore)




*******************************************************************************
* -->>  Stampa appendice in coda allo scontrino
* -----------------------------------------------------------------------------
* 		si possono stampare max 11 righe di appendice di 32 caratteri ciascuna
* -----------------------------------------------------------------------------
*		il/i comando/i va inviato a scontrino aperto e comunque prima del 
*		comando di chiusura (pagamento) 
*******************************************************************************
FUNCTION InviaAppe
*******************************************************************************
PARAMETERS _StrAppe
IF EMPTY(_StrAppe)
	_StrAppe="Grazie e Arrivederci"
ENDIF

Declare Long SendAppendice       in w32ecash.dll String@Printer, String@lpBuffer

_out=SendAppendice('1',@_StrAppe)

IF _out <> 0
	DescrErrore(_out)
	RETURN (.f.)
ENDIF

RETURN (.t.)



*******************************************************************************
* -->>  Stampa appendice in coda allo scontrino
* -----------------------------------------------------------------------------
* 		si possono stampare max 11 righe di appendice di 32 caratteri ciascuna
* -----------------------------------------------------------------------------
*		il/i comando/i va inviato a scontrino aperto e comunque prima del 
*		comando di chiusura (pagamento) 
*******************************************************************************
FUNCTION InviaRiga
*******************************************************************************
PARAMETERS _StrRiga

Declare Long SendCommand         in w32ecash.dll string@lpBuffer

_out=SendCommand(_StrRiga)

IF _out <> 0
	DescrErrore(_out)
	=SendCommand('K')
	RETURN (.f.)
ENDIF

RETURN (.t.)





*******************************************************************************
* -->>  Stampa appendice in coda allo scontrino
* -----------------------------------------------------------------------------
* 		si possono stampare max 11 righe di appendice di 32 caratteri ciascuna
* -----------------------------------------------------------------------------
*		il/i comando/i va inviato a scontrino aperto e comunque prima del 
*		comando di chiusura (pagamento) 
*******************************************************************************
FUNCTION StampaRiga
*******************************************************************************
PARAMETERS _tipo,_descri,_qta,_prezzo,_sconto,_reparto
IF PARAMETERS() < 6
	*=MESSAGEBOX("Parametri StampaRiga insufficienti",16,"*** ATTENZIONE ***")
    V_TESTO = "Parametri StampaRiga insufficienti"
	V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
	&V_FORM
ENDIF

DO CASE 
	CASE UPPER(_tipo) = "I"		&& ricevo riga di dettaglio
		IF LEN(ALLTRIM(_descri)) > 16
			_descri=SUBSTR(_descri,1,16)
		ENDIF 
		_reso=''
		IF _prezzo < 0
		 _reso='9M'
		endif
		_cmd=_reso+'"'+UPPER(ALLTRIM(_descri))+'"'+IIF(_qta < 2,ALLTRIM(STR(_prezzo))+'H',ALLTRIM(STR(_qta))+'*'+ALLTRIM(STR(_prezzo))+'H')+ALLTRIM(_reparto)+'R'
		IF !InviaRiga(_cmd)
			RETURN (.f.)
		ENDIF 
		IF !EMPTY(_sconto)
			_cmd='"SCONTATO DEL '+ALLTRIM(STR(_sconto))+'%"@'
			IF !InviaRiga(_cmd)
				RETURN (.f.)
			ENDIF 
		ENDIF
		 
	CASE UPPER(_tipo) = "T"		&& ricevo riga di chiusura
		IF EMPTY(_prezzo)
			_cmd=ALLTRIM(_reparto)+'T'
		ELSE
			_cmd=ALLTRIM(STR(_prezzo))+'H'+ALLTRIM(_reparto)+'T'
		ENDIF
		IF !InviaRiga(_cmd)
			RETURN (.f.)
		ENDIF
		
		* -->> ricevute x cc e bancomat
		DO CASE 
			CASE ALLTRIM(_reparto) = '3'	&& carta di credito
			_max = 25
			DIMENSION CcDoc[_max]
			CcDoc[01] = '"                          "@'
			CcDoc[02] = '"DESCR. DEL CENTRO SERVIZI "@'
			CcDoc[03] = '"                          "@'
			CcDoc[04] = '"ESERCIZIO COMMERCIALE     "@'
			CcDoc[05] = '"INDIRIZZO                 "@'
			CcDoc[06] = '"LOCALITA                  "@'
			CcDoc[07] = '"                          "@'
			CcDoc[08] = '"CAUSALE:"@'
			CcDoc[09] = '"S/E-CE"@'
			CcDoc[10] = '"T-ID:"@'
			CcDoc[11] = '"N.TRANS."@'
			CcDoc[12] = '"CC:"@'
			CcDoc[13] = '"AUT.NUM:"@'
			CcDoc[14] = '"IMPORTO EURO:"@'
			CcDoc[15] = '"                          "@'
			CcDoc[16] = '"FIRMA CLIENTE:"@'
			CcDoc[17] = '"                          "@'
			CcDoc[18] = '"                          "@'
			CcDoc[19] = '".........................."@'
			CcDoc[20] = '"(CONTROVALORE LIRE:)"@'
			CcDoc[21] = '"                          "@'
			CcDoc[22] = '"  TRANSAZIONE ESEGUITA"@'
			CcDoc[23] = '"                          "@'
			CcDoc[24] = '"DESCRIZIONE BANCA"@'
			CcDoc[25] = '"                          "@'
			
			FOR _J=1 TO 2
				IF !InviaRiga('j')
					RETURN (.f.)
				ENDIF 
				FOR _JJ=1 TO _MAX
					IF !InviaRiga(CcDoc[_JJ])
						RETURN (.f.)
					ENDIF 
				NEXT
				IF !InviaRiga('J')
					RETURN (.f.)
				ENDIF 
			NEXT
			
			CASE ALLTRIM(_reparto) = '4'	&& bancomat
			_max = 20
			DIMENSION CcDoc[_max]
			CcDoc[01] = '"                          "@'
			CcDoc[02] = '"DESCR. DEL CENTRO SERVIZI "@'
			CcDoc[03] = '"                          "@'
			CcDoc[04] = '"ESERCIZIO COMMERCIALE     "@'
			CcDoc[05] = '"INDIRIZZO                 "@'
			CcDoc[06] = '"LOCALITA                  "@'
			CcDoc[07] = '"                          "@'
			CcDoc[08] = '"CAUSALE:"@'
			CcDoc[09] = '"S/E-CE"@'
			CcDoc[10] = '"T-ID:"@'
			CcDoc[11] = '"N.TRANS."@'
			CcDoc[12] = '"AUT.NUM:"@'
			CcDoc[13] = '"IMPORTO EURO:"@'
			CcDoc[14] = '"                          "@'
			CcDoc[15] = '"(CONTROVALORE LIRE:)"@'
			CcDoc[16] = '"                          "@'
			CcDoc[17] = '"  TRANSAZIONE ESEGUITA"@'
			CcDoc[18] = '"                          "@'
			CcDoc[19] = '"DESCRIZIONE BANCA"@'
			CcDoc[20] = '"                          "@'
			
			IF !InviaRiga('j')
				RETURN (.f.)
			ENDIF 
			FOR _JJ=1 TO _MAX
				IF !InviaRiga(CcDoc[_JJ])
					RETURN (.f.)
				ENDIF 
			NEXT
			IF !InviaRiga('J')
				RETURN (.f.)
			ENDIF 
			
		ENDCASE  		
		 
		
	CASE UPPER(_tipo) = "M"		&& ricevo riga di commento
		IF LEN(ALLTRIM(_descri)) > 26
			_descri=SUBSTR(_descri,1,26)
		ENDIF 
		_cmd='"'+ALLTRIM(_descri)+'"@'
		IF !InviaRiga(_cmd)
			RETURN (.f.)
		ENDIF 

	CASE UPPER(_tipo) = "C"		&& ricevo riga di comandi
		IF LEN(ALLTRIM(_descri)) > 26
			_descri=SUBSTR(_descri,1,26)
		ENDIF 
		_cmd=ALLTRIM(_descri)
		IF !InviaRiga(_cmd)
			RETURN (.f.)
		ENDIF 
	
ENDCASE 


RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di inizializzazione scontrino
* -----------------------------------------------------------------------------
* 		Quando lo scontrino è in errore 
* -----------------------------------------------------------------------------
*******************************************************************************
FUNCTION InviaCorrezione
*******************************************************************************

=StampaRiga('C','K',0,0,0,' ')

RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di subtotal
* -----------------------------------------------------------------------------
* 		Quando lo scontrino è in errore 
* -----------------------------------------------------------------------------
*******************************************************************************
FUNCTION InviaSubtotal
*******************************************************************************

=StampaRiga('C','=',0,0,0,' ')

RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di chiusura cassa
*******************************************************************************
FUNCTION ChiusuraCassa
*******************************************************************************

IF !StampaRiga('C','z0|1tc',0,0,0,' ')
   =InviaCorrezione()
ENDIF

RETURN (.t.)


*******************************************************************************
* -->>  Annullo dello scontrino in linea
*******************************************************************************
FUNCTION AnnulloScontrino
*******************************************************************************

PARAMETERS _SINO


RELEASE X_SINO
PUBLIC  X_SINO
X_SINO = _SINO

*DO WHILE .T.
*   _STATO_ECASH = InterrogaMf(0)
*   DO CASE 
*	  CASE _STATO_ECASH = "1"
*		   V_TESTO = "Attenzione!!! Scontrino aperto in cassa"
*		   V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
*		   &V_FORM
*          =InviaCorrezione()
*          =Inviasubtotal()
*          =StampaRiga('M',' ',0,0,0,' ')
*		   LOOP
*  	  CASE _STATO_ECASH = "2"
*		   V_TESTO = "Attenzione!!! Cassa in stato di errore"
*		   V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
*		   &V_FORM
*          =InviaCorrezione()
*          =Inviasubtotal()
*          =StampaRiga('M',' ',0,0,0,' ')
*		   LOOP
*	  CASE _STATO_ECASH = "3"
*		   V_TESTO = "Attenzione!!! Scontrino aperto e cassa in stato di errore"
*		   V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
*		   &V_FORM
*          =InviaCorrezione()
*          =Inviasubtotal()
*          =StampaRiga('M',' ',0,0,0,' ')
*		   LOOP
*  ENDCASE 
*  EXIT
*ENDDO

DO WHILE .T.
   IF StampaRiga('M',' ',0,0,0,' ')
      EXIT
   ENDIF
ENDDO

IF X_SINO = 'SI'
   XXX_ERRORE = 0
   RETURN (XXX_ERRORE)
ENDIF

DO WHILE .T.

   V_TESTO = "Desideri annullare lo scontrino in linea ?"
   V_FORM  = "DO FORM FORM\DOMANDA_ECASH WITH '" + V_TESTO + "'"
   &V_FORM
   IF PUB_ERRORE = 6  && RISPOSTA SI
      XXX_ERRORE = 1
      EXIT
   ELSE
      V_TESTO = "Desideri ristampare lo scontrino ?"
      V_FORM  = "DO FORM FORM\DOMANDA_ECASH WITH '" + V_TESTO + "'"
      &V_FORM
      IF PUB_ERRORE = 6  && RISPOSTA SI
         XXX_ERRORE = 2
         EXIT
      ENDIF
   ENDIF
   
ENDDO   

IF XXX_ERRORE = 1    && annullo dello scontrino (anche delle elaborazioni già fatte)
   IF !StampaRiga('C','25F1T',0,0,0,' ')
      =InviaCorrezione()
   ENDIF
ENDIF
IF XXX_ERRORE = 2    && annullo dello scontrino (per ristampa dello stesso)
   IF !StampaRiga('C','25F1T',0,0,0,' ')
      =InviaCorrezione()
   ENDIF
ENDIF

RETURN (XXX_ERRORE)


*******************************************************************************
* -->>  Gestione taglio dello scontrino
*		0 taglio disabilitato
*		1 taglio parziale
*		2 taglio totale
*******************************************************************************
FUNCTION AttivaTaglio	
*******************************************************************************
PARAMETERS _StrPara

Declare Long SetPrinterCutter    in w32ecash.dll String@CutterStatus

_out=SetPrinterCutter(_StrPara)

IF _out <> 0
	DescrErrore(_out)
	RETURN (.f.)
ENDIF

RETURN (.t.)



*********************************
PROCEDURE start_w32ecash_dll
*********************************
Declare Long SendCommand         in w32ecash.dll string@lpBuffer
Declare Long SetEcrKeyboard      in w32ecash.dll string@Enable
Declare Long OpenConnection      in w32ecash.dll long@hwnd
Declare Long GetEcrData          in w32ecash.dll string@DataType, String@Buffer, Long@Size
Declare String GetErrorDescription in w32ecash.dll long@NumError
Declare Long SendAppendice       in w32ecash.dll String@Printer, String@lpBuffer
Declare Long UpdateNonFiscalDoc  in w32ecash.dll String@DataType
Declare Long UpdateFiscalDoc     in w32ecash.dll Long@Valore, String@DataType
Declare Long SetPrinterCutter    in w32ecash.dll String@CutterStatus
