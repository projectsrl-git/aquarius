/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_AN
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_AN] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AN_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_MAG_AN_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_MAG_AN SET MAG_CSTMAN = 0
UPDATE U_MAG_AN SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_GG
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_MAG_GG_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_MAG_GG SET MAG_CSTMAN = 0
UPDATE U_MAG_GG SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_GS
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GS] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GS_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_MAG_GS_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_MAG_GS SET MAG_CSTMAN = 0
UPDATE U_MAG_GS SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_DA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_MAG_DA_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_MAG_DA SET MAG_CSTMAN = 0
UPDATE U_MAG_DA SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_SA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_SA] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_SA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_SA_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_MAG_SA_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_MAG_SA SET MAG_CSTMAN = 0
UPDATE U_MAG_SA SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_SS
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_SS] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_SS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_SS_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_MAG_SS_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_MAG_SS SET MAG_CSTMAN = 0
UPDATE U_MAG_SS SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_MO
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_CSTMAN numeric(16,6) NULL,
	 MOV_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_CSTMAN] DEFAULT (0) FOR [MOV_CSTMAN],
	CONSTRAINT [DF_U_MAG_MO_MOV_CSTSCA] DEFAULT (0) FOR [MOV_CSTSCA]
go
UPDATE U_MAG_MO SET MOV_CSTMAN = 0
UPDATE U_MAG_MO SET MOV_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_MS
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MS] ADD 
	 MOV_CSTMAN numeric(16,6) NULL,
	 MOV_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MS_MOV_CSTMAN] DEFAULT (0) FOR [MOV_CSTMAN],
	CONSTRAINT [DF_U_MAG_MS_MOV_CSTSCA] DEFAULT (0) FOR [MOV_CSTSCA]
go
UPDATE U_MAG_MS SET MOV_CSTMAN = 0
UPDATE U_MAG_MS SET MOV_CSTSCA = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_INV_MA
**************************************************************
*/
ALTER TABLE [dbo].[U_INV_MA] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_INV_MA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_INV_MA_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_INV_MA_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_INV_MA SET MAG_CSTMAN = 0
UPDATE U_INV_MA SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE INVENTARIO CON PDA PER LA TABELLA  ==>  U_PDA_CA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDA_CA] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDA_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDA_CA_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_PDA_CA_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_PDA_CA SET MAG_CSTMAN = 0
UPDATE U_PDA_CA SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE INVENTARIO CON PDA PER LA TABELLA  ==>  U_PDA_MA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDA_MA] ADD 
	 MAG_CSTMAN numeric(16,6) NULL,
	 MAG_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDA_MA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDA_MA_MAG_CSTMAN] DEFAULT (0) FOR [MAG_CSTMAN],
	CONSTRAINT [DF_U_PDA_MA_MAG_CSTSCA] DEFAULT (0) FOR [MAG_CSTSCA]
go
UPDATE U_PDA_MA SET MAG_CSTMAN = 0
UPDATE U_PDA_MA SET MAG_CSTSCA = 0


/* 
**************************************************************
GESTIONE INVENTARIO CON PDA PER LA TABELLA  ==>  U_PDA_MO
**************************************************************
*/
ALTER TABLE [dbo].[U_PDA_MO] ADD 
	 MOV_CSTMAN numeric(16,6) NULL,
	 MOV_CSTSCA numeric(16,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDA_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDA_MO_MOV_CSTMAN] DEFAULT (0) FOR [MOV_CSTMAN],
	CONSTRAINT [DF_U_PDA_MO_MOV_CSTSCA] DEFAULT (0) FOR [MOV_CSTSCA]
go
UPDATE U_PDA_MO SET MOV_CSTMAN = 0
UPDATE U_PDA_MO SET MOV_CSTSCA = 0
