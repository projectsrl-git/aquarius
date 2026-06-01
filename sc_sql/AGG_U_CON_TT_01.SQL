
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TT] ADD 
	 CON_DOCU2 varchar(150) COLLATE Latin1_General_CI_AS NULL,
	 CON_DOCU3 varchar(150) COLLATE Latin1_General_CI_AS NULL,
	 CON_DOCU4 varchar(150) COLLATE Latin1_General_CI_AS NULL,
	 CON_DOCU5 varchar(150) COLLATE Latin1_General_CI_AS NULL,
	 CON_DOCU6 varchar(150) COLLATE Latin1_General_CI_AS NULL,
	 CON_DOCU7 varchar(150) COLLATE Latin1_General_CI_AS NULL
	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TT_CON_DOCU2] DEFAULT ('') FOR [CON_DOCU2],
	CONSTRAINT [DF_U_CON_TT_CON_DOCU3] DEFAULT ('') FOR [CON_DOCU3],
	CONSTRAINT [DF_U_CON_TT_CON_DOCU4] DEFAULT ('') FOR [CON_DOCU4],
	CONSTRAINT [DF_U_CON_TT_CON_DOCU5] DEFAULT ('') FOR [CON_DOCU5],
	CONSTRAINT [DF_U_CON_TT_CON_DOCU6] DEFAULT ('') FOR [CON_DOCU6],
	CONSTRAINT [DF_U_CON_TT_CON_DOCU7] DEFAULT ('') FOR [CON_DOCU7]
	
go

UPDATE U_CON_TT SET CON_DOCU2 = ''
UPDATE U_CON_TT SET CON_DOCU3 = ''
UPDATE U_CON_TT SET CON_DOCU4 = ''
UPDATE U_CON_TT SET CON_DOCU5 = ''
UPDATE U_CON_TT SET CON_DOCU6 = ''
UPDATE U_CON_TT SET CON_DOCU7 = ''
