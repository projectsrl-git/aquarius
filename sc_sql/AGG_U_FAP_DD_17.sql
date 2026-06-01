
/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[U_FAP_DD] ADD 
	ORD_MAGGIORAZ BIT NULL
go

ALTER TABLE [dbo].[U_FAP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_DD_ORD_MAGGIORAZ] DEFAULT (0) FOR [ORD_MAGGIORAZ]
go

UPDATE U_FAP_DD SET ORD_MAGGIORAZ = 0
