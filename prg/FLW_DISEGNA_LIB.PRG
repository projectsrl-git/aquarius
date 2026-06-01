**********************************************************
PROCEDURE FLW_DEFVAR
**********************************************************
PUBLIC scelta[5,2]
scelta[1,1]= 0
scelta[1,2]= 50
scelta[2,1]= 50
scelta[2,2]= 100
scelta[3,1]= 100
scelta[3,2]= 50
scelta[4,1]= 50
scelta[4,2]= 0
scelta[5,1]= 0
scelta[5,2]= 50

PUBLIC collegamento[5,2]
collegamento[1,1]= 25
collegamento[1,2]= 0
collegamento[2,1]= 100
collegamento[2,2]= 0
collegamento[3,1]= 75
collegamento[3,2]= 100
collegamento[4,1]= 0
collegamento[4,2]= 100
collegamento[5,1]=	25
collegamento[5,2]=	0

PUBLIC input_esterno[5,2]
input_esterno[1,1]= 0
input_esterno[1,2]= 0
input_esterno[2,1]= 100
input_esterno[2,2]= 0
input_esterno[3,1]= 75
input_esterno[3,2]= 100
input_esterno[4,1]= 25
input_esterno[4,2]= 100
input_esterno[5,1]=	0
input_esterno[5,2]=	0


PUBLIC pub_descrizione_nodo,PUB_CALLING_OBJECT
PUBLIC PUB_TOP,PUB_LEFT,PUB_X,PUB_Y, PUB_X_OFFSET, PUB_Y_OFFSET, PUB_X_INIZIALE , PUB_Y_INIZIALE , PUB_ALTEZZA_INIZIALE , PUB_LUNGHEZZA_INIZIALE 
PUBLIC PUB_COLLEGAMENTO_INIZIALE_X,PUB_COLLEGAMENTO_INIZIALE_Y, PUB_COLLEGAMENTO_FINALE_X,PUB_COLLEGAMENTO_FINALE_Y, PUB_FLAG_COLLEGAMENTO
PUBLIC PUB_BLOCCO_PRECEDENTE
PUBLIC PUB_ID_PROCEDURA,PUB_DESCRIZIONE_PROCEDURA,PUB_PROC_CODCLI,PUB_PROC_RAGSOC
PUBLIC PUB_CODATTIV,PUB_DESATTIV

*** DISTINGUO SE SONO IN INSERIMENTO O MODIFICA O ESECUZIONE
PUBLIC PUB_FLOW_INSERIMENTO,PUB_FLOW_MODIFICA,PUB_FLOW_ESECUZIONE,PUB_FLOW_RICERCA,PUB_FLOW_ANNULLO

PUBLIC PUB_FLAG_LOOP

**************************************
PUB_FLOW_INSERIMENTO	=.F.
PUB_FLOW_MODIFICA		=.F.
PUB_FLOW_ESECUZIONE		=.F.
PUB_FLOW_RICERCA		=.F.
PUB_FLOW_ANNULLO		=.F.
**************************************

PUB_DESCRIZIONE_NODO		=""

PUB_CALLING_OBJECT			=""
PUB_TOP						=20
PUB_LEFT					=20
PUB_X_OFFSET 				=0
PUB_Y_OFFSET 				=0
PUB_X						=0
PUB_Y						=0
PUB_X_INIZIALE             	=0 
PUB_Y_INIZIALE             	=0
PUB_ALTEZZA_INIZIALE       	=0
PUB_LUNGHEZZA_INIZIALE     	=0
PUB_COLLEGAMENTO_INIZIALE_X	=0
PUB_COLLEGAMENTO_INIZIALE_Y	=0
PUB_COLLEGAMENTO_FINALE_X  	=0
PUB_COLLEGAMENTO_FINALE_Y  	=0
PUB_FLAG_COLLEGAMENTO		=.F.

PUB_BLOCCO_PRECEDENTE  =""

PUB_ID_PROCEDURA =""
PUB_DESCRIZIONE_PROCEDURA = ""
PUB_PROC_CODCLI = ""
PUB_PROC_RAGSOC = ""
PUB_CODATTIV    = ""
PUB_DESATTIV    = ""

PUB_FLAG_LOOP	=.F.

* PROCEDURE FLW_DEFVAR
**********************************************************

**********************************************************
PROCEDURE FLW_RELEASE_VAR
**********************************************************
RELEASE pub_descrizione_nodo,PUB_CALLING_OBJECT
RELEASE PUB_TOP,PUB_LEFT,PUB_X,PUB_Y, PUB_X_OFFSET, PUB_Y_OFFSET, PUB_X_INIZIALE , PUB_Y_INIZIALE , PUB_ALTEZZA_INIZIALE , PUB_LUNGHEZZA_INIZIALE 
RELEASE PUB_COLLEGAMENTO_INIZIALE_X,PUB_COLLEGAMENTO_INIZIALE_Y, PUB_COLLEGAMENTO_FINALE_X,PUB_COLLEGAMENTO_FINALE_Y, PUB_FLAG_COLLEGAMENTO
RELEASE PUB_BLOCCO_PRECEDENTE
RELEASE PUB_ID_PROCEDURA,PUB_DESCRIZIONE_PROCEDURA,PUB_PROC_CODCLI,PUB_PROC_RAGSOC
RELEASE PUB_CODATTIV,PUB_DESATTIV

RELEASE	PUB_FLOW_INSERIMENTO,PUB_FLOW_MODIFICA,PUB_FLOW_ESECUZIONE,PUB_FLOW_RICERCA,PUB_FLOW_ANNULLO

RELEASE PUB_FLAG_LOOP

* PROCEDURE FLW_RELEASE_VAR
**********************************************************



