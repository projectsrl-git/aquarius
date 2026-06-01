/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 	 FOR_PRIPAGA varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_PRIPAGA] DEFAULT ('    ') FOR [FOR_PRIPAGA]
go

UPDATE U_FOR_AN SET FOR_COSATRATTA 	= 'GENER'
UPDATE U_FOR_AN SET FOR_GRADOIMPORTANZA = 'PRIMA'
UPDATE U_FOR_AN SET FOR_FORMAPAGAMENTO 	= 'RIMES'
UPDATE U_FOR_AN SET FOR_TIPOCONTRATTO 	= 'SCADE'
UPDATE U_FOR_AN SET FOR_CODACQ	 	= '001'
UPDATE U_FOR_AN SET FOR_PRIPAGA		= '0500'