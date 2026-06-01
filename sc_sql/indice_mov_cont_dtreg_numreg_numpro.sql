IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'mov_cont_dtreg_numreg_numpro')
    DROP INDEX mov_cont_dtreg_numreg_numpro ON MOV_CONT;
GO

CREATE INDEX mov_cont_dtreg_numreg_numpro ON MOV_CONT ( MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE ) 



GO