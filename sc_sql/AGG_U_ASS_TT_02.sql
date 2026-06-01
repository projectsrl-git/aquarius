
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ASS_TT] ADD 
	 	 [ASS_DESCEF] varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 	 [ASS_NOTE] [text] COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ASS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ASS_TT_ASS_DESCEF] DEFAULT ('') FOR [ASS_DESCEF],
	CONSTRAINT [DF_U_ASS_TT_ASS_NOTE] DEFAULT ('') FOR [ASS_NOTE]
go

UPDATE U_ASS_TT SET ASS_DESCEF 	= ' '
UPDATE U_ASS_TT SET ASS_NOTE 	= '     '
