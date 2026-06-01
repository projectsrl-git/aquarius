
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_DD] ADD 
	CNT_STATO varchar(03) COLLATE Latin1_General_CI_AS NULL,
	CNT_DESSTA varchar(50) COLLATE Latin1_General_CI_AS NULL,
        CNT_AZIONE TEXT COLLATE Latin1_General_CI_AS NULL,
	CNT_DTPRAZ varchar(10) COLLATE Latin1_General_CI_AS NULL

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_DD_CNT_STATO] DEFAULT ('') FOR [CNT_STATO],
	CONSTRAINT [DF_U_CNT_DD_CNT_DESSTA] DEFAULT ('') FOR [CNT_DESSTA],
	CONSTRAINT [DF_U_CNT_DD_CNT_AZIONE] DEFAULT ('') FOR [CNT_AZIONE],
	CONSTRAINT [DF_U_CNT_DD_CNT_DTPRAZ] DEFAULT ('') FOR [CNT_DTPRAZ]
go

UPDATE U_CNT_DD SET CNT_STATO = SPACE(03), CNT_DESSTA = SPACE(50), CNT_AZIONE = '', CNT_DTPRAZ = SPACE(10)