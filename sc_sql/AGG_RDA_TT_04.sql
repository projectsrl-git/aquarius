/* 
**************************************************************
ALLARGAMENTO CAMPO CODICE UTENTE RICHIEDENTE A 20 CARATTERI
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT]
	ALTER COLUMN CODRIC VARCHAR(20) COLLATE Latin1_General_CI_AS NULL

GO
