
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_AN] ADD 
	 art_descrweb varchar(254) COLLATE Latin1_General_CI_AS NULL,
	 ART_PRZVENWEB [numeric](10, 2) NULL
	 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_art_descrweb] DEFAULT ('') FOR [art_descrweb],
	CONSTRAINT [DF_U_ART_AN_ART_PRZVENWEB]	DEFAULT ('0') 		FOR 	[ART_PRZVENWEB]  
go
UPDATE U_ART_AN SET art_descrweb=''
update U_ART_AN set ART_PRZVENWEB = 0