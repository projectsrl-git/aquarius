create function dbo.ConcatenaClienti(@pj_prgprd1 varchar(100),@pj_prgprd2 varchar(100))   
returns varchar(8000)   
as  
Begin  
            Declare @result as  varchar(8000)   
            Set @result =''  
			select @result = @result + rtrim(CAST ( CAST ( pr5_codcli AS int) AS varchar)) + '; ' from u_prd_d5 
			where u_prd_d5.pj_prgprd1 = @pj_prgprd1 and pj_prgprd2 = @pj_prgprd2
			group by pr5_codcli
            return @result   
End  

