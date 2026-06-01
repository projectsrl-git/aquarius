if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index MOV_CONT.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index MOV_CONT.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMINTER')
   drop index MOV_CONT.NUMINTER
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_DTREG')
   drop index MOV_CONT.MOV_DTREG
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NREGIS')
   drop index MOV_CONT.MOV_NREGIS
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NDOC')
   drop index MOV_CONT.MOV_NDOC
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NPROT')
   drop index MOV_CONT.MOV_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCONTO')
   drop index MOV_CONT.DESCONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_DTDOC')
   drop index MOV_CONT.MOV_DTDOC
GO
 
CREATE INDEX [CONTO] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DTREG], [MOV_NREGIS]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_DESMOV]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMINTER] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_DTREG] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_DTREG], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NREGIS] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NREGIS]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NDOC] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NPROT] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCONTO] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_DTDOC] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_DTDOC], [MOV_NDOC]) ON [PRIMARY]
GO
 
