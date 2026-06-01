*!*	*** FABIANO 05/01/2014
*!*	*** ATTIVA/DISATTIVA IL WINMAIN

*!*	IF TYPE("PUB_NOWINM")!="U" AND PUB_NOWINM
*!*		*** RICREA IL MENU PER L'UTENTE
*!*		DO CREA_WINMAIN
*!*	ELSE
*!*		DO WINMAIN.MPR
*!*	ENDIF
*!*	   	

*!*	*** VISUALIZZA LA LABEL <DESCRIZIONE SOCIETA'> + <OPERATORE> SULLO SFONDO DEL GESTIONALE
*!*	*** E.M. 05/02/2008

*!*	*** RICHIAMA LE FUNZIONCINE DI DISPLAY DELLA SOCIETA'
*!*	DO PRG\SAY_ESERCIZIO      

*!*	IF PUB_MENU_WIN8

*!*		LIVELLO_MENU= 'PRIMO'  
*!*		V_FORM = "DO FORM FORM\AQ_00 WITH LIVELLO_MENU LINKED"
*!*		&V_FORM
*!*		
*!*	ENDIF

**=> ERASMO - INIZIO 06/10/2015
*************************************************
* -->> personalizza il menu in stile win8
*************************************************
PUB_MENU_WIN8_UTENTE = .F.
SxxxS=STR(SELECT())
x_cond = "CODICE = '" + ALLTRIM(PUB_CODOPE) + "'"
Csql   = "select * from res_oper where " + x_cond + " order by CODICE"
IF !ExecCommand(cSql,"Res_Oper_cu_")
   return(.f.)
ENDIF
SELECT Res_Oper_cu_
GO TOP
IF !EOF()
 	M.RES_MENU_WIN8 = RES_MENU_WIN8 	
ELSE
 	M.RES_MENU_WIN8 = .F.	
ENDIF
IF M.RES_MENU_WIN8 
	PUB_MENU_WIN8_UTENTE = .T.					&& L'UTENTE DESIDERA GESTIRE LI MENU IN STILE WIN8 E SUPERIORI
ELSE
	PUB_MENU_WIN8_UTENTE = .F.					&& L'UTENTE DESIGESRA GESTIRE IL MENU TRADIZIONALE
ENDIF
SELECT &SxxxS

**=> ERASMO - INIZIO 21/05/2018
*** SE NON PRODUZIONE CABLAGGI, NASCONDO IL TASTO EPRSONALIZZATO PER L'APERTURE CARTELLA DISEGNI
IF PUB_PRDCABLAGGI
	ZTA.COMMAND7.VISIBLE = .T.
ELSE
	ZTA.COMMAND7.VISIBLE = .F.
ENDIF
**=> ERASMO - FINE 21/05/2018

*!*	IF !PUB_MENU_WIN8_UTENTE 
*!*		PUB_MENU_WIN8_UTENTE  = PUB_MENU_WIN8 		&& SE NON IMPOSTATA NESSUNA OPZIONE A LIVELLO UTENTE GESTISCE L'IMPOSTAZIONE GENERALE AZIENDALE
*!*	ENDIF
IF !PUB_MENU_WIN8
	PUB_MENU_WIN8_UTENTE = .F.  && SE NON ABILITATO A LIVELLO AZIENDALE, NON PERMETTO LA VISUALIZZAZIONE NEANCHE A LIVELLO UTENTE	
	ZTA.COMMAND1.VISIBLE = .F.  && NASCONDO IL TASTO DI MODIFICA COLORI MENU WIN8
ELSE
	ZTA.COMMAND1.VISIBLE = .T.  && VISUALIZZO IL TASTO DI MODIFICA COLORI MENU WIN8
ENDIF

*** RICHIAMA LE FUNZIONCINE DI DISPLAY DELLA SOCIETA'
DO PRG\SAY_ESERCIZIO

IF !PUB_MENU_WIN8_UTENTE 	&& ESCLUSO MENU WIN8 E SUPERIORI : CONTROLLO SUL SINGOLO OPERATORE
	
	** Menu principale
	DO SETMENU
   	
   	*** FABIANO 05/01/2014
   	*** ATTIVA/DISATTIVA IL WINMAIN
   	IF PUB_NOWINM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
		DO CREA_WINMAIN
   	ELSE
   		DO WINMAIN.MPR
   	ENDIF
		   		
	*READ EVENTS
	   
ELSE

	SET SYSMENU TO  && ERASMO - 15/09/2020

    DO CREA_VOCI_MENU_VISIBILI
*!*		LIVELLO_MENU= 'PRIMO'  
*!*		V_FORM = "DO FORM FORM\AQ_00 WITH LIVELLO_MENU LINKED"
*!*		&V_FORM
	DO COMPONI_MENU_SU_SCREEN
ENDIF
**=> ERASMO - FINE 06/10/2015
