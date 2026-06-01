
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ADD 
		ORS_MAGS varchar (06) COLLATE Latin1_General_CI_AS NULL,
		ORS_MAGD varchar (06) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_OFF_DD_ORS_MAGS] DEFAULT ('') FOR [ORS_MAGS],
        CONSTRAINT [DF_U_OFF_DD_ORS_MAGD] DEFAULT ('') FOR [ORS_MAGD]
go

UPDATE U_OFF_DD SET ORS_MAGS = ''
UPDATE U_OFF_DD SET ORS_MAGD = ''
