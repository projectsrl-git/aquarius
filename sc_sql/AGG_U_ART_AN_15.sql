/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_NONVAL BIT NULL
go

ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_ART_NONVAL] DEFAULT (0) FOR [ART_NONVAL]
go


UPDATE U_ART_AN SET ART_NONVAL = 0
