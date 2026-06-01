*************************************************************************
*   ESTRAE EFFETTI					                                    *
*************************************************************************

FUNCTION ESTRAE_EFFETTI


        ** ACCESSO PER FORNITORE
		x_codi = "con_codfor = '" + ALLTRIM(SUBSTR(XXX_CONTO,PUB_SOTTOG,PUB_CONTO)) + "'"
		cSql="SELECT * FROM u_ass_dd WHERE "+ x_codi + " order by ass_codfor"
		IF !ExecCommand(cSql,"cur_u_ass_dd")
		   return(.f.)
		ENDIF

		SELECT cur_u_ass_dd
		GO TOP
	
		___TAGGANCIO 	= DAGGANCIO
		
        ** ACCESSO SUL CONTRATTO
		x_codi = "taggancio = '" + ___taggancio + "'"
		cSql="SELECT * FROM U_ASS_TT WHERE " + x_codi + " order by con_tipcon,con_numcon"
		IF !ExecCommand(cSql,"cur_U_ASS_TT")
		   return(.f.)
		ENDIF

		___DESASS  = ASS_TIPASS
						
		SELECT cur_u_ass_dd
		GO TOP


		DO WHILE !EOF()

		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF

	
			** SE STO VARIANDO UNA PRIMA NOTA RIMOSTRO LE RIGHE DEL DOCUMENTO EXTRA CONTABILE
 			IF (PUB_VARPN=.T.) .OR. (PUB_ANNPN=.T.)	
		
				IF !EMPTY(ass_numpro) 
					IF ALLTRIM(ass_numpro) <> ALLTRIM(XXX_NUMINT)  && SCARTA TUTTI I DOCUMENTI DI ALTRE REGISTRAZIONI
						SELECT cur_u_ass_dd
						SKIP +1
						LOOP
					ENDIF
				ENDIF

			ELSE

				IF !EMPTY(ass_numpro) 					&& SCARTA TUTTI I DOCUMENTI GIA ASSEGNATI
					SELECT cur_u_ass_dd
					SKIP +1
					LOOP
				ENDIF
			
			ENDIF



		   SELECT     cur_u_ass_dd
		   M.WSELEZ   = SPACE(06)
		   M.WANNO    = SUBSTR(ASS_DTVERS,7,4)
		   M.WCONTO   = ASS_CODFOR
		   M.WTIPDOC  = "EFFETTO"
		   M.WDESDOC  = ___DESASS
		   M.WNUMDOC  = ASS_NUMASD
		   M.WDATDOC  = ASS_DTVERS
		   M.WSYSDOC  = ASS_SYSDOC
		   M.WDTSCAD  = ASS_DTVERS
		   M.WCOVAL   = ASS_DTVERS
		   M.WIMPORTO = TEURO(M.WCOVAL,ASS_IMPTOD,RIBALTA2(M.WDATDOC))
		   M.WPAGATO  = 0
		   M.WNUMPROOLD = ASS_NUMPRO  &&VECCHIO NUMERO DI REGISTRAZIONE



  		   SELECT WORK
		   APPEND BLANK
		   GATHER MEMVAR MEMO
		   REPLACE WDATDOC  WITH RIBALTA2(M.WDATDOC)


		   SELECT cur_u_ass_dd
		   SKIP +1

		ENDDO

		SELECT WORK
		SET ORDER TO WORK
		GO TOP

		OK_WORK = .F.
		DO WHILE .NOT.EOF()       && VERIFICA SE ESISTONO I MOVIMENTI
		   OK_WORK = .T.      
		   SKIP +1
		ENDDO

		IF !OK_WORK
		   RETURN
		ENDIF


RETURN


*****************

DO CASE

	CASE  __TPROC__  = "ASS"

        SELECT EXTRAWORK
        GO TOP
        
        DO WHILE !EOF()
        
            SCATTER MEMVAR MEMO 

          
            
		    ** ACCESSO ALLA RIGA DELL'ASSEGNO PER CODICE SYSDOC PER RIPORTARE IL NUOVO AGGANCIO NUMPRO 
				x_codi = "ass_sysdoc = '" + M.EXTRA_SYSDOC + "'"
				cSql="SELECT * FROM U_ASS_DD WHERE "+ x_codi + " order by ass_sysdoc"
			    IF !ExecRW(cSql,"u_ass_dd","R")
			 	   return(.f.)
			    ENDIF

				SELECT u_ass_dd
				REPLACE ASS_NUMPRO WITH ALLTRIM(PN_C)

			    IF !ExecRW("","u_ass_dd","W")
				   return(.f.)
			    ENDIF

		    
		    ** ACCESSO ALLA RIGA  DELL'ASSEGNO PER CODICE NUMPROOLD PER TOGLIERE IL VECCHIO AGGANCIO NUMPRO 
				x_codi = "ass_numpro = '" + M.EXTRA_NUMPROOLD + "'"
				cSql="SELECT * FROM U_ASS_DD WHERE "+ x_codi + " order by ass_sysdoc"
			    IF !ExecRW(cSql,"u_ass_dd","R")
			 	   return(.f.)
			    ENDIF

				SELECT u_ass_dd
				REPLACE ASS_NUMPRO WITH SPACE(10)

			    IF !ExecRW("","u_ass_dd","W")
				   return(.f.)
			    ENDIF
		    
		    
		    
            SELECT EXTRAWORK		    
		    SKIP + 1
		    
        ENDDO 



ENDCASE


SELECT(AXABBSZ)