**********************************************************
PROCEDURE FLW_CREA_CURSORI
**********************************************************
CREATE CURSOR BLOCCHI (;
	NOME C(20) ,;
	TIPO C(20) ,;
	TOP N(5,0),;
	LEFT N(5,0),;
	HEIGHT N(5,0),;
	WIDTH N(5,0),;
	TESTO M,;
	COLORE N(10,0),;
	PREC C(20),;
	SUCC C(20),;
	SELEZIONE C(1),;
	ESECUZIONE C(1) )
	

SELECT BLOCCHI	
INDEX ON NOME TAG NOME 
INDEX ON SUCC TAG SUCC 
INDEX ON PREC TAG PREC 
INDEX ON SELEZIONE TAG SELEZIONE 
INDEX ON ESECUZIONE TAG ESECUZIONE 


CREATE CURSOR LINEE (;
	NOME C(20) ,;
	TOP N(5,0),;
	LEFT N(5,0),;
	HEIGHT N(5,0),;
	WIDTH N(5,0),;
	SLANT C(1),;
	BLOCCODA C(20),;
	BLOCCOA C(20) )

SELECT LINEE	
INDEX ON NOME TAG NOME 
INDEX ON BLOCCODA TAG BLOCCODA 
INDEX ON BLOCCOA TAG BLOCCOA 


CREATE CURSOR STEPS (;
	ID_PROCEDURA C(20) ,;
	ID_BLOCCO C(20) ,;
	ID_STEP C(20) ,;
	USERID C(30),;
	FLG_ESEGUITO L,;
	DATA_INIZIO C(10),;
	ORA_INIZIO C(8),;
	DATA_FINE C(10),;
	ORA_FINE C(8))

SELECT STEPS	
INDEX ON ID_BLOCCO TAG ID_BLOCCO 
INDEX ON DATA_INIZIO+ORA_INIZIO TAG INIZIO 
INDEX ON DATA_FINE+ORA_FINE TAG FINE 



CREATE CURSOR DECO (;
	ID_PROCEDURA C(20) ,;
	ID_BLOCCO C(20) ,;
	ID_DECO C(20) ,;
	DESCRIZIONE C(30),;
	COMANDO C(50))

SELECT DECO 	
INDEX ON ID_DECO TAG ID_DECO 
INDEX ON ID_BLOCCO+ID_DECO TAG ID_BLOCCO

* FLW_CREA_CURSORI
**********************************************************


**********************************************************
PROCEDURE FLW_AGGIUNGI_BLOCCO
**********************************************************
LPARAMETERS	_OBJ_BLOCCO

LOCAL _BLOCCO_PRECEDENTE,_NR_BLOCCO,_OBJ_BLOCCO_PRECEDENTE,_MACRO,_OBJ_FORM

_BLOCCO_PRECEDENTE=FLW_GET_NOME_BLOCCO_SELEZIONATO()

SELECT BLOCCHI
SET ORDER TO NOME

APPEND BLANK

WITH _OBJ_BLOCCO

	REPLACE NOME WITH .Name ,;
	 TIPO WITH .TipoBlocco,;
	 TOP  WITH .Top,;
	 LEFT WITH .Left,;
	 HEIGHT WITH .Height,;
	 WIDTH WITH  .Width,;
	 COLORE WITH .Shape.BackColor,;
	 PREC WITH _BLOCCO_PRECEDENTE,;
	 SUCC WITH ""

 
	IF !EMPTY(_BLOCCO_PRECEDENTE)
		_MACRO="_OBJ_BLOCCO_PRECEDENTE =_OBJ_BLOCCO.Parent."+_BLOCCO_PRECEDENTE
		&_MACRO
		
		_NR_BLOCCO = _OBJ_BLOCCO_PRECEDENTE.GET_NUMERO_BLOCCO()+1
	
		_OBJ_BLOCCO.set_numero_blocco(_NR_BLOCCO)
		
		SELECT BLOCCHI 
		SET ORDER TO NOME
		SEEK _BLOCCO_PRECEDENTE
		
		REPLACE SUCC WITH .Name
		
	ENDIF	
	
	_MACRO="_OBJ_FORM =_OBJ_BLOCCO.Parent"
	&_MACRO
	
	IF _OBJ_FORM.ViewPortTop+_OBJ_BLOCCO.Top+_OBJ_BLOCCO.Height - _OBJ_FORM.Height >=0
		_OBJ_FORM.SetViewPort(_OBJ_FORM.ViewPortLeft,_OBJ_FORM.ViewPortTop+_OBJ_BLOCCO.Top+_OBJ_BLOCCO.Height+40)
		*F* _OBJ_FORM.Refresh
	ENDIF

	
ENDWITH

* PROCEDURE FLW_AGGIUNGI_BLOCCO
**********************************************************



**********************************************************
PROCEDURE FLW_AGGIORNA_BLOCCO
**********************************************************
LPARAMETERS	_OBJ_BLOCCO

LOCAL _MACRO,_OBJ_FORM

SELECT BLOCCHI
SET ORDER TO NOME

SEEK _OBJ_BLOCCO.Name

WITH _OBJ_BLOCCO

	REPLACE NOME WITH .Name ,;
	 TIPO WITH .TipoBlocco,;
	 TOP  WITH .Top,;
	 LEFT WITH .Left,;
	 HEIGHT WITH .Height,;
	 WIDTH WITH  .Width,;
	 COLORE WITH .Shape.BackColor

ENDWITH

* PROCEDURE FLW_AGGIORNA_BLOCCO
**********************************************************


**********************************************************
PROCEDURE FLW_AGGIUNGI_LINEA
**********************************************************
LPARAMETERS	_OBJ_FORM,_OBJ_BLOCCO

LOCAL _LEFT,_TOP,_WIDTH,_HEIGHT,_OBJ_BLOCCO_PRECEDENTE,_MACRO,_NOME_LINEA

