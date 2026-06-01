/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	ORD_OKEMAIL numeric (4,0) NULL
go

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_OKEMAIL] DEFAULT (0) FOR [ORD_OKEMAIL]
go

UPDATE U_FAT_TT SET ORD_OKEMAIL = 0 
