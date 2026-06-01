if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CalcolaTotale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[CalcolaTotale]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE CalcolaTotale 
(
 @codPVD varchar(3)
)
 AS
SELECT SUM(cas_valcon + cas_valnoc + cas_valpos + cas_valcar + cas_valass + cas_valfin + cas_valalt) AS TOTALE
   FROM     dbo.u_pdv_sc
 WHERE     cas_codpdv = @codPVD
GROUP BY cas_codpdv
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

