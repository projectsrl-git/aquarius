
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_SYSGGG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_SYSGGS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_SYSDAG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_SYSDAS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_SYSGGG] DEFAULT ('') FOR [ORD_SYSGGG],
	CONSTRAINT [DF_U_BFO_DD_ORD_SYSGGS] DEFAULT ('') FOR [ORD_SYSGGS],
	CONSTRAINT [DF_U_BFO_DD_ORD_SYSDAG] DEFAULT ('') FOR [ORD_SYSDAG],
	CONSTRAINT [DF_U_BFO_DD_ORD_SYSDAS] DEFAULT ('') FOR [ORD_SYSDAS]
go

UPDATE U_BFO_DD SET ORD_SYSGGG = SPACE(10)
UPDATE U_BFO_DD SET ORD_SYSGGS = SPACE(10)
UPDATE U_BFO_DD SET ORD_SYSDAG = SPACE(10)
UPDATE U_BFO_DD SET ORD_SYSDAS = SPACE(10)

