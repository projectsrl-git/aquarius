

RIT = MESSAGEBOX("Procedo con l'aggiornamento"+CHR(13)+"del campo IVA (IMPOSTO = NO se non è una fattura) dell'archivio U_CCO_LE ??? ",292,"ATTENZIONE")

IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

   
	x_cond = "leg_codsoc = '" + PUB_CODSOC + "'"
	Csql   = "select * from U_CCO_LE where " + x_cond + " order by leg_codsoc,leg_codtop,leg_codcon,leg_sequen"
	IF !ExecCommand(cSql,"tmp_u_cco_le")
	   return(.f.)
	ENDIF
	
	
	SELECT TMP_U_CCO_LE
    GO TOP   
    DO WHILE .NOT. EOF()
   
		_ID_UNIQUE = id_unique
	    
		v_seek	 = 'TOP'+LEG_CODTOP
		v_chiave ="codice"
		IF seek_std('para',v_seek,v_chiave,'CUR_PARAXX')
		    
		    SELECT CUR_PARAXX
		   
		    IF SUBSTR(LIBERA,2,1) = "S" && NO FATTURA/NOTA CREDITO
		    
		    ELSE
				x_cond = "id_unique = '" + _ID_UNIQUE + "'"
				cSql   = "select * from u_cco_le where " + x_cond + " order by leg_codtop"
				IF !ExecRW(cSql,"U_CCO_LE","R")
				   return(.f.)
				ENDIF


				SELECT U_CCO_LE
				REPLACE LEG_CODIVA WITH "NO"

				IF !ExecRW(cSql,"U_CCO_LE","W")
					return(.f.)
				ENDIF
		    ENDIF


		ENDIF  
   
   		
   		SELECT TMP_U_CCO_LE
   		SKIP +1
   
    ENDDO
   
 


RIT = MESSAGEBOX("Archivio U_CCO_LE  "+CHR(13)+"aggiornato correttamente",16,"ATTENZIONE")