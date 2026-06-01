
*!*	##############################################################################################################

					**********************************************************************************************
					***         	       PROJECT SRL - CALCOLO VALORI BILANCIO CEE	                       ***
					***                                                                                        ***
					**********************************************************************************************

*!*	SERGIO E' DA VEDERE CASO PER CASO IN FUNZIONE DI QUELLO CHE DICE IL COMMERCIALISTA : VEDI PUNTI COMMENTATI
*!*	##############################################################################################################

RELEASE _BIL_CEE_INCLUDI_PREVISIONALI
PUBLIC _BIL_CEE_INCLUDI_PREVISIONALI

_BIL_CEE_INCLUDI_PREVISIONALI = .F.


RIT=MESSAGEBOX("Funzione di gestione calcolo bilancio CEE: continuare con l'elaborazione?",292,"ATTENZIONE")

IF RIT=6
ELSE
   RETURN
ENDIF


RIT=MESSAGEBOX("Funzione di gestione calcolo bilancio CEE: includere movimenti previsionali?",292,"ATTENZIONE")

IF RIT=6
	_BIL_CEE_INCLUDI_PREVISIONALI =.T.
ELSE
   _BIL_CEE_INCLUDI_PREVISIONALI =.F.
ENDIF


x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
CSQL   = "UPDATE BILNEW SET CORRENTE = 0 WHERE " + x_soci
IF !ExecCommand(cSql,"BILNEW")
   return(.f.)
ENDIF


WAIT WINDOW 'OPERAZIONE ASSEGNAZIONE RIGHE...ATTENDERE PER FAVORE...' TIMEOUT (3)

x_soci = "int_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from u_int_tt where " + x_cond + " order by int_codsoc,int_conto"
IF !ExecCommand(cSql,"U_INT_TT")
   return(.f.)
ENDIF
SELECT U_INT_TT
GO TOP



DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODRIG = INT_CODRIG
   V_CODRIA = INT_CODRIA
   V_CONTO  = INT_CONTO
   V_IMPATT = 0

   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_codi = "con_conto = '" + ALLTRIM(V_CONTO) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_codi
   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecCommand(cSql,"CONTI")
      return(.f.)
   ENDIF
   SELECT CONTI
   GO TOP
   IF !EOF()
      V_IMPATT = CON_IMP_D - CON_IMP_A
      
		IF _BIL_CEE_INCLUDI_PREVISIONALI 
      		IF (PRE_IMP_D - PRE_IMP_A) <> 0
      			WAIT WINDOW "Elaborati dati previsionali su conto "+ALLTRIM(CON_CONTO)+" - "+ALLTRIM(CON_DESCR) NOWAIT
				V_IMPATT = V_IMPATT + (PRE_IMP_D - PRE_IMP_A)
			ENDIF
		ENDIF
   ELSE
      =MESSAGEBOX('Il conto : '+V_CONTO+' non risulta presente in archivi',62,'ATTENZIONE')
   ENDIF

   x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
   x_cond = x_soci
   X_RIG = PADL(ALLTRIM(V_CODRIG),10," ")
   VV=V_CODRIG


*!*		ATTRIBUISCE IL CODICE RIGA AVERE IN ALTERNATIVA SE DIGITATO

   IF V_IMPATT >= 0
      x_codi = "bil_codrig = '" + PADL(ALLTRIM(V_CODRIG),10," ") + "'"
      x_cond = x_cond + " and " + x_codi
   ELSE
      IF !EMPTY(V_CODRIA)            && BANCHE IN PASSIVO
         x_codi = "bil_codrig = '" + PADL(ALLTRIM(V_CODRIA),10," ") + "'"
         x_cond = x_cond + " and " + x_codi
         VV=V_CODRIA
      ELSE
         x_codi = "bil_codrig = '" + PADL(ALLTRIM(V_CODRIG),10," ") + "'"
         x_cond = x_cond + " and " + x_codi
	     VV=V_CODRIG
      ENDIF
   ENDIF

 
   Csql   = "select * from bilnew where " + x_cond + " order by bil_codsoc,bil_codrig"
   IF !ExecRW(Csql,"bilnew","R")
 	  return(.f.)
   ENDIF
   SELECT BILNEW
   GO TOP
   IF EOF()
		   
		***Codice riga non presente in archivio
		
		MESSAGEBOX("Verificare la confluenza di "+ALLTRIM(V_CONTO)+" in bilancio CEE in quanto non assegnata la riga di destinazione",48,"Confluenza definita in modo incompleto")
