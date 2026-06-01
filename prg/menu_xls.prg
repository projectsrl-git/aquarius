*********************************************************************************************
*								ELENCO MENU' AQUARIUS SU FOGLIO EXCEL						*
*********************************************************************************************
SET DEFAULT TO SYS(5)+SYS(2003)
SELECT * FROM WINMAIN.mnx INTO CURSOR MAIN
SELECT * FROM TBL_MENU.DBF INTO CURSOR CUR_MENU
INDEX ON (ALLTRIM(MENU)+ALLTRIM(MENU)+ALLTRIM(STR(ORDINE))) TAG DAGGANCIO

CREATE CURSOR TO_XLS (VOCE1 C(100), VOCE2 C(100), VOCE3 C(100), VOCE4 C(100), VOCE5 C(100), VOCE6 C(100), VOCE7 C(100),;
					  VOCE8 C(100), VOCE9 C(100), VOCE10 C(100), VOCE11 C(100), VOCE12 C(100), VOCE13 C(100),;
					  VOCE14 C(100), VOCE15 C(100), COMANDO C(200))

CREATE CURSOR APPOGGIO (ORDINE N(4), MENU C(50), LABEL C(50), COMANDO C(200), DESCRIZION C(200), UTENTI C(200))

CREATE CURSOR APPOGGIO_2 (ORDINE N(4), MENU C(50), LABEL C(50), COMANDO C(200), DESCRIZION C(200), UTENTI C(200))

CREATE CURSOR APPOGGIO_3 (ORDINE N(4), MENU C(50), LABEL C(50), COMANDO C(200), DESCRIZION C(200), UTENTI C(200))


WAIT WINDOWS "Generazione del file excel in corso... " NOWAIT

