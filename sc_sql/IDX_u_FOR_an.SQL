if exists (select name from dbo.sysindexes where name = 'U_FOR_AN')
   drop index u_FOR_an.U_FOR_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FOR_RG')
   drop index u_FOR_an.U_FOR_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FOR_LO')
   drop index u_FOR_an.U_FOR_LO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FOR_NA')
   drop index u_FOR_an.U_FOR_NA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FOR_PI')
   drop index u_FOR_an.U_FOR_PI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FOR_AL')
   drop index u_FOR_an.U_FOR_AL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FOR_CE')
   drop index u_FOR_an.U_FOR_CE
GO
 
CREATE UNIQUE INDEX [U_FOR_AN] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FOR_RG] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FOR_LO] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_LOCALI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FOR_NA] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_NAZION]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FOR_PI] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FOR_AL] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_RICERC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FOR_CE] ON [dbo].[u_FOR_an]([FOR_CODSOC], [FOR_CLICEE]) ON [PRIMARY]
GO
 
