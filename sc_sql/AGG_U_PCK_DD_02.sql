
/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PCK_DD] ADD 
		 ORD_QTADE2 numeric (17,3) NULL,
	 	 ORD_NOTA varchar (50) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_PCK_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_DD_ORD_QTADE2] DEFAULT ('0')    FOR [ORD_QTADE2],
	CONSTRAINT [DF_U_PCK_DD_ORD_NOTA] DEFAULT ('    ') FOR [ORD_NOTA]


UPDATE U_PCK_DD SET ORD_QTADE2 	= 0 
UPDATE U_PCK_DD SET ORD_NOTA 	= SPACE(50) 

