* RICARICO IN AUTOMATICO DEL MAGAZZINO DIREZIONALE

IF PUB_CLIDIR

   XX=SELECT()
   
   SCATTER MEMVAR MEMO 

   x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   Csql   = "select * from u_bol_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(cSql,"CUR_DETT")
      RETURN .F.
   ENDIF 
   SELECT CUR_DETT
   GO TOP
   IF !EOF()
      DO WHILE .T.

         IF EOF()
            EXIT
         ENDIF

         IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   
            SKIP +1
            LOOP
         ENDIF   

         SCATTER MEMVAR MEMO

         x_codi = "mov_codord = '" + ALLTRIM(M.MOV_CODORD) + "'"
         x_nume = "mov_numord = '" + ALLTRIM(M.MOV_NUMORD) + "'"
         x_data = "mov_datord = '" + ALLTRIM(M.MOV_DATORD) + "'"
         x_tipo = "mov_tipord = '" + ALLTRIM(M.MOV_TIPORD) + "'"
         x_arti = "mov_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
         x_maga = "mov_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"                                             
         x_cond = x_codi + " and " + x_nume + " and " + x_data + " and " + x_tipo + " and " + x_arti + " and " + x_maga
         cSql = "select * from u_mag_cl where " + x_cond + " order by mov_codord,mov_numord,mov_datord,mov_tipord,mov_codart,mov_codmag"
         IF !ExecRW(cSql,"U_MAG_CL","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_CL
         GO TOP   
         IF EOF()
         ELSE
            REPLACE MOV_QTAGIA WITH MOV_QTAGIA + M.ORD_QTAORD
            IF MOV_FLGFAT = .T.
               IF MOV_NUMFAT = SPACE(06) .OR. EMPTY(MOV_NUMFAT)
                  REPLACE MOV_FLGFAT WITH .F.
               ENDIF
            ENDIF
         ENDIF    
         IF !ExecRW(cSql,"U_MAG_CL","W")
            return(.f.)
         ENDIF

         SELECT CUR_DETT
         SKIP +1

      ENDDO

   ENDIF         

   SELECT(XX)

ENDIF