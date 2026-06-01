*******************************************************************************
* -->> libreria per la scrittura degli scontrini della cassa OLIVETTI
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

RELEASE ELAMIControl,Tentativi,Extra,Canale
PUBLIC ELAMIControl,Tentativi,Extra,Canale

ELAMIControl=CREATEOBJECT("elami.elamicontrol")
Tentativi = 0
Extra 	  = " "
Canale    = .f.

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


_lResult=ELAMIControl.GetErrorDescription(_IdErrore)

*=MESSAGEBOX(_lResult,16,"*** ATTENZIONE ***")
V_TESTO = _lResult
V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
&V_FORM

RETURN (.t.)




********************************************************************************************
* -->>  Interroga il misuratore fiscale sui seguenti punti:
*		codice da inviare				cosa ritorna
* ------------------------------------------------------------------------------------------
*		0	stato del sistema 			41 se scontrino fiscale chiuso e cassa non in errore
*										42 se scontrino fiscale aperto e cassa non in errore
*										43 se scontrino fiscale non aperto
*										44 se scontrino fiscale aperto con pagamento parziale
*										   effettuato e in attesa del saldo
*										45 se scontrino fiscale terminato ma senza comando di 
* 										   chiusura
* ------------------------------------------------------------------------------------------
*		per avere le altre informazioni consulta il manuale ELA Manager alla pagina 106
*		punto 8.4.3
* ------------------------------------------------------------------------------------------
********************************************************************************************
FUNCTION InterrogaMf
********************************************************************************************
PARAMETERS _IdCodice
IF EMPTY(_IdCodice)
	_Idcodice=0
ENDIF

_IdValore = SPACE(250)

IF _Idcodice=0
	_cmd = "<GETFISSTATUS/>"
ELSE
	_cmd = "<GETINFO><ATTRIBUTE>"+ALLTRIM(STR(_Idcodice))+"</ATTRIBUTE></GETINFO>"
ENDIF

IF !Canale
	IF !ApriChiudiSessione("A","--")
		return(.f.)
	ENDIF 

	rtOp = ELAMIControl.SendCommand(@_cmd, @_IdValore)
	IF rtOp <> 0
		=MESSAGEBOX(ELAMIControl.GetErrorDescription(rtOp),16,"")
		RETURN (.f.)
	ENDIF 

	IF !ApriChiudiSessione("C","--")
		return(.f.)
	ENDIF 
ELSE 
	rtOp = ELAMIControl.SendCommand(@_cmd, @_IdValore)
	IF rtOp <> 0
		=MESSAGEBOX(ELAMIControl.GetErrorDescription(rtOp),16,"")
		RETURN (.f.)
	ENDIF 
ENDIF


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


RETURN (.t.)



*******************************************************************************
*******************************************************************************
FUNCTION InviaRiga
*******************************************************************************
PARAMETERS _StrRiga

rtOp = ELAMIControl.SendCommand(@_StrRiga, @Extra)
IF rtOp <> 0
	=MESSAGEBOX(ELAMIControl.GetErrorDescription(rtOp),16,"")
	RETURN (.f.)
ENDIF 

RETURN (.t.)


*******************************************************************************
FUNCTION ApriChiudiSessione
*******************************************************************************
PARAMETERS _ApriChiudi,_Fiscale

IF _ApriChiudi ="A"

	Tentativi = 0
	Extra     = " "
	Canale    = .f.
	
	_OUT = ELAMIControl.release(1)
	IF _out <> 0
		DescrErrore(_out)
		ELAMIControl.release(1)
		RETURN (.f.)
	ENDIF

	_OUT = ELAMIControl.Initialize(2)
	IF _out <> 0
		DescrErrore(_out)
		ELAMIControl.release(1)
		RETURN (.f.)
	ENDIF

	DO WHILE (Tentativi <= 5)
		_OUT = ELAMIControl.LockPeriphericals()
		If _OUT <> 0
			WAIT WINDOW "Connessione in corso..." TIMEOUT 2
			Tentativi = Tentativi + 1
		ELSE
			EXIT 
		EndIf
	ENDDO 

	If(Tentativi > 3)
		=MESSAGEBOX("Impossibile accedere in modalità esclusiva alle periferiche."+CHR(13)+ELAMIControl.GetErrorDescription(_out),16,"")
		RETURN (.F.)
	ENDIF 

	_OUT = ELAMIControl.BeginWorkSession()
	If _OUT <> 0 
		=MESSAGEBOX("Errore nell'apertura della sessione di lavoro"+CHR(13)+ELAMIControl.GetErrorDescription(_OUT),16,"")
		= ELAMIControl.EndWorkSession()
		= ELAMIControl.UnlockPeriphericals()
		RETURN (.F.)
	EndIf
	Canale    = .t.
	DO CASE 
		CASE  _Fiscale = "SI"
			_cmd="<FISCALOPEN/>"
			IF !InviaRiga(_cmd)
				RETURN (.f.)
			ENDIF 
		CASE  _Fiscale = "NO"
			_cmd="<NOFISCALOPEN/>"
			IF !InviaRiga(_cmd)
				RETURN (.f.)
			ENDIF 
	ENDCASE 
ELSE
	DO CASE 
		CASE  _Fiscale = "SI"
			_cmd="<FISCALCLOSE/>"
			IF !InviaRiga(_cmd)
				RETURN (.f.)
			ENDIF 
		CASE  _Fiscale = "NO"
			_cmd="<NOFISCALCLOSE/>"
			IF !InviaRiga(_cmd)
				RETURN (.f.)
			ENDIF 
	ENDCASE 
	
	= ELAMIControl.EndWorkSession()
	= ELAMIControl.UnlockPeriphericals()
	= ELAMIControl.release(1)
	Canale    = .f.
ENDIF

RETURN (.t.)


*******************************************************************************
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

IF !Canale
	IF !ApriChiudiSessione("A","SI")
		return(.f.)
	ENDIF 
ENDIF

