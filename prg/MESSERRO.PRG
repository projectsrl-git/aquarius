
***********************************************************************
* PROCEDURA - MESSERRO     Data: 08.10.98   Autore: Project
***********************************************************************
*
*  FUNZIONE CHE INTERCETTA ERRORI DI PROGRAMMA
*  SE INTERCETTA ERRORE:
*            VALORIZZA _X_FINEOK = .F. 
*            VALORIZZA _X_MOTIVO = MESSAGGIO DI ERRORE CHE VIENE MEMORIZZATO
*                                  NEL LOG DELLE PROCEDURE
*  Sintassi:
*  ON ERROR DO MESSERRO(_PARA1,_PARA2,_PARA3,_PARA4)
*
*  Descrizione parametri:
*  _PARA1= Nome della procedura dove si è verificato l'errore
*  _PARA2= Tipologia di errore da gestire
*  _PARA3= Descrizione della procedura in cui si è verificato l'errore
*  _PARA4= Libero
*
**************************
PARA _PARA1,_PARA2,_PARA3,_PARA4

IF PARAMETER() < 2
  _PARA2=0
  _PARA3=""
  _PARA4=""
ENDIF

IF PARAMETER() < 3
  _PARA3=""
  _PARA4=""
ENDIF

IF PARAMETER() < 4
  _PARA4=""
ENDIF


_FILE_ATTIVA_SCRITTURA_LOG = SYS(5)+SYS(2003)+'\'+"__MESSERROLOG__"
IF !FILE(_FILE_ATTIVA_SCRITTURA_LOG)
	RETURN .T.
ENDIF


_x_motivo = "Caso non gestito"


_mes_err_sele=select()
if !file("LOGERROR.DBF")
  create dbf logerror free(data t(8),;
  						   wrk c(60),;
  						   utente c(10),;
  						   msg m(4))
  select logerror
  use
endif
select(_mes_err_sele)




DO CASE
  CASE _PARA2=0
*      SET STEP ON
*      SET ECHO ON
*     PUB_ABEND=.T.
*     _X_FINEOK=.F.
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
               
  CASE _PARA2=1
  	 = AERROR(aErrorArray)  && Data from most recent error

     ___STRINGA_ERRORE_ODBC='ERRORE ODBC: DETTAGLIO ERRORE'+CHR(13)
     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ "Codice errore: "+STR(aErrorArray(1))+"<--"+CHR(13)
     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ "Descr. errore: "+aErrorArray(2)+"<--"+CHR(13)
*!*	     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ aErrorArray(3)+"<--"+CHR(13)
*!*	     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ aErrorArray(4)+"<--"+CHR(13)
*!*	     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ aErrorArray(5)+"<--"+CHR(13)
*!*	     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ aErrorArray(6)+"<--"+CHR(13)
*!*	     ___STRINGA_ERRORE_ODBC=___STRINGA_ERRORE_ODBC+ STR(aErrorArray(7))+"<--"+CHR(13)
   
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())+CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())+CHR(10)+CHR(13)+CHR(13)+;
               ___STRINGA_ERRORE_ODBC
  CASE _PARA2=2
      PUB_ERRORE=999
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=3
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=4
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=5
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=6
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=7
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=8
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=9
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=998
     PUB_ERRORE=ERROR()
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=999
     _X_MOTIVO="Errore durante l'esecuzione della procedura "+_PARA1+CHR(13)+;
               "Descrizione procedura: "+_PARA3+CHR(10)+CHR(13)+;
               "Errore:    "+str(ERROR())+CHR(10)+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(10)+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(10)+CHR(13)+;
               "Tabella in uso: "+alias(select())++CHR(10)+CHR(13)+;
               "Rec-number: "+str(recno())
  CASE _PARA2=1000

ENDCASE


_mes_err_sele=select()
=opendb("logerror")
append blank
replace data	with datetime();
        wrk		with sys(0);
        utente  with pub_codope;
        msg		with _x_motivo
SELECT logerror
USE
        
select(_mes_err_sele)


*     IF ERROR()=1884
*       =MESSAGEB("Nel tentativo di aggiornare il database sul server, è stato riscontrato un errore di connessione"+chr(13)+;
*                 "sulla rete, pertanto non sono possibili ulteriori aggiornamenti."+chr(13)+;
*                 "E' necessario eseguire una ricostruzione indici COMPLETA per correggere eventuali anomalie "+chr(13)+;
*                 "E' opportuno verificare la stabilità della rete per evitare che questo problema si ripresenti!!!!!"+chr(13)+chr(13)+;
*                 "L'APPLICAZIONE VIENE INTERROTTA IN ATTESA DELLA RICOSTRUZIONE INDICI COMPLETA",16,"*** RISCONTRATO PROBLEMA SULLA RETE ***")
*       CLEAR EVENTS
*       QUIT
*     ENDIF


RETURN(.T.)


**************************************************************************
* Procedura - OPENDB                    Data: 10.11.95   Autore: Project
**************************************************************************
* Procedura da utilizzare per aprire un DB
*
PROCEDURE OPENDB
PARA V1
IF !USED(V1)
   USE &V1 IN 0 AGAIN
ENDIF
SELECT &V1
SET FILTER TO
SET ORDER TO
GO TOP
RETURN
*EOF Procedure: OPENDB
