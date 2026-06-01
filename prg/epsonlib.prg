
*******************************************************************************
* -->> libreria per la scrittura degli scontrini della cassa EPSON
*******************************************************************************

*******************************************************************************
* -->> Apertura canale di comunicazione con la stampante fiscale
*******************************************************************************
FUNCTION ApriConnessione
*******************************************************************************
PARAMETERS _IdCanale
IF EMPTY(_IdCanale)
	_IdCanale=4
ENDIF

IF _IdCanale=100
    FPX.PortClose
	RETURN(.T.)
ENDIF

RELEASE FPX,operatore,font
PUBLIC  FPX,operatore,font
operatore = 1
font      = 1

FPX = CREATEOBJECT("EpsonFP2.EpsonFPControl")
FPX.Settings = "9600,n,8,1"
FPX.COMPort  = _IdCanale
FPX.PortOpen
FPX.EuroSettings = 2

_out = FPX.PortIsOpen

IF !(_out)
    V_TESTO = "Impossibile connettersi alla stampante fiscale"
	V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
	&V_FORM
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

_lResult=FPX.GetLastErrorDescription(1,_IdErrore)

V_TESTO = ALLTRIM(_lResult)
V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
&V_FORM

RETURN (.t.)




********************************************************************************************
* -->>  Interroga il misuratore fiscale sui seguenti punti:
*		codice da inviare				cosa ritorna
* ------------------------------------------------------------------------------------------
*		0	stato del sistema 			0 se cassa non in errore
*										3 se cassa in errore
********************************************************************************************
FUNCTION InterrogaMf
********************************************************************************************
PARAMETERS _IdCodice
IF EMPTY(_IdCodice)
	_Idcodice=0
ENDIF

DO CASE
   
   CASE _IdCodice = 0
        _ris = FPX.opReadStato(operatore)
        IF _ris <> 0
           DescrErrore(_ris)
           RETURN(.F.)
        ENDIF
        _ris = FPX.LastState
        IF _ris = '00100'
           _out = 0
        ELSE
           _out = 3
        ENDIF

ENDCASE


RETURN (_out)




*******************************************************************************
* -->>  Stampa appendice in coda allo scontrino
* -----------------------------------------------------------------------------
* 		si possono stampare max 5 righe di appendice di 40 caratteri ciascuna
*       per FP210
* 		si possono stampare max 9 righe di appendice di 40 caratteri ciascuna
*       per FP260 e FP90
* -----------------------------------------------------------------------------
*		il/i comando/i va inviato a scontrino aperto e comunque prima del 
*		comando di chiusura (pagamento) 
* -----------------------------------------------------------------------------
*		non gestisce il "vai a capo" automatico, bisogna inviare una stringa
*       per ogni riga voluta, variando il secondo parametro della funzione
*******************************************************************************
FUNCTION InviaAppe
*******************************************************************************
PARAMETERS _StrAppe
IF EMPTY(_StrAppe)
	_StrAppe="Grazie e Arrivederci"
ENDIF

_lung = LEN(ALLTRIM(_StrAppe))
_nume = ROUND((_lung/40)+1,0)
K = 1

FOR I=1 TO _nume
    stringa = SUBSTR(_StrAppe,K,40)
    K = K + 40
    _out = FPX.opPromoAgg(operatore,I,stringa)
    IF _out <> 0
       DescrErrore(_out)
       RETURN(.F.)
    ENDIF
ENDFOR


RETURN (.t.)



*******************************************************************************
* -->>  Stampa righe aggiuntive tra la voce "Resto" e la data
* -----------------------------------------------------------------------------
* 		si possono stampare max 5 righe di appendice di 40 caratteri ciascuna
*       per FP210
* 		si possono stampare max 9 righe di appendice di 40 caratteri ciascuna
*       per FP260 e FP90
* -----------------------------------------------------------------------------
*		il/i comando/i va inviato a scontrino aperto e comunque prima del 
*		comando di chiusura (pagamento) 
* -----------------------------------------------------------------------------
*		non gestisce il "vai a capo" automatico, bisogna inviare una stringa
*       per ogni riga voluta, variando il secondo parametro della funzione
*******************************************************************************
FUNCTION RigheAgg
*******************************************************************************
PARAMETERS _RigaAgg,_NumRiga

