
/****** Object:  UserDefinedFunction [dbo].[ConcatenaProdottiBancale_prod_carichi]    Script Date: 25/07/2014 17:52:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[ConcatenaProdottiBancale_prod_carichi](@idbanc varchar(30))
returns varchar(8000)   
as  
Begin  
            Declare @result as varchar(8000)
            Set @result = ''
			select @result = @result + rtrim(codart) + '; ' from (
				select codart from prod_carichi
				where idbanc = @idbanc 
				group by codart
			) as t1
            return substring(@result,1,len(@result) - 1)
End  



GO


