/* 
**************************************************************
CAMPI PER LA GESTIONE DELLE DISTINTE RID
**************************************************************
*/

ALTER TABLE [dbo].[U_CCO_TT] ADD 
	 ORD_CODFIS varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODSIA varchar(15) COLLATE Latin1_General_CI_AS NULL,
	 ORD_IDCREDIT varchar(35) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CODCUC varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CCO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CCO_TT_ORD_CODFIS] DEFAULT ('') FOR [ORD_CODFIS],
	CONSTRAINT [DF_U_CCO_TT_ORD_CODSIA] DEFAULT ('') FOR [ORD_CODSIA],
	CONSTRAINT [DF_U_CCO_TT_ORD_IDCREDIT] DEFAULT ('') FOR [ORD_IDCREDIT],
	CONSTRAINT [DF_U_CCO_TT_ORD_CODCUC] DEFAULT ('') FOR [ORD_CODCUC]

go

UPDATE U_CCO_TT SET ORD_CODFIS = ''
UPDATE U_CCO_TT SET ORD_CODSIA = ''
UPDATE U_CCO_TT SET ORD_IDCREDIT = ''
UPDATE U_CCO_TT SET ORD_CODCUC = ''


