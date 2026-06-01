/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_BFO_DD] ADD 
	ORD_STATOCQ varchar(3) COLLATE Latin1_General_CI_AS NULL,
	ORD_DATACQ varchar(10) COLLATE Latin1_General_CI_AS NULL,
	ORD_SYSCQ varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_STATOCQ] DEFAULT ('') FOR [ORD_STATOCQ],
	CONSTRAINT [DF_U_BFO_DD_ORD_DATACQ] DEFAULT ('') FOR [ORD_DATACQ],
	CONSTRAINT [DF_U_BFO_DD_ORD_SYSCQ] DEFAULT ('') FOR [ORD_SYSCQ] 
go


UPDATE U_BFO_DD SET ORD_STATOCQ  = '' 
UPDATE U_BFO_DD SET ORD_DATACQ = '' 
UPDATE U_BFO_DD SET ORD_SYSCQ  = ''
