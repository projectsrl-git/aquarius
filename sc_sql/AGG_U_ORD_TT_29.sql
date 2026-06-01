/* 
***********************************************
INSERIMENTO NUOVO CAMPO "Motivazione scaduto"
***********************************************

*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_MOTSCA varchar(4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_TT_ORD_MOTSCA] DEFAULT ('')
go
