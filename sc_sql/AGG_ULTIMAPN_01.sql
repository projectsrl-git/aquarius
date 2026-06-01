/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[ULTIMA_PN] ADD 
	 ULPN_CCOSTO varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 ULPN_DESCCOSTO varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[ULTIMA_PN] WITH NOCHECK ADD 

	CONSTRAINT [DF_ULTIMA_PN_ULPN_CCOSTO] DEFAULT ('') FOR [ULPN_CCOSTO],
	CONSTRAINT [DF_ULTIMA_PN_ULPN_DESCCOSTO] DEFAULT ('') FOR [ULPN_DESCCOSTO]

go

UPDATE ULTIMA_PN SET ULPN_CCOSTO = ''
UPDATE ULTIMA_PN SET ULPN_DESCCOSTO = ''