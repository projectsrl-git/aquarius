
/* 
************************************************************************
INSERIMENTO NUOVO CAMPO PER STATO DICHIARAZIONE DI CONFORMITA' VISIONATA
************************************************************************
*/
ALTER TABLE [DBO].[U_BFO_DD] ADD 
	FLGVISMDCA BIT NOT NULL DEFAULT (0)
GO
