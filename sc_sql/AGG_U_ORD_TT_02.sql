
/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 	 ORD_PKLOK varchar (01) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_PKLOK] DEFAULT (' ') FOR [ORD_PKLOK]



UPDATE U_ORD_TT SET ORD_PKLOK 	= SPACE(01) 

