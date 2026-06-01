
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FLOW_PROCEDURE] ADD 
	[DATA_ULTAGG]        [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[ORA_ULTAGG]         [varchar] (8) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FLOW_PROCEDURE] WITH NOCHECK ADD 
	CONSTRAINT [DF_FLOW_PROCEDURE_DATA_ULTAGG] DEFAULT ('') FOR [DATA_ULTAGG],
	CONSTRAINT [DF_FLOW_PROCEDURE_ORA_ULTAGG] DEFAULT ('') FOR [ORA_ULTAGG]
go
