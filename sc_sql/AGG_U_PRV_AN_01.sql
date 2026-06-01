
/*         
***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************
*/
ALTER TABLE [dbo].[U_PRV_AN] ADD 
	 PRV_NONMOD varchar(1) COLLATE Latin1_General_CI_AS NULL

go
ALTER TABLE [dbo].[U_PRV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_PRV_NONMOD] DEFAULT ('') FOR [PRV_NONMOD]
go


UPDATE U_PRV_AN SET PRV_NONMOD = SPACE(1)
