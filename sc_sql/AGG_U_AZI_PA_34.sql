/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
  
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 	 AZI_TRANCH bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_TRANCH] DEFAULT (0) FOR [AZI_TRANCH]
go

update u_azi_pa set AZI_TRANCH = 0
