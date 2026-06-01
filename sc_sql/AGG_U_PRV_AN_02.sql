
/*         
***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************
*/
ALTER TABLE [dbo].[U_PRV_AN] ADD 
	 PRV_DISLIQ numeric(10,0)  NULL


go
ALTER TABLE [dbo].[U_PRV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_PRV_DISLIQ] DEFAULT (0) FOR [PRV_DISLIQ]
go


UPDATE U_PRV_AN SET PRV_DISLIQ = 0
