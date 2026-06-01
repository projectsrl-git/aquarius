PARAMETERS V_SEEK

x_soci = "bpn_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
x_sele = "dbo.ribalta2(BPN_DATADAL) as BPN_DATADAL_RIBALTATA, dbo.ribalta2(BPN_DATAAL) as BPN_DATAAL_RIBALTATA, case BPN_FATCLFO WHEN 1 THEN 'SI' ELSE '' END AS SOLO_FATTURE, " + ;
         "case BPN_OPZCF when 2 then 'Solo fatture clienti' when 3 then 'Solo fatture fornitori' else '' end AS OPZ_FATTURE"  && ERASMO - 27/01/2021

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER DATA DAL
 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nord   = "BPN_DATADAL = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select " + x_sele + ", * from BLOCCAPN where " + x_cond + " order by bpn_codsoc,bpn_datadal,bpn_dataal" 
        ELSE
           x_nord   = "BPN_DATADAL = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select " + x_sele + ", * from BLOCCAPN where " + x_cond + ;
                                                 " order by bpn_codsoc,bpn_datadal,bpn_dataal" 
 
   CASE V_SCELTA=2                          && ACCESSO PER DATA AL
   
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nord   = "BPN_DATAAL = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select " + x_sele + ", * from BLOCCAPN where " + x_cond + ;
                                                    " order by bpn_codsoc,bpn_datadal,bpn_dataal" 
        ELSE
           x_nord   = "BPN_DATAAL = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select " + x_sele + ", * from BLOCCAPN where " + x_cond + ;
                                                 " order by bpn_codsoc,bpn_datadal,bpn_dataal" 

ENDCASE