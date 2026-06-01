if exists (select name from dbo.sysindexes where name = 'U_CLI_AN')
   drop index u_cli_an.U_CLI_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_RG')
   drop index u_cli_an.U_CLI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_LO')
   drop index u_cli_an.U_CLI_LO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_NA')
   drop index u_cli_an.U_CLI_NA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_AG')
   drop index u_cli_an.U_CLI_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_PI')
   drop index u_cli_an.U_CLI_PI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_AL')
   drop index u_cli_an.U_CLI_AL
GO
 
CREATE UNIQUE INDEX [U_CLI_AN] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_RG] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_LO] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_LOCALI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_NA] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_NAZION]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_AG] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_AGE], [CLI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_PI] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_AL] ON [dbo].[u_cli_an]([CLI_CODSOC], [CLI_RICERC]) ON [PRIMARY]
GO
 
