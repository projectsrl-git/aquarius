
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_AN] ADD 
		ART_CODLIS varchar (06) COLLATE Latin1_General_CI_AS NULL,
		ART_DESLIS varchar (30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ART_AN_ART_CODLIS] DEFAULT ('') FOR [ART_CODLIS],
        CONSTRAINT [DF_U_ART_AN_ART_DESLIS] DEFAULT ('') FOR [ART_DESLIS]
go



UPDATE U_ART_AN SET ART_CODLIS 	= ''
UPDATE U_ART_AN SET ART_DESLIS 	= ''

