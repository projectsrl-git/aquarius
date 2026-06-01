
/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	ORD_MAGGIORAZ BIT NULL
go

ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_MAGGIORAZ] DEFAULT (0) FOR [ORD_MAGGIORAZ]
go

UPDATE U_FAT_DD SET ORD_MAGGIORAZ = 0
