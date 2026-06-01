SELECT * FROM U_LIS_TT WHERE LIS_CODCLI = '000000001' AND LIS_CODART= 'AM 514'
SELECT *  FROM U_LIS_LG
SELECT * FROM U_LIS_LG WHERE lis_codsoc = '01' and lis_tipo = 'CLIENTE' and lis_codcli = '000000001' order by lis_codsoc,lis_tipo,lis_codcli
select * from u_lis_tt where lis_codsoc = '01' and lis_codcli = '000000001' and lis_codart = 'AM 514' order by lis_codsoc,lis_codcli,lis_codart
