****************************************************************
* LIBRERIA COMUNICAZIONE CON POS
****************************************************************

*****************************
procedure definisceTabAscii
*****************************
release ascii2bin
public ascii2bin[128]

ascii2bin[1]  ="00000000"    && <NUL>  \0  
ascii2bin[2]  ="00000001"    && <SOH>   
ascii2bin[3]  ="00000010"    && <STX>   
ascii2bin[4]  ="00000011"    && <ETX>   
ascii2bin[5]  ="00000100"    && <EOT>   
ascii2bin[6]  ="00000101"    && <ENQ>   
ascii2bin[7]  ="00000110"    && <ACK>   
ascii2bin[8]  ="00000111"    && <BEL> \a  
ascii2bin[9]  ="00001000"    && <BS>  \b  
ascii2bin[10] ="00001001"    && <HT>  \t  
ascii2bin[11] ="00001010"    && <LF>  \n  
ascii2bin[12] ="00001011"    && <VT>  \v  
ascii2bin[13] ="00001100"    && <FF>  \f  
ascii2bin[14] ="00001101"    && <CR>  \r  
ascii2bin[15] ="00001110"    && <SO>   
ascii2bin[16] ="00001111"    && <SI>   
ascii2bin[17] ="00010000"    && <DLE>   
ascii2bin[18] ="00010001"    && <DC1>   
ascii2bin[19] ="00010010"    && <DC2>   
ascii2bin[20] ="00010011"    && <DC3>   
ascii2bin[21] ="00010100"    && <DC4>   
ascii2bin[22] ="00010101"    && <NAK>   
ascii2bin[23] ="00010110"    && <SYN>   
ascii2bin[24] ="00010111"    && <ETB>   
ascii2bin[25] ="00011000"    && <CAN>   
ascii2bin[26] ="00011001"    && <EM>   
ascii2bin[27] ="00011010"    && <SUB>   
ascii2bin[28] ="00011011"    && <ESC>   
ascii2bin[29] ="00011100"    && <FS>   
ascii2bin[30] ="00011101"    && <GS>   
ascii2bin[31] ="00011110"    && <RS>   
ascii2bin[32] ="00011111"    && <US>   
ascii2bin[33] ="00100000"    && <SP>   
ascii2bin[34] ="00100001"    && !   
ascii2bin[35] ="00100010"    && "   
ascii2bin[36] ="00100011"    && #   
ascii2bin[37] ="00100100"    && $   
ascii2bin[38] ="00100101"    && %   
ascii2bin[39] ="00100110"    && &   
ascii2bin[40] ="00100111"    && '   
ascii2bin[41] ="00101000"    && (   
ascii2bin[42] ="00101001"    && )   
ascii2bin[43] ="00101010"    && *   
ascii2bin[44] ="00101011"    && +   
ascii2bin[45] ="00101100"    && ,   
ascii2bin[46] ="00101101"    && -   
ascii2bin[47] ="00101110"    && .   
ascii2bin[48] ="00101111"    && /   
ascii2bin[49] ="00110000"    && 0   
ascii2bin[50] ="00110001"    && 1   
ascii2bin[51] ="00110010"    && 2   
ascii2bin[52] ="00110011"    && 3   
ascii2bin[53] ="00110100"    && 4   
ascii2bin[54] ="00110101"    && 5   
ascii2bin[55] ="00110110"    && 6   
ascii2bin[56] ="00110111"    && 7   
ascii2bin[57] ="00111000"    && 8   
ascii2bin[58] ="00111001"    && 9   
ascii2bin[59] ="00111010"    && :   
ascii2bin[60] ="00111011"    && ;   
ascii2bin[61] ="00111100"    && <   
ascii2bin[62] ="00111101"    && =   
ascii2bin[63] ="00111110"    && >   
ascii2bin[64] ="00111111"    && ?   
ascii2bin[65] ="01000000"    && @   
ascii2bin[66] ="01000001"    && A   
ascii2bin[67] ="01000010"    && B   
ascii2bin[68] ="01000011"    && C   
ascii2bin[69] ="01000100"    && D   
ascii2bin[70] ="01000101"    && E   
ascii2bin[71] ="01000110"    && F   
ascii2bin[72] ="01000111"    && G   
ascii2bin[73] ="01001000"    && H   
ascii2bin[74] ="01001001"    && I   
ascii2bin[75] ="01001010"    && J   
ascii2bin[76] ="01001011"    && K   
ascii2bin[77] ="01001100"    && L   
ascii2bin[78] ="01001101"    && M   
ascii2bin[79] ="01001110"    && N   
ascii2bin[80] ="01001111"    && O   
ascii2bin[81] ="01010000"    && P   
ascii2bin[82] ="01010001"    && S   
ascii2bin[83] ="01010010"    && R   
ascii2bin[84] ="01010011"    && S   
ascii2bin[85] ="01010100"    && T   
ascii2bin[86] ="01010101"    && U   
ascii2bin[87] ="01010110"    && V   
ascii2bin[88] ="01010111"    && W   
ascii2bin[89] ="01011000"    && X   
ascii2bin[90] ="01011001"    && Y   
ascii2bin[91] ="01011010"    && Z   
ascii2bin[92] ="01011011"    && [   
ascii2bin[93] ="01011100"    && \  \\  
ascii2bin[94] ="01011101"    && ]   
ascii2bin[95] ="01011110"    && ^   
ascii2bin[96] ="01011111"    && _   
ascii2bin[97] ="01100000"    && `   
ascii2bin[98] ="01100001"    && a   
ascii2bin[99] ="01100010"    && b   
ascii2bin[100]="01100011"    && c   
ascii2bin[101]="01100100"    && d   
ascii2bin[102]="01100101"    && e   
ascii2bin[103]="01100110"    && f   
ascii2bin[104]="01100111"    && g   
ascii2bin[105]="01101000"    && h   
ascii2bin[106]="01101001"    && i   
ascii2bin[107]="01101010"    && j   
ascii2bin[108]="01101011"    && k   
ascii2bin[109]="01101100"    && l   
ascii2bin[110]="01101101"    && m   
ascii2bin[111]="01101110"    && n   
ascii2bin[112]="01101111"    && o   
ascii2bin[113]="01110000"    && p   
ascii2bin[114]="01110001"    && q   
ascii2bin[115]="01110010"    && r   
ascii2bin[116]="01110011"    && s   
ascii2bin[117]="01110100"    && t   
ascii2bin[118]="01110101"    && u   
ascii2bin[119]="01110110"    && v   
ascii2bin[120]="01110111"    && w   
ascii2bin[121]="01111000"    && x   
ascii2bin[122]="01111001"    && y   
ascii2bin[123]="01111010"    && z   
ascii2bin[124]="01111011"    && {   
ascii2bin[125]="01111100"    && |   
ascii2bin[126]="01111101"    && }   
ascii2bin[127]="01111110"    && ~   
ascii2bin[128]="01111111"    && <DEL>   
return
*----------------------------


*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore

_valore=""

IF FILE(_configfile) && Esiste il file? 

	gnConfigFile = FOPEN(_configfile) && Se esiste, lo apre in lettura
	IF gnConfigFile >= 0 && Verifica errore in apertura del file
		&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)

			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if chiave=_proprieta
					_valore=valore
				endif
			endif
		enddo
	ENDIF

	=FCLOSE(gnConfigFile) 

ENDIF

return _valore


*****************************
procedure logpos
*****************************
parameters infoDaLoggare

if !used("logpos")
	use logpos in 0 again
endif

select logpos
append blank
replace timestamp with dtoc(date())+time(),;
		attivita with infoDaLoggare

return
*----------------------------

*****************************
function mostraAscii
*****************************
parameters stringaDaLeggere

descrizioneAscii=">"

for i = 1 to len(stringaDaLeggere)
	descrizioneAscii=descrizioneAscii+allt(str(i))+":"+allt(str(asc(substr(stringaDaLeggere,i,1))))+"-"
next
descrizioneAscii=descrizioneAscii+"<"

return descrizioneAscii
*----------------------------

*****************************
function convAscii2bin
*****************************
parameters carattereDaConvertire
=definisceTabAscii()
return ascii2bin[asc(carattereDaConvertire)+1]
*----------------------------


*****************************
function convBin2ascii
*****************************
parameters binarioDaConvertire
=definisceTabAscii()
return chr(ascan(ascii2bin,binarioDaConvertire)-1)
*----------------------------


*****************************
procedure ConfigRS232
*****************************
parameters codiceTerminale,oCom

*** lettura file di configurazione

isConfigFile=.f.
setPorta=0
setVelocita=space(0)
setParita=space(0)
setNumBitDato=space(0)
setNumBitStop=space(0)
setSimulaPos=space(0)
setEsitoOk=space(0)

IF FILE('pos.cfg')	  && Esiste il file? 
	gnPosFile = FOPEN('pos.cfg')	  && Se esiste, lo apre in lettura
	IF gnPosFile >= 0  && Verifica errore in apertura del file
		&& Se non viene trovato alcun errore legge file
		do while !feof(gnPosFile)
			riga=FGETS(gnPosFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=upper(allt(substr(riga,at("=",riga)+1)))
				
				do case 
					case chiave="COM."+ALLTRIM(codiceTerminale)
						setPorta=val(valore)
					case chiave="VELOCITA."+ALLTRIM(codiceTerminale)
						setVelocita=valore
					case chiave="PARITA."+ALLTRIM(codiceTerminale)
						setParita=valore
					case chiave="BITDATO."+ALLTRIM(codiceTerminale)
						setNumBitDato=valore
					case chiave="BITSTOP."+ALLTRIM(codiceTerminale)
						setNumBitStop=valore
					case chiave="SIMULAZIONE."+ALLTRIM(codiceTerminale)
						setSimulaPos=valore
					case chiave="SIMULAZIONE_TRANSAZIONE_OK."+ALLTRIM(codiceTerminale)
						setEsitoOk=valore
				endcase
			endif
		enddo
	ENDIF
	=FCLOSE(gnPosFile)	
	
	if 	setSimulaPos="SI"
		if setEsitoOk="SI"
			return .t.
		else 
			return .f.
		endif
	endif
	
	if 	setPorta>0 ;
		and !EMPTY(setVelocita) ;
		and !EMPTY(setParita) ;
		and !EMPTY(setNumBitDato) ;
		and !EMPTY(setNumBitStop) 
		isConfigFile=.t.
	endif
ENDIF

*** fine lettura file di configurazione

if isConfigFile

	oCom.CommPort = setPorta
	oCom.Settings = setVelocita+","+setParita+","+setNumBitDato+","+setNumBitStop
	oCom.InputLen = 0
	return .t.
endif


*** se non e' presente il file di configurazione leggo da database
*** i parametri per impostare la connesione con la porta
if !used("PARA")
  use PARA in 0 again
endif
select PARA
set order to CODICE
seek "POS"+codiceTerminale
if !found()
  return .f. 
endif

elencoParametri=para.libera

* scelgo COM1 o COM2
* default = COM2
posizioneParametro=at("COM=",elencoParametri)
if posizioneParametro>0
	valoreParametro=substr(elencoParametri,posizioneParametro)
	valoreParametro=substr(valoreParametro,len("COM=")+1,at(";",valoreParametro)-len("COM=")-1)
	setPorta = val(valoreParametro)
endif

* scelgo impostazioni porta
* velocita' in baud
*setVelocita="9600"
posizioneParametro=at("VELOCITA=",elencoParametri)
if posizioneParametro>0
	valoreParametro=substr(elencoParametri,posizioneParametro)
	valoreParametro=substr(valoreParametro,len("VELOCITA=")+1,at(";",valoreParametro)-len("VELOCITA=")-1)
	setVelocita= allt(valoreParametro)
endif
* partità  P=PARI
*          D=DISPARI
*          N=nessuna
*setParita="N"
posizioneParametro=at("PARITA=",elencoParametri)
if posizioneParametro>0
	valoreParametro=substr(elencoParametri,posizioneParametro)
	valoreParametro=substr(valoreParametro,len("PARITA=")+1,at(";",valoreParametro)-len("PARITA=")-1)
	setVelocita= allt(valoreParametro)
endif
* numero bit di dato
*setNumBitDato="8"
posizioneParametro=at("BITDATO=",elencoParametri)
if posizioneParametro>0
	valoreParametro=substr(elencoParametri,posizioneParametro)
	valoreParametro=substr(valoreParametro,len("BITDATO=")+1,at(";",valoreParametro)-len("BITDATO=")-1)
	setVelocita= allt(valoreParametro)
endif
* numero bit di stop
*setNumBitStop="1"
posizioneParametro=at("BITSTOP=",elencoParametri)
if posizioneParametro>0
	valoreParametro=substr(elencoParametri,posizioneParametro)
	valoreParametro=substr(valoreParametro,len("BITSTOP=")+1,at(";",valoreParametro)-len("BITSTOP=")-1)
	setVelocita= allt(valoreParametro)
endif

oCom.CommPort = setPorta
oCom.Settings = setVelocita+","+setParita+","+setNumBitDato+","+setNumBitStop
oCom.InputLen = 0

return .t.
*----------------------------


*****************************
procedure InviaDatiRS232
*****************************
parameters stringaDaInviare,oCom

* Apre comunicazione con porta seriale
oCom.PortOpen = .T.

* Scrive sulla porta seriale
oCom.Output = stringaDaInviare+chr(13)

* Chiude comunicazione sulla seriale
oCom.PortOpen = .F.

LOGPOS(stringaDaInviare)

return
*----------------------------

*****************************
procedure RiceviDatiRS232
*****************************
parameters oCom

* Apre comunicazione con porta seriale
oCom.PortOpen = .T.

cBuffer =space(0)

DO WHILE .T.

    DoEvents

	read TIMEOUT 1
    cBuffer = cBuffer + oCom.Input
    
    IF !empty(cBuffer)
	*MESSAGEBOX("Il POS ha risposto " + cBuffer+" "+mostraAscii(cBuffer))
	logpos(cBuffer+" "+mostraAscii(cBuffer))
        EXIT
    ENDIF
ENDDO

* Chiude comunicazione sulla seriale
oCom.PortOpen = .F.

return cBuffer 
*----------------------------

*****************************
procedure creaLRC
*****************************
parameters stringaDaVerificare
declare basePerXOR[8]
basePerXOR[1]=1
basePerXOR[2]=1
basePerXOR[3]=1
basePerXOR[4]=1
basePerXOR[5]=1
basePerXOR[6]=1
basePerXOR[7]=1
basePerXOR[8]=0

lunghezza=len(stringaDaVerificare)
declare aParola[lunghezza]

for i=1 to lunghezza
	carattere=substr(stringaDaVerificare,i,1)
	aParola[i]=convAscii2bin(carattere)
	for j=1 to 8
		bit=val(substr(aParola[i],8-j+1,1))
		basePerXOR[j]=bitxor(basePerXOR[j],bit)
	next
next

lrc=""
for j=1 to 8
	lrc=lrc+allt(iif(basePerXOR[8-j+1]=0,"0","1"))
next

carattereFinale=convBin2ascii(lrc)

return carattereFinale
*----------------------------

**********************************************************
* Protocollo messaggi
* --------------------------------------------------------
*
* tipo msg     				da   a    
* --------------------------------------------------------
* Richiesta importo			POS  ELAB
* Invio importo			    ELAB POS
* Esito transazione			POS  ELAB 
* Conferma fisica ricezione <--> <-->
* Rifiuto  fisico ricezione <--> <-->
**********************************************************


*****************************
* Messaggio Invio importo
*----------------------------
* lungh.  valore
* 1       STX = ASCII(2)
* 9       d.Terminale + 0 finale riempitivo
* 1       Codice messaggio= "I"
* 8       Importo transazione allineato a destra
*         con 0 riempitivi a sinistra
* 1       "0" fisso ignorato dal POS
* 3       campo non utilizzato da nostro POS
* 32      "0"
* 1       ETX = ASCII(3)
* 1       LRC 
*****************************
function msgInviaImporto
*****************************
parameters codiceTerminale,importo

importoFormattato=convFormatoEuro(importo)

msg=chr(2)+;
	codiceTerminale+"0"+;
	"I"+;
	importoFormattato+;
	"0"+;
	space(3)+;
	replicate("0",32)+;
	chr(3)
	
lrc=creaLRC(msg)
msg=msg+lrc

return msg
*----------------------------

*****************************
* Messaggio Richiesta importo
*----------------------------
* lungh.  valore
* 1       STX = ASCII(2)
* 9       Id.Terminale + 0 finale riempitivo
* 1       - Codice messaggio= "I" (nostro caso)
*           se "Ricezione importo seriale 2" vale 1-4
*         - Codice messaggio= "Y" 
*           se "Ricezione importo seriale 2" vale 7-8
* 1       ETX = ASCII(3)
* 1       LRC 
*****************************
function msgRichiestaImporto
*****************************
parameters codiceTerminale

msg=chr(2)+;
	codiceTerminale+"0"+;
	"I"+;
	chr(3)
	
lrc=creaLRC(msg)
msg=msg+lrc

return msg
*----------------------------

*****************************
* Verifica Richiesta importo
*****************************
function verMsgRichImporto
*****************************
parameters msg,codiceTerminale

esitoVerifica=99 && 0 messaggio corretto
				 && 99 errore di trasmissione o errore formale

* CONTROLLO CORRETTEZZA TRASMISSIONE
*
* controllo se LRC è corretto	
lrc=creaLRC(substr(msg,1,len(msg)-1))
if lrc!=substr(msg,len(msg),1)
   esitoVerifica=99
   return esitoVerifica
endif

* CONTROLLO FORMALE
*
* codifica la prima parte del messaggio 
* per confrontarlo con quello arrivato 
* dal POS e verificare che si tratti effettivamente di
* UN MESSAGGIO DI RICHIESTA IMPORTO
codifica=chr(2)+;
              codiceTerminale+"0"+;
              "Y"+;
              chr(3)
* verifico se è un messaggio di esito
* proveniente dal terminale corretto 			  
if substr(msg,1,len(codifica))!=codifica
   esitoVerifica=99
   return esitoVerifica
endif

esitoVerifica=0

return esitoVerifica
*----------------------------


*****************************
* Messaggio Conferma fisica
*----------------------------
* lungh. 	valore
* 1			ACX = ASCII(6)
* 1			ETX = ASCII(3)
* 1			LRC 
*****************************
function msgConfermaFisica
*****************************
parameters codiceTerminale

msg=chr(6)+;
	chr(3)
	
lrc=creaLRC(msg)
msg=msg+lrc

return msg
*----------------------------


*****************************
* Messaggio Rifiuto fisico
*----------------------------
* lungh. 	valore
* 1			NAK = ASCII(21)
* 1			ETX = ASCII(3)
* 1			LRC 
*****************************
function msgRifiutoFisico
*****************************
parameters codiceTerminale

msg=chr(21)+;
	chr(3)
	
lrc=creaLRC(msg)
msg=msg+lrc

return msg
*----------------------------



*****************************
* Verifica Esito Transazione
*----------------------------
* lungh. 	valore
* 1			STX = ASCII(2)
* 9			Id.Terminale + 0 finale riempitivo
* 1			Codice messaggio= "E"
* 2         Esito 00 = esito OK
*				  01...99 = esito transazione KO
* 19 		PAN della carta con spazi riempitivi a sinistra
* 1 		Tipo di carta: "0" BANCOMAT
*						   "1" CARTA CREDITO
*						   "2" FIDELITY
* 2 		
* 1			ETX = ASCII(3)
* 1			LRC 
*****************************
function verificaMsgEsito
*****************************
parameters msgEsito,codiceTerminale

esitoVerifica=99 && 0 messaggio corretto
				 && 99 errore di trasmissione o errore formale
				 && 1 messaggio corretto ma transazione fallita

* CONTROLLO CORRETTEZZA TRASMISSIONE
*
* controllo se LRC è corretto	
lrc=creaLRC(substr(msgEsito,1,len(msgEsito)-1))
if lrc!=substr(msgEsito,len(msgEsito),1)
   esitoVerifica=99
   return esitoVerifica
endif

* CONTROLLO FORMALE
*
* codifica la prima parte del messaggio 
* fino al PAN per confrontarlo con quello arrivato 
* dal POS e verificare che si tratti effettivamente di
* UN MESSAGGIO DI ESITO TRANSAZIONE
* e in più
* CHE L'ESITO SIA POSITIVO 
codificaEsito=chr(2)+;
              codiceTerminale+"0"+;
              "E"
* verifico se è un messaggio di esito
* proveniente dal terminale corretto 			  
if substr(msgEsito,1,len(codificaEsito))!=codificaEsito
   esitoVerifica=99
   return esitoVerifica
endif
	
* controllo se è un messaggio di esito positivo			  
if substr(msgEsito,len(codificaEsito)+1,2)!="00"
   esitoVerifica=1
   return esitoVerifica
endif


esitoVerifica=0

return esitoVerifica
*----------------------------



*****************************
function convFormatoEuro 
*****************************
parameters valore

strValore=""

* controllo se il valore ha decimali
* int(valore) mi restituisce la parte intera del valore non arrorondata
if valore-int(valore)=0
	* solo interi
	* accodo i 2 decimali senza la virgola alla stringa del numero
	strValore=str(valore)+"00"
else
	* con decimali
	* 1) arrotondo a 2 decimali 
	* 2) accodo i 2 decimali senza la virgola alla stringa del numero
	strValore=allt(str(round(valore, 2),9,2))
	strValore=substr(strValore,1,len(strValore)-3)+substr(strValore,len(strValore)-1,2)
endif

strValore=replicate("0",8-len(ALLTRIM(strValore)))+ALLTRIM(strValore)

return strValore
*----------------------------


*****************************
procedure eseguiTransazionePOS 
*****************************

parameters idTerminale,importo

#DEFINE stato_iniziale 				0
#DEFINE stato_POS_richiede_importo 	10
#DEFINE stato_ELAB_inviato_importo 	20
#DEFINE stato_POS_ricevuto_importo 	30
#DEFINE stato_POS_invia_esito	 	40
#DEFINE stato_chiude_com_pos	 	99

release codiceEsitoTransazione,stato_com_pos,oCom

private codiceEsitoTransazione && 0 = transazione esegita correttamente
                               && 1 = transazione fallita (esce dal ciclo lettura carta)
                               && 99 = errore di comunicazione con il POS nella ricezione 
                               &&      del messaggio di esito della transazione 
                               &&      (loop nel ciclo di lettura carta 
                               &&      per attesa nuova strisciata) 

private stato_com_pos          && definisce lo stato della comunicazione col POS

* inizializza parametri porta seriale per 
* comunicazione con POS

oForm=CreateObject("form") 
SET CLASSLIB TO "rs232comm.vcx"
oForm.AddObject("oCom","rs232comm") 

stato_com_pos = stato_iniziale
codiceEsitoTransazione = 99

isPos=ConfigRS232(idTerminale,oForm.oCom)
if !isPos
	if esitoPositivoSmulazione(idTerminale)
		visualizzaMessaggio("STRISCIARE_CARTA") 
		READ TIMEOUT 1
		visualizzaMessaggio("ATTENDERE") 
		READ TIMEOUT 1
		visualizzaMessaggio("TRANSAZIONE_OK") 
		READ TIMEOUT 1
		codiceEsitoTransazione =0
	else
		visualizzaMessaggio("STRISCIARE_CARTA") 
		READ TIMEOUT 1
		visualizzaMessaggio("ATTENDERE") 
		READ TIMEOUT 1
		visualizzaMessaggio("TRANSAZIONE_KO") 
		READ TIMEOUT 1
		codiceEsitoTransazione =99
	endif
	cancellaMessaggio()
	return codiceEsitoTransazione 
endif

visualizzaMessaggio("STRISCIARE_CARTA") 
READ TIMEOUT 1

DO WHILE .t.

	datiRicevuti=RiceviDatiRS232(oForm.oCom)
	
	if empty(datiRicevuti)
		loop
	endif

	do case 

		case stato_com_pos = stato_iniziale
			
			if datiRicevuti=msgRichiestaImporto(idTerminale)
				cancellaMessaggio()
				logpos("POS chiede importo")
				InviaDatiRS232(msgConfermaFisica(),oForm.oCom)
				logpos("Inviata a POS conferma fisica")
				InviaDatiRS232(msgInviaImporto(idTerminale,importo),oForm.oCom)
				logpos("Inviato a POS messaggio con importo")
				* imposto nuovo stato
				stato_com_pos=stato_ELAB_inviato_importo
				visualizzaMessaggio("ATTENDERE") 
			else
				cancellaMessaggio()
				wait window "ERRORE DI COMUNICAZIONE CON POS: ATTENDERE" nowait
				READ TIMEOUT 1	
				logpos("POS ha inviato messaggio errato o inatteso")
				InviaDatiRS232(msgRifiutoFisico(),oForm.oCom)
				logpos("Inviato a POS rifiuto fisico")
				visualizzaMessaggio("STRISCIARE_CARTA") 
			endif
			loop
			
		case stato_com_pos = stato_ELAB_inviato_importo

			if datiRicevuti=msgConfermaFisica()
				logpos("POS ha inviato conferma ricezione importo")

				* imposto nuovo stato
				stato_com_pos=stato_POS_ricevuto_importo
				visualizzaMessaggio("ATTENDERE") 
			ENDIF
			loop

		case stato_com_pos = stato_POS_ricevuto_importo

			esitoVerifica=verificaMsgEsito(datiRicevuti,idTerminale)
 			do case 
				case esitoVerifica=0
					logpos("POS ha inviato esito positivo transazione")
					InviaDatiRS232(msgConfermaFisica(),oForm.oCom)
					logpos("Inviata a POS conferma fisica")

					* imposto nuovo stato
					stato_com_pos=stato_chiude_com_pos
					visualizzaMessaggio("TRANSAZIONE_OK") 
					codiceEsitoTransazione=0
					exit
				case esitoVerifica=1
					InviaDatiRS232(msgConfermaFisica(),oForm.oCom)
					logpos("Inviata comunque a POS conferma fisica")
					visualizzaMessaggio("TRANSAZIONE_KO") 
					stato_com_pos=stato_chiude_com_pos
					codiceEsitoTransazione=1
					exit
				case esitoVerifica=99
					InviaDatiRS232(msgRifiutoFisico(),oForm.oCom)
					logpos("Inviata comunque a POS conferma fisica")
					wait window "ERRORE DI CONNESSIONE CON IL POS" nowait
					stato_com_pos=stato_iniziale
					codiceEsitoTransazione=99
					exit
			endcase

			loop

		case stato_com_pos = stato_chiude_com_pos
			exit
	endcase
		
enddo

RELEASE oForm 

cancellaMessaggio()
return codiceEsitoTransazione
*----------------------------


*****************************
procedure esitoPositivoSmulazione
*****************************
PARAMETERS codiceTerminale
*** lettura file di configurazione

setEsitoOk=space(0)

IF FILE('pos.cfg')	  && Esiste il file? 
	gnPosFile = FOPEN('pos.cfg')	  && Se esiste, lo apre in lettura
	IF gnPosFile >= 0  && Verifica errore in apertura del file
		&& Se non viene trovato alcun errore legge file
		do while !feof(gnPosFile)
			riga=FGETS(gnPosFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=upper(allt(substr(riga,at("=",riga)+1)))
				
				do case 
					case chiave="SIMULA_TRANSAZIONE_OK."+ALLTRIM(codiceTerminale)
						setEsitoOk=valore
				endcase
			endif
		enddo
	ENDIF
	=FCLOSE(gnPosFile)	
	
	if setEsitoOk="SI"
		return .t.
	else 
		return .f.
	endif
endif

&& qui non passa mai perche' il fatto che 
&& esista il config e' controllato prima di
&& richiamare questa procedure
&& Ho messo comunque il return per completezza sintattica
&& di una procedure che restutisce un flag boolean 
return .f.
*----------------------------

*****************************
procedure visualizzaMessaggio
*****************************
parameters tipoMesaggio
LOCAL messaggioDaVisualizzare

DO CASE 
	CASE tipoMesaggio=="ATTENDERE"
		messaggioDaVisualizzare="ATTENDERE PREGO... TRANSAZIONE IN CORSO"
	CASE tipoMesaggio=="TRANSAZIONE_OK"
		messaggioDaVisualizzare="OPERAZIONE ESEGUITA CORRETTAMENTE"
	CASE tipoMesaggio=="TRANSAZIONE_KO"
		messaggioDaVisualizzare="ATTENZIONE! OPERAZIONE FALLITA"
	CASE tipoMesaggio=="STRISCIARE_CARTA"
		messaggioDaVisualizzare="STRISCIARE CARTA"
	OTHERWISE	
		messaggioDaVisualizzare=tipoMesaggio
ENDCASE


WAIT WINDOW messaggioDaVisualizzare NOWAIT

*cancellaMessaggio()
*DEFINE WINDOW output FROM 2,1 TO 15,79 ;
*	HALFHEIGHT CLOSE FLOAT GROW SHADOW ZOOM FILL FILE tipoMesaggio+".bmp"
*ACTIVATE WINDOW output
*SHOW WINDOW output
*----------------------------


*****************************
procedure cancellaMessaggio
*****************************
*RELEASE WINDOW output
*CLEAR
*----------------------------
