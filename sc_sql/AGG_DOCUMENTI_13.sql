/* 
****************************************************************************************
INSERIMENTO CAMPO ORD_IMPONIB (Qtà NR in confezione/pallet) IN TABELLE DETTAGLI DOCUMENTI
INSERIMENTO CAMPO ORD_IMPOSTA (Qtà NR in confezione/pallet) IN TABELLE DETTAGLI DOCUMENTI
****************************************************************************************
*/

--######################################################################################
ALTER TABLE [dbo].[U_PRB_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_PRB_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRB_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_PRB_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_PRB_TT SET ORD_IMPONIB = 0
UPDATE U_PRB_TT SET ORD_IMPOSTA = 0

--######################################################################################
ALTER TABLE [dbo].[RDA_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[RDA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_RDA_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE RDA_TT SET ORD_IMPONIB = 0
UPDATE RDA_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_PCK_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_PCK_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_PCK_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_PCK_TT SET ORD_IMPONIB = 0
UPDATE U_PCK_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_FAM_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_FAM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAM_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_FAM_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_FAM_TT SET ORD_IMPONIB = 0
UPDATE U_FAM_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_CTL_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_CTL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CTL_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_CTL_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_CTL_TT SET ORD_IMPONIB = 0
UPDATE U_CTL_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_SPE_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_SPE_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SPE_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_SPE_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_SPE_TT SET ORD_IMPONIB = 0
UPDATE U_SPE_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_BFO_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_BFO_TT SET ORD_IMPONIB = 0
UPDATE U_BFO_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_MRI_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_MRI_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MRI_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_MRI_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_MRI_TT SET ORD_IMPONIB = 0
UPDATE U_MRI_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_AMM_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_AMM_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_AMM_TT SET ORD_IMPONIB = 0
UPDATE U_AMM_TT SET ORD_IMPOSTA = 0
