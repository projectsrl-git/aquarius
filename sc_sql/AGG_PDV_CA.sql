
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	 CAS_UNIMIS varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 CAS_CODIVA varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 CAS_CATAGO varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 CAS_GRUEDI varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 CAS_EDITOR varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 CAS_COLLAN varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 CAS_CATMER varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 CAS_AUTORE varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_UNIMIS] DEFAULT ('') FOR [CAS_UNIMIS],
	CONSTRAINT [DF_U_PDV_CA_CAS_CODIVA] DEFAULT ('') FOR [CAS_CODIVA],
	CONSTRAINT [DF_U_PDV_CA_CAS_CATAGO] DEFAULT ('') FOR [CAS_CATAGO],
	CONSTRAINT [DF_U_PDV_CA_CAS_GRUEDI] DEFAULT ('') FOR [CAS_GRUEDI],
	CONSTRAINT [DF_U_PDV_CA_CAS_EDITOR] DEFAULT ('') FOR [CAS_EDITOR],
	CONSTRAINT [DF_U_PDV_CA_CAS_COLLAN] DEFAULT ('') FOR [CAS_COLLAN],
	CONSTRAINT [DF_U_PDV_CA_CAS_CATMER] DEFAULT ('') FOR [CAS_CATMER],
	CONSTRAINT [DF_U_PDV_CA_CAS_AUTORE] DEFAULT ('') FOR [CAS_AUTORE]
go
