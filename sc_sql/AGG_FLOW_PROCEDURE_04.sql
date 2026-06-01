
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FLOW_PROCEDURE] ADD 
	[NR_PROC_GENERATE]   [numeric] (5,0) NULL,
	[IDATTIVITANC]        [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[VERSIONE]        [varchar] (5) COLLATE Latin1_General_CI_AS NULL,
	[DATA_VALIDITA]   [varchar] (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FLOW_PROCEDURE] WITH NOCHECK ADD 
	CONSTRAINT [DF_FLOW_PROCEDURE_NR_PROC_GENERATE] DEFAULT (0) FOR [NR_PROC_GENERATE],
	CONSTRAINT [DF_FLOW_PROCEDURE_IDATTIVITANC] DEFAULT ('') FOR [IDATTIVITANC],
	CONSTRAINT [DF_FLOW_PROCEDURE_VERSIONE] DEFAULT ('') FOR [VERSIONE],
	CONSTRAINT [DF_FLOW_PROCEDURE_DATA_VALIDITA] DEFAULT ('') FOR [DATA_VALIDITA]
go

UPDATE [dbo].[FLOW_PROCEDURE] SET NR_PROC_GENERATE=0
UPDATE [dbo].[FLOW_PROCEDURE] SET IDATTIVITANC=''
UPDATE [dbo].[FLOW_PROCEDURE] SET VERSIONE=''
UPDATE [dbo].[FLOW_PROCEDURE] SET DATA_VALIDITA=''