SELECT WINMAIN
go top
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF

	SCATTER MEMVAR MEMO
	
	__VOCE1 = ""
	__VOCE2 = ""
	__VOCE3 = ""
	__VOCE4 = ""
	__VOCE5 = ""
	__VOCE6 = ""
	__VOCE7 = ""
	__COMANDO = ""
	__AGGANCIO = ""
	__RICHIAMO = ""
	V_MENU = 0

	
	IF ALLTRIM(M.LEVELNAME) = '_MSYSMENU'  
		__VOCE1 = ALLTRIM(M.PROMPT)
	ENDIF
	
	
	
	IF M.OBJCODE = 77 AND ALLTRIM(M.LEVELNAME) <> '_MSYSMENU' AND ALLTRIM(M.PROMPT) <> "\-"
		__VOCE2 = ALLTRIM(M.PROMPT)
	ENDIF
	
	
	
	IF !EMPTY(__VOCE1) .OR. !EMPTY(__VOCE2)
		SELECT TO_XLS
		APPEND BLANK
		REPLACE VOCE1 		WITH __VOCE1
		REPLACE VOCE2		WITH __VOCE2
	ENDIF

	
	
	
	IF M.OBJCODE = 67 AND ALLTRIM(M.LEVELNAME) <> '_MSYSMENU'  	
		__VOCE3 = ALLTRIM(M.PROMPT)
		
		IF !EMPTY(__VOCE3)
			SELECT TO_XLS
			APPEND BLANK
			REPLACE VOCE3		WITH __VOCE3
		ENDIF
		
		** vado sulla tbl_menu per recuperare la __VOCE4 e il COMANDO
		__AGGANCIO = ALLTRIM(M.COMMAND)
		stringa=ALLTRIM(__AGGANCIO)
		start=AT("'",stringa)
		end=ATC("',",SUBSTR(stringa,start+1))
		__AGGANCIO=SUBSTR(stringa,start+1,end-1)

		SELECT CUR_MENU
		go top
		DO WHILE .T.
		   IF EOF()
		      EXIT
		   ENDIF

		   SET FILTER TO
   		   SET FILTER TO ALLTRIM(MENU)==ALLTRIM(__AGGANCIO)

	 	   SCATTER MEMVAR MEMO

		   __VOCE4 = ALLTRIM(M.LABEL)
		   __COMANDO = ALLTRIM(M.COMANDO)

		    IF (!EMPTY(__VOCE4) .OR. !EMPTY(__COMANDO)) .AND. (ALLTRIM(M.MENU) == ALLTRIM(__AGGANCIO))
				SELECT TO_XLS
				APPEND BLANK
				REPLACE VOCE4		WITH __VOCE4

				IF !(UPPER('SUBMENU')$UPPER(__COMANDO))
					REPLACE COMANDO		WITH __COMANDO
					
				ELSE
				*

					stringa=ALLTRIM(__COMANDO)
					richiamo_start=AT("'",stringa)
					richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
					__RICHIAMO=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)
					
					SELECT * from CUR_MENU INTO CURSOR TBL_MENU_2
					
					SELECT TBL_MENU_2
					go top
					DO WHILE .T.
					   IF EOF()
					      EXIT
 				       ENDIF
						SET FILTER TO
						SET FILTER TO UPPER(ALLTRIM(MENU))==UPPER(ALLTRIM(__RICHIAMO))

						SELECT TBL_MENU_2

						__VOCE5 = ALLTRIM(LABEL)
						__COMANDO = ALLTRIM(COMANDO)
						

					    IF UPPER(ALLTRIM(MENU))==UPPER(ALLTRIM(__RICHIAMO))
						SELECT TO_XLS
						APPEND BLANK
						REPLACE VOCE4		WITH ""
						REPLACE VOCE5 		WITH __VOCE5
						
						
						
						
						**************** inizio

							__richiamo_principale = ""
							_record = 1
							_record_2 = 1
							_record_3 = 1
							_record_2_t = ""
							_comando = ""
							i=5
							
							ai=i
							i=i+1
							
							ai= ALLTRIM(STR(ai))
							i= ALLTRIM(STR(i))

							stringa=ALLTRIM(__COMANDO)
							richiamo_start=AT("'",stringa)
							richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
							__RICHIAMO&i=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)
							
							__richiamo_principale = __RICHIAMO&i


							if !(UPPER('SUBMENU')$UPPER(__COMANDO))
								REPLACE COMANDO		WITH __COMANDO
							ENDIF

							DO WHILE (UPPER('SUBMENU')$UPPER(__COMANDO))
					
					
							****************** per la voce7 - inizio
							_k=0  && aggiunta 7-7-9
							IF TYPE('i') = 'N'
								i= i+1
								i = ALLTRIM(STR(i))
							ENDIF
							IF TYPE('ai') = 'N'
								ai=ai+1
								ai= ALLTRIM(STR(ai))
							ENDIF
							_record_2 = 1
							stringa=ALLTRIM(__COMANDO)
							richiamo_start=AT("'",stringa)
							richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
							__RICHIAMO&i=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)
							
							__richiamo_principale = __RICHIAMO&i
							SELECT APPOGGIO_2
							USE
						    CREATE CURSOR APPOGGIO_2 (ORDINE N(4), MENU C(50), LABEL C(50), COMANDO C(200), DESCRIZION C(200), UTENTI C(200))
							****************** per la voce7 - fine

							IF TYPE('i') = 'N'
								i= ALLTRIM(STR(i))
							ENDIF
							IF TYPE('ai') = 'N'
								ai= ALLTRIM(STR(ai))
							ENDIF
							
							SELECT * from CUR_MENU INTO CURSOR TBL_MENU_&i
		 				       	    
							SELECT TBL_MENU_&i
							go top
							u=0
							DO WHILE .T.
							   IF EOF()
							      EXIT
		 				       ENDIF
		 				        a=0
		 				       	
		 				       	
		 				       	IF ALLTRIM(__RICHIAMO&i) <> ALLTRIM(__richiamo_principale)
		 				       	    __richiamo = __RICHIAMO&i
   									
		 				       	    select TBL_MENU_&i
		 				       	    go top
									DO WHILE !EOF()
			 				       	    SCATTER MEMVAR MEMO
			 				       	    SELECT APPOGGIO
			 				       	    APPEND BLANK
			 				       	    GATHER MEMVAR MEMO
			 				       	    SELECT TBL_MENU_&i
			 				       	    skip+1
		 				       	    ENDDO
		 				       	    SELECT APPOGGIO
		 				       	    a=RECCOUNT()
		 				       	    GOTO RECORD(_record)
		 				       	    
	 				       	    IF RECNO()<>1
		 				       	    ELSE
										i = VAL(i)
										ai = VAL(ai)
										i = i+1
										ai = ai+1
										ai= ALLTRIM(STR(ai))
										i= ALLTRIM(STR(i))
									ENDIF
									__RICHIAMO&i = __richiamo
									SELECT * from CUR_MENU INTO CURSOR TBL_MENU_&i
									
								ENDIF
								
								SET FILTER TO
								SET FILTER TO UPPER(ALLTRIM(MENU))==UPPER(ALLTRIM(__RICHIAMO&i))

								b=0
								IF ALLTRIM(__RICHIAMO&i) <> ALLTRIM(__richiamo_principale)
									SELECT APPOGGIO
								ELSE 
									*************** START
									IF _record_2 <=1
										select TBL_MENU_&i
			 				       	    go top
										DO WHILE !EOF()
				 				       	    SCATTER MEMVAR MEMO
				 				       	    SELECT APPOGGIO_2
				 				       	    APPEND BLANK
				 				       	    GATHER MEMVAR MEMO
				 				       	    SELECT TBL_MENU_&i
				 				       	    skip+1
			 				       	    ENDDO
		 				       	    endif
		 				       	    *************** END
		 				       	    SELECT APPOGGIO_2
		 				       	    GO TOP 
		 				       	    a=RECCOUNT()
		 				       	    _k=0
		 				       	    GOTO RECORD(_record_2)
								ENDIF 

								__VOCE&i = ALLTRIM(LABEL)
								__COMANDO = ALLTRIM(COMANDO)
								

								
								
								************************************ 
								IF (UPPER('SUBMENU')$UPPER(__COMANDO))
									IF !EMPTY(ALLTRIM(_comando))
										_rich = ""
										IF !EMPTY(alltrim(__COMANDO)) .and. (alltrim(_comando)<>ALLTRIM(__COMANDO))&&aggiunta 7-7-9
											stringa=ALLTRIM(__COMANDO)
										ELSE
											stringa=ALLTRIM(_comando)
										ENDIF 
										richiamo_start=AT("'",stringa)
										richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
										_rich=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)
										_cifre = ""
										_l_cifre = 0
										_cifre = ALLTRIM(_rich)
										_l_cifre= LEN(ALLTRIM(_rich))
										_cifre= SUBSTR(_cifre,_l_cifre-2,3)
									ELSE
										&& aggiunta7-7-9
										IF !EMPTY(__COMANDO)
											_rich = ""
											stringa=ALLTRIM(__COMANDO)
											richiamo_start=AT("'",stringa)
											richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
											_rich=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)
											_cifre = ""
											_l_cifre = 0
											_cifre = ALLTRIM(_rich)
											_l_cifre= LEN(ALLTRIM(_rich))
											_cifre= SUBSTR(_cifre,_l_cifre-2,3)
											_k=1
										ELSE
										&& fineaggiunta7-7-9
											_cifre = 'abc'
										ENDIF
									ENDIF 



									if ((__COMANDO <> _comando) .or. (BETWEEN(_cifre,'0','9')))
										IF TYPE('i') = 'C'
											i= VAL(i)
										ENDIF
										IF TYPE('ai') = 'C'
											ai= VAL(ai)
										ENDIF
										i=i+1
										ai=ai+1
										i= ALLTRIM(STR(i))
										ai= ALLTRIM(STR(ai))
										
										_record_3 = 1
										IF _k=0 
											stringa=ALLTRIM(_comando)
											&& aggiunta 8-7-9
											IF (UPPER('SUBMENU')$UPPER(__COMANDO))
												stringa=ALLTRIM(__COMANDO)
											ENDIF 
										ELSE && aggiunta 7-7-9
											stringa=ALLTRIM(__COMANDO)
										ENDIF 
										
										richiamo_start=AT("'",stringa)
										richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
										__RICHIAMO&i=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)

										SELECT * from CUR_MENU INTO CURSOR TBL_MENU_&i
										SET FILTER TO
										SET FILTER TO UPPER(ALLTRIM(MENU))==UPPER(ALLTRIM(__RICHIAMO&i))
										
										b=0
