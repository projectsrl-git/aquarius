/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_TT] ADD 
	 ORD_NUMORC varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DATORC varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_IDSDI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CUP varchar(15) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CIG varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_TT_ORD_NUMORC] DEFAULT ('') FOR [ORD_NUMORC],
	CONSTRAINT [DF_COMMESSA_TT_ORD_DATORC] DEFAULT ('') FOR [ORD_DATORC],
	CONSTRAINT [DF_COMMESSA_TT_ORD_IDSDI] DEFAULT ('') FOR [ORD_IDSDI],
	CONSTRAINT [DF_COMMESSA_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP],
	CONSTRAINT [DF_COMMESSA_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]

go

UPDATE COMMESSA_TT SET ORD_NUMORC = ''
UPDATE COMMESSA_TT SET ORD_DATORC = ''
UPDATE COMMESSA_TT SET ORD_IDSDI = ''
UPDATE COMMESSA_TT SET ORD_CUP = ''
UPDATE COMMESSA_TT SET ORD_CIG = ''