IF LEN(ALLTRIM(_RigaAgg)) > 40
   _RigaAgg = SUBSTR(_RigaAgg,1,40)
ENDIF

_out = FPX.opRigheAgg(operatore,_NumRiga,_RigaAgg)
IF _out <> 0
   DescrErrore(_out)
   RETURN(.F.)
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
    V_TESTO = "Parametri StampaRiga insufficienti"
	V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
	&V_FORM
ENDIF

IF !EMPTY(_prezzo)
   _prezzo = ROUND(_prezzo/100,2)
ENDIF

DO CASE 
   
   CASE UPPER(_tipo) = "I"		&& ricevo riga di dettaglio

		IF LEN(ALLTRIM(_descri)) > 20
			_descri=SUBSTR(_descri,1,20)
		ENDIF 

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
	     
        * gestione reso soldi
		IF _qta > 0 .AND. _prezzo < 0
		   _prezzo = _prezzo * (-1)
		   IF _qta > 1
		      _out = FPX.opRepartoResoQInt(operatore,_descri,_qta,_prezzo,_reparto)
		   ELSE
		      _out = FPX.opRepartoReso(operatore,_descri,_prezzo,_reparto)
		   ENDIF
		   _prezzo = _prezzo * (-1)
		ENDIF
		
        * gestione reso merce
        IF _qta < 0 .AND. _prezzo > 0
           _qta = _qta * (-1)
		   IF _qta > 1
		      _out = FPX.opRepartoResoQInt(operatore,_descri,_qta,_prezzo,_reparto)
		   ELSE
		      _out = FPX.opRepartoReso(operatore,_descri,_prezzo,_reparto)
		   ENDIF
		   _qta = _qta * (-1)
		ENDIF   
		
		* riga di dettaglio normale
        IF _qta > 0 .AND. _prezzo > 0
		   IF _qta > 1
              _out = FPX.opRepartoQInt(operatore,_descri,_qta,_prezzo,_reparto)
		   ELSE
              _out = FPX.opReparto(operatore,_descri,_prezzo,_reparto)
		   ENDIF
		ENDIF
		
   	    IF _out <> 0
           DescrErrore(_out)  
		   RETURN (.f.)
		ENDIF
		
		* gestione eventuale sconto 
  		IF !EMPTY(_sconto)
		   _cmd = 'SCONTATO DEL '+ALLTRIM(STR(_sconto))+'%'
           _out = FPX.opDescAgg(operatore,_cmd)
 	   	   IF _out <> 0
              DescrErrore(_out)  
		      RETURN (.f.)
		   ENDIF 
		ENDIF
					 
   CASE UPPER(_tipo) = "T"		&& ricevo riga di chiusura
		
		=IntestaScontrino()
		 
		DO CASE
		
		   CASE ALLTRIM(_reparto) = '1'
		        _out = FPX.opContante(operatore,_prezzo)
 	   	        IF _out <> 0
                   DescrErrore(_out)  
		           RETURN (.f.)
		        ENDIF
		      
		   CASE ALLTRIM(_reparto) = '2'
		        _out = FPX.opAssegno(operatore,_prezzo)
 	   	        IF _out <> 0
                   DescrErrore(_out)  
		           RETURN (.f.)
		        ENDIF
		
  		   CASE ALLTRIM(_reparto) = '3'	&& carta di credito
		        _out = FPX.opCredCC(operatore,1)
 	   	        IF _out <> 0
                   DescrErrore(_out)  
		           RETURN (.f.)
		        ENDIF
                
				* -->> scrivo scontrino x carta di credito
				* -------------------------------------------
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
				
  		        _out = FPX.opIniSNoFisc(operatore)
 	   	        IF _out <> 0
                   DescrErrore(_out)  
		           RETURN (.f.)
		        ENDIF
				FOR K=1 TO _max
 		            _cmd = CcDoc[K]
                    _out = FPX.opDatiSNoFisc(operatore,font,_cmd)
 	   	            IF _out <> 0
                       DescrErrore(_out)  
		               RETURN (.f.)
		            ENDIF 
				NEXT
   		        _out = FPX.opEndSNoFisc(operatore)
 	   	        IF _out <> 0
                   DescrErrore(_out)  
		           RETURN (.f.)
		        ENDIF
						 
		   CASE ALLTRIM(_reparto) = '4'	&& bancomat

        ENDCASE 
		
   CASE UPPER(_tipo) = "M"		&& ricevo riga di commento
		IF LEN(ALLTRIM(_descri)) > 40
			_descri=SUBSTR(_descri,1,40)
		ENDIF 
  	    _cmd = ALLTRIM(_descri)
        _out = FPX.opDescAgg(operatore,_cmd)
 	    IF _out <> 0
           DescrErrore(_out)  
		   RETURN (.f.)
		ENDIF 

   CASE UPPER(_tipo) = "C"		&& ricevo riga di comandi
	
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

