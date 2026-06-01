/* 
*******************************************************************************************
AGGIUNTA CAMPI PER DETERMINAZIONE SOGGETTO IN SOTTORIGA ARTICOLO NEI DETTAGLI DEI DOCUMENTI
*******************************************************************************************
*/

--*******************************************************************************************
ALTER TABLE [dbo].[U_OFF_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_OFF_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_OFF_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_OFF_DD SET ORD_TIPSOG = ''
UPDATE U_OFF_DD SET ORD_CODSOG = ''
UPDATE U_OFF_DD SET ORD_DESSOG = ''

--*******************************************************************************************
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_ORD_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_ORD_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_ORD_DD SET ORD_TIPSOG = ''
UPDATE U_ORD_DD SET ORD_CODSOG = ''
UPDATE U_ORD_DD SET ORD_DESSOG = ''

--*******************************************************************************************
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_ORF_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_ORF_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_ORF_DD SET ORD_TIPSOG = ''
UPDATE U_ORF_DD SET ORD_CODSOG = ''
UPDATE U_ORF_DD SET ORD_DESSOG = ''

--*******************************************************************************************
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_BOL_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_BOL_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_BOL_DD SET ORD_TIPSOG = ''
UPDATE U_BOL_DD SET ORD_CODSOG = ''
UPDATE U_BOL_DD SET ORD_DESSOG = ''

--*******************************************************************************************
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_BFO_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_BFO_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_BFO_DD SET ORD_TIPSOG = ''
UPDATE U_BFO_DD SET ORD_CODSOG = ''
UPDATE U_BFO_DD SET ORD_DESSOG = ''

--*******************************************************************************************
ALTER TABLE [dbo].[U_FAP_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_FAP_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_FAP_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_FAP_DD SET ORD_TIPSOG = ''
UPDATE U_FAP_DD SET ORD_CODSOG = ''
UPDATE U_FAP_DD SET ORD_DESSOG = ''

--*******************************************************************************************
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_TIPSOG varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSOG varchar(20) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESSOG varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_TIPSOG] DEFAULT ('') FOR [ORD_TIPSOG],
	CONSTRAINT [DF_U_FAT_DD_ORD_CODSOG] DEFAULT ('') FOR [ORD_CODSOG],
	CONSTRAINT [DF_U_FAT_DD_ORD_DESSOG] DEFAULT ('') FOR [ORD_DESSOG]
go

UPDATE U_FAT_DD SET ORD_TIPSOG = ''
UPDATE U_FAT_DD SET ORD_CODSOG = ''
UPDATE U_FAT_DD SET ORD_DESSOG = ''

