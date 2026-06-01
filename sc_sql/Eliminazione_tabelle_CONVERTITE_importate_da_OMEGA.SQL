if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANAAZI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANAAZI]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FIGPROF]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FIGPROF]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CENTRCOM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CENTRCOM]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[STATORIC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[STATORIC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TITOLO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TITOLO]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[STATOCIV]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[STATOCIV]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[POSMILIT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[POSMILIT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[statoris]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[statoris]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[settazi]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[settazi]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[areamerc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[areamerc]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[centrcom]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[centrcom]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CLASSTC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CLASSTC]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[STATORIC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[STATORIC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMUNI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[COMUNE]
GO

