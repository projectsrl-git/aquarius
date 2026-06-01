/* 
******************************************************************
VARIAZIONE DIMENSIONI CAMPO U_DIS_TT.DIT_CODIVA DA 2 A 3 CARATTERI
******************************************************************
*/
ALTER TABLE [dbo].[U_DIS_TT] ALTER COLUMN
	 DIT_CODIVA varchar(3) COLLATE Latin1_General_CI_AS NULL 
GO

/* 
******************************************************************
AGGIORNAMENTO CAMPO U_DIS_TT.DIT_CODIVA DA ANAGRAFICA ARTICOLI
******************************************************************
*/
UPDATE U_DIS_TT SET DIT_CODIVA = (SELECT COALESCE(ART_CODIVA,'') FROM U_ART_PR WHERE ART_CODPRI = U_DIS_TT.DIT_GRUPPO)