*!*			CANCELLO LA RIGA DI U_INT_TT IN CUI NON E' PRESENTE INT_CODRIG
*!*			_csqldelete   = "DELETE FROM U_INT_TT WHERE INT_CONTO='"+ALLTRIM(V_CONTO)+"' AND INT_CODRIG =''"
*!*	   		IF !ExecCommand(_csqldelete,"_bil_temp")
*!*				return(.f.)
*!*			ENDIF
	
		SELECT U_INT_TT
		SKIP
		LOOP
   ELSE 
      REPLACE CORRENTE WITH CORRENTE + V_IMPATT
   ENDIF
   
   IF !ExecRW("","bilnew","W")
      return(.f.)
   ENDIF
   
   SELECT U_INT_TT
   SKIP +1

ENDDO

WAIT WINDOW 'Operazione calcolo economici, attendere per favore...' TIMEOUT(3)

V_TOTALE = 0

Csql   = "select * from bilnew order by bil_codsoc,bil_codrig"
IF !ExecRW(Csql,"bilnew","R")
   return(.f.)
ENDIF
SELECT BILNEW
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   * PER SOLO RIGHE CONTI ECONOMICI FA ABS

   XRIGA=BIL_CODRIG
   IF VAL(XRIGA) <  21600    && SALTA LE RIGHE DEI CONTI NON ECONOMICI
      SKIP +1
      LOOP
   ENDIF


*!*	   SERGIO E' DA VEDERE CASO PER CASO IN FUNZIONE DI QUELLO CHE DICE IL COMMERCIALISTA

*!*	   IF VAL(XRIGA) =  21900    && RIMANENZE ANNI PRECEDENTI CAMBIO SEGNO
*!*	      XORRENTE = CORRENTE * -1
*!*	      REPLACE CORRENTE WITH XORRENTE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   IF VAL(XRIGA) =  24400    && VARIAZIONE MAT.PRIME : SERGIO E' DA VEDERE CASO PER CASO IN FUNZIONE DI QUELLO CHE DICE IL COMMERCIALISTA
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

   REPLACE CORRENTE WITH ABS(CORRENTE)  && RENDE IL VALORE IN ASSOLUTO

   SELECT BILNEW
   SKIP +1

ENDDO

IF !ExecRW("","bilnew","W")
   return(.f.)
ENDIF

WAIT WINDOW 'Operazione calcolo totali, attendere per favore...' TIMEOUT(3)


 
V_TOTALE = 0

x_soci = "cor_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from u_cor_tt where " + x_cond + " order by cor_codsoc,cor_riga"
IF !ExecCommand(cSql,"U_COR_TT")
   return(.f.)
ENDIF
SELECT U_COR_TT
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CONFLU = COR_CONFLU
   SEGNO  = COR_SEGNO
   RIGA   = COR_RIGA

   x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "bil_codrig = '" + PADL(ALLTRIM(RIGA),10," ") + "'"
   x_cond = x_soci + " and " + x_codi

   Csql   = "select * from bilnew where " + x_cond + " order by bil_codsoc,bil_codrig"
   IF !ExecRW(Csql,"bilnew","R")
 	  return(.f.)
   ENDIF
   
   
   SELECT BILNEW
   GO TOP
   
   IF EOF()
   ELSE         && VADO SU BILNEW E PRENDO IL VALORE CORRENTE DI QUESTA RIGA
      IF SEGNO='+'
         V_TOTALE=V_TOTALE+CORRENTE
      ELSE
         V_TOTALE=V_TOTALE-CORRENTE
      ENDIF
   ENDIF

   x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "bil_codrig = '" + PADL(ALLTRIM(CONFLU),10," ") + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from bilnew where " + x_cond + " order by bil_codsoc,bil_codrig"
   IF !ExecRW(Csql,"bilnew","R")
 	  return(.f.)
   ENDIF
   SELECT BILNEW
   GO TOP
   IF EOF()
      =MESSAGEBOX("Non trovata la riga di confluenza, aggiornamento annullato"+CONFLU,62,"ATTENZIONE")
      RETURN
   ELSE 
      REPLACE CORRENTE WITH CORRENTE+V_TOTALE
      V_TOTALE=0
   ENDIF
   IF !ExecRW("","bilnew","W")
      return(.f.)
   ENDIF

   SELECT U_COR_TT
   SKIP +1

ENDDO

MESSAGEBOX('Operazione conclusa, Buon lavoro...',64,"Calcolo bilancio CEE")
