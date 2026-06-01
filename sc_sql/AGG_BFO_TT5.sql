
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 ORD_DATOR2 varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_DATOR2] DEFAULT ('') FOR [ORD_DATOR2]
go
UPDATE U_BFO_TT SET ORD_DATOR2 = ORD_DATORD

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORS_DATOR2 varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORS_DATOR2] DEFAULT ('') FOR [ORS_DATOR2]
go
UPDATE U_BFO_DD SET ORS_DATOR2 = ORS_DATORD
