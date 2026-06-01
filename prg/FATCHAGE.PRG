**********************************************************************
* CAMBIA IL CODICE AGENTE		SU FATTURE		 				     *
*																	 *
**********************************************************************


**=> ERASMO - INIZIO 16/03/2012

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_agen = "ord_age = '" + ALLTRIM(AGEDAL) + "'"
x_cond = x_soci + " and " + x_data + " and " + x_agen


**=> ERASMO - FINE 16/03/2012
cSql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_codcli,ord_age"
IF !ExecRW(cSql,"u_fat_tt","R")
   RETURN .F.
ENDIF
SELECT u_fat_tt

**=> ERASMO - INIZIO 16/03/2012
REPLACE SELEZIONE WITH "" ALL
GO TOP
IF EOF()
	MESSAGEBOX("Nessuna fattura con il codice agente selezionato",16,"Attenzione")
	IF !ExecRW(cSql,"u_fat_tt","W")
	   RETURN .F.
	ENDIF
	RETURN .F.
ENDIF

DO prg\browseview WITH "u_fat_tt","Selezionare le fatture per i quali modificare il codice agente","ORD_AGE:Agente,W:07;ORD_CODCLI:Codice,W:20;ORD_NUMORD:Num.ord.,W:08;ORD_DATORD:Data.ord.,W:12;ORD_ragsoc:Ragione Sociale,W:60;",610,600,.T.,.F.

SELECT u_fat_tt
**=> ERASMO - FINE 16/03/2012

GO TOP


WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT


CT      = 0
CTRELAB = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   **=> ERASMO - INIZIO 16/03/2012
   IF EMPTY(SELEZIONE)
      SKIP + 1
      LOOP
   ENDIF
   
     
	x_dt1     = ord_datord
	x_numo    = ord_numord
	x_codc    = ord_codcli

	x_clie    = "prv_codcli = '" + x_codc + "'"
	x_numo    = "prv_numfat = '" + x_numo + "'"
	x_data    = "prv_datfat = '" + x_dt1 + "'"

    cSql   = "DELETE FROM U_PRV_AN WHERE  " + x_clie + " and " + x_numo  + " and " + x_data    


	IF !ExecCommand(CSQL,"U_PRV_AN")
	   RETURN (.f.)
	ENDIF 
     
     
   SELECT U_FAT_TT
   REPLACE ORD_AGE WITH AGEAL
 
   CT = CT +1
   WAIT WINDOWS "Fatture aggiornate "+STR(CT,9,0) NOWAIT

   SKIP +1




ENDDO

IF !ExecRW(cSql,"U_FAT_TT","W")
   RETURN .F.
ENDIF 

=MESSAGEBOX("Fine elaborazione",64,"ATTENZIONE")

RELEASE WINDOW DISPLAY