/***************************************************************
CAMPO Tipo Scadenza
***************************************************************/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_TIPSCA varchar(1) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_ART_TIPSCA] DEFAULT ('')
go
