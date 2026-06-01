/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	[NOIVACARCLI ] [varchar] (1)  COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_NOIVACARCLI ] DEFAULT ('') FOR [NOIVACARCLI ]
go


-- SE IVA SPLIT PAYMENT IMPOSTA 'S'
UPDATE PARA SET NOIVACARCLI  = CASE WHEN SUBSTRING(CODICE,1,5)= 'IVASP' THEN 'S' ELSE ' ' END
