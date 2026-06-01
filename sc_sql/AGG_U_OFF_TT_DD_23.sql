
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_CCOSTO varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CONCON varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_CCOSTO] DEFAULT ('') FOR [ORD_CCOSTO],
	CONSTRAINT [DF_U_OFF_TT_ORD_CONCON] DEFAULT ('') FOR [ORD_CONCON]
go

UPDATE U_OFF_TT SET ORD_CCOSTO = ''
UPDATE U_OFF_TT SET ORD_CONCON = ''



ALTER TABLE [dbo].[U_OFF_DD] ADD 
	 ORD_CCODET varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CONDET varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_DD_ORD_CCODET] DEFAULT ('') FOR [ORD_CCODET],
	CONSTRAINT [DF_U_OFF_DD_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go

UPDATE U_OFF_DD SET ORD_CCODET = ''
UPDATE U_OFF_DD SET ORD_CONDET = ''









