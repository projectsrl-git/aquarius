/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [DBO].[U_ART_AN] ADD 
	ART_CHDIBA bit NULL
GO

ALTER TABLE [DBO].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_ART_CHDIBA] DEFAULT (0) FOR [ART_CHDIBA]
GO

UPDATE U_ART_AN SET ART_CHDIBA = 0