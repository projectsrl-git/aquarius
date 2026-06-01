
/* 
**************************************************************************************************
INSERIMENTO VALUTA E TIPOLOGIA LISTINO CLIENTE IN TABELLA DI ABILITAZIONE LISTINI CLIENTE/ARTICOLO
**************************************************************************************************
*/
ALTER TABLE [dbo].[U_LIS_LG] ADD 
	LIS_CODVAL varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LIS_LG_LIS_CODVAL] DEFAULT (''),
	LIS_CODGLI varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LIS_LG_LIS_CODGLI] DEFAULT ('')
go

