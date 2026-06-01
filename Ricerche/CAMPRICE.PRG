PARAMETERS V_SEEK

IF V_TYPEUSER = 1
   x_clie = "cmp_ragsoc like '" + ALLTRIM(M.CMP_RAGSOC) + "%'"
ELSE
   x_clie = "cmp_ragsoc = cmp_ragsoc"
ENDIF
x_cond = x_clie

*!*	IF V_TYPEUSER = 2
*!*	   x_tres = "cmp_tipres = 1"
*!*	   x_cond = x_cond + " and " + x_tres
*!*	ENDIF

*!*	IF V_TYPEUSER = 3
*!*	   x_tres = "cmp_dtcm03 <> SPACE(10)"
*!*	   x_cond = x_cond + " and " + x_tres
*!*	ENDIF

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER 'N°CAMPIONATURA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_numcmp like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cmp_numcmp like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr" 

   CASE V_SCELTA=2                         && ACCESSO PER 'DATA ARRIVO'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_datarr = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cmp_datarr = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr" 

   CASE V_SCELTA=3                         && ACCESSO PER 'CLIENTE'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cmp_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr" 
                                                 
   CASE V_SCELTA=4                         && ACCESSO PER 'AGENTE'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_desage like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cmp_desage like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr" 
                                                 
   CASE V_SCELTA=5                          && ACCESSO PER 'DA ANALIZZARE SUPERFICI'
        x_cod1   = "cmp_tipres = 1"
        x_cod2   = "cmp_dtcm02 = SPACE(10)"
        x_cond   = x_cond + " and " + x_cod1 + " and " + x_cod2
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"      
                                                 
   CASE V_SCELTA=6                         && ACCESSO PER 'ANALIZZATO SUPERFICI'
        x_cod1   = "cmp_tipres = 1"
        x_cod2   = "cmp_dtcm02 <> SPACE(10)"
        x_cond   = x_cond + " and " + x_cod1 + " and " + x_cod2
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"
                                                 
   CASE V_SCELTA=7                         && ACCESSO PER 'SENZA DISP.LOTTI'  X  CLIENTE

        x_codi = ""  && ERASMO 09/11/2006
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_codi   = "cmp_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
        x_cod1   = "(cmp_tipres = 1 and cmp_dtcm02 <> SPACE(10) and cmp_dtcm03 <> SPACE(10))"
        x_cod2   = "(cmp_tipres = 2 and cmp_dtcm03 <> SPACE(10))"
        x_cod3   = "cmp_dtcm0X = SPACE(10)"        
        IF EMPTY(x_codi)
           x_cond   = x_cond + " and (" + x_cod1 + " or " + x_cod2 + ") and " + x_cod3
        ELSE
           x_cond   = x_cond + " and (" + x_cod1 + " or " + x_cod2 + ") and " + x_cod3 + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"

   CASE V_SCELTA=8                         && ACCESSO PER 'SENZA DISP.LOTTI'  X  AGENTE
        
        x_codi = ""  && ERASMO 09/11/2006
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_desage like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_codi   = "cmp_desage like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
        x_cod1   = "(cmp_tipres = 1 and cmp_dtcm02 <> SPACE(10) and cmp_dtcm03 <> SPACE(10))"
        x_cod2   = "(cmp_tipres = 2 and cmp_dtcm03 <> SPACE(10))"
        x_cod3   = "cmp_dtcm0X = SPACE(10)"        
        IF EMPTY(x_codi)
           x_cond   = x_cond + " and (" + x_cod1 + " or " + x_cod2 + ") and " + x_cod3
        ELSE
           x_cond   = x_cond + " and (" + x_cod1 + " or " + x_cod2 + ") and " + x_cod3 + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_codage,cmp_ragsoc,cmp_datarr"
                                                 
   CASE V_SCELTA=9                         && ACCESSO PER 'CON DISP.LOTTI'
        x_cod1   = "(cmp_tipres = 1 and cmp_dtcm02 <> SPACE(10) and cmp_dtcm03 <> SPACE(10))"
        x_cod2   = "(cmp_tipres = 2 and cmp_dtcm03 <> SPACE(10))"
        x_cod3   = "cmp_dtcm0X <> SPACE(10)"        
        x_cond   = x_cond + " and (" + x_cod1 + " or " + x_cod2 + ") and " + x_cod3
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"                                                 
                                                 
   CASE V_SCELTA=10                         && ACCESSO PER 'DA RISPONDERE CAMPIONATURA'
        x_cod1   = "cmp_dtcm0X <> SPACE(10)"
        x_cod2   = "cmp_dtcm04 = SPACE(10)"
        x_cond   = x_cond + " and " + x_cod1 + " and " + x_cod2
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"
                                                 
   CASE V_SCELTA=11                        && ACCESSO PER 'RISPOSTA CAMPIONATURA'
        x_cod1   = "cmp_dtcm0X <> SPACE(10)"
        x_cod2   = "cmp_dtcm04 <> SPACE(10)"
        x_cond   = x_cond + " and " + x_cod1 + " and " + x_cod2
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"
                                                 
   CASE V_SCELTA=12                         && ACCESSO PER 'ARTICOLO'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cmp_artnum like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cmp_artnum like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cmp_cl where " + x_cond + ;
                                                 " order by cmp_numcmp,cmp_ragsoc,cmp_codage,cmp_datarr"                                                  
   
ENDCASE
