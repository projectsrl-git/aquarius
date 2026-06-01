/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_AN] ADD 
	 	 AZI_COSATRATTA varchar(05) COLLATE Latin1_General_CI_AS NULL,
	 	 AZI_GRADOIMPORTANZA varchar(05) COLLATE Latin1_General_CI_AS NULL,
	 	 AZI_FORMAPAGAMENTO varchar(05) COLLATE Latin1_General_CI_AS NULL, 
	 	 AZI_TIPOCONTRATTO varchar(05) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_AZI_COSATRATTA] DEFAULT ('     ') FOR [AZI_COSATRATTA],
	CONSTRAINT [DF_U_AZI_AN_AZI_GRADOIMPORTANZA] DEFAULT ('     ') FOR [AZI_GRADOIMPORTANZA],
	CONSTRAINT [DF_U_AZI_AN_AZI_FORMAPAGAMENTO] DEFAULT ('     ') FOR [AZI_FORMAPAGAMENTO],
	CONSTRAINT [DF_U_AZI_AN_AZI_TIPOCONTRATTO] DEFAULT ('     ') FOR [AZI_TIPOCONTRATTO]
go


UPDATE U_AZI_AN SET AZI_COSATRATTA = '     '
UPDATE U_AZI_AN SET AZI_GRADOIMPORTANZA = '     '
UPDATE U_AZI_AN SET AZI_FORMAPAGAMENTO = '     '
UPDATE U_AZI_AN SET AZI_TIPOCONTRATTO = '     '
