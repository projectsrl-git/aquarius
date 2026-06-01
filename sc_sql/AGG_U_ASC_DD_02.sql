/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ASC_DD] ADD 
	 ORD_CONINC varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ORD_INCASS bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ASC_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ASC_DD_ORD_CONINC] DEFAULT ('') FOR [ORD_CONINC],
	CONSTRAINT [DF_U_ASC_DD_ORD_INCASS] DEFAULT ('') FOR [ORD_INCASS]

go

UPDATE U_ASC_DD SET ORD_CONINC = ''
UPDATE U_ASC_DD SET ORD_INCASS = 0
