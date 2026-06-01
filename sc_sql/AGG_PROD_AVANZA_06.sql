
/* 
************************************************************************
INSERIMENTO NUOVO CAMPO PER STATO DICHIARAZIONE DI CONFORMITA' VISIONATA
************************************************************************
*/
ALTER TABLE [DBO].[PROD_AVANZA] ADD 
	FLGVISMDCP BIT NOT NULL DEFAULT (0)
GO
