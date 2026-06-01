create function dbo.ConcatenaOrdiniBancale_d5_pk(@pr5_idbanc varchar(30))
returns varchar(8000)   
as  
Begin  
            Declare @result as varchar(8000)
            Set @result = ''
			select @result = @result + rtrim(pr5_numord) + '; ' from (
				select pr5_numord from u_prd_d5
				where pr5_idbanc = @pr5_idbanc 
				group by pr5_numord
				union
				select pr5_numord from u_prd_pk
				where pr5_idbanc = @pr5_idbanc 
				group by pr5_numord
			) as t1
            return substring(@result,1,len(@result) - 1)
End  


