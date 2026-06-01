* RICARICO IN AUTOMATICO DEL MAGAZZINO LOGISTICO

IF PUB_MLEBDT

   SCATTER MEMVAR MEMO 

   x_cond = "aggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   cSql = "select * from u_loc_mo where " + x_cond + " order by aggancio"
   IF !ExecCommand(cSql,"CU_LOC_MO")
   RETURN .F. 
   ENDIF
   SELECT CU_LOC_MO
   GO TOP
   IF EOF()
   ELSE

      DO WHILE .T.

         IF EOF()
            EXIT
         ENDIF

         SCATTER MEMVAR MEMO
 
         x_maga = "loc_codmag = '" + ALLTRIM(M.LOC_CODMAG) + "'"
         x_cors = "loc_corsia = '" + ALLTRIM(M.LOC_CORSIA) + "'"
         x_fila = "loc_fila = " + STR(M.LOC_FILA,2,0)
         x_pian = "loc_piano = " + STR(M.LOC_PIANO,2,0)
         x_codi = "loc_codart = '" + ALLTRIM(M.LOC_CODART) + "'"
         x_data = "loc_datcar = '" + ALLTRIM(M.LOC_DATCAR) + "'"                                    
         x_cond = x_maga + " and " + x_cors + " and " + x_fila + " and " + x_pian + " and " + x_codi + " and " + x_data
         cSql = "select * from u_loc_gi where " + x_cond + " order by loc_codmag,loc_corsia,loc_fila,loc_piano,loc_codart,loc_datcar"
         IF !ExecRW(cSql,"U_LOC_GI","R")
            return(.f.)
         ENDIF
         SELECT U_LOC_GI
         GO TOP
         IF EOF()
            APPEND BLANK
            GATHER MEMVAR MEMO
         ELSE
            REPLACE LOC_QTAGIA WITH LOC_QTAGIA + M.LOC_QTAGIA
         ENDIF 
         IF !ExecRW(cSql,"U_LOC_GI","W")
            return(.f.)
         ENDIF

         SELECT CU_LOC_MO
         SKIP +1

      ENDDO

      CSQL="DELETE FROM U_LOC_MO WHERE AGGANCIO = ?M.TAGGANCIO"
      IF !ExecCommand(CSQL,"U_LOC_MO")
         RETURN (.f.)
      ENDIF
   
   ENDIF         

ENDIF