IF _STATO = 3
   _ris = FPX.opRiavvioStampaDaFineCarta(operatore)
   IF _ris <> 0
      DescrErrore(_ris)
      RETURN(.F.)
   ENDIF
ENDIF

RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di subtotal
* -----------------------------------------------------------------------------
* 		Quando lo scontrino è in errore 
* -----------------------------------------------------------------------------
*******************************************************************************
FUNCTION InviaSubtotal
*******************************************************************************

_out = FPX.opSubTot(operatore)
IF _out <> 0
   DescrErrore(_out)  
   RETURN (.f.)
ENDIF
_subtotale = FPX.LastSubTotFisc

=StampaRiga('M',_subtotale,0,0,0,' ')

RETURN (.t.)


*******************************************************************************
* -->>  Lancio comando di chiusura cassa
*******************************************************************************
FUNCTION ChiusuraCassa
*******************************************************************************

WAIT WINDOW "Operazione di chiusura giornaliera ....." TIMEOUT 5
IF MESSAGEBOX("Desideri chiudere definitivamente la giornata ?",292,"*** DOMANDA ***") = 6
   _ris = FPX.opZChiusuraFisc(operatore)
   IF _ris <> 0
      DescrErrore(_out)
      RETURN(.F.)
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
   =InviaCorrezione()
   _out = FPX.opVoidTot(operatore)
   IF _out <> 0
      DescrErrore(_out)  
	  RETURN (.f.)
   ENDIF 
ENDIF
IF XXX_ERRORE = 2    && annullo dello scontrino (per ristampa dello stesso)
   =InviaCorrezione()
   _out = FPX.opVoidTot(operatore)
   IF _out <> 0
      DescrErrore(_out)  
	  RETURN (.f.)
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

RETURN (.t.)


*******************************************************************************
* -->>  Apre il cassetto in modo non fiscale
*******************************************************************************
FUNCTION ApriCassetto
*******************************************************************************

_out = FPX.opApriCassetto(operatore)
IF _out <> 0
   DescrErrore(_out)  
   RETURN (.f.)
ENDIF 

RETURN (.t.)


*******************************************************************************
* -->>  Settaggio delle righe di intestazione e di pié pagina
*******************************************************************************
FUNCTION IntestaScontrino
*******************************************************************************

DIMENSION _header[6]
DIMENSION _footer[6]

* -->> righe di intestazione scontrino
* ---------------------------------------
_header[1] = "MINERVA S.P.A."
_header[2] = ""
_header[3] = "VIA MAMURRANO - FORMIA(LT)"
_header[4] = "C/O CENTRO COMM.LE ITACA"
_header[5] = "P.IVA 00884930116"
_header[6] = "TEL.0771 737074"

* -->> righe di cortesia scontrino (pié pagina)
* -----------------------------------------------
_footer[1] = ""
_footer[2] = "                 GRAZIE"
_footer[3] = "                    E"
_footer[4] = "               ARRIVEDERCI"
_footer[5] = ""
_footer[6] = ""

*FOR J=1 TO 6
*   _out = FPX.opProgRigaInt(J,_header[J])
*   IF _out <> 0
*      DescrErrore(_out)  
*      RETURN (.f.)
*   ENDIF 
*NEXT

FOR J=1 TO 6
    _out = FPX.opPromoAgg(operatore,J,_footer[J])
    IF _out <> 0
       DescrErrore(_out)
       RETURN(.F.)
    ENDIF
NEXT

RETURN (.t.)