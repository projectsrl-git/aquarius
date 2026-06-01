**--> RIVALUTAZIONE COMPONENTISTICA

x_cond = "dit_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"CURSORE")
   RETURN .F.
ENDIF
SELECT CURSORE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   XAGGA = TAGGANCIO

   X_UNIQUE = ID_UNIQUE
   
   x_cond = "daggancio = '" + XAGGA + "'"
   cSql = "select * from u_dis_dd where " + x_cond + " order by daggancio"
   IF !ExecRW(cSql,"U_DIS_DD","R")
      RETURN .F.
   ENDIF
   SELECT U_DIS_DD
   GO TOP
   IF !EOF()

	  DO WHILE .T.
	     
	     IF EOF()
	        EXIT
	     ENDIF
 
		 IF DELETED()
		    SKIP +1
		    LOOP
	     ENDIF

         V_ESISTE = CERCADB(DIS_CODART)

         IF V_ESISTE = .T.
            IF DIS_TIPO = 'G'
            ELSE
               REPLACE DIS_TIPO WITH 'G'			&& ERA UN ARTICOLO NORMALE E ORA E' UNA DISTINTA BASE
            ENDIF
         ELSE   
            IF DIS_TIPO = 'G'
               REPLACE DIS_TIPO WITH 'A'			&& ERA UNA DISTINTA BASE E ORA DIVENTA UN ARTICOLO NORMALE
            ENDIF
         ENDIF   
                      
		 SELECT U_DIS_DD
		 SKIP +1

	  ENDDO
   ELSE
      CSQL="DELETE FROM U_DIS_TT WHERE ID_UNIQUE = ?X_UNIQUE"
      IF !ExecCommand(CSQL,"U_DIS_TT")
         RETURN (.f.)
      ENDIF      
      SELECT CURSORE
      SKIP +1
      LOOP
   ENDIF

   IF !ExecRW(cSql,"U_DIS_DD","W")
      RETURN .F.
   ENDIF

   SELECT CURSORE
   SKIP +1
    
ENDDO    

WAIT WINDOW "Fine rivalutazione componentistica"
   
RETURN