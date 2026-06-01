create function dbo.ConcatenaProdotti(@pj_prgprd1 varchar(100),@pj_prgprd2 varchar(100))   
returns varchar(8000)   
as  
Begin  
            Declare @result as  varchar(8000)   
            Set @result =''  
			select @result = @result + rtrim(pr4_codart) + '; ' from u_prd_d4 
			where u_prd_d4.pj_prgprd1 = @pj_prgprd1 and pj_prgprd2 = @pj_prgprd2
			group by pr4_codart
            return @result   
End  


