
/****** Object:  UserDefinedFunction [dbo].[ConcatenaOrdiniBancale_prod_carichi]    Script Date: 28/07/2014 09:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[ConcatenaOrdiniBancale_prod_carichi](@idbanc varchar(30))
returns varchar(8000)   
as  
Begin  
            Declare @result as varchar(8000)
            Set @result = ''
			select @result = @result + rtrim(numord) + '; ' from (
				select numord from prod_carichi
				left outer join prod_ordini on prod_ordini.codsys = prod_carichi.sysord
				where idbanc = @idbanc 
				group by numord
			) as t1
            return substring(@result,1,len(@result) - 1)
End  



GO


