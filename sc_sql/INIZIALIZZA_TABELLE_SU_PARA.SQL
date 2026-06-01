/****** TITOLO DI STUDIO ******/

DELETE FROM PARA WHERE CODICE LIKE 'TIT%'

INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT001','Arch.   ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT002','Dott.   ')
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT003','Dott.ssa') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT004','Ing.    ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT005','Prof.   ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT006','Prof.ssa') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT007','Sig.    ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('TIT008','Sig.ra  ') 

UPDATE PARA SET DESCRI = RTRIM(DESCRI) WHERE  CODICE LIKE 'TIT%'

SELECT *  FROM PARA WHERE CODICE LIKE 'TIT%'


/****** STATO CIVILE ******/

DELETE FROM PARA WHERE CODICE LIKE 'CIV%' 

INSERT INTO PARA  (CODICE,DESCRI) VALUES ('CIV001','Celibe   ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('CIV002','Coniugata')
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('CIV003','Coniugato') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('CIV004','Nubile   ') 


UPDATE PARA SET DESCRI = RTRIM(DESCRI) WHERE  CODICE LIKE 'CIV%'

SELECT *  FROM PARA WHERE CODICE LIKE 'CIV%'



/****** POSIZIONE MILITARE ******/

DELETE FROM PARA WHERE CODICE LIKE 'MIL%' 

INSERT INTO PARA  (CODICE,DESCRI) VALUES ('MIL001','Assolto     ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('MIL002','Congedato   ')
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('MIL003','Esentato    ') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('MIL004','Non assolto ') 


UPDATE PARA SET DESCRI = RTRIM(DESCRI) WHERE  CODICE LIKE 'MIL%'

SELECT *  FROM PARA WHERE CODICE LIKE 'MIL%'


/****** Stato risorsa ******/ 

DELETE FROM PARA WHERE CODICE LIKE 'SRS%' 

INSERT INTO PARA  (CODICE,DESCRI) VALUES ('SRS001','stato risorsa 1') 
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('SRS002','stato risorsa 2')
INSERT INTO PARA  (CODICE,DESCRI) VALUES ('SRS003','stato risorsa 3') 

UPDATE PARA SET DESCRI = RTRIM(DESCRI) WHERE  CODICE LIKE 'SRS%'

SELECT *  FROM PARA WHERE CODICE LIKE 'SRS%'


                                  	             
/****** Settori aziendali ******/ 

DELETE FROM PARA WHERE CODICE LIKE 'SAZ%' 

INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ001','Amministrazione - Controllo di Gestione  ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ002','Commerciale - Vendite                    ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ003','Consulenza                               ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ004','Customer Service - Call Center           ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ005','Database - Backup                        ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ006','Direzione Generale - Executive Management')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ007','Docenza - Organizzazione                 ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ008','Hardware - Information Systems           ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ009','Hostess -Promoter                        ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ010','Marketing - Pubblicità - PR              ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ011','Operai - Manutenzione                    ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ012','Operatore - Data Entry                   ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ013','Progettazione - Tecnica                  ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ014','Redazione - Traduzione                   ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ015','Risorse Umane - Formazione - Recruiting  ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ016','Segreteria - Servizi Generali            ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ017','Sistemistico                             ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ018','Sviluppo software - Analisi              ')  			
INSERT INTO PARA (CODICE,DESCRI) VALUES ('SAZ019','Web Designer - Grafica                   ')  			

UPDATE PARA SET DESCRI = RTRIM(DESCRI) WHERE  CODICE LIKE 'SAZ%'

SELECT *  FROM PARA WHERE CODICE LIKE 'SAZ%'             



/****** funzioni aziendali ******/ 

DELETE FROM PARA WHERE CODICE LIKE 'FUN%' 

INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN001','Account                                     ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN002','Amministratore Delegato                     ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN003','Amministratore Unico                        ','AU ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN004','Assessore                                   ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN005','Consigliere                                 ','CNS')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN006','Direttore Commerciale                       ','DC ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN007','Direttore Generale                          ','DG ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN008','Direzione Didattica                         ','DD ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN009','Dirigente Scolastico                        ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN010','Docente                                     ','DOC')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN011','GBS IGEM HR Lead                            ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN012','Il Responsabile                             ','RSP')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN013','Partner - Account                           ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN014','Presidente                                  ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN015','Presidente del Consiglio di Amministrazione ','PCA')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN016','Professore di Orientamento                  ','PO ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN017','Responsabile Acquisti                       ','RAC')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN018','Responsabile Commerciale                    ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN019','Service Delivery Manager                    ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN020','Sindaco                                     ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN021','Supply Manager                              ','   ')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN022','Supporto Commerciale                        ','SCM')  			
INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('FUN023','Tecnico Informatico                         ','INF')  			

UPDATE PARA SET DESCRI = RTRIM(DESCRI) WHERE  CODICE LIKE 'FUN%'
UPDATE PARA SET LIBERA = RTRIM(LIBERA) WHERE  CODICE LIKE 'FUN%'

SELECT *  FROM PARA WHERE CODICE LIKE 'FUN%'             

                                                 