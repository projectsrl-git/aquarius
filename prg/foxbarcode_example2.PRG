
SET PROCEDURE TO prg\FoxBarcode.prg ADDITIVE
SET PROCEDURE TO prg\gpimage2.prg ADDITIVE

*-- Create object
loFbc = CREATEOBJECT("FoxBarcode")

*!*	*-- Set the properties
*!*	WITH loFbc
*!*	  .cImageType = "PNG"
*!*	  .nBarcodeType = 110 && Code 128
*!*	  .cSet128 = "A" && Set 128 C
*!*	  .nImageHeight = 100
*!*	  .nFactor = 2
*!*	ENDWITH

*!*	*-- Generate image
*!*	lcImagen = loFbc.BarcodeImage("MFLMPE0100551400")


*loFbc.BarcodeImage("","",[cText="MFLMPE0100551400", cImageType="PNG", nBarcodeType=110, cSet128="A", nImageHeight=100, nFactor=2])
  
  
CREATE CURSOR TEST (CAMPO1 C(10))
APPEND BLANK
REPLACE CAMPO1 WITH "CIAO"
GO TOP

REPORT FORM "report\test" NOCONSOLE PREVIEW
