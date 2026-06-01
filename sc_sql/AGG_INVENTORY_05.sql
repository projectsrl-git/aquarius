   
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TABELLA INVENTORY
**************************************************************
*/
ALTER TABLE [dbo].[INVENTORY] ADD 
	SERIAL varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_INVENTORY_SERIAL] DEFAULT ('')
go