IF ISNULL(_OBJ_BLOCCO) OR ISNULL(_OBJ_BLOCCO.BloccoPrecedente) OR EMPTY(_OBJ_BLOCCO.BloccoPrecedente)
	RETURN
ENDIF

_MACRO="_OBJ_BLOCCO_PRECEDENTE =_OBJ_FORM."+_OBJ_BLOCCO.BloccoPrecedente
&_MACRO

_LEFT = INT(_OBJ_BLOCCO_PRECEDENTE.Left+ _OBJ_BLOCCO_PRECEDENTE.Width/2)
_TOP  = INT(_OBJ_BLOCCO_PRECEDENTE.Top + _OBJ_BLOCCO_PRECEDENTE.Height/2)

_WIDTH = INT(_OBJ_BLOCCO.Left + _OBJ_BLOCCO.Width/2) -_LEFT
_HEIGHT = INT(_OBJ_BLOCCO.Top + _OBJ_BLOCCO.Height/2)-_TOP

_nome_linea="linea_"+SYS(2015)
_OBJ_FORM.AddObject(_nome_linea,"Line")
_macro="objLinea =_OBJ_FORM."+_nome_linea
&_macro


WITH objLinea 			
	.ZOrder(1)
	.left =_LEFT 
	.top  =_TOP 
	.Visible=.t.
	.width=ABS(_WIDTH )
	.height=ABS(_HEIGHT )

	DO CASE 	
		CASE _WIDTH < 0 AND _HEIGHT >0
			.LineSlant="/"
			.left = .left -.width
		CASE _WIDTH > 0 AND _HEIGHT <0
			.LineSlant="/"
			.top = .top -.height
		CASE _width > 0 AND _height >0
			.LineSlant="\"
	ENDCASE
	
	SELECT LINEE
	SET ORDER TO NOME
	APPEND BLANK
	
	REPLACE ;
		NOME 		WITH .Name ,;
	 	TOP  		WITH .Top,;
	 	LEFT 		WITH .Left,;
	 	HEIGHT 		WITH .Height,;
	 	WIDTH 		WITH .Width,;
	 	BLOCCODA 	WITH _OBJ_BLOCCO.BloccoPrecedente,;
		BLOCCOA 	WITH _OBJ_BLOCCO.Name,;
	 	SLANT 		WITH .LineSlant
	 	
	
ENDWITH 


* PROCEDURE FLW_AGGIUNGI_LINEA
**********************************************************




**********************************************************
PROCEDURE FLW_AGGIUNGI_LINEA_LOOP
**********************************************************
LPARAMETERS	_OBJ_FORM,_OBJ_BLOCCO

LOCAL _LEFT,_TOP,_WIDTH,_HEIGHT,_OBJ_BLOCCO_PRECEDENTE,_MACRO,_NOME_LINEA

SET STEP ON 

IF ISNULL(_OBJ_BLOCCO) OR ISNULL(_OBJ_BLOCCO.BloccoPrecedente) OR EMPTY(_OBJ_BLOCCO.BloccoPrecedente)
	RETURN
ENDIF

_MACRO="_OBJ_BLOCCO_PRECEDENTE =_OBJ_FORM."+_OBJ_BLOCCO.BloccoPrecedente
&_MACRO

_LEFT = INT(_OBJ_BLOCCO_PRECEDENTE.Left+ _OBJ_BLOCCO_PRECEDENTE.Width/2)
_TOP  = INT(_OBJ_BLOCCO_PRECEDENTE.Top + _OBJ_BLOCCO_PRECEDENTE.Height/2)

_WIDTH = INT(_OBJ_BLOCCO.Left + _OBJ_BLOCCO.Width/2) -_LEFT
_HEIGHT = INT(_OBJ_BLOCCO.Top + _OBJ_BLOCCO.Height/2)-_TOP

_nome_linea="linea_"+SYS(2015)
_OBJ_FORM.AddObject(_nome_linea,"Line")
_macro="objLinea =_OBJ_FORM."+_nome_linea
&_macro


WITH objLinea 			
	.ZOrder(1)
	.left =_LEFT 
	.top  =_TOP 
	.Visible=.t.
	.width=ABS(_WIDTH )
	.height=ABS(_HEIGHT )

	DO CASE 	
		CASE _WIDTH < 0 AND _HEIGHT >0
			.LineSlant="/"
			.left = .left -.width
		CASE _WIDTH > 0 AND _HEIGHT <0
			.LineSlant="/"
			.top = .top -.height
		CASE _width > 0 AND _height >0
			.LineSlant="\"
	ENDCASE
	
	SELECT LINEE
	SET ORDER TO NOME
	APPEND BLANK
	
	REPLACE ;
		NOME 		WITH .Name ,;
	 	TOP  		WITH .Top,;
	 	LEFT 		WITH .Left,;
	 	HEIGHT 		WITH .Height,;
	 	WIDTH 		WITH .Width,;
	 	BLOCCODA 	WITH _OBJ_BLOCCO.BloccoPrecedente,;
		BLOCCOA 	WITH _OBJ_BLOCCO.Name,;
	 	SLANT 		WITH .LineSlant
	 	
	
ENDWITH 


* PROCEDURE FLW_AGGIUNGI_LINEA
**********************************************************


**********************************************************
PROCEDURE FLW_GET_NOME_BLOCCO_SELEZIONATO
**********************************************************

LOCAL _NOME_BLOCCO_PRECEDENTEMENTE_SELEZIONATO

_NOME_BLOCCO_PRECEDENTEMENTE_SELEZIONATO=""

SELECT BLOCCHI 
SET ORDER TO SELEZIONE
SEEK "S"

IF FOUND()
	_NOME_BLOCCO_PRECEDENTEMENTE_SELEZIONATO=NOME
ENDIF

RETURN _NOME_BLOCCO_PRECEDENTEMENTE_SELEZIONATO

* PROCEDURE FLW_GET_NOME_BLOCCO_SELEZIONATO
**********************************************************

**********************************************************
PROCEDURE FLW_GET_NUMERO_BLOCCHI
**********************************************************
LOCAL _SWWS, _NUMERO_BLOCCHI

_SWWS=SELECT()

_NUMERO_BLOCCHI=0

SELECT BLOCCHI
GO TOP 
DO WHILE !EOF()

	IF DELETED()
		SELECT BLOCCHI
		SKIP +1
		LOOP
	ENDIF
	
	_NUMERO_BLOCCHI=_NUMERO_BLOCCHI+1
	
	SELECT BLOCCHI
	SKIP +1
ENDDO

SELECT(_SWWS)

RETURN _NUMERO_BLOCCHI
* PROCEDURE FLW_GET_NUMERO_BLOCCHI
**********************************************************



**********************************************************
PROCEDURE FLW_SPOSTA_LINEA_TRA_DUE_PUNTI
**********************************************************
LPARAMETERS _OBJ_LINEA, _X0, _Y0, _X1, _Y1

LOCAL _LEFT,_TOP,_WIDTH,_HEIGHT 


IF _X0 <= _X1
	_LEFT=_X0
ELSE
	_LEFT=_X1
ENDIF

IF _Y0 <= _Y1
	_TOP=_Y0
ELSE
	_TOP=_Y1
ENDIF

IF ((_X0 <= _X1 AND _Y0 <= _Y1) OR (_X0 > _X1 AND _Y0 > _Y1))
	_OBJ_LINEA.LineSlant="\"
ELSE
	_OBJ_LINEA.LineSlant="/"
ENDIF

_WIDTH  = ABS(_X0 - _X1)
_HEIGHT = ABS(_Y0 - _Y1)


_OBJ_LINEA.Move( _LEFT,_TOP,_WIDTH,_HEIGHT )

RETURN 
* PROCEDURE FLW_SPOSTA_LINEA_TRA_DUE_PUNTI
**********************************************************



**********************************************************
PROCEDURE FLW_SPOSTA_LINEA_TRA_DUE_BLOCCHI
**********************************************************
LPARAMETERS _OBJ_LINEA, _BLOCCODA , _BLOCCOA 

LOCAL _SWWS ,  _OBJ_LINEA, _X0, _Y0, _X1, _Y1

_SWWS=SELECT()

SELECT BLOCCHI
SET ORDER TO NOME
SEEK _BLOCCODA

IF !FOUND() 
	SELECT(_SWWS)
	RETURN 
ENDIF

IF DELETED()
	SELECT(_SWWS)
	RETURN 
ENDIF

_X0 = LEFT + INT(WIDTH /2)
_Y0 = TOP + INT(HEIGHT /2)

SELECT BLOCCHI
SET ORDER TO NOME
SEEK _BLOCCOA

IF !FOUND() 
	SELECT(_SWWS)
	RETURN 
ENDIF

IF DELETED()
	SELECT(_SWWS)
	RETURN 
ENDIF

_X1 = LEFT + INT(WIDTH /2)
_Y1 = TOP + INT(HEIGHT /2)

FLW_SPOSTA_LINEA_TRA_DUE_PUNTI( _OBJ_LINEA, _X0, _Y0, _X1, _Y1)

SELECT(_SWWS)

RETURN
* PROCEDURE FLW_SPOSTA_LINEA_TRA_DUE_BLOCCHI
**********************************************************


**********************************************************
PROCEDURE FLW_GET_ULTIMO_BLOCCO
**********************************************************
LPARAMETER _OBJ_FORM

LOCAL _SWWS,_ULTIMO_BLOCCO,_CONTA_BLOCCHI

_SWWS=SELECT()

_ULTIMO_BLOCCO=""

_CONTA_BLOCCHI=0

SELECT BLOCCHI
SET ORDER TO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SELECT BLOCCHI
		SKIP
		LOOP
	ENDIF
	
	
	_CONTA_BLOCCHI = _CONTA_BLOCCHI+1

	_ULTIMO_BLOCCO=NOME
	
	SKIP +1
ENDDO

SELECT(_SWWS)

RETURN _ULTIMO_BLOCCO

* PROCEDURE FLW_GET_ULTIMO_BLOCCO
**********************************************************

**********************************************************
PROCEDURE FLW_SELEZIONA_PRIMO_BLOCCO
**********************************************************
LPARAMETER _OBJ_FORM

LOCAL _SWWS,_MACRO

_SWWS=SELECT()

_PRIMO_BLOCCO=""

SELECT BLOCCHI
SET ORDER TO
GO TOP

_PRIMO_BLOCCO=NOME

_MACRO="_OBJ_BLOCCO =_OBJ_FORM."+_PRIMO_BLOCCO
&_MACRO

_OBJ_BLOCCO.SETFOCUS()
_OBJ_BLOCCO.SELEZIONA()	

SELECT(_SWWS)

* PROCEDURE FLW_SELEZIONA_PRIMO_BLOCCO
**********************************************************


**********************************************************
PROCEDURE FLW_GET_ULTIMO_BLOCCO_ESEGUITO
**********************************************************
LOCAL _SWWS,_ULTIMO_BLOCCO_ESEGUITO

_SWWS=SELECT()

_ULTIMO_BLOCCO_ESEGUITO=""

SELECT BLOCCHI
SET ORDER TO ESECUZIONE
SEEK "S"
IF FOUND()
	IF !DELETED()
		_ULTIMO_BLOCCO_ESEGUITO = NOME
	ENDIF
