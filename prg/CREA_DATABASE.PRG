************************************************
* PROGRAM CREA_DATABASE.PRG
************************************************

set procedure to Tesoreria_base_class.prg additive
oTes = CREATEOBJECT("Tesoreria_base")
oTes.CreaTabellaMovimentiDelleRisorse
oTes.CreaTabellaCausaliMovimentiBancari
oTes.CreaTabellaRisorse
oTes.CreaTabellaSaldi
RELEASE oTes

