/* 
****************************************************************************************
INSERIMENTO CAMPO ORD_IMPONIB (Qtà NR in confezione/pallet) IN TABELLE DETTAGLI DOCUMENTI
INSERIMENTO CAMPO ORD_IMPOSTA (Qtà NR in confezione/pallet) IN TABELLE DETTAGLI DOCUMENTI
****************************************************************************************
*/

--######################################################################################
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_ORF_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_ORF_TT SET ORD_IMPONIB = 0
UPDATE U_ORF_TT SET ORD_IMPOSTA = 0
--######################################################################################
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_OFF_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_OFF_TT SET ORD_IMPONIB = 0
UPDATE U_OFF_TT SET ORD_IMPOSTA = 0
--######################################################################################
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_ORD_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_ORD_TT SET ORD_IMPONIB = 0
UPDATE U_ORD_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_BOL_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_BOL_TT SET ORD_IMPONIB = 0
UPDATE U_BOL_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[L_BOL_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_L_BOL_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE L_BOL_TT SET ORD_IMPONIB = 0
UPDATE L_BOL_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_FAP_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_FAP_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_FAP_TT SET ORD_IMPONIB = 0
UPDATE U_FAP_TT SET ORD_IMPOSTA = 0


--######################################################################################
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	ORD_IMPONIB numeric(17,3) NULL,
	ORD_IMPOSTA numeric(17,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_IMPONIB] DEFAULT (0) FOR [ORD_IMPONIB],
	CONSTRAINT [DF_U_FAT_TT_ORD_IMPOSTA] DEFAULT (0) FOR [ORD_IMPOSTA]
GO
UPDATE U_FAT_TT SET ORD_IMPONIB = 0
UPDATE U_FAT_TT SET ORD_IMPOSTA = 0
