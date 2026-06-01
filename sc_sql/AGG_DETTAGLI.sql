
/* 
**************************************************************
DOCUMENTI DI CARICO MAGAZZINO
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_BFO_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_BFO_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_BFO_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
DOCUMENTI DI SCARICO MAGAZZINO
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_PRZCON [numeric](17, 6) NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_BOL_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD],
	CONSTRAINT [DF_U_BOL_DD_ORD_PRZCON] DEFAULT (0) FOR [ORD_PRZCON]
go

UPDATE U_BOL_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_BOL_DD SET ORD_FLGMOD = SPACE(1)
UPDATE U_BOL_DD SET ORD_PRZCON = 0

/* 
**************************************************************
DOCUMENTI DI OFFERTE A CLIENTI
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_OFF_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_OFF_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_OFF_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
DOCUMENTI DI ORDINI A FORNITORI
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_ORF_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_ORF_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_ORF_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
DOCUMENTI DI ORDINI CLIENTI
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_ORD_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_ORD_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_ORD_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
DOCUMENTI DI FATTURAZIONE PROFORMA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAP_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_FAP_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_FAP_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_FAP_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
DOCUMENTI DI FATTURAZIONE
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 ORD_PRZCON [numeric](17, 6) NULL,
	 ORD_FORNIT varchar(10) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_FAT_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD],
	CONSTRAINT [DF_U_FAT_DD_ORD_PRZCON] DEFAULT (0) FOR [ORD_PRZCON],
	CONSTRAINT [DF_U_FAT_DD_ORD_FORNIT] DEFAULT ('') FOR [ORD_FORNIT]
go

UPDATE U_FAT_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_FAT_DD SET ORD_FLGMOD = SPACE(1)
UPDATE U_FAT_DD SET ORD_PRZCON = 0
UPDATE U_FAT_DD SET ORD_FORNIT = SPACE(10)

/* 
**************************************************************
PREBOLLA DI RESO
**************************************************************
*/
ALTER TABLE [dbo].[U_PRB_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRB_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRB_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_PRB_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_PRB_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_PRB_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
DISTINTA DI SPEDIZIONE
**************************************************************
*/
ALTER TABLE [dbo].[U_SPE_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_SPE_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SPE_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_SPE_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_SPE_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_SPE_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
ORDINI DI RIFORNIMENTO (SOLO SU AQUASQL - AQUARIUS)
**************************************************************
*/
ALTER TABLE [dbo].[U_MRI_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MRI_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MRI_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_MRI_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_MRI_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_MRI_DD SET ORD_FLGMOD = SPACE(1)

/* 
**************************************************************
ORDINI C/LAVORO (SOLO SU AQUASQL - AQUARIUS)
**************************************************************
*/
ALTER TABLE [dbo].[U_CTL_DD] ADD 
	 ORD_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CTL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CTL_DD_ORD_LEGSYS] DEFAULT ('') FOR [ORD_LEGSYS],
	CONSTRAINT [DF_U_CTL_DD_ORD_FLGMOD] DEFAULT ('') FOR [ORD_FLGMOD]
go

UPDATE U_CTL_DD SET ORD_LEGSYS = SPACE(10)
UPDATE U_CTL_DD SET ORD_FLGMOD = SPACE(1)


