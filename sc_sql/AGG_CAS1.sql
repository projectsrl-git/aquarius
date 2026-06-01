
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	 CAS_TOP varchar(4) COLLATE Latin1_General_CI_AS NULL,
	 CAS_QTA [numeric](4) NULL ,
	 CAS_VAL [numeric](10, 2) NULL ,
	 CAS_IVA [numeric](3) NULL ,
	 CAS_DES varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 CAS_TIP varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_TOP] DEFAULT ('') FOR [CAS_TOP],
	CONSTRAINT [DF_U_PDV_CA_CAS_QTA] DEFAULT (0) FOR [CAS_QTA],
	CONSTRAINT [DF_U_PDV_CA_CAS_VAL] DEFAULT (0) FOR [CAS_VAL],
	CONSTRAINT [DF_U_PDV_CA_CAS_IVA] DEFAULT (0) FOR [CAS_IVA],
	CONSTRAINT [DF_U_PDV_CA_CAS_DES] DEFAULT ('') FOR [CAS_DES],
	CONSTRAINT [DF_U_PDV_CA_CAS_TIP] DEFAULT ('') FOR [CAS_TIP]
go
