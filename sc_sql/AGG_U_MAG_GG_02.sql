/* 
****************************************************************************************
ALTERAZIONE DELLA SOLA DIMENSIONE DEL CAMPO
N.B.: E' STATO NECESSARIO ELIMINARE GLI INDICI IN CUI E' COINVOLTO IL CAMPO 'MAG_GIACEN'
****************************************************************************************
*/

if exists (select * from sys.indexes where name = 'U_MAG_G5' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_G5 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'U_MAG_G6' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_G6 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'U_MAG_G7' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_G7 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'U_MAG_G8' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_G8 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'U_MAG_G9' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_G9 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'U_MAG_10' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_10 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'U_MAG_11' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX U_MAG_11 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_01' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_01 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_02' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_02 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_03' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_03 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_04' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_04 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_09' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_09 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_10' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_10 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_11' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_11 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_12' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_12 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_13' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_13 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_14' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_14 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_15' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_15 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_17' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_17 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_18' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_18 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_20' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_20 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_21' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_21 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_23' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_23 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_29' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_29 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_30' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_30 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_31' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_31 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_32' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_32 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_33' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_33 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_34' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_34 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_35' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_35 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_36' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_36 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_37' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_37 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_38' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_38 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_40' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_40 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_42' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_42 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_43' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_43 ON U_MAG_GG
GO
if exists (select * from sys.indexes where name = 'INDICE_46' and object_id = object_id(N'[dbo].[U_MAG_GG]'))
	DROP INDEX INDICE_46 ON U_MAG_GG
GO


ALTER TABLE [dbo].[U_MAG_GG] ALTER COLUMN
	 MAG_GIACEN Numeric (19,4) NULL
GO


/* 
****************************************************************************************
AGGIUNTA CAMPO QUANTITA' IN METRI CUBI
****************************************************************************************
*/

ALTER TABLE [dbo].[U_MAG_GG] ADD
	 [MAG_QTAMC] NUMERIC(19,4) NULL
GO

ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_MAG_GG_MAG_QTAMC] DEFAULT (0) FOR [MAG_QTAMC]
go

UPDATE U_MAG_GG SET MAG_QTAMC = 0
