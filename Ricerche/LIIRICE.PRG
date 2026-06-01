PARAMETERS V_SEEK

x_cond = "1=1"

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "LIS_CODLIS = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "LIS_CODLIS = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select  substring(LIS_NOTELIS,1,254) as lis_notelis_r,dbo.ribalta2(lis_datlis) as lis_data_dal_r,dbo.ribalta2(lis_allist) as lis_data_al_r,* from IMPIANTI_LI where " + x_cond + ;
                                                 " order by LIS_CODLIS" 

   CASE V_SCELTA=2          				&& ACCESSO PER DATA
 		
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
          ELSE
           x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select substring(LIS_NOTELIS,1,254) as lis_notelis_r,dbo.ribalta2(lis_datlis) as lis_data_dal_r,dbo.ribalta2(lis_allist) as lis_data_al_r, * from IMPIANTI_LI where " + x_cond + ;
 		           " order by lis_datlis,LIS_CODLIS " 


   CASE V_SCELTA=3          				&& CODICE RAGRUPPAMENTO


        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_impia = "lis_codrag like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_impia 
           ENDIF
           _ii_cSql   = x_cond + " order by lis_codrag" 
        ELSE
           x_impia = "lis_codrag like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_impia 
        ENDIF
        _ii_cSql = "select  substring(LIS_NOTELIS,1,254) as lis_notelis_r,dbo.ribalta2(lis_datlis) as lis_data_dal_r,dbo.ribalta2(lis_allist) as lis_data_al_r,* from IMPIANTI_LI where " + x_cond + ;
                                                 " order by lis_codrag" 







  
ENDCASE
