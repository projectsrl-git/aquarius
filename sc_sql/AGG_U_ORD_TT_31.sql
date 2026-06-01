/* 
*****************************************************
INSERIMENTO NUOVO CAMPO 'Abilita consegna parziale'
*****************************************************

*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_CONPRZ varchar(2) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_TT_ORD_CONPRZ] DEFAULT ('')
go
