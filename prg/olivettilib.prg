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

IF _IdCanale=100
	= ELAMIControl.EndWorkSession()
	= ELAMIControl.UnlockPeriphericals()
	= ELAMIControl.release(1)
	Canale    = .f.
	RETURN(.T.)
ENDIF


RELEASE ELAMIControl,Tentativi,Extra,Canale
PUBLIC ELAMIControl,Tentativi,Extra,Canale

ELAMIControl=CREATEOBJECT("elami.elamicontrol")
Tentativi = 0
Extra 	  = " "
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
=IntestaScontrino(6)

RETURN (.t.)

*******************************************************************************
* -->>  Settaggio delle righe di intestazione e di pié pagina
*******************************************************************************
FUNCTION IntestaScontrino
*******************************************************************************
PARAMETERS _MaxRow

IF _MaxRow > 12
	_MaxRow=12
ENDIF 

DIMENSION _header[12]
DIMENSION _footer[5]

* -->> righe di intestazione scontrino max 12 righe
* ---------------------------------------
_header[01] = "LIBRERIA DEL CENTRO"
_header[02] = " "
_header[03] = "MINERVA SPA"
_header[04] = "CENTRO COMM.LE ITACA"
_header[05] = "FORMIA (LT)"
_header[06] = "TEL. 0771 737074"
_header[07] = ""
_header[08] = ""
_header[09] = ""
_header[10] = ""
_header[11] = ""
_header[12] = ""
_header[_MaxRow] = "00884930116"   && riga partita iva

* -->> righe di cortesia scontrino (pié pagina)
* -----------------------------------------------
_footer[01] = ""
_footer[02] = "GRAZIE"
_footer[03] = "E"
_footer[04] = "ARRIVEDERCI"
_footer[05] = ""

FOR J=1 TO _MaxRow
	_cmd = "<PRESETTING><LINETYPE>HEADER</LINETYPE><ROW>"+ALLTRIM(STR(J))+"</ROW><DESCRIPTION>"+_header[J]+"</DESCRIPTION><ATTRIBUTE>"+IIF(BETWEEN(J,1,1),"10","1")+"</ATTRIBUTE><FONT>1</FONT></PRESETTING>"
	=StampaRiga('C',_cmd,0,0,0,' ')
NEXT


FOR J=1 TO 5
	IF EMPTY(_footer[J])
		_cmd = "<PRESETTING><LINETYPE>FOOTER</LINETYPE><ROW>"+ALLTRIM(STR(J))+"</ROW><DESCRIPTION>"+_footer[J]+"</DESCRIPTION><ATTRIBUTE>1</ATTRIBUTE><FONT>1</FONT></PRESETTING>"
	else
		_cmd = "<PRESETTING><LINETYPE>FOOTER</LINETYPE><ROW>"+ALLTRIM(STR(J))+"</ROW><DESCRIPTION>"+_footer[J]+"</DESCRIPTION><ATTRIBUTE>8</ATTRIBUTE><FONT>1</FONT></PRESETTING>"
	endif
	=StampaRiga('C',_cmd,0,0,0,' ')
NEXT

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

rtOp = ELAMIControl.SendCommand(@_cmd, @_IdValore)
IF rtOp <> 0
	=MESSAGEBOX(ELAMIControl.GetErrorDescription(rtOp),16,"")
	RETURN (.f.)
ENDIF 

RETURN (ALLTRIM(_IdValore))




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
* -->>  invia il comando alla stampante fiscale e gestische eventuale 
* 		errore di ritorno
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
* -->>  prepara le righe di stampa creando la stringa di comandi da inviare
*		alla stampante
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
		
		* -->> decodifica determinati caratteri con stringhe
		* -->> alternative
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
	        CASE _reparto = '1'
				_codiva="4,00"
            CASE _reparto = '2'
				_codiva="10,00"
            CASE _reparto = '3'
				_codiva="20,00"
            CASE _reparto = '4'
				_codiva="0,00"
			OTHERWISE 
				_codiva="0,00"
		ENDCASE 
		IF _qta < 0
   	       _cmd = "<SALE><AMOUNT>"+ALLTRIM(STR((_prezzo/100)*_qta,10,2))+"</AMOUNT><DESCRIPTION>"+ALLTRIM(_descri)+"</DESCRIPTION><VATVALUE>"+_codiva+"</VATVALUE><LINEAOPT>'   "+ALLTRIM(STR(_qta))+" X "+ALLTRIM(STR((_prezzo/100),10,2))+"'</LINEAOPT></SALE>"
        ELSE
  		   IF _qta < 2
			  _cmd = "<SALE><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>"+ALLTRIM(_descri)+"</DESCRIPTION><VATVALUE>"+_codiva+"</VATVALUE></SALE>"
		   ELSE
			  _cmd = "<SALE><AMOUNT>"+ALLTRIM(STR((_prezzo/100)*_qta,10,2))+"</AMOUNT><DESCRIPTION>"+ALLTRIM(_descri)+"</DESCRIPTION><VATVALUE>"+_codiva+"</VATVALUE><LINEAOPT>'   "+ALLTRIM(STR(_qta))+" X "+ALLTRIM(STR((_prezzo/100),10,2))+"'</LINEAOPT></SALE>"
		   ENDIF
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

		_subtotale = ROUND(VAL(InterrogaMf(12)),2)
		
		DO CASE 
			CASE ALLTRIM(_reparto) = '1'
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Contanti </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
                IF InterrogaMf(0) = '45'  && se in attesa della chiusura delle scontrino
				   * WAIT WINDOW STR(_subtotale,10,2)+STR(ROUND((_prezzo/100),2),10,2)
                  _cmd="<FISCALCLOSE/>"
				   IF !InviaRiga(_cmd)
					  RETURN (.f.)
				   ENDIF
  				   * -->> mando messaggio sul display cliente
				   * -->> del totale e del resto
				   =MessaggioDisplay()
				ENDIF 

			
			CASE ALLTRIM(_reparto) = '2'
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Assegno </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
                IF InterrogaMf(0) = "45"  && se in attesa della chiusura delle scontrino
				   _cmd="<FISCALCLOSE/>"
			   	   IF !InviaRiga(_cmd)
					  RETURN (.f.)
				   ENDIF 
  				   * -->> mando messaggio sul display cliente
				   * -->> del totale e del resto
				   =MessaggioDisplay()
				ENDIF
				
			CASE ALLTRIM(_reparto) = '3'	&& carta di credito
   			    * GESTIONE POS FABIANO
   			    idTerminale = "89020068"
                importo     = _prezzo/100
                *if eseguiTransazionePOS(idTerminale,importo)=0
	            *   messagebox("Transazione avvenuta con successo!")
                *else
	            *   messagebox("Transazione fallita!")
                *endif
                
                if eseguiTransazionePOS(idTerminale,importo)=0
                else
					RETURN (.f.)
                endif
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Carta di credito </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
                IF InterrogaMf(0) = "45"  && se in attesa della chiusura delle scontrino
				   _cmd="<FISCALCLOSE/>"
				   IF !InviaRiga(_cmd)
					  RETURN (.f.)
				   ENDIF
  				   * -->> mando messaggio sul display cliente
				   * -->> del totale e del resto
				   =MessaggioDisplay()
				ENDIF 

				* -->> scrivo scontrino x carta di credito
				* -------------------------------------------
				*_max = 25
				*DIMENSION CcDoc[_max]
				*CcDoc[01] = "' '"
				*CcDoc[02] = "DESCR. DEL CENTRO SERVIZI"
				*CcDoc[03] = "' '"
				*CcDoc[04] = "ESERCIZIO COMMERCIALE"
				*CcDoc[05] = "INDIRIZZO"
				*CcDoc[06] = "LOCALITA"
				*CcDoc[07] = "' '"
				*CcDoc[08] = "CAUSALE:"
				*CcDoc[09] = "S/E-CE"
				*CcDoc[10] = "T-ID:"
				*CcDoc[11] = "N.TRANS."
				*CcDoc[12] = "CC:"
				*CcDoc[13] = "AUT.NUM:"
				*CcDoc[14] = "IMPORTO EURO:"
				*CcDoc[15] = "' '"
				*CcDoc[16] = "FIRMA CLIENTE:"
				*CcDoc[17] = "' '"
				*CcDoc[18] = "' '"
				*CcDoc[19] = ".........................."
				*CcDoc[20] = "(CONTROVALORE LIRE:)"
				*CcDoc[21] = "' '"
				*CcDoc[22] = "  TRANSAZIONE ESEGUITA"
				*CcDoc[23] = "' '"
				*CcDoc[24] = "DESCRIZIONE BANCA"
				*CcDoc[25] = "' '"
				
				*FOR j=1 TO 2
				*	_cmd="<NOFISCALOPEN/>"
				*	IF !InviaRiga(_cmd)
				*		RETURN (.f.)
				*	ENDIF 
				*	FOR _JJ=1 TO _MAX
				*		_cmd="<PRINT><MESSAGE>"+CcDoc[_JJ]+"</MESSAGE><ATTRIBUTE>2</ATTRIBUTE></PRINT>"
				*		IF !InviaRiga(_cmd)
				*			RETURN (.f.)
				*		ENDIF 
				*	NEXT
				*	_cmd="<NOFISCALCLOSE/>"
				*	IF !InviaRiga(_cmd)
				*		RETURN (.f.)
				*	ENDIF 
				*NEXT 
				
			
			CASE ALLTRIM(_reparto) = '4'	&& bancomat
   			    * GESTIONE POS FABIANO
   			    idTerminale = "89020068"
                importo     = _prezzo/100
                *if eseguiTransazionePOS(idTerminale,importo)=0
	            *   messagebox("Transazione avvenuta con successo!")
                *else
	            *   messagebox("Transazione fallita!")
                *endif

                if eseguiTransazionePOS(idTerminale,importo)=0
                else
					RETURN (.f.)
                endif
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Bancomat </DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
                IF InterrogaMf(0) = "45"  && se in attesa della chiusura delle scontrino
				   _cmd="<FISCALCLOSE/>"
				   IF !InviaRiga(_cmd)
					  RETURN (.f.)
				   ENDIF
  				   * -->> mando messaggio sul display cliente
				   * -->> del totale e del resto
				   =MessaggioDisplay()
				ENDIF 

				* -->> scrivo scontrino x bancomat
				* -------------------------------------------
				*_max = 20
				*DIMENSION CcDoc[_max]
				*CcDoc[01] = "' '"
				*CcDoc[02] = "DESCR. DEL CENTRO SERVIZI "
				*CcDoc[03] = "' '"
				*CcDoc[04] = "ESERCIZIO COMMERCIALE     "
				*CcDoc[05] = "INDIRIZZO                 "
				*CcDoc[06] = "LOCALITA                  "
				*CcDoc[07] = "' '"
				*CcDoc[08] = "CAUSALE:"
				*CcDoc[09] = "S/E-CE"
				*CcDoc[10] = "T-ID:"
				*CcDoc[11] = "N.TRANS."
				*CcDoc[12] = "AUT.NUM:"
				*CcDoc[13] = "IMPORTO EURO:"
				*CcDoc[14] = "                          "
				*CcDoc[15] = "(CONTROVALORE LIRE:)"
				*CcDoc[16] = "' '"
				*CcDoc[17] = "  TRANSAZIONE ESEGUITA"
				*CcDoc[18] = "' '"
				*CcDoc[19] = "DESCRIZIONE BANCA"
				*CcDoc[20] = "' '"
				
				*FOR j=1 TO 2
				*	_cmd="<NOFISCALOPEN/>"
				*	IF !InviaRiga(_cmd)
				*		RETURN (.f.)
				*	ENDIF 
				*	FOR _JJ=1 TO _MAX
				*		_cmd="<PRINT><MESSAGE>"+CcDoc[_JJ]+"</MESSAGE><ATTRIBUTE>2</ATTRIBUTE></PRINT>"
				*		IF !InviaRiga(_cmd)
				*			RETURN (.f.)
				*		ENDIF 
				*	NEXT
				*	_cmd="<NOFISCALCLOSE/>"
				*	IF !InviaRiga(_cmd)
				*		RETURN (.f.)
				*	ENDIF 
				*NEXT 
				
			CASE ALLTRIM(_reparto) = '5'
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Tessera-Altro</DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
                IF InterrogaMf(0) = '45'  && se in attesa della chiusura delle scontrino
				   _cmd="<FISCALCLOSE/>"
			   	   IF !InviaRiga(_cmd)
					  RETURN (.f.)
				   ENDIF 
  				   * -->> mando messaggio sul display cliente
				   * -->> del totale e del resto
				   =MessaggioDisplay()
				ENDIF
				
			CASE ALLTRIM(_reparto) = '6'
				_cmd="<PAYMENT><AMOUNT>"+ALLTRIM(STR((_prezzo/100),10,2))+"</AMOUNT><DESCRIPTION>Finanziamento</DESCRIPTION></PAYMENT>"
				IF !InviaRiga(_cmd)
					RETURN (.f.)
				ENDIF 
                IF InterrogaMf(0) = "45"  && se in attesa della chiusura delle scontrino
				   _cmd="<FISCALCLOSE/>"
			   	   IF !InviaRiga(_cmd)
					  RETURN (.f.)
				   ENDIF 
  				   * -->> mando messaggio sul display cliente
				   * -->> del totale e del resto
				   =MessaggioDisplay()
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
IF !StampaRiga('C','<FISCALREPORT/>',0,0,0,' ')
   =InviaCorrezione()
