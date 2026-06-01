
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[risubanc] ADD 
	 IBAN varchar(27) COLLATE Latin1_General_CI_AS NULL,
	 NAZION varchar (3) COLLATE Latin1_General_CI_AS NULL,
	 CHKDGT varchar (2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[risubanc] WITH NOCHECK ADD 
	CONSTRAINT [DF_risubanc_IBAN] DEFAULT ('') FOR [IBAN],
	CONSTRAINT [DF_risubanc_NAZION] DEFAULT ('') FOR [NAZION],
	CONSTRAINT [DF_risubanc_CHKDGT] DEFAULT ('') FOR [CHKDGT]
go

UPDATE risubanc SET IBAN = ''
UPDATE risubanc SET NAZION = ''
UPDATE risubanc SET CHKDGT = ''
