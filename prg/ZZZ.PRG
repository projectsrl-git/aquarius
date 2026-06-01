IF !PUB_CONTOSIMILCEE


ELSE


	X_CONTI  = "01,02,03,99"
	v_seek	 = "DTE_CO"+PUB_CODSOC
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   X_CONTI=ALLTRIM(LIBERA)
	ENDIF
		
	V_PATDAL=STR_EXTRACT(X_CONTI,",",1)
	V_PATAL =STR_EXTRACT(X_CONTI,",",2)
	V_ECODAL=STR_EXTRACT(X_CONTI,",",3)
	V_ECOAL =STR_EXTRACT(X_CONTI,",",4)

	V_POSBIL = ''


	IF BETWEEN(VAL(SUBSTR(M.CON_CONTO,1,(PUB_MASTRO-1))),VAL(V_PATDAL),VAL(V_PATAL))	
	   V_POSBIL = "P"
	ENDIF
	IF BETWEEN(VAL(SUBSTR(M.CON_CONTO,1,(PUB_MASTRO-1))),VAL(V_ECODAL),VAL(V_ECOAL))	
	   V_POSBIL = "E"
	ENDIF


	IF V_POSBIL = "P" OR V_POSBIL = "E"
	ELSE 
		MESSAGEBOX("Posizione bilancio errata :  P = patrimoniale E = economico",16,"Attenzione")
		THISFORMSET.FORM1PDC000.Pageframe1.Page1.txtCon_descr18.SetFocus
		RETURN .F.
	ENDIF

ENDIF
