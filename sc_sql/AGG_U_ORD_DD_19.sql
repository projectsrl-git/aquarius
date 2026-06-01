
/* 
*************************************************************************************
INSERIMENTO CAMPI "STATO PRODUZIONE" E "NUMERO PEZZI PRODOTTI" PER PORTAFOGLIO ORDINI
*************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD
	ORD_STAPRO varchar(20) COLLATE Latin1_General_CI_AS NULL,
	ORD_NUMBOP numeric (6,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
    CONSTRAINT [DF_U_ORD_DD_ORD_STAPRO] DEFAULT ('') FOR [ORD_STAPRO],
    CONSTRAINT [DF_U_ORD_DD_ORD_NUMBOP] DEFAULT (0) FOR [ORD_NUMBOP]
go

UPDATE U_ORD_DD SET ORD_STAPRO = ''
UPDATE U_ORD_DD SET ORD_NUMBOP = 0
