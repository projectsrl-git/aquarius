
/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 	 ORD_PUBBLI varchar (01) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_PUBBLI] DEFAULT (' ') FOR [ORD_PUBBLI]



UPDATE U_ORD_DD SET ORD_PUBBLI 	= SPACE(01) 

