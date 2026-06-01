*****************************************************************************************
* 	PROCEDURA PER LA SOSTITUZIONE DESCRIZIONE ANAGRAFICA ARTICOLI SU ARCHIVI AQUARIUS   *
*   DA ANAGRAFICA ARTICOLI																*
*****************************************************************************************

_CTR = 0

CSQL="DELETE FROM U_ART_PR WHERE ART_CODPRI = ''"
IF !ExecCommand(CSQL,"U_ART_PR")
   RETURN (.f.)
ENDIF 

PUBLIC VAR1[14]     && VAR1 rappresenta un vettore di stringhe rappresentanti data-bases 
VAR1[1]	= "U_ORD_DD"
VAR1[2]	= "U_FAT_DD"
VAR1[3]	= "U_OFF_DD"
VAR1[4]	= "U_BOL_DD"
VAR1[5]	= "U_FAP_DD"
VAR1[6]	= "U_ORF_DD"
VAR1[7]	= "U_COM_DD"
VAR1[8]	= "U_CTL_DD"
VAR1[9]	= "U_MAG_AN"
VAR1[10]= "U_COM_ED"
VAR1[11]= "S_COM_ED"
VAR1[12]= "U_DIS_DD"
VAR1[13]= "U_STC_AN"
VAR1[14]= "U_MAG_MO"

