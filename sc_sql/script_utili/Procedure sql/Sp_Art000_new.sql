if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sp_Art000_new]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_Art000_new]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.Sp_Art000_new
	@maxRighe int,
	@iPag  int,
	@Tabella varchar(255),
	@CampiVista varchar(255),
	@CampiFiltro varchar(255),
	@CampiFiltro1 varchar(255),
	@Ordine varchar(255)

AS
DECLARE @sqlstmt nvarchar(4000)
SET ROWCOUNT @maxRighe

SET @sqlstmt = 'SELECT ' + @CampiVista 
				 + ' FROM u_art_pr AS U1 INNER JOIN  u_mag_an as M1'
				 + '		on u1.art_codsoc = m1.mag_codsoc'
				 + '		and u1.art_codpri = m1.mag_codart'
				 + ' WHERE ' 
				 + '		(SELECT COUNT(*)'
				 + '		 FROM u_art_pr AS U2 INNER JOIN  u_mag_an as M2'
				 + '		on u2.art_codsoc = m2.mag_codsoc'
				 + '		and u2.art_codpri = m2.mag_codart'
				 + '  	 WHERE  ' + @CampiFiltro
				 + '		 AND ' + @CampiFiltro1
				 + '  	) > ' + CAST((@maxRighe * @iPag) - (@maxRighe + 1) AS varchar)
				 + ' AND ' + @CampiFiltro1
				 + ' ORDER BY ' + @Ordine

EXEC dbo.sp_executesql @sqlstmt
GO

SET ROWCOUNT 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


