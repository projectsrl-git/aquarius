/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_CODDCA varchar(2) COLLATE Latin1_General_CI_AS NULL,
	ART_CODDCP varchar(2) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_ART_CODDCA] DEFAULT ('') FOR [ART_CODDCA],
	CONSTRAINT [DF_U_ART_AN_ART_CODDCP] DEFAULT ('') FOR [ART_CODDCP]
go


UPDATE U_ART_AN SET ART_CODDCA = ''
UPDATE U_ART_AN SET ART_CODDCP = ''

