/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	ORD_PERPAG numeric (7,3) NULL
go

ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_PERPAG] DEFAULT (0) FOR [ORD_PERPAG]
go

UPDATE U_BOL_TT SET ORD_PERPAG = 0 
