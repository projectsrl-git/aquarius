SELECT par_codcli,par_npart,par_dtscad,par_nprog,par_nreg,* FROM PART_CLI WHERE PAR_CODCLI = '0126000001270'
update part_cli set par_npart = '6501' where id_unique = '4FA61BBA-1D5C-4C72-8088-221D2983B356'
update part_cli set par_DTSCAD = '2005/09/30' where id_unique = '4FA61BBA-1D5C-4C72-8088-221D2983B356'

SELECT par_codcli,par_npart,par_dtscad,par_nprog,par_nreg,* FROM PART_CLI WHERE PAR_CODCLI = '0123000000469' AND PAR_FATT = 11917.97 AND PAR_NPROG <> 100
SELECT par_codcli,par_npart,par_dtscad,par_nprog,par_nreg,* FROM PART_CLI WHERE PAR_CODCLI = '0123000000469' AND PAR_FATT = 5769.01 AND PAR_NPROG <> 100
update part_cli set par_DTSCAD = '2005/04/30' where id_unique = '68E9981D-E52D-4E25-B78A-8AC4CB3880D4'
update part_cli set par_DTSCAD = '2005/05/31' where id_unique = 'F915CDD0-E4BD-41B3-B6AB-8D7661B7A71F'

SELECT par_codcli,par_npart,par_dtscad,par_nprog,par_nreg,PAR_FATT,* FROM PART_CLI WHERE PAR_CODCLI = '0123000000554' AND PAR_FATT = 1323.07 AND PAR_NPROG <> 100
SELECT par_codcli,par_npart,par_dtscad,par_nprog,par_nreg,PAR_FATT,* FROM PART_CLI WHERE PAR_CODCLI = '0123000000554' AND PAR_NPART = '4744' AND PAR_NPROG <> 100 
update part_cli set par_DTSCAD = '2004/12/16' where id_unique = '72F1F419-C3B2-4F43-90D5-A0B0B036A962'
update part_cli set par_DTSCAD = '2005/05/17' where id_unique = '5AD5E4F9-B578-40B7-82F4-55ECAD6CDE71'



