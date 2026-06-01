/* 
****************************************************************************************
INSERIMENTO CAMPO ORD_QTANRC (Qtà NR in confezione/pallet) IN TABELLE DETTAGLI DOCUMENTI
****************************************************************************************
*/

--######################################################################################
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	ORD_QTANRC numeric(17,0) NULL
GO
ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_QTANRC] DEFAULT (0) FOR [ORD_QTANRC]
GO
UPDATE U_ORF_DD SET ORD_QTANRC = 0


--######################################################################################
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	ORD_QTANRC numeric(17,0) NULL
GO
ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_QTANRC] DEFAULT (0) FOR [ORD_QTANRC]
GO
UPDATE U_ORD_DD SET ORD_QTANRC = 0


--######################################################################################
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	ORD_QTANRC numeric(17,0) NULL
GO
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_QTANRC] DEFAULT (0) FOR [ORD_QTANRC]
GO
UPDATE U_BOL_DD SET ORD_QTANRC = 0


--######################################################################################
ALTER TABLE [dbo].[L_BOL_DD] ADD 
	ORD_QTANRC numeric(17,0) NULL
GO
ALTER TABLE [dbo].[L_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_DD_ORD_QTANRC] DEFAULT (0) FOR [ORD_QTANRC]
GO
UPDATE L_BOL_DD SET ORD_QTANRC = 0


--######################################################################################
ALTER TABLE [dbo].[U_FAP_DD] ADD 
	ORD_QTANRC numeric(17,0) NULL
GO
ALTER TABLE [dbo].[U_FAP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_DD_ORD_QTANRC] DEFAULT (0) FOR [ORD_QTANRC]
GO
UPDATE U_FAP_DD SET ORD_QTANRC = 0


--######################################################################################
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	ORD_QTANRC numeric(17,0) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_QTANRC] DEFAULT (0) FOR [ORD_QTANRC]
GO
UPDATE U_FAT_DD SET ORD_QTANRC = 0
