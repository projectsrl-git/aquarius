create function dbo.ConcatenaOrdiniBancale_pk(@pr5_idbanc varchar(30))
returns varchar(8000)   
as  
Begin  
            Declare @result as varchar(8000)
            Set @result = ''
			select @result = @result + rtrim(pr5_numord) + '; ' from u_prd_pk
			where pr5_idbanc = @pr5_idbanc 
			group by pr5_numord
            return substring(@result,1,len(@result) - 1)
End  


