if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetSearch_Paging02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetSearch_Paging02]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE GetSearch_Paging02 (
  @tabella nvarchar(255),
  @what nvarchar(255),
  @what_1 nvarchar(255),
  @what_2 nvarchar(255),
  @what_3 nvarchar(255),
  @ordine nvarchar(255),
  @PageIndex int,
  @PageSize int
) AS

-- ricavo gli estremi inferiore e superiore
DECLARE @Upper int
DECLARE @Lower int
DECLARE @sqlstmt1 nvarchar(4000)
DECLARE @sqlstmt2 nvarchar(4000)

SET @Lower = (@PageSize * (@PageIndex-1)) + 1
SET @Upper = @Lower + @PageSize - 1

SET @sqlstmt1 = ' INSERT INTO #Paging(OriginalID)' +
		' SELECT ID_unique FROM ' + @TABELLA + 
		' WHERE ' + @what + @what_1 + @what_2 + @what_3 +
		' ORDER BY ' + @ordine

SET @sqlstmt2 = ' SELECT t.* FROM #Paging p, ' + @TABELLA + ' t' +
		' WHERE p.OriginalID = t.ID_unique ' + 
		' AND CAST(p.RowID AS VARCHAR) >= ' + CAST(@Lower AS VARCHAR) + 
		' AND CAST(p.RowID AS VARCHAR) <= ' + CAST(@Upper AS VARCHAR) +
		' ORDER BY ' + @ordine

-- tabella temporanea
CREATE TABLE #Paging
(
  RowID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  OriginalID varchar(50) NOT NULL
)

-- inserisco la chiave della tabella in quella di appoggio
--INSERT INTO #Paging(OriginalID)
--  SELECT ID_unique FROM U_BAN_AN WHERE @what

-- estraggo i dati dalle due tabelle
--SELECT t.* FROM #Paging p, U_BAN_AN t
--  WHERE
--  p.OriginalID = t.ID_unique AND
--  p.RowID >= @Lower AND p.RowID <= @Upper
--  order by @ordine


EXEC dbo.sp_executesql @sqlstmt1

EXEC dbo.sp_executesql @sqlstmt2


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

