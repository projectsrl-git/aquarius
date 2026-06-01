/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	ORD_PERPAG numeric (7,3) NULL
go

ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_PERPAG] DEFAULT (0) FOR [ORD_PERPAG]
go

UPDATE U_ORD_TT SET ORD_PERPAG = 0 
