/* 
***********************************************
INSERIMENTO NUOVO CAMPO "Da imputare sp.trasp."
***********************************************

*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_SPTIMP varchar(2) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
go
