X_QUALE = ALLTRIM(STR(V_QUALE))

Z_CDDOC = "M.AST_CDDOC&X_QUALE"
Z_ANNO  = "M.AST_ANNO&X_QUALE"
Z_NUMDA = "M.AST_NUMDA&X_QUALE"
Z_NUMAL = "M.AST_NUMAL&X_QUALE"
Z_DATDA = "RIBALTA2(M.AST_DATDA&X_QUALE)"
Z_DATAL = "RIBALTA2(M.AST_DATAL&X_QUALE)"

Z_CODCCO = "M.AST_CODCCO"

W_CODCCO = &Z_CODCCO

W_CDDOC = &Z_CDDOC
W_ANNO  = &Z_ANNO
W_NUMDA = &Z_NUMDA
W_NUMAL = &Z_NUMAL
W_DATDA = &Z_DATDA
W_DATAL = &Z_DATAL

IF W_DATDA = SPACE(10) .AND. ;
   W_DATAL = SPACE(10)
   V_OK = .T.
   RETURN
ENDIF

x_codi = "ast_codsoc = '" + M.AST_CODSOC + "'"
x_data = "ast_datsca = ast_datsca"
x_nsca = "ast_numsca = ast_numsca"
x_clie = "ast_codcli = '" + M.AST_CODCLI + "'"
x_cond = x_codi + " and " + x_data + " and " + x_nsca + " and " + x_clie
cSql = "select * from u_ast_an where " + x_cond + " order by ast_datsca,ast_numsca,ast_codcli"
IF !ExecCommand(cSql,"CU_AST_AN")
  return(.f.)
ENDIF
SELECT *                                                                             ;
FROM CU_AST_AN                                                                        ;  
WHERE AST_CODLOC = M.AST_CODLOC AND (                                                ;
       (AST_CDDOC1 <> SPACE(03) AND AST_CDDOC1 = W_CDDOC AND AST_ANNO1  = W_ANNO AND AST_CODCCO = W_CODCCO AND;
        (                        ;
         (AST_DATDA1 = W_DATDA AND AST_DATAL1 = W_DATAL)))                           ;
      OR ;
       (AST_CDDOC2 <> SPACE(03) AND AST_CDDOC2 = W_CDDOC AND AST_ANNO2  = W_ANNO AND AST_CODCCO = W_CODCCO AND  ;
        (                          ;
         (AST_DATDA2 = W_DATDA AND AST_DATAL2 = W_DATAL)))                           ;
      OR ;
       (AST_CDDOC3 <> SPACE(03) AND AST_CDDOC3 = W_CDDOC AND AST_ANNO3  = W_ANNO AND AST_CODCCO = W_CODCCO AND  ;
        (                         ;
         (AST_DATDA3 = W_DATDA AND AST_DATAL3 = W_DATAL)))                           ;
      OR ;
       (AST_CDDOC4 <> SPACE(03) AND AST_CDDOC4 = W_CDDOC AND AST_ANNO4  = W_ANNO AND AST_CODCCO = W_CODCCO AND  ;
        (                         ;
         (AST_DATDA4 = W_DATDA AND AST_DATAL4 = W_DATAL)))                           ;
      OR ;
       (AST_CDDOC5 <> SPACE(03) AND AST_CDDOC5 = W_CDDOC AND AST_ANNO5  = W_ANNO AND AST_CODCCO = W_CODCCO AND  ;
        (                          ;
         (AST_DATDA5 = W_DATDA AND AST_DATAL5 = W_DATAL)))                           ;
                                    ) ;       
INTO CURSOR PIPPO

SELECT PIPPO
GO TOP

IF EOF()
   V_OK = .T.
ELSE
   X_NUMSCA = ALLTRIM(AST_NUMSCA)
   X_NUMSCH = ALLTRIM(AST_NUMSCH)
   IF ZTB.ININSERIMENTO
      V_OK = .F.
   ELSE
      IF ALLTRIM(M.AST_NUMSCA) = X_NUMSCA .AND. ALLTRIM(M.AST_NUMSCH) = X_NUMSCH 
         V_OK = .T.
      ELSE
         V_OK = .F.
      ENDIF
   ENDIF
ENDIF


* V_OK = .T.

RETURN