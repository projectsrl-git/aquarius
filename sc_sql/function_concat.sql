create function dbo.ConcatCliPrgTaglio(@prgtg varchar(10))   
returns varchar(8000)   
as  
Begin  
            Declare @result as  varchar(8000)   
            Set @result =''  
			select @result = @result + rtrim(CAST ( CAST ( pr5_codcli AS int) AS varchar)) + '; ' 
			from u_prd_d5 as liv5
				left outer join u_prd_d4 as liv4
				on liv4.pj_prgprd4 = liv5.pj_prgprd4
			where liv4.pr4_nprgtg = rtrim(@prgtg)
			group by liv5.pr5_codcli
            return @result   
End  

--drop function dbo.ConcatCliPrgTaglio