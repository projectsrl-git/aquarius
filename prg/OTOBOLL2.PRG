*!*	DEFINE WINDOW WSELESOC;
*!*	AT 0,0 SIZE 20,100;
*!*	SYSTEM CLOSE NOGROW FLOAT;
*!*	FONT 'Courier New',8
*!*	MOVE WINDOW WSELESOC CENTER

V_EVASIONE = 0
V_EVASPARZ = 0
OK_PROC    = .F.

SELECT CU_ORD_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
  
   AGGA    = TAGGANCIO
   VRAGSOC = ALLTRIM(ORD_RAGEMI)
   VNUMORD = ORD_NUMORD
   VDATORD = RIBALTA2(ORD_DATORD)
  
   x_cond = "daggancio = '" + ALLTRIM(AGGA) + "'"
   Csql   = "select * from u_ord_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF  
   SELECT U_ORD_DD
   GO TOP

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DELETED()
         SKIP +1
         LOOP
      ENDIF

      IF (!("*** COMMENTO ***" $ ORD_DESART) .AND. !ORD_CHIUSO .AND. ORD_QTAORD > ORD_QTAEV)
      ELSE
         SKIP +1
         LOOP
      ENDIF

*!*	      V_MAGA = ORS_MAGS
*!*	      V_ARTI = ORD_CODART
*!*	      IF PUB_CTRGIA 
*!*	         SELECT CU_MAG_AN
*!*	         GO TOP
*!*	         LOCATE FOR MAG_CODSOC = PUB_CODSOC .AND. ;
*!*	                    MAG_CODMAG = V_MAGA .AND. ;
*!*	                    MAG_CODART = V_ARTI
*!*	         IF FOUND()
*!*	            V_GIACE = MAG_GIACEN
*!*	         ELSE
*!*	            x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
*!*	            x_codi = "mag_codmag = '" + V_MAGA + "'"
*!*	            x_arti = "mag_codart = '" + V_ARTI + "'"
*!*	            x_cond = x_soci + " and " + x_codi + " and " + x_arti
*!*	            cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
*!*	            IF !ExecCommand(cSql,"CUR_GIACENZE")
*!*	              RETURN .F.
*!*	            ENDIF
*!*	            SELECT CUR_GIACENZE
*!*	            GO TOP   
*!*	            IF EOF()               
*!*	               V_GIACE = 0
*!*	            ELSE
*!*	               V_GIACE = MAG_GIACEN
*!*	            ENDIF
*!*	         ENDIF
*!*	      ELSE
*!*	         x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
*!*	         x_codi = "mag_codmag = '" + V_MAGA + "'"
*!*	         x_arti = "mag_codart = '" + V_ARTI + "'"
*!*	         x_cond = x_soci + " and " + x_codi + " and " + x_arti
*!*	         cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
*!*	         IF !ExecCommand(cSql,"CUR_GIACENZE")
*!*	            RETURN .F.
*!*	         ENDIF
*!*	         SELECT CUR_GIACENZE
*!*	         GO TOP   
*!*	         IF EOF()               
*!*	            V_GIACE = 0
*!*	         ELSE
*!*	            V_GIACE = MAG_GIACEN
*!*	         ENDIF         
*!*	      ENDIF         

		**=> ERASMO - INIZIO 26/10/2011
		_ww_codsoc = PUB_CODSOC
		_ww_anaart = ORD_CODART
		_ww_codmag = ORD_MAGA
		_ww_prenot = .T.  && SOLO GIACENZE NON PRENOTATE
		_ww_codint = ""
		_ww_altezz = ORD_ALTEZZ
		_ww_lunghe = ORD_LUNGHE
		_ww_fila_x = ""
		_ww_pian_x = ""
		_ww_ubic_x = ""
		_GIACENZA = AQM_RILEVA_GIACENZE_DISPONIBILI(_ww_codsoc,_ww_anaart,_ww_codmag,_ww_prenot,_ww_codint,_ww_altezz,_ww_lunghe,_ww_fila_x,_ww_pian_x,_ww_ubic_x)
		V_GIACE = _GIACENZA
		**=> ERASMO - FINE 26/10/2011
	
      SELECT U_ORD_DD
      REPLACE ORD_QTAORG WITH V_GIACE
      REPLACE ORD_QTADEV WITH ORD_QTAORD - ORD_QTAEV
      *IF ORD_QTADEV < 1
      IF ORD_QTADEV < 0  && ERASMO - 26/10/2011
         REPLACE ORD_QTADEV WITH 0
      ENDIF
      SKIP +1
   ENDDO      
  
   SELECT U_ORD_DD
   GO TOP

   V_EVASPARZ = 0
  
   DO WHILE .T.
      
      IF EOF()
         EXIT
      ENDIF
  
      V_EVASIONE = V_EVASIONE + ORD_QTADEV
      V_EVASPARZ = V_EVASPARZ + ORD_QTADEV
 
      SKIP +1  

   ENDDO                  

   IF V_EVASIONE<>0
      OK_PROC = .T.
   ENDIF

   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF
  
   SELECT CU_ORD_TT
   SKIP +1
  
ENDDO

RELEASE WINDOWS WSELESOC

RETURN