**FOR I=1 TO 14  && MOVIMENTI DI MAGAZZINO NON GESTITI
FOR I=1 TO 13
    
    _CTR = 0 
    
    cSql = "select * from u_art_pr order by art_codsoc,art_codpri"
    IF !ExecCommand(cSql,"CUR_ARTICOLI")
       RETURN .F.
    ENDIF
    SELECT CUR_ARTICOLI
    GO TOP

    DO WHILE .T.
 
       IF EOF()
          EXIT
       ENDIF
 
       IF DELETED()
          SKIP +1
          LOOP
       ENDIF
 
       VCODART = ART_CODPRI
       VDESART = ART_DESCR 
 
       DO CASE 

  		  CASE I=1			&& U_ORD_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_ord_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_ORD_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_ORD_DD
               GO TOP

  		  CASE I=2			&& U_FAT_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_fat_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_FAT_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_FAT_DD
               GO TOP

  		  CASE I=3			&& U_OFF_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_off_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_OFF_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_OFF_DD
               GO TOP

  		  CASE I=4			&& U_BOL_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_bol_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_BOL_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_BOL_DD
               GO TOP

  		  CASE I=5			&& U_FAP_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_fap_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_FAP_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_FAP_DD
               GO TOP

  		  CASE I=6  		&& U_ORF_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_orf_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_ORF_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_ORF_DD
               GO TOP

  		  CASE I=7			&& U_COM_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_com_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_COM_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_COM_DD
               GO TOP

  		  CASE I=8			&& U_CTL_DD
               
               x_cond = "ord_codart = '" + VCODART + "'"
               cSql = "select * from u_ctl_dd where " + x_cond + " order by ord_codart"
               IF !ExecRW(cSql,"U_CTL_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_CTL_DD
               GO TOP

  		  CASE I=9			&& U_MAG_AN
               
               x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
               x_codi = "mag_codart = '" + VCODART + "'"
               x_cond = x_soci + " and " + x_codi
               cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codart"
               IF !ExecRW(cSql,"U_MAG_AN","R")
                  RETURN .F.
               ENDIF
               SELECT U_MAG_AN
               GO TOP

 		  CASE I=10			&& U_COM_ED
 		  
               x_cond = "lcd_codart = '" + VCODART + "'"
               cSql = "select * from u_com_ed where " + x_cond + " order by lcd_codart"
               IF !ExecRW(cSql,"U_COM_ED","R")
                  RETURN .F.
               ENDIF
               SELECT U_COM_ED
               GO TOP

		  CASE I=11			&& S_COM_ED

               x_cond = "lcd_codart = '" + VCODART + "'"
               cSql = "select * from s_com_ed where " + x_cond + " order by lcd_codart,lcd_codmag,lcd_numcom,lcd_datsca"
               IF !ExecRW(cSql,"S_COM_ED","R")
                  RETURN .F.
               ENDIF
               SELECT S_COM_ED
               GO TOP

 		  CASE I=12			&& U_DIS_DD
 		  
               x_cond = "dis_codart = '" + VCODART + "'"          
               cSql = "select * from u_dis_dd where " + x_cond + " order by dis_codart"
               IF !ExecRW(cSql,"U_DIS_DD","R")
                  RETURN .F.
               ENDIF
               SELECT U_DIS_DD
               GO TOP

*!*	 		  CASE I=13			&& U_STC_AN
*!*	 		  
*!*	               x_cond = "stc_codart = '" + VCODART + "'"          
*!*	               cSql = "select * from u_stc_an where " + x_cond + " order by stc_codart"
*!*	               IF !ExecRW(cSql,"U_STC_AN","R")
*!*	                  RETURN .F.
*!*	               ENDIF
*!*	               SELECT U_STC_AN
*!*	               GO TOP

		  CASE I=14			&& U_MAG_MO

               x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
               x_codi = "mov_codart = '" + VCODART + "'"
               x_cond = x_soci + " and " + x_codi
               cSql = "select * from u_mag_mo where " + x_cond + " order by mov_codsoc,mov_codart"
               IF !ExecRW(cSql,"U_MAG_MO","R")
                  RETURN .F.
               ENDIF
               SELECT U_MAG_MO
               GO TOP
	
       ENDCASE
	 
       WAIT WINDOWS "Archivio in elaborazione "+VAR1[I] NOWAIT

       DO WHILE .T.
          
          IF EOF()
             EXIT
          ENDIF
          
          IF DELETED()
             SKIP +1
             LOOP
          ENDIF

          _CTR = _CTR + 1
 
          IF I<=8
             IF ORD_CODART<VCODART
                SKIP +1
                LOOP
             ENDIF
             IF ORD_CODART>VCODART
                EXIT
             ENDIF
             REPLACE ORD_DESART WITH VDESART
             WAIT WINDOWS "Archivio in elaborazione "+VAR1[I]+" - "+STR(_CTR,7,0) NOWAIT
          ENDIF
        
          IF I==9
             IF MAG_CODART<VCODART
                SKIP +1
                LOOP
             ENDIF
             IF MAG_CODART>VCODART
                EXIT
             ENDIF         
             REPLACE MAG_DESART WITH VDESART
             WAIT WINDOWS "Archivio in elaborazione "+VAR1[I]+" - "+STR(_CTR,7,0) NOWAIT
          ENDIF 
          
          IF I>9 .AND. I<12
 	         IF LCD_CODART<VCODART
                 SKIP +1
                 LOOP
             ENDIF
             IF LCD_CODART>VCODART
                 EXIT
             ENDIF
             REPLACE LCD_DESART WITH VDESART
             WAIT WINDOWS "Archivio in elaborazione "+VAR1[I]+" - "+STR(_CTR,7,0) NOWAIT
          ENDIF
  
          IF I==12
             IF DIS_CODART<VCODART
                SKIP +1
                LOOP
             ENDIF
             IF DIS_CODART>VCODART
               EXIT
             ENDIF       
             REPLACE DIS_DESCRI WITH VDESART
             WAIT WINDOWS "Archivio in elaborazione "+VAR1[I]+" - "+STR(_CTR,7,0) NOWAIT
          ENDIF
  
          IF I==13
             IF STC_CODART<VCODART
         		SKIP +1
         		LOOP
         	 ENDIF
         	 IF STC_CODART>VCODART
         		EXIT
         	 ENDIF
           	 REPLACE STC_DESART WITH VDESART
             WAIT WINDOWS "Archivio in elaborazione "+VAR1[I]+" - "+STR(_CTR,7,0) NOWAIT
          ENDIF                    

          IF I==14
          	 IF MOV_CODART<VCODART
         		SKIP +1
         		LOOP
         	 ENDIF
         	 IF MOV_CODART>VCODART
         		EXIT
         	 ENDIF
             * REPLACE MOV_DESART WITH	VDESART
             WAIT WINDOWS "Archivio in elaborazione "+VAR1[I]+" - "+STR(_CTR,7,0) NOWAIT
          ENDIF                    
   
          SKIP +1
   
       ENDDO    

       DO CASE

  		  CASE I=1			&& U_ORD_DD
  		                 
               IF !ExecRW(cSql,"U_ORD_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=2			&& U_FAT_DD
               
               IF !ExecRW(cSql,"U_FAT_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=3			&& U_OFF_DD
               
               IF !ExecRW(cSql,"U_OFF_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=4			&& U_BOL_DD
               
               IF !ExecRW(cSql,"U_BOL_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=5			&& U_FAP_DD
               
               IF !ExecRW(cSql,"U_FAP_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=6  		&& U_ORF_DD
               
               IF !ExecRW(cSql,"U_ORF_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=7			&& U_COM_DD
               
               IF !ExecRW(cSql,"U_COM_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=8			&& U_CTL_DD
               
               IF !ExecRW(cSql,"U_CTL_DD","W")
                  RETURN .F.
               ENDIF

  		  CASE I=9			&& U_MAG_AN
               
               IF !ExecRW(cSql,"U_MAG_AN","W")
                  RETURN .F.
               ENDIF

 		  CASE I=10			&& U_COM_ED
 		  
               IF !ExecRW(cSql,"U_COM_ED","W")
                  RETURN .F.
               ENDIF

		  CASE I=11			&& S_COM_ED

               IF !ExecRW(cSql,"S_COM_ED","W")
                  RETURN .F.
               ENDIF

 		  CASE I=12			&& U_DIS_DD
 		  
               IF !ExecRW(cSql,"U_DIS_DD","W")
                  RETURN .F.
               ENDIF

*!*	 		  CASE I=13			&& U_STC_AN
*!*	 		  
*!*	               IF !ExecRW(cSql,"U_STC_AN","W")
*!*	                  RETURN .F.
*!*	               ENDIF

		  CASE I=14			&& U_MAG_MO

               IF !ExecRW(cSql,"U_MAG_MO","W")
                  RETURN .F.
               ENDIF
	
       ENDCASE
                 
       SELECT CUR_ARTICOLI
       SKIP +1
    ENDDO     

NEXT

RIT = MESSAGEBOX("Operazione terminata "+CHR(13)+"correttamente",16,"ATTENZIONE")