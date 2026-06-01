/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

/*
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_DATSCA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_OFF_TT_ORD_DATSCA] DEFAULT ('')
go
*/
-- SCRIPT MODIFICATO PER INSTALLAZIONE DIRETTA ANTICIPATA IN PROD CARDIILINE (NON ALLINEATO CON TUTTI GLI SCRIPT AD OGGI): SE NON ESISTE GIA' VIENE AGGIUNTO IL CAMPO
if NOT exists(select * from sys.columns where name = 'ORD_DATSCA' and object_id = object_id(N'[dbo].[U_OFF_TT]'))
BEGIN
	ALTER TABLE [dbo].[U_OFF_TT] ADD 
	ORD_DATSCA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_OFF_TT_ORD_DATSCA] DEFAULT ('')
END