
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORS_DTCONF varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORS_DTCONF] DEFAULT ('') FOR [ORS_DTCONF]

go

UPDATE U_ORF_DD SET ORS_DTCONF = ''


