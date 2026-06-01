
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
		ORD_NUMORC varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATORC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_OFF_TT_ORD_NUMORC] DEFAULT ('') FOR [ORD_NUMORC],
        CONSTRAINT [DF_U_OFF_TT_ORD_DATORC] DEFAULT ('') FOR [ORD_DATORC]
 go

UPDATE U_OFF_TT SET ORD_NUMORC = ''
UPDATE U_OFF_TT SET ORD_DATORC = ''
