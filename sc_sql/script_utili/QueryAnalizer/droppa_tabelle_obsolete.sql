if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[corpo]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[corpo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[corpo2]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[corpo2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJ]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJ]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJBEBE]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJBEBE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJCAR]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJCAR]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJCLA]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJCLA]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJCRI]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJCRI]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJDAV]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJDAV]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJFAU]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJFAU]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJFLA]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJFLA]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJMAX]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJMAX]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJMOR]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJMOR]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJQ]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJQ]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CPJSER]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CPJSER]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[D]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[D]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CCOSTX]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CCOSTX]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CCOSTX]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CCOSTX]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CONTIX]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CONTIX]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FPSMOVC]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[FPSMOVC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[M1999]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[M1999]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MKDUEPJ]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[MKDUEPJ]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MOVSTALL]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[MOVSTALL]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTFOR]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PARTFOR]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PIPPO]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PIPPO]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROVA]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROVA]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SDF]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SDF]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SERG]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SERG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SERGIO]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SERGIO]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TEMPO]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[TEMPO]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UCLIAN]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[UCLIAN]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ZONET_VE]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ZONET_VE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBI_LOG]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBI_LOG]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBI_ORDINE]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBI_ORDINE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBI_STRU]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBI_STRU]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEP]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIEP]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEP10]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIEP10]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEP20]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIEP20]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEP30]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIEP30]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEP70]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIEP70]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEPEF]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIEPEF]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC17]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC17]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC20]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC20]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC30]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC30]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC40]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC40]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC50]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC50]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC60]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC60]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPC70]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPC70]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIPCEF]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIPCEF]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRH]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRH]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRH61]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRH61]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRH62]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRH62]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRH63]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRH63]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRH64]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRH64]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRH65]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRH65]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIRHEF]') 
   and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CBIRHEF]
GO