ENDIF
WAIT WINDOW "Operazione di chiusura giornaliera ....." TIMEOUT 5
IF MESSAGEBOX("Desideri chiudere definitivamente la giornata ?",292,"*** DOMANDA ***") = 6
	IF !StampaRiga('C','<RESETREPORT/>',0,0,0,' ')
	   =InviaCorrezione()
	ENDIF
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

&& annullo dello scontrino (anche delle elaborazioni già fatte)
IF !StampaRiga('C','<CANCEL/>',0,0,0,' ')
 	=InviaCorrezione()
ENDIF
=StampaRiga('C','<FISCALCLOSE/>',0,0,0,' ')

IF X_SINO = 'SI'
   XXX_ERRORE = 0
   RETURN (XXX_ERRORE)
ENDIF

IF X_SINO = 'NI'
   XXX_ERRORE = 9
   RETURN (XXX_ERRORE)
ENDIF

XXX_ERRORE = 1

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

*******************************************************************************
* -->>  Gestione taglio dello scontrino
*******************************************************************************
FUNCTION MessaggioDisplay	
*******************************************************************************
_ECRTOTALE = ALLTRIM(STR(VAL(STRTRAN(InterrogaMf(11),".",",")),10,2))
_ECRRESTO  = ALLTRIM(STR(VAL(STRTRAN(InterrogaMf(13),".",",")),10,2))

DIMENSION _ecrdis[2]
_ecrdis[1]="<SHOWCLIENT><ROW>1</ROW><MESSAGE>TOTALE"+PADL(_ECRTOTALE,10)+"</MESSAGE></SHOWCLIENT>"
_ecrdis[2]="<SHOWCLIENT><ROW>2</ROW><MESSAGE>RESTO"+PADL(_ECRRESTO,11)+"</MESSAGE></SHOWCLIENT>"

FOR _k=1 TO 2
	IF !InviaRiga(_ecrdis[_k])
		RETURN (.f.)
	ENDIF 
NEXT 

RETURN (.t.)

*******************************************************************************
* -->>  Apre il cassetto in modo non fiscale
*******************************************************************************
FUNCTION ApriCassetto
*******************************************************************************

=StampaRiga('C','<OPENDRAWER><DRAWER>1</DRAWER></OPENDRAWER>',0,0,0,' ')

RETURN (.t.)


