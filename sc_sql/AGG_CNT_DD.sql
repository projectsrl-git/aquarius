
/* 
**************************************************************
DETTAGLIO CONTATTI
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_DD] ADD 
	 CNT_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_DD_CNT_FLGMOD] DEFAULT ('') FOR [CNT_FLGMOD]
go


UPDATE U_CNT_DD SET CNT_FLGMOD = SPACE(1)

/* 
**************************************************************
DETTAGLIO CONTATTI (PROPOSTE E CALCOLO PREZZO)
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_PR] ADD 
	 CNT_FLGMOD varchar(1) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_PR_CNT_FLGMOD] DEFAULT ('') FOR [CNT_FLGMOD]
go


UPDATE U_CNT_PR SET CNT_FLGMOD = SPACE(1)