ENDIF

IF EMPTY(_ULTIMO_BLOCCO_ESEGUITO)
	MESSAGEBOX("Nessun blocco eseguito",48,"Attenzione")
ENDIF

RETURN _ULTIMO_BLOCCO_ESEGUITO

* PROCEDURE FLW_GET_ULTIMO_ESEGUITO
**********************************************************


**********************************************************
PROCEDURE FLW_GET_NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE
**********************************************************
LOCAL _SWWS,_NOME_ULTIMO_BLOCCO_ESEGUITO,_NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE

_SWWS=SELECT()

_NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE=""

_NOME_ULTIMO_BLOCCO_ESEGUITO=FLW_GET_ULTIMO_BLOCCO_ESEGUITO()

IF EMPTY(_NOME_ULTIMO_BLOCCO_ESEGUITO)
	MESSAGEBOX("Nessun blocco eseguito",48,"Attenzione")
	SELECT(_SWWS)
	RETURN ""
ENDIF

SELECT BLOCCHI
SET ORDER TO NOME
SEEK _NOME_ULTIMO_BLOCCO_ESEGUITO
_NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE=SUCC

IF EMPTY(_NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE)
	MESSAGEBOX("Non ci sono blocchi successivi in questo ramo del diagramma",48,"Attenzione")
ENDIF

SELECT(_SWWS)
RETURN _NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE

* PROCEDURE FLW_GET_NOME_PROSSIMO_BLOCCO_DA_ESEGUIRE
**********************************************************


**********************************************************
PROCEDURE FLW_REFRESH_NUMERI_BLOCCO
**********************************************************
LPARAMETER _OBJ_FORM

LOCAL _SWWS,_MACRO,_OBJ_BLOCCO,_CONTA_BLOCCHI

_SWWS=SELECT()

_CONTA_BLOCCHI=0

SELECT BLOCCHI
SET ORDER TO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SELECT BLOCCHI
		SKIP
		LOOP
	ENDIF
	
	_CONTA_BLOCCHI = _CONTA_BLOCCHI+1

	_MACRO="_OBJ_BLOCCO =_OBJ_FORM."+NOME
	&_MACRO
	
	_OBJ_BLOCCO.Set_numero_blocco(_CONTA_BLOCCHI)
	
	SKIP +1
ENDDO

SELECT(_SWWS)

* PROCEDURE FLW_REFRESH_NUMERI_BLOCCO
**********************************************************



**********************************************************
PROCEDURE FLW_REFRESH_BLOCCHI_ESEGUITI
**********************************************************
LPARAMETER _OBJ_FORM

LOCAL _SWWS,_MACRO,_OBJ_BLOCCO

_SWWS=SELECT()

_CONTA_BLOCCHI=0

SELECT STEPS
SET ORDER TO INIZIO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SELECT STEPS
		SKIP
		LOOP
	ENDIF
	
	IF EMPTY(DATA_INIZIO)
		EXIT
	ENDIF
	
	_MACRO="_OBJ_BLOCCO =_OBJ_FORM."+ID_BLOCCO
	&_MACRO
	
	IF EMPTY(DATA_FINE)	&& BLOCCO IN ESECUZIONE
		_OBJ_BLOCCO.Shape.BorderColor=RGB(0,255,255)
		_OBJ_BLOCCO.Shape.BorderWidth = 10
		_OBJ_BLOCCO.Shape.FillColor=RGB(255,255,255)
		_OBJ_BLOCCO.Shape.FillStyle=4		
		
	ELSE	&& BLOCCO GIA' ELABORATO MA NON ATTUALMENTE IN ESECUZIONE
		_OBJ_BLOCCO.Shape.BorderColor=RGB(0,0,0)
		_OBJ_BLOCCO.Shape.BorderWidth=2
		_OBJ_BLOCCO.Shape.FillColor=RGB(0,0,0)
		_OBJ_BLOCCO.Shape.FillStyle=4
		
	ENDIF
	
	SELECT STEPS
	SKIP +1
ENDDO

SELECT(_SWWS)

* PROCEDURE FLW_REFRESH_BLOCCHI_ESEGUITI
**********************************************************


**********************************************************
PROCEDURE FLW_METTE_FINE_A_ESECUZIONE_BLOCCO_PRECEDENTE
**********************************************************
LOCAL _SWWS,_NOME_ULTIMO_BLOCCO_ESEGUITO

_SWWS=SELECT()

_NOME_ULTIMO_BLOCCO_ESEGUITO=FLW_GET_ULTIMO_BLOCCO_ESEGUITO()

*** CERCO IL BLOCCO PRECEDENTEMENTE IN ESECUZIONE
*** E' UN BLOCCO CON DATA_INIZIO/ORA_INIZIO MA SENZA DATA_FINE/ORA_FINE
SELECT STEPS 
SET ORDER TO ID_BLOCCO
GO TOP
SEEK _NOME_ULTIMO_BLOCCO_ESEGUITO

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF
	
	IF ID_BLOCCO!=_NOME_ULTIMO_BLOCCO_ESEGUITO
		EXIT
	ENDIF
	
	*** SE NON HA DATA_FINE E ORA_FINE 
	*** E' IL BLOCCO CHE STAVO ESEGUENDO
	IF EMPTY(DATA_FINE) AND EMPTY(ORA_FINE)
		REPLACE DATA_FINE WITH RIBALTA2(DTOC(DATE()))
		REPLACE ORA_FINE WITH TIME()
		EXIT
	ELSE
		SKIP
		LOOP
	ENDIF

	SELECT STEPS 
	SKIP	
ENDDO

SELECT(_SWWS)

* PROCEDURE FLW_METTE_FINE_A_ESECUZIONE_BLOCCO_PRECEDENTE
**********************************************************


