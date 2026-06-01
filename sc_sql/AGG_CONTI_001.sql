
/*         
***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	 CON_TIPO_CONTO varchar(1) COLLATE Latin1_General_CI_AS NULL
 go
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_CON_TIPO_CONTO] DEFAULT ('') FOR [CON_TIPO_CONTO]
go


UPDATE CONTI SET CON_TIPO_CONTO = SPACE(1)