*										IF (ALLTRIM(__RICHIAMO&i) <> ALLTRIM(__richiamo_principale))
										IF (ALLTRIM(__RICHIAMO&i) <> ALLTRIM(__richiamo_principale)) .and. _k=0 && aggiunta 7-7-9
											SELECT APPOGGIO
										ELSE 
											
											*************** 
											IF _record_3 <=1
										
											SELECT APPOGGIO_3
											USE
											CREATE CURSOR APPOGGIO_3 (ORDINE N(4), MENU C(50), LABEL C(50), COMANDO C(200), DESCRIZION C(200), UTENTI C(200))
											SELECT APPOGGIO_3
											GO top
										
												select TBL_MENU_&i
					 				       	    go top
												DO WHILE !EOF()
						 				       	    SCATTER MEMVAR MEMO
						 				       	    SELECT APPOGGIO_3
						 				       	    APPEND BLANK
						 				       	    GATHER MEMVAR MEMO
						 				       	    SELECT TBL_MENU_&i
						 				       	    skip+1
					 				       	    ENDDO
				 				       	    endif
				 				       	    *************** 
				 				       	    SELECT APPOGGIO_3
				 				       	    GO TOP 
				 				       	    a=RECCOUNT()
				 				       	    GOTO RECORD(_record_3)
										ENDIF 

										__VOCE&i = ALLTRIM(LABEL)
										__COMANDO&i = ALLTRIM(COMANDO)
										
										
										IF ((UPPER(ALLTRIM(MENU)) == UPPER(ALLTRIM(__RICHIAMO&i)))) .or. EMPTY(ALLTRIM(__RICHIAMO&i))
										u=0
										
										IF _k=1 && aggiunta 7-7-9
											SELECT APPOGGIO_2
											SCATTER MEMVAR memo
											SELECT TO_XLS
											i = VAL(i)
											ai = VAL(ai)
											i=i-1
											ai=ai-1
											i= ALLTRIM(STR(i))
											ai= ALLTRIM(STR(ai))
											APPEND BLANK &&nuova aggiunta
											REPLACE VOCE&i 		WITH ALLTRIM(m.LABEL)
											IF !(UPPER('SUBMENU')$UPPER(m.COMANDO))  &&aggiunta 7-7-9
												REPLACE COMANDO 	WITH ALLTRIM(m.COMANDO)
											ENDIF 
											i = VAL(i)
											ai = VAL(ai)
											i = i+1
											ai = ai+1
											i= ALLTRIM(STR(i))
											ai= ALLTRIM(STR(ai))
											SELECT APPOGGIO_3
										ENDIF
										
										FOR a=1 TO RECCOUNT()
										SELECT APPOGGIO_3
										GOTO RECORD(a)
										SCATTER MEMVAR memo
										
										SELECT TO_XLS
										APPEND BLANK
										REPLACE VOCE&ai		WITH ""									
										REPLACE VOCE&i 		WITH ALLTRIM(m.LABEL)
										IF !(UPPER('SUBMENU')$UPPER(m.COMANDO))
											REPLACE COMANDO 	WITH ALLTRIM(m.COMANDO)
										ENDIF 
										u=u+1
										endfor
										
										ENDIF


										IF TYPE('i') = 'C'
											i= VAL(i)
										ENDIF
										IF TYPE('ai') = 'C'
											ai= VAL(ai)
										ENDIF
										i=i-1
										ai=ai-1
										i= ALLTRIM(STR(i))
										ai= ALLTRIM(STR(ai))
										_record_2_t = "torna"
										
										IF BETWEEN(_cifre,'0','9')
											_record_2_t = ""
										endif	
										
										SELECT APPOGGIO_2
									endif
			
								ENDIF
							
								************************************* 
								







							    IF (UPPER(ALLTRIM(MENU)) == UPPER(ALLTRIM(__RICHIAMO&i))) .or. EMPTY(ALLTRIM(__RICHIAMO&i))
									SELECT TO_XLS
									
									IF _k<>1 && aggiunta 7-7-9
										GO bott
										skip-u
										IF (voce&i)<>(__VOCE&i)
										APPEND BLANK
										ENDIF
										
										REPLACE VOCE&ai		WITH ""
										REPLACE VOCE&i 		WITH __VOCE&i
									ENDIF
									
									*************************************
									_comando = __COMANDO
									*************************************
									
									IF ALLTRIM(__VOCE&i) = "Documenti per la banca"
									ENDIF 
									IF !(UPPER('SUBMENU')$UPPER(__COMANDO))  &&LUCA
										REPLACE COMANDO 	WITH __COMANDO
									ENDIF
									
									IF ALLTRIM(__RICHIAMO&i) <> ALLTRIM(__richiamo_principale)
										V_MENU=1
									ELSE
										V_MENU=2
									ENDIF
									
									stringa=ALLTRIM(__COMANDO)
									richiamo_start=AT("'",stringa)
									richiamo_end=ATC("'",SUBSTR(stringa,richiamo_start+1))
									__RICHIAMO&i=SUBSTR(stringa,richiamo_start+1,richiamo_end-1)
								ENDIF 
									IF V_MENU<>1
										__RICHIAMO&i = __richiamo_principale
										SELECT APPOGGIO_2
										Skip+1
										IF _record_2_t ="torna"
											_record_2 = RECNO()-1
											_record_2_t = ""
										ELSE
											_record_2 = RECNO()
										ENDIF
									ELSE
										SELECT APPOGGIO
										IF RECCOUNT() = 0
										ENDIF
										
										Skip+1
										_record = RECNO()
									ENDIF
						    
							 ENDDO
							 
						ai = VAL(ai)
						i = VAL(i)
						
						ENDDO  && chiude l'if [submenù è contenuto in comando]
						
						
						**************** fine
						
						ENDIF 
						SELECT APPOGGIO_2
						USE
						CREATE CURSOR APPOGGIO_2 (ORDINE N(4), MENU C(50), LABEL C(50), COMANDO C(200), DESCRIZION C(200), UTENTI C(200))
						SELECT APPOGGIO_2
						GO top
												
						select TBL_MENU_2
					    Skip+1
					 ENDDO
					
				ENDIF && chiude l'if [submenù è contenuto in comando]
				
		    ENDIF && chiude l'if per la scrittura della voce 4 

		   select CUR_MENU
		   Skip+1

		ENDDO
		
	ENDIF
	
	
	
	select WINMAIN
	skip+1
ENDDO

SELECT TO_XLS
GO top

_PTH = SYS(5)+ALLTRIM(PUB_DIR)

COPY TO &_PTH\Elenco_menu.xls TYPE XLS

_V_FILE = _PTH +"\Elenco_menu.xls"
DO Open_with_default_windows_program WITH _V_FILE
