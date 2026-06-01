
/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 	 ORD_PKLOK varchar (01) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_PKLOK] DEFAULT (' ') FOR [ORD_PKLOK]



UPDATE U_ORD_DD SET ORD_PKLOK 	= SPACE(01) 

