
/* 
**************************************************************
COME MODIFICARE IL NOME DEL CAMPO DI UNA TABELLA
**************************************************************
*/

EXEC sp_rename N'dbo.U_CLI_EX.CODCLI_SYSPAC', N'CODCLI_SISPAC', 'COLUMN';
GO