**********************************************************
PROCEDURE FLW_HO_RAGGIUNTO_UN_BLOCCO_FINALE
**********************************************************
LPARAMETERS _NOME_BLOCCO

LOCAL _SWWS
_SWWS=SELECT()

*** AGGIORNO I PASSI DI ESECUZIONE
*** INSERENDO L'INIZIO DELLL'ESECUZIONE DI QUESTO BLOCCO
***
SELECT STEPS
SET ORDER TO ID_BLOCCO
SEEK _NOME_BLOCCO
IF !FOUND()
	APPEND BLANK
	REPLACE ;
		ID_PROCEDURA 	WITH PUB_ID_PROCEDURA,;
		ID_BLOCCO 		WITH _NOME_BLOCCO ,;
		ID_STEP 		WITH SYS(2015),;
		USERID			WITH PUB_CODOPE,;
		FLG_ESEGUITO	WITH .T.,;
		DATA_INIZIO		WITH RIBALTA2(DTOC(DATE())),;
		ORA_INIZIO		WITH TIME(),;
		DATA_FINE		WITH RIBALTA2(DTOC(DATE())),;
		ORA_FINE		WITH TIME()
ENDIF
			
DO FLW_SALVA_STEPS

SELECT(_SWWS)

* PROCEDURE FLW_HO_RAGGIUNTO_UN_BLOCCO_FINALE
**********************************************************



**********************************************************
PROCEDURE FLW_SALVA_BLOCCHI
**********************************************************
LOCAL _CONTA_BLOCCHI,_SWWS

_SWWS=SELECT()

*** PROCEDURE
**********************************************************

cSql="DELETE FROM FLOW_PROCEDURE WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"___DEL_FLOW_PROCEDURE")
   return(.f.)
ENDIF

cSql="SELECT * FROM FLOW_PROCEDURE WHERE 1=0"
IF !ExecRW(cSql,"FLOW_PROCEDURE","R")
	return(.f.)
ENDIF

SELECT FLOW_PROCEDURE
APPEND BLANK
REPLACE ID_PROCEDURA WITH PUB_ID_PROCEDURA
REPLACE DESCRIZIONE WITH PUB_DESCRIZIONE_PROCEDURA
REPLACE CODCLI WITH PUB_PROC_CODCLI
REPLACE DATA_ULTAGG WITH RIBALTA2(DTOC(DATE()))
REPLACE ORA_ULTAGG  WITH TIME()

	
IF !ExecRW(cSql,"FLOW_PROCEDURE","W")
   return(.f.)
ENDIF


*** BLOCCHI
**********************************************************

cSql="DELETE FROM FLOW_BLOCCHI WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"___DEL_FLOW_BLOCCHI")
   return(.f.)
ENDIF

cSql="SELECT * FROM FLOW_BLOCCHI WHERE 1=0"
IF !ExecRW(cSql,"FLOW_BLOCCHI","R")
	return(.f.)
ENDIF

SELECT BLOCCHI
SET ORDER TO
GO TOP

_CONTA_BLOCCHI=0

DO WHILE !EOF()

	IF DELETED()
		SELECT BLOCCHI
		SKIP
		LOOP
	ENDIF

	_CONTA_BLOCCHI = _CONTA_BLOCCHI+1
	
	SELECT BLOCCHI
	SCATTER MEMVAR MEMO

	SELECT FLOW_BLOCCHI
	APPEND BLANK
	
	GATHER MEMVAR MEMO
	REPLACE ID_PROCEDURA WITH PUB_ID_PROCEDURA
	REPLACE TOPPOS  WITH M.TOP
	REPLACE LEFTPOS WITH M.LEFT
	REPLACE TESTO   WITH M.TESTO
	REPLACE COLORE  WITH M.COLORE
	REPLACE NR_BLOCCO WITH _CONTA_BLOCCHI
	
	SELECT BLOCCHI
	SKIP
ENDDO

IF !ExecRW(cSql,"FLOW_BLOCCHI","W")
   return(.f.)
ENDIF


*** LINEE
**********************************************************

cSql="DELETE FROM FLOW_LINEE WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"___DEL_FLOW_LINEE")
   return(.f.)
ENDIF

cSql="SELECT * FROM FLOW_LINEE WHERE 1=0"
IF !ExecRW(cSql,"FLOW_LINEE","R")
	return(.f.)
ENDIF

SELECT LINEE
SET ORDER TO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SELECT LINEE
		SKIP
		LOOP
	ENDIF

	SELECT LINEE
	SCATTER MEMVAR MEMO

	SELECT FLOW_LINEE 
	APPEND BLANK
	
	GATHER MEMVAR MEMO
	REPLACE ID_PROCEDURA WITH PUB_ID_PROCEDURA
	REPLACE TOPPOS  WITH M.TOP
	REPLACE LEFTPOS WITH M.LEFT

	
	SELECT LINEE
	SKIP
ENDDO

IF !ExecRW(cSql,"FLOW_LINEE","W")
   return(.f.)
ENDIF


**DO FLW_SALVA_STEPS

	
SELECT(_SWWS)

MESSAGEBOX("Salvataggio effettuato correttamente","Operazione terminata",64)

RETURN

* PROCEDURE FLW_SALVA_BLOCCHI
**********************************************************




**********************************************************
PROCEDURE FLW_SALVA_STEPS
**********************************************************
LOCAL _SWWS,_PROCEDURA_TERMINATA,_TROVATO_ULTIMO_BLOCCO_ESEGUITO

_SWWS=SELECT()

*** STEPS
**********************************************************
cSql="SELECT * FROM FLOW_STEPS WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"___CUR_FLOW_STEPS")
	return(.f.)
ENDIF


