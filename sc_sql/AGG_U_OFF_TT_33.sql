/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_OFF_DD] ADD 
	 ORS_CODEMI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORS_TIPORD varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_DD_ORS_CODEMI] DEFAULT ('') FOR [ORS_CODEMI],
	CONSTRAINT [DF_U_OFF_DD_ORS_TIPORD] DEFAULT ('') FOR [ORS_TIPORD],
	CONSTRAINT [DF_U_OFF_DD_ORS_DESTIN] DEFAULT ('') FOR [ORS_DESTIN]
go

UPDATE U_OFF_DD SET ORS_CODEMI = ''
UPDATE U_OFF_DD SET ORS_TIPORD = ''
UPDATE U_OFF_DD SET ORS_DESTIN = ''

