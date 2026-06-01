/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAP_TT] ADD 
	 t_enpacl numeric(11,2) NULL,
	 t_ra numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_t_enpacl] DEFAULT (0) FOR t_enpacl,
	CONSTRAINT [DF_U_FAP_TT_t_ra] DEFAULT (0) FOR [t_ra]
go

UPDATE U_FAP_TT SET t_enpacl= 0
UPDATE U_FAP_TT SET t_ra = 0
