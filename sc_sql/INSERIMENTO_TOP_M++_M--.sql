
-- INSERIMENTO PARAMETRI DI RICARICO AUTOMATICO MAGAZZINO

DECLARE @DATA_OGGI_ISO_cAAAAMMGG VARCHAR(8)
DECLARE @DATA_OGGI_TXT_cAAAAMMGG VARCHAR(10)

SET @DATA_OGGI_ISO_cAAAAMMGG = CONVERT(VARCHAR(8), Getdate(), 112)
SET @DATA_OGGI_TXT_cAAAAMMGG = Substring(@DATA_OGGI_ISO_cAAAAMMGG, 1, 4) + '/' +
							   Substring(@DATA_OGGI_ISO_cAAAAMMGG, 5, 2) + '/' +
							   Substring(@DATA_OGGI_ISO_cAAAAMMGG, 7, 2)

DELETE FROM PARA WHERE CODICE = 'TOPM++'
INSERT INTO PARA
            (CODICE,
             DESCRI,
			 LIBERA,
			 PAR_DATINS)
VALUES		('TOPM++',
			 'Ricarico automatico magazzino durante la modifica della DDT',
			 'CN      NNNN                    MOM--   NM',
			 @DATA_OGGI_TXT_cAAAAMMGG)

DELETE FROM PARA WHERE CODICE = 'TOPM--'
INSERT INTO PARA
            (CODICE,
             DESCRI,
			 LIBERA,
			 PAR_DATINS)
VALUES		('TOPM--',
			 'Scarico automatico magazzino durante la modifica della BFO',
			 'SN      NNNN                    MOM++   NM',
			 @DATA_OGGI_TXT_cAAAAMMGG)


