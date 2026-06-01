UPDATE U_CLI_AN SET 
cli_baefor = cli_bae,
cli_nazfor = cli_nazion,
cli_chefor = cli_codche,
cli_cinfor = cli_codcin,
cli_abifor = cli_codabi,
cli_cabfor = cli_codcab,
cli_nccfor = cli_numcc,
cli_ibafor = cli_cdiban
WHERE 'CPA'+cli_conpag IN (SELECT CODICE FROM PARA WHERE CODICE LIKE 'CPA%' AND SUBSTRING(LIBERA,10,1) <> 'X')


UPDATE U_CLI_AN SET 
cli_bae = '',
cli_nazion = '',
cli_codche = '',
cli_codcin = '',
cli_codabi = '',
cli_codcab = '',
cli_numcc = '',
cli_cdiban = ''
WHERE 'CPA'+cli_conpag IN (SELECT CODICE FROM PARA WHERE CODICE LIKE 'CPA%' AND SUBSTRING(LIBERA,10,1) <> 'X')