DO CASE 
	CASE UPPER(_tipo) = "I"		&& ricevo riga di dettaglio

		_descri=UPPER(ALLTRIM(_descri))
		_descri=STRTRAN(_descri,'"','&quot;')
		_descri=STRTRAN(_descri,'&','&amp;')
		_descri=STRTRAN(_descri,'<','&lt;')
		_descri=STRTRAN(_descri,'>','&gt;')
		_descri=STRTRAN(_descri,"A'","&224;")
		_descri=STRTRAN(_descri,"E'","&232;")
		_descri=STRTRAN(_descri,"I'","&236;")
		_descri=STRTRAN(_descri,"O'","&242;")
		_descri=STRTRAN(_descri,"U'","&249;")
		_descri=STRTRAN(_descri,UPPER("à"),"&224;")
		_descri=STRTRAN(_descri,UPPER("è"),"&232;")
		_descri=STRTRAN(_descri,UPPER("ì"),"&236;")
		_descri=STRTRAN(_descri,UPPER("ò"),"&242;")
		_descri=STRTRAN(_descri,UPPER("ù"),"&249;")

		_codiva="0,00"
		DO CASE 
	        CASE _REP = '1'
				_codiva="4,00"
            CASE _REP = '2'
				_codiva="10,00"
            CASE _REP = '3'
				_codiva="20,00"
            CASE _REP = '4'
				_codiva="0,00"
			OTHERWISE 
				_codiva="0,00"
		ENDCASE 
		IF _qta < 2
			_cmd = "<SALE><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>"+ALLTRIM(_descri)+"</DESCRIPTION><VATVALUE>"+_codiva+"</VATVALUE></SALE>"
		ELSE
			_cmd = "<SALE><AMOUNT>"+ALLTRIM(STR((_prezzo/100)*_qta,10,2))+"</AMOUNT><DESCRIPTION>"+ALLTRIM(_descri)+"</DESCRIPTION><VATVALUE>"+_codiva+"</VATVALUE><LINEAOPT>'   "+ALLTRIM(STR(_qta))+" X "+ALLTRIM(STR((_prezzo/100),10,2))+"'</LINEAOPT></SALE>"
		ENDIF
		IF !InviaRiga(_cmd)
			RETURN (.f.)
		ENDIF 

		IF !EMPTY(_sconto)
			_cmd="<PRINT><MESSAGE>SCONTATO DEL "+ALLTRIM(STR(_sconto))+"%</MESSAGE><ATTRIBUTE>2</ATTRIBUTE></PRINT>"
			IF !InviaRiga(_cmd)
				RETURN (.f.)
			ENDIF 
		ENDIF
		 
	CASE UPPER(_tipo) = "T"		&& ricevo riga di chiusura
		DO CASE 
			CASE ALLTRIM(_reparto) = '1'
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Contanti </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
				IF !ApriChiudiSessione("C","SI")
					return(.f.)
				ENDIF 
			
			CASE ALLTRIM(_reparto) = '2'
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Assegno </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
				IF !ApriChiudiSessione("C","SI")
					return(.f.)
				ENDIF 
			
			CASE ALLTRIM(_reparto) = '3'	&& carta di credito
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Carta di credito </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
				IF !ApriChiudiSessione("C","SI")
					return(.f.)
				ENDIF 

				* -->> scrivo scontrino x carta di credito
				* -------------------------------------------
				IF !Canale
					IF !ApriChiudiSessione("A","NO")
						return(.f.)
					ENDIF 
				ENDIF
				_max = 25
				DIMENSION CcDoc[_max]
				CcDoc[01] = "' '"
				CcDoc[02] = "DESCR. DEL CENTRO SERVIZI"
				CcDoc[03] = "' '"
				CcDoc[04] = "ESERCIZIO COMMERCIALE"
				CcDoc[05] = "INDIRIZZO"
				CcDoc[06] = "LOCALITA"
				CcDoc[07] = "' '"
				CcDoc[08] = "CAUSALE:"
				CcDoc[09] = "S/E-CE"
				CcDoc[10] = "T-ID:"
				CcDoc[11] = "N.TRANS."
				CcDoc[12] = "CC:"
				CcDoc[13] = "AUT.NUM:"
				CcDoc[14] = "IMPORTO EURO:"
				CcDoc[15] = "' '"
				CcDoc[16] = "FIRMA CLIENTE:"
				CcDoc[17] = "' '"
				CcDoc[18] = "' '"
				CcDoc[19] = ".........................."
				CcDoc[20] = "(CONTROVALORE LIRE:)"
				CcDoc[21] = "' '"
				CcDoc[22] = "  TRANSAZIONE ESEGUITA"
				CcDoc[23] = "' '"
				CcDoc[24] = "DESCRIZIONE BANCA"
				CcDoc[25] = "' '"
				
				FOR j=1 TO 2
					FOR _JJ=1 TO _MAX
						_cmd="<PRINT><MESSAGE>"+CcDoc[_JJ]+"</MESSAGE><ATTRIBUTE>2</ATTRIBUTE></PRINT>"
						IF !InviaRiga(_cmd)
							RETURN (.f.)
						ENDIF 
					NEXT
				NEXT 
				
				IF !ApriChiudiSessione("C","NO")
					return(.f.)
				ENDIF 
			
			CASE ALLTRIM(_reparto) = '4'	&& bancomat
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Bancomat </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
				IF !ApriChiudiSessione("C","SI")
					return(.f.)
				ENDIF 

				* -->> scrivo scontrino x bancomat
				* -------------------------------------------
				IF !Canale
					IF !ApriChiudiSessione("A","NO")
						return(.f.)
					ENDIF 
				ENDIF
				_max = 20
				DIMENSION CcDoc[_max]
				CcDoc[01] = "' '"
				CcDoc[02] = "DESCR. DEL CENTRO SERVIZI "
				CcDoc[03] = "' '"
				CcDoc[04] = "ESERCIZIO COMMERCIALE     "
				CcDoc[05] = "INDIRIZZO                 "
				CcDoc[06] = "LOCALITA                  "
				CcDoc[07] = "' '"
				CcDoc[08] = "CAUSALE:"
				CcDoc[09] = "S/E-CE"
				CcDoc[10] = "T-ID:"
				CcDoc[11] = "N.TRANS."
				CcDoc[12] = "AUT.NUM:"
				CcDoc[13] = "IMPORTO EURO:"
				CcDoc[14] = "                          "
				CcDoc[15] = "(CONTROVALORE LIRE:)"
				CcDoc[16] = "' '"
				CcDoc[17] = "  TRANSAZIONE ESEGUITA"
				CcDoc[18] = "' '"
				CcDoc[19] = "DESCRIZIONE BANCA"
				CcDoc[20] = "' '"
				
				FOR _JJ=1 TO _MAX
					_cmd="<PRINT><MESSAGE>"+CcDoc[_JJ]+"</MESSAGE><ATTRIBUTE>2</ATTRIBUTE></PRINT>"
					IF !InviaRiga(_cmd)
						RETURN (.f.)
					ENDIF 
				NEXT
				IF !ApriChiudiSessione("C","NO")
					return(.f.)
				ENDIF 
				
		ENDCASE  		
		 
		
	CASE UPPER(_tipo) = "M"		&& ricevo riga di commento
		_cmd="<PRINT><MESSAGE>"+ALLTRIM(_descri)+"</MESSAGE><ATTRIBUTE>2</ATTRIBUTE></PRINT>"
		IF !InviaRiga(_cmd)
			RETURN (.f.)
		ENDIF 

	CASE UPPER(_tipo) = "C"		&& ricevo riga di comandi
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

