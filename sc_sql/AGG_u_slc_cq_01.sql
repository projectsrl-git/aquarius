/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_SLC_CQ] ADD 
	SLC_SYSCQ varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_SLC_CQ] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SLC_CQ_SLC_SYSCQ] DEFAULT ('') FOR [SLC_SYSCQ] 
go



UPDATE U_SLC_CQ SET SLC_SYSCQ  = ''
