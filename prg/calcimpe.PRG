***********************************
FUNCTION CALCIMPE
***********************************
PARAMETERS _ARTICOLO,_FUNZIONE 


** FUNZIONE PER IL RICALCOLO DELLA QUANTITA' IMPEGNATA

** 1) ACCEDO CON L'ARTICOLO AI DETTAGLI DELLE PACKING LIST (U_PCK_DD) E PER OGNI DETTAGLIO :
**
**    VERIFICO SE E' STATA CREATA UNA DDT TRAMITE LA TABELLA DI LEGAME U_BOL_LE :
**
**         PER QUESTO LEGGO CON U_PCK_DD.ORD_CODSYS LA TABELLA U_BOL_LE.LEG_SYSPCK 
**               SE NON TROVO NESSUN RECORD ALLORA E' UN DETTAGLIO BUONO PER CALCOLARE L'IMPEGNATO:
**
**                            ACCEDO ALLA PACKING LIST CON CHIAVE U_PCK_LE.LEG_SYSPCK=U_PCK_DD.ORD_CODSYS
**                            SALVO IN SAVE_PCK_LE U_PCK_LE PER I RIFERIMENTI AL MAGAZZINO 
**                                                                (U_PCK_LE.LEG_SYSMAG=U_MAG_GG.MAG_UNIQUE)
**
**               SE LA TROVO SIGNIFICA CHE LA DDT E' STATA CREATA E L'IMPEGNO E' GIA' STATO SCARICATO
**
** 2) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO A U_MAG_GG(MAG_UNIQUE) TRAMITE LEG_SYSMAG 
**    E AZZERO LA QUANTITA' MAG_QTAIMP = 0 SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**
** 3) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO TRAMITE MAG_SYSMAG AL RECORD DEL MAGAZZINO U_MAG_GG 
**    E SOMMO IN  MAG_QTAIMP , LEG_QUANTITA SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**




** 0) --- 


   cSql   = "select * from u_pck_le where 1=0"
   IF !ExecCommand(Csql,"SAVE_PCK_LE")				&& CONTIENE I RIFERIMENTI PER AGGIORNARE LA QUANTITA' IMPEGNATA
      return(.f.)
   ENDIF


** 1) ----


   x_cond = "ORD_CODART = '" + ALLTRIM(_ARTICOLO) + "'"
   Csql   = "select * from U_PCK_DD where " + x_cond + " order by daggancio"
   IF !ExecCommand(cSql,"K_PCK_DD")
      return(.f.)
   ENDIF

   SELECT K_PCK_DD
   GO TOP
   DO WHILE .NOT. EOF()

        SCATTER MEMVAR MEMO

		*!*	IF M.ORD_CODSYS = '_1FH1509GJ'
		*!*	  SET STEP ON
		*!*	ENDIF

        x_syspck = "leg_syspck = '" + ALLTRIM(M.ORD_CODSYS) + "'"
        cSql   = "select * from u_bol_le where " + x_syspck  + " order by leg_agganc"
        IF !ExecCommand(Csql,"K_BOL_LE")
           return(.f.)
        ENDIF
        SELECT K_BOL_LE
        GO TOP
        IF EOF()	&& IMPEGNO EFFETTIVO DA GESTIRE : NON ESISTE IL LEGAME TRA LA PACKING LIST E U_BOL_LE : LA BOLLA DEVE ESSERE ANCORA CREATA

            
	        x_syspck = "leg_syspck = '" + ALLTRIM(M.ORD_CODSYS) + "'"
	        cSql   = "select * from u_pck_le where " + x_syspck  + " order by leg_agganc"
	        IF !ExecCommand(Csql,"K_PCK_LE")
	           return(.f.)
	        ENDIF
	        
	        SELECT K_PCK_LE
	        GO TOP
	        DO WHILE !EOF()

	            SCATTER MEMVAR MEMO			&& CONTIENE I RIFERIMENTI PER AGGIORNARE LA QUANTITA' IMPEGNATA

	            SELECT SAVE_PCK_LE
	            APPEND BLANK
	            GATHER MEMVAR MEMO

 				SELECT K_PCK_LE
 				SKIP +1
			ENDDO
			            
        ENDIF


  
    	SELECT K_PCK_DD
		SKIP +1


   ENDDO
   




** 2) ----


	SELECT SAVE_PCK_LE
    GO TOP 
    
    DO WHILE .NOT. EOF()
   
       SCATTER MEMVAR MEMO 
       
	   *=> Azzera quantità impegnata sulla giacenza di dettaglio
	   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
	   Csql   = "select * from u_mag_gg where " + x_cond 
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   
	   SELECT U_MAG_GG
	   IF RECCOUNT() <> 0
           REPLACE MAG_QTAIMP WITH 0
	   ENDIF

       SCATTER MEMVAR MEMO   

       IF !ExecRw(cSql,"U_MAG_GG","W")
         return(.f.)
       ENDIF


	   *=> Aggiornamento quantità impegnata sulla giacenza di riepilogo
	   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
	   x_data   = "mag_datagg = '" + SPACE(10) + "'"
	   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
	   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
	   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
	   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
	   Csql     = "select * from u_mag_gg where " + x_cond
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   SELECT U_MAG_GG
	   IF RECCOUNT() <> 0
	         REPLACE MAG_QTAIMP WITH 0
	   ENDIF

	   SCATTER MEMVAR MEMO   
	   IF !ExecRw(cSql,"U_MAG_GG","W")
	      return(.f.)
	   ENDIF



	   SELECT SAVE_PCK_LE
	   SKIP +1

	ENDDO


** 3) ----

	IF _FUNZIONE = "RICALCOLA"
	
		SELECT SAVE_PCK_LE
	    GO TOP 
	    DO WHILE .NOT. EOF()
	   
	       SCATTER MEMVAR MEMO 
	       
		   *=> Ricalcola e aggiorna la quantità impegnata sulla giacenza di dettaglio
		   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
		   Csql   = "select * from u_mag_gg where " + x_cond 
		   IF !ExecRW(cSql,"U_MAG_GG","R")
		      return(.f.)
		   ENDIF
		   
		   SELECT U_MAG_GG
		   IF RECCOUNT() <> 0
	           REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
		   ENDIF

	       SCATTER MEMVAR MEMO   

	       IF !ExecRw(cSql,"U_MAG_GG","W")
	         return(.f.)
	       ENDIF


		   *=> Ricalcola e aggiorna la impegnata sulla giacenza di riepilogo
		   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
		   x_data   = "mag_datagg = '" + SPACE(10) + "'"
		   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
		   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
		   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
		   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
		   Csql     = "select * from u_mag_gg where " + x_cond
		   IF !ExecRW(cSql,"U_MAG_GG","R")
		      return(.f.)
		   ENDIF
		   SELECT U_MAG_GG
		   IF RECCOUNT() <> 0
		         REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
		   ENDIF

		   SCATTER MEMVAR MEMO   
		   IF !ExecRw(cSql,"U_MAG_GG","W")
		      return(.f.)
		   ENDIF



		   SELECT SAVE_PCK_LE
		   SKIP +1

		ENDDO
	ENDIF _FUNZIONE = "RICALCOLA"

	IF _FUNZIONE = "RICALCOLA"
	    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+_ARTICOLO+" ricalcolato"
	ELSE
	    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+_ARTICOLO+" azzerato"
	ENDIF



RETURN
