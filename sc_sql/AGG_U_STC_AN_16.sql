
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_STC_AN] ADD 
		 STC_MAGA varchar(6) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_STC_AN] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_STC_AN_STC_MAGA] DEFAULT ('')    FOR [STC_MAGA]
go

UPDATE U_STC_AN SET STC_MAGA 	= '' 
