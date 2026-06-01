/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_AN] ADD 
	 	 AZI_PRIPAGA varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_AZI_PRIPAGA] DEFAULT ('    ') FOR [AZI_PRIPAGA]
go



UPDATE U_AZI_AN SET AZI_COSATRATTA 	= 'GENER'
UPDATE U_AZI_AN SET AZI_GRADOIMPORTANZA = 'PRIMA'
UPDATE U_AZI_AN SET AZI_FORMAPAGAMENTO 	= 'RIMES'
UPDATE U_AZI_AN SET AZI_TIPOCONTRATTO 	= 'SCADE'
UPDATE U_AZI_AN SET AZI_CONAQUISTO 	= '001'
UPDATE U_AZI_AN SET AZI_PRIPAGA 	= '0500'