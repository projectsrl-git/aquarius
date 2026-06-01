PARAMETERS V_SEEK

x_cond = "cer_agganc = cer_agganc"

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER Num.DDT
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_numddt = '" + TRC(6,ALLTRIM(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_numddt = '" + TRC(6,ALLTRIM(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_numddt,cer_datddt" 

   CASE V_SCELTA=2          				&& ACCESSO PER Data DDT
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_datddt = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_datddt = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_datddt,cer_numddt" 
 		
   CASE V_SCELTA=3          				&& ACCESSO PER Rag.Soc.Cliente
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_ragsoc,cer_datddt" 
   
   CASE V_SCELTA=4          				&& ACCESSO PER Articolo
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_codart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_codart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_codart,cer_ragsoc,cer_datddt" 

   CASE V_SCELTA=5          				&& ACCESSO PER Num.lotto
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_nrlint = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_nrlint = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_nrlint,cer_ragsoc,cer_datddt" 
                                                 
   CASE V_SCELTA=6          				&& ACCESSO PER Tipo Prg.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_tipprg = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_tipprg = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_tipprg,cer_numprg,cer_amgprg"                                                  

   CASE V_SCELTA=7          				&& ACCESSO PER Num.Prg.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_numprg = '" + TRC(6,ALLTRIM(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_numprg = '" + TRC(6,ALLTRIM(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_numprg,cer_amgprg" 
                                                 
   CASE V_SCELTA=8          				&& ACCESSO PER Data Prg.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cer_amgprg = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cer_amgprg = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cer_co where " + x_cond + ;
                                                 " order by cer_amgprg,cer_numprg"                                           
   
ENDCASE
