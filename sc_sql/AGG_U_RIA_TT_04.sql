/*   
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ADD 
		 ORD_FLGRVE [bit] NULL ,
	 	 ORD_DTVERS varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIA_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_RIA_TT_ORD_FLGRVE] DEFAULT (0) 	FOR [ORD_FLGRVE],
	CONSTRAINT [DF_U_RIA_TT_ORD_DTVERS] DEFAULT  ('      ') FOR [ORD_DTVERS]

go

UPDATE U_RIA_TT SET ORD_FLGRVE = 0
UPDATE U_RIA_TT SET ORD_DTVERS = '          '