SELECT ___CUR_FLOW_STEPS
GO TOP
IF EOF()
	_PROCEDURA_TERMINATA=.F.

ELSE
	_PROCEDURA_TERMINATA=.T.
	
	_TROVATO_ULTIMO_BLOCCO_ESEGUITO=.F.

	DO WHILE !EOF()

		IF DELETED()
			SELECT ___CUR_FLOW_STEPS
			SKIP
			LOOP	
		ENDIF
		
		IF EMPTY(DATA_INIZIO) OR EMPTY(DATA_FINE)
			_PROCEDURA_TERMINATA=.F.
			EXIT
		ENDIF
		
		IF FLG_ESEGUITO
			_TROVATO_ULTIMO_BLOCCO_ESEGUITO=.T.
		ENDIF

		SELECT ___CUR_FLOW_STEPS
		SKIP
	ENDDO

ENDIF

IF _PROCEDURA_TERMINATA
	IF _TROVATO_ULTIMO_BLOCCO_ESEGUITO
		SELECT(_SWWS)
		RETURN
	ENDIF
ENDIF

cSql="DELETE FROM FLOW_STEPS WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"___DEL_FLOW_STEPS")
   return(.f.)
ENDIF

cSql="SELECT * FROM FLOW_STEPS WHERE 1=0"
IF !ExecRW(cSql,"FLOW_STEPS","R")
	return(.f.)
ENDIF

SELECT STEPS
SET ORDER TO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SELECT STEPS
		SKIP
		LOOP
	ENDIF

	SELECT STEPS
	SCATTER MEMVAR MEMO

	SELECT FLOW_STEPS
	APPEND BLANK
	
	GATHER MEMVAR MEMO
	REPLACE ID_PROCEDURA WITH PUB_ID_PROCEDURA
	
	SELECT STEPS
	SKIP
ENDDO

IF !ExecRW(cSql,"FLOW_STEPS","W")
   return(.f.)
ENDIF

	
SELECT(_SWWS)

RETURN

* PROCEDURE FLW_SALVA_STEPS
**********************************************************


**********************************************************
PROCEDURE FLW_DELETE_PROCEDURA
**********************************************************
_SWWS=SELECT()


*** CONTROLLO SE CI SONO DEGLI STEPS
**********************************************************
cSql="SELECT * FROM FLOW_STEPS WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"CFLOW_STEPS")
   return(.f.)
ENDIF

SELECT CFLOW_STEPS
GO TOP
IF !EOF()
	=MESSAGEBOX("Ci sono dei passaggi operativi già eseguiti. Non è consentita la cancellazione della procedura.",48,"Attenzione")
	RETURN
ENDIF

*** PROCEDURE
**********************************************************
cSql="DELETE FROM FLOW_PROCEDURE WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"CFLOW_PROCEDURE")
   return(.f.)
ENDIF


*** BLOCCHI
**********************************************************
cSql="DELETE FROM FLOW_BLOCCHI WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"CFLOW_BLOCCHI")
   return(.f.)
ENDIF


*** LINEE
**********************************************************
cSql="DELETE FROM FLOW_LINEE WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"CFLOW_LINEE")
   return(.f.)
ENDIF


* *** STEPS
* **********************************************************
* cSql="DELETE FROM FLOW_STEPS WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
* IF !ExecCommand(cSql,"CFLOW_STEPS")
*    return(.f.)
* ENDIF


SELECT(_SWWS)
RETURN

* PROCEDURE FLW_DELETE_PROCEDURA
**********************************************************


**********************************************************
PROCEDURE FLW_CARICA_CURSORI_DA_DB
**********************************************************
LOCAL _SWWS

_SWWS=SELECT()

*** BLOCCHI
cSql="SELECT * FROM FLOW_BLOCCHI WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"' ORDER BY NR_BLOCCO "
IF !ExecCommand(cSql,"CFLOW_BLOCCHI")
	return(.f.)
ENDIF
SELECT CFLOW_BLOCCHI
GO TOP


*** LINEE
cSql="SELECT * FROM FLOW_LINEE WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"'"
IF !ExecCommand(cSql,"CFLOW_LINEE")
	return(.f.)
ENDIF
SELECT CFLOW_LINEE
GO TOP

DO FLW_CARICA_CURSORE_STEPS_DA_DB

RETURN

* PROCEDURE FLW_CARICA_CURSORI_DA_DB
**********************************************************

**********************************************************
PROCEDURE FLW_CARICA_CURSORE_STEPS_DA_DB
**********************************************************
LOCAL _SWWS

_SWWS=SELECT()

*** STEPS
cSql="SELECT * FROM FLOW_STEPS WHERE ID_PROCEDURA='"+PUB_ID_PROCEDURA+"' AND USERID='"+PUB_CODOPE+"'"
IF !ExecCommand(cSql,"CFLOW_STEPS")
	return(.f.)
ENDIF
SELECT CFLOW_STEPS
GO TOP

SELECT(_SWWS)

RETURN

* PROCEDURE FLW_CARICA_CURSORE_STEPS_DA_DB
**********************************************************


**********************************************************
PROCEDURE FLW_GET_NOME_BLOCCO_DA_ESEGUIRE
**********************************************************
LOCAL _SWWS,_NOME_BLOCCO_DA_ESEGUIRE,_NOME_ULTIMO_BLOCCO_ESEGUITO

_NOME_BLOCCO_DA_ESEGUIRE=""

_SWWS=SELECT()

*** PRIMO CONTROLLO
*** E' NECESSARIO CHE CI SIA ALMENO UN BLOCCO
SELECT BLOCCHI
SET ORDER TO NOME
GO TOP
IF RECCOUNT()=0
	=MESSAGEBOX("E' necessario che sia presente almeno un blocco.",48,"Attenzione")
	SELECT(_SWWS)
	RETURN _NOME_BLOCCO_DA_ESEGUIRE	
