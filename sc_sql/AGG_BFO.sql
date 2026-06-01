
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_CODTAG varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESTAG varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODCOL varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESCOL varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_CODTAG] DEFAULT ('') FOR [ORD_CODTAG],
	CONSTRAINT [DF_U_BFO_DD_ORD_DESTAG] DEFAULT ('') FOR [ORD_DESTAG],
	CONSTRAINT [DF_U_BFO_DD_ORD_CODCOL] DEFAULT ('') FOR [ORD_CODCOL],
	CONSTRAINT [DF_U_BFO_DD_ORD_DESCOL] DEFAULT ('') FOR [ORD_DESCOL]
go
