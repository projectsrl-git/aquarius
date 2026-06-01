
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_PR] ADD 
	DAGGANCIO_PR varchar(10) COLLATE Latin1_General_CI_AS NULL,
	CNT_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_PR_DAGGANCIO_PR] DEFAULT ('') FOR [DAGGANCIO_PR],
	CONSTRAINT [DF_U_CNT_PR_CNT_FLGMOD] DEFAULT ('') FOR [CNT_FLGMOD]
go

UPDATE U_CNT_TT SET DAGGANCIO_PR=SPACE(10),CNT_FLGMOD=SPACE(1)

