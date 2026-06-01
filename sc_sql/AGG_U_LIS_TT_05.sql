
/* 
**************************************************************
INSERIMENTO TIPOLOGIA LISTINO CLIENTE
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_TT] ADD 
	 LIS_VALIDO varchar(2) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LIS_TT_LIS_VALIDO] DEFAULT ('')
go

