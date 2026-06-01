
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_CO] ADD 
	 ORF_DATCAN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORF_ORACAN varchar(08) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_CO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_CO_ORF_DATCAN] DEFAULT ('') FOR [ORF_DATCAN],
	CONSTRAINT [DF_U_ORF_CO_ORF_ORACAN] DEFAULT ('') FOR [ORF_ORACAN]
go

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CAN_CO] ADD 
	 ORF_DATCAN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORF_ORACAN varchar(08) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CAN_CO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CAN_CO_ORF_DATCAN] DEFAULT ('') FOR [ORF_DATCAN],
	CONSTRAINT [DF_U_CAN_CO_ORF_ORACAN] DEFAULT ('') FOR [ORF_ORACAN]
go

UPDATE U_ORF_CO SET ORF_DATCAN = SPACE(10)
UPDATE U_ORF_CO SET ORF_ORACAN = SPACE(08)
UPDATE U_CAN_CO SET ORF_DATCAN = SPACE(10)
UPDATE U_CAN_CO SET ORF_ORACAN = SPACE(08)
