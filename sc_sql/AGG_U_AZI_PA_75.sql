
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_CAUGNE varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CAPAGL varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CAUSMP varchar(3) COLLATE Latin1_General_CI_AS NULL,  
	AZI_CAURIM varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CAUSPR varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_ARTSPR varchar(16) COLLATE Latin1_General_CI_AS NULL,
	AZI_CAUCAL varchar(3) COLLATE Latin1_General_CI_AS NULL,  
	AZI_CAUSCL varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CACARI varchar(3) COLLATE Latin1_General_CI_AS NULL,	
	AZI_CASCRI varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CACATA varchar(3) COLLATE Latin1_General_CI_AS NULL,  
	AZI_CASCTA varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CACART varchar(3) COLLATE Latin1_General_CI_AS NULL,  
	AZI_CASCRT varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CASCLE varchar(3) COLLATE Latin1_General_CI_AS NULL,  
	AZI_ARTSLE varchar(16) COLLATE Latin1_General_CI_AS NULL,
	AZI_CAPRNO varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_SCPRNO varchar(3) COLLATE Latin1_General_CI_AS NULL,
	AZI_CASCNO varchar(3) COLLATE Latin1_General_CI_AS NULL,  	
	AZI_ARTSNO varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_CAUGNE] DEFAULT ('') FOR [AZI_CAUGNE],
	CONSTRAINT [DF_u_azi_pa_AZI_CAPAGL] DEFAULT ('') FOR [AZI_CAPAGL],
	CONSTRAINT [DF_u_azi_pa_AZI_CAUSMP] DEFAULT ('') FOR [AZI_CAUSMP],
	CONSTRAINT [DF_u_azi_pa_AZI_CAURIM] DEFAULT ('') FOR [AZI_CAURIM],
	CONSTRAINT [DF_u_azi_pa_AZI_CAUSPR] DEFAULT ('') FOR [AZI_CAUSPR],
	CONSTRAINT [DF_u_azi_pa_AZI_ARTSPR] DEFAULT ('') FOR [AZI_ARTSPR],
	CONSTRAINT [DF_u_azi_pa_AZI_CAUCAL] DEFAULT ('') FOR [AZI_CAUCAL],
	CONSTRAINT [DF_u_azi_pa_AZI_CAUSCL] DEFAULT ('') FOR [AZI_CAUSCL],	
	CONSTRAINT [DF_u_azi_pa_AZI_CACARI] DEFAULT ('') FOR [AZI_CACARI],
	CONSTRAINT [DF_u_azi_pa_AZI_CASCRI] DEFAULT ('') FOR [AZI_CASCRI],
	CONSTRAINT [DF_u_azi_pa_AZI_CACATA] DEFAULT ('') FOR [AZI_CACATA],
	CONSTRAINT [DF_u_azi_pa_AZI_CASCTA] DEFAULT ('') FOR [AZI_CASCTA],
	CONSTRAINT [DF_u_azi_pa_AZI_CACART] DEFAULT ('') FOR [AZI_CACART],
	CONSTRAINT [DF_u_azi_pa_AZI_CASCRT] DEFAULT ('') FOR [AZI_CASCRT],
	CONSTRAINT [DF_u_azi_pa_AZI_CASCLE] DEFAULT ('') FOR [AZI_CASCLE],
	CONSTRAINT [DF_u_azi_pa_AZI_ARTSLE] DEFAULT ('') FOR [AZI_ARTSLE],
	CONSTRAINT [DF_u_azi_pa_AZI_CAPRNO] DEFAULT ('') FOR [AZI_CAPRNO],
	CONSTRAINT [DF_u_azi_pa_AZI_SCPRNO] DEFAULT ('') FOR [AZI_SCPRNO],
	CONSTRAINT [DF_u_azi_pa_AZI_CASCNO] DEFAULT ('') FOR [AZI_CASCNO],
	CONSTRAINT [DF_u_azi_pa_AZI_ARTSNO] DEFAULT ('') FOR [AZI_ARTSNO]
go

UPDATE u_azi_pa SET AZI_CAUGNE = ''
UPDATE u_azi_pa SET AZI_CAPAGL = ''
UPDATE u_azi_pa SET AZI_CAUSMP = ''
UPDATE u_azi_pa SET AZI_CAURIM = ''
UPDATE u_azi_pa SET AZI_CAUSPR = ''
UPDATE u_azi_pa SET AZI_ARTSPR = ''
UPDATE u_azi_pa SET AZI_CAUCAL = ''
UPDATE u_azi_pa SET AZI_CAUSCL = ''
UPDATE u_azi_pa SET AZI_CACARI = ''
UPDATE u_azi_pa SET AZI_CASCRI = ''
UPDATE u_azi_pa SET AZI_CACATA = ''
UPDATE u_azi_pa SET AZI_CASCTA = ''
UPDATE u_azi_pa SET AZI_CACART = ''
UPDATE u_azi_pa SET AZI_CASCRT = ''
UPDATE u_azi_pa SET AZI_CASCLE = ''
UPDATE u_azi_pa SET AZI_ARTSLE = ''
UPDATE u_azi_pa SET AZI_CAPRNO = ''
UPDATE u_azi_pa SET AZI_SCPRNO = ''
UPDATE u_azi_pa SET AZI_CASCNO = ''
UPDATE u_azi_pa SET AZI_ARTSNO = ''