_STATO = InterrogaMf(0)

=StampaRiga('C','<CANCEL/>',0,0,0,' ')
=StampaRiga('C','<FISCALCLOSE/>',0,0,0,' ')

RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di subtotal
* -----------------------------------------------------------------------------
* 		Quando lo scontrino è in errore 
* -----------------------------------------------------------------------------
*******************************************************************************
FUNCTION InviaSubtotal
*******************************************************************************

=StampaRiga('C','<SUBTOTAL/>',0,0,0,' ')

RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di chiusura cassa
*******************************************************************************
FUNCTION ChiusuraCassa
*******************************************************************************
IF !Canale
	IF !ApriChiudiSessione("A","--")
		return(.f.)
	ENDIF 
ENDIF

IF !StampaRiga('C','<FISCALREPORT/>',0,0,0,' ')
   =InviaCorrezione()
ENDIF
WAIT WINDOW "Operazione di chiusura giornaliera ....." TIMEOUT 5
IF MESSAGEBOX("Desideri chiudere definitivamente la giornata ?",292,"*** DOMANDA ***") = 6
	IF !StampaRiga('C','<RESETREPORT/>',0,0,0,' ')
	   =InviaCorrezione()
	ENDIF
ENDIF 

IF !ApriChiudiSessione("C","--")
	return(.f.)
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
   IF !StampaRiga('C','<CANCEL/>',0,0,0,' ')
      =InviaCorrezione()
   ENDIF
	=StampaRiga('C','<FISCALCLOSE/>',0,0,0,' ')
ENDIF
IF XXX_ERRORE = 2    && annullo dello scontrino (per ristampa dello stesso)
   IF !StampaRiga('C','<CANCEL/>',0,0,0,' ')
      =InviaCorrezione()
   ENDIF
	=StampaRiga('C','<FISCALCLOSE/>',0,0,0,' ')
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

RETURN (.t.)


