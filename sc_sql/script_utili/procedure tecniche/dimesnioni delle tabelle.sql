---- http://www.ideativi.it/blog/138/dimensioni-di-tutte-le-tabelle-di-un-database-sql-server.aspx

CREATE PROCEDURE [dbo].[CalculateTableSize]
AS
BEGIN
-- realizzato da - 2011
SET NOCOUNT ON;

CREATE TABLE #FrameworkTableSize(
[TableName] [varchar](100) NULL,
[RowNumber] [int] NULL,
[KBReservedSize] varchar(100) NULL,
[KBDataSize] varchar(100) NULL,
[KBIndexSize] varchar(100) NULL,
[KBUnusedSize] varchar(100) NULL
)

declare DBObjectCursor cursor for select 'dbo.' + name from dbo.sysobjects where xtype = 'u'
declare @TableName varchar(100)

open DBObjectCursor
fetch next from DBObjectCursor into @TableName

while @@fetch_status = 0
begin
insert into #FrameworkTableSize (TableName, RowNumber , KBReservedSize, KBDataSize, KBIndexSize , KBUnusedSize)
exec sp_spaceused @TableName

fetch next from DBObjectCursor into @TableName
end

close DBObjectCursor
deallocate DBObjectCursor

SELECT * FROM #FrameworkTableSize

END