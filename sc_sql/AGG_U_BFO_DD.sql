/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_SCARIC bit NULL,
	 ORD_QTAPDA numeric(9,2)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_SCARIC] DEFAULT (0) FOR [ORD_SCARIC],
	CONSTRAINT [DF_U_BFO_DD_ORD_QTAPDA] DEFAULT (0) FOR [ORD_QTAPDA]
go

UPDATE U_BFO_DD SET ORD_SCARIC = 0
UPDATE U_BFO_DD SET ORD_QTAPDA = 0