ENDIF

*** CASO (1)
*** CERCO UN BLOCCO INIZIATO MA NON FINITO
SELECT STEPS
SET ORDER TO ID_BLOCCO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF
	
	*** SE HO DATA INIZIO 
	*** E NON HO DATA FINE
	*** ALLORA E' UN BLOCCO CHE HO INIZIATO E NON HO FINITO
	*** >>>>>>>>>>>>>>> E' QUELLO CHE VOGLIO
	IF !EMPTY(DATA_INIZIO) AND EMPTY(DATA_FINE)
		_NOME_BLOCCO_DA_ESEGUIRE=ID_BLOCCO
		SELECT(_SWWS)
		RETURN _NOME_BLOCCO_DA_ESEGUIRE
	ENDIF

	SELECT STEPS
	SKIP
ENDDO

*** SE NON TROVO NEANCHE UN CASO (1)
*** CERCO IL CASO (2)

*** CASO (2)
*** ORDINO PER DATA INIZIO
*** VADO IN FONDO E PRENDO IL BLOCCO INIZIATO PIU' DI RECENTE
*** PRENDO QUELLO COME BLOCCO ULTIMO ESEGUITO E SE E' FINITO VADO AL SUCCESSIVO PER INIZIARLO
_NOME_ULTIMO_BLOCCO_ESEGUITO=""

SELECT STEPS
SET ORDER TO INIZIO
GO BOTTOM
IF !EMPTY(DATA_INIZIO)
	_NOME_ULTIMO_BLOCCO_ESEGUITO=ID_BLOCCO
ENDIF 

*** PRENDO IL BLOCCO SUCCESSIVO
IF !EMPTY(_NOME_ULTIMO_BLOCCO_ESEGUITO)
	SELECT BLOCCHI
	SET ORDER TO NOME
	SEEK _NOME_ULTIMO_BLOCCO_ESEGUITO
	IF FOUND() 
		_NOME_BLOCCO_DA_ESEGUIRE=SUCC
	ENDIF 
	
	*** SE NON CI SONO BLOCCHI SUCCESSIVI SONO ARRIVATO AD UN BLOCCO FINALE
	IF EMPTY(_NOME_BLOCCO_DA_ESEGUIRE)
		SELECT(_SWWS)
		RETURN _NOME_BLOCCO_DA_ESEGUIRE
	ENDIF
	
	*** SE C'E' UN BLOCCO SUCCESSIVO
	*** FACCIO UNA CONTROVERIFICA E VEDO SE ESISTE IL BLOCCO SUCCESSIVO
	*** SE NON LO TROVO VUOL DIRE CHE E' UN BLOCCO NON PIU' ESISTENTE 
	*** E NON POSSO PRENDERLO COME BLOCCO DA ESEGUIRE
	SELECT BLOCCHI
	SET ORDER TO NOME
	SEEK _NOME_BLOCCO_DA_ESEGUIRE
	IF !FOUND() 
		_NOME_BLOCCO_DA_ESEGUIRE=""
	ENDIF 	
ENDIF

*** SE NEL PASSO PRECEDENTE SONO RIUSCITO A VALORIZZARE
*** IL NOME DEL BLOCCO DA ESEGUIRE
*** HO FINITO
IF !EMPTY(_NOME_BLOCCO_DA_ESEGUIRE)
	SELECT(_SWWS)
	RETURN _NOME_BLOCCO_DA_ESEGUIRE
ENDIF

*** SE NON TROVO NEANCHE UN CASO(1) E NEANCHE UN CASO (2)
*** PRENDO IL PRIMO BLOCCO DEL FLOW-CHART 
SELECT BLOCCHI
SET ORDER TO NOME
GO TOP
_NOME_BLOCCO_DA_ESEGUIRE=NOME

SELECT(_SWWS)

RETURN _NOME_BLOCCO_DA_ESEGUIRE

* PROCEDURE FLW_GET_NOME_BLOCCO_DA_ESEGUIRE
**********************************************************




**********************************************************
PROCEDURE FLW_CANCELLA_BLOCCO_SU_CURSORI
**********************************************************
LPARAMETERS _NOME_BLOCCO_DA_CANCELLARE,_BLOCCO_PRECEDENTE,_BLOCCO_SUCCESSIVO

LOCAL _SWWS

_SWWS=SELECT()

SELECT BLOCCHI
SET ORDER TO NOME
SEEK _NOME_BLOCCO_DA_CANCELLARE 

_BLOCCO_PRECEDENTE = PREC
_BLOCCO_SUCCESSIVO = SUCC

IF FOUND() AND !DELETED()
	DELETE 
ENDIF

*** ESISTE UN BLOCCO SUCCESSIVO?
*** se esiste un blocco successivo a quello appena cancellato
*** devo fare in modo che il suo blocco precedente diventi il
*** blocco precedente di quello appena cancellato

IF !EMPTY(_BLOCCO_SUCCESSIVO)
	SEEK _BLOCCO_SUCCESSIVO
	REPLACE PREC WITH _BLOCCO_PRECEDENTE
ENDIF

*** ESISTE UN BLOCCO PRECEDENTE?
*** se esiste un blocco PRECEDENTE a quello appena cancellato
*** devo fare in modo che il suo blocco SUCCESSIVO diventi il
*** blocco SUCCESSIVO di quello appena cancellato

IF !EMPTY(_BLOCCO_PRECEDENTE)
	SEEK _BLOCCO_PRECEDENTE
	REPLACE SUCC WITH _BLOCCO_SUCCESSIVO
ENDIF

SELECT(_SWWS)

RETURN 

* PROCEDURE FLW_CANCELLA_BLOCCO_SU_CURSORI
**********************************************************
