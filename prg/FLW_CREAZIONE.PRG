CLOSE DATABASES ALL


Public myWingForm as Object
myWingForm = .f.

PUBLIC myActive as Boolean
myActive = .f.


SET CLASSLIB TO wing.vcx addi

USE &PUB_USER AS OPTDETAILS IN 0 AGAIN
SELECT OPTDETAILS

IF PUB_USER='ALB'

	DO FORM FORM\flw_creazione_admin.scx
ELSE

	DO FORM FORM\flw_creazione_user.scx
ENDIF
***DO FORM FORM\flw_creazione.scx


return