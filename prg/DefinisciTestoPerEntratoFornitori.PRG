
**********************************************************
* Definizione Classe TestoPerEntratoFornitori
**********************************************************
DEFINE CLASS TestoPerEntratoFornitori AS TextBox

	SpecialEffect = 1
	
	PROCEDURE GotFocus
		
		This.Parent.ReadOnly = .F.
		This.SelectOnEntry = .T.
		This.SetFocus()
		NODEFAULT
		
	ENDPROC
	
	
	PROCEDURE LostFocus
		
		This.Parent.ReadOnly = .T.
		
	ENDPROC
	
	
	PROCEDURE Valid
		
		THIS.Parent.PARENT.PARENT.ricalcola_risultato()
		THIS.Parent.PARENT.REFRESH

	ENDPROC
	
ENDDEFINE
