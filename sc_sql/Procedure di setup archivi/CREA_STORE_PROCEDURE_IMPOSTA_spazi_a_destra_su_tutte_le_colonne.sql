GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_spaced_padright_all_string_columns')
DROP PROCEDURE usp_spaced_padright_all_string_columns
GO
CREATE PROCEDURE usp_spaced_padright_all_string_columns
@schema_Table_name VARCHAR(MAX)
AS
DECLARE @SQL AS VARCHAR(MAX)
 
SET @SQL=STUFF((SELECT ', ' + QUOTENAME([name])
+ ' = CAST(' + QUOTENAME([name]) + ' AS char(254))' FROM
sys.columns WHERE object_id=object_id(@schema_Table_name)
AND system_type_id IN(167)
FOR XML PATH('')),1,1,'')

PRINT @SQL
 
SET @SQL = 'UPDATE ' + @schema_Table_name + ' SET' + @SQL
PRINT @SQL
 
EXEC(@SQL)
GO