/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
  
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 	 AZI_NRSENO bit NULL,
		 AZI_PROTNO numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NRSENO] DEFAULT (0) FOR [AZI_NRSENO],
	CONSTRAINT [DF_U_AZI_PA_AZI_PROTNO] DEFAULT (0) FOR [AZI_PROTNO]
go

update u_azi_pa set AZI_NRSENO = 0
UPDATE U_AZI_PA SET AZI_PROTNO = -1