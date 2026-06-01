/* 
*******************************************************************************************************
INSERIMENTO NUOVI CAMPI IN TABELLA DETTAGLI DI.BA.:
	- DIS_OPZCST = OPZIONE PER DETERMINAZIONE DEI COSTI (ANAGRAFICA ARTICOLI / DETTAGLIO DISTINTA BASE)
	- DIS_CODFOR = CODICE FORNITORE
	- DIS_DESFOR = DESCRIZIONE FORNITORE
*******************************************************************************************************
*/
ALTER TABLE [dbo].[U_DIS_DD] ADD 
	DIS_OPZCST numeric(1,0) NULL,
	DIS_CODFOR varchar(10) COLLATE Latin1_General_CI_AS NULL,
	DIS_DESFOR varchar(80) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_DD_DIS_OPZCST] DEFAULT (1) FOR [DIS_OPZCST],
	CONSTRAINT [DF_U_DIS_DD_DIS_CODFOR] DEFAULT ('') FOR [DIS_CODFOR],
	CONSTRAINT [DF_U_DIS_DD_DIS_DESFOR] DEFAULT ('') FOR [DIS_DESFOR]
go


UPDATE U_DIS_DD SET DIS_OPZCST = 1
UPDATE U_DIS_DD SET DIS_CODFOR = ''
UPDATE U_DIS_DD SET DIS_DESFOR = ''