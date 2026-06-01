CREATE FUNCTION ribalta2  (@DATE varchar(10))
RETURNS varchar(10)
AS
BEGIN
   DECLARE @_daterit varchar(10)
   DECLARE @_separa varchar(1)
   DECLARE @_giorno varchar(2)
   DECLARE @_mese varchar(2)
   DECLARE @_anno varchar(4)
   set @_daterit = SPACE(10)
   set @_separa  = ''
   if SUBSTRING(@DATE,3,1) in ('.','-','/') 
		begin	
	      set @_SEPARA=SUBSTRING(@DATE,3,1)
	      set @_GIORNO=SUBSTRING(@DATE,1,2)
		   set @_MESE  =SUBSTRING(@DATE,4,2)
		   set @_ANNO  =SUBSTRING(@DATE,7,4)
		   set @_daterit =@_ANNO+@_SEPARA+@_MESE+@_SEPARA+@_GIORNO
		end
   if SUBSTRING(@DATE,5,1) in ('.','-','/')
		begin   
		   set @_SEPARA=SUBSTRING(@DATE,5,1)
		   set @_GIORNO=SUBSTRING(@DATE,9,2)
		   set @_MESE  =SUBSTRING(@DATE,6,2)
		   set @_ANNO  =SUBSTRING(@DATE,1,4)
		   set @_daterit =@_GIORNO+@_SEPARA+@_MESE+@_SEPARA+@_ANNO
	end
   RETURN(@_daterit)
END
