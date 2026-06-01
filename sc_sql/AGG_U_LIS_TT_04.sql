
/* 
**************************************************************
INSERIMENTO TIPOLOGIA LISTINO CLIENTE
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_TT] ADD 
	 LIS_CODGLI varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LIS_TT_LIS_CODGLI] DEFAULT ('')
go

