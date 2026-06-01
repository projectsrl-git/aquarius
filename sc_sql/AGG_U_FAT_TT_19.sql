/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	ORD_PERPAG numeric (7,3) NULL
go

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_PERPAG] DEFAULT (0) FOR [ORD_PERPAG]
go

UPDATE U_FAT_TT SET ORD_PERPAG = 0 
