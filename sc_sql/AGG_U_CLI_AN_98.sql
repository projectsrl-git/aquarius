/***********************************************/
/* ALTERAZIONE DELLA SOLA DIMENSIONE DEL CAMPO */
/***********************************************/

if exists (select name from dbo.sysindexes where name = 'U_CLI_AL')
   drop index u_cli_an.U_CLI_AL
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CLI_AN.INDICE_07
GO

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_RICERC varchar(50) NOT NULL
GO


CREATE INDEX [U_CLI_AL] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_RICERC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_CLI_AN]([CLI_RICERC]) ON [PRIMARY]
GO