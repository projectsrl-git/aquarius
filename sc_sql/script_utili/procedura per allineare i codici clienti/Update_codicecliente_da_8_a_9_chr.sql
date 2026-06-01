/***********************   U_CLI_AN ***********************/ 
update u_cli_an 
set cli_codcli = '0'+substring(cli_codcli,1,len(cli_codcli)) 
where len(cli_codcli) = 8


/***********************   U_FOR_AN ***********************/
update u_for_an 
set for_codcli = '0'+substring(for_codcli,1,len(for_codcli)) 
where len(for_codcli) = 8


/***********************   U_ORD_TT ***********************/
update u_ord_tt 
set ord_codcli = '0'+substring(ord_codcli,1,len(ord_codcli)) 
where len(ord_codcli) = 8

update u_ord_tt 
set ord_codemi = '0'+substring(ord_codemi,1,len(ord_codemi)) 
where len(ord_codemi) = 8


/***********************   U_ORD_DD ***********************/
update u_ord_dd 
set ors_codemi = '0'+substring(ors_codemi,1,len(ors_codemi)) 
where len(ors_codemi) = 8

update u_ord_dd 
set ors_codcli = '0'+substring(ors_codcli,1,len(ors_codcli)) 
where len(ors_codcli) = 8


/***********************   U_FAT_TT ***********************/
update u_fat_tt 
set ord_codcli = '0'+substring(ord_codcli,1,len(ord_codcli)) 
where len(ord_codcli) = 8

update u_fat_tt 
set ord_codemi = '0'+substring(ord_codemi,1,len(ord_codemi)) 
where len(ord_codemi) = 8


/***********************   U_FAT_DD ***********************/
update u_fat_dd 
set ors_codemi = '0'+substring(ors_codemi,1,len(ors_codemi)) 
where len(ors_codemi) = 8

update u_fat_dd 
set ors_codcli = '0'+substring(ors_codcli,1,len(ors_codcli)) 
where len(ors_codcli) = 8


/***********************   U_BOL_TT ***********************/
update u_bol_tt 
set ord_codcli = '0'+substring(ord_codcli,1,len(ord_codcli)) 
where len(ord_codcli) = 8

update u_bol_tt 
set ord_codemi = '0'+substring(ord_codemi,1,len(ord_codemi)) 
where len(ord_codemi) = 8


/***********************   U_BOL_DD ***********************/
update u_bol_dd 
set ors_codemi = '0'+substring(ors_codemi,1,len(ors_codemi)) 
where len(ors_codemi) = 8

update u_bol_dd 
set ors_codcli = '0'+substring(ors_codcli,1,len(ors_codcli)) 
where len(ors_codcli) = 8


/***********************   U_ORF_TT ***********************/
update u_orf_tt 
set ord_codcli = '0'+substring(ord_codcli,1,len(ord_codcli)) 
where len(ord_codcli) = 8


/***********************   U_ORF_DD ***********************/
update u_orf_dd 
set ors_codcli = '0'+substring(ors_codcli,1,len(ors_codcli)) 
where len(ors_codcli) = 8


/***********************   U_RIC_TT ***********************/
update u_ric_tt 
set ric_codcli = '0'+substring(ric_codcli,1,len(ric_codcli)) 
where len(ric_codcli) = 8


/***********************   U_RIC_DD ***********************/
update u_ric_dd 
set ric_conto = substring(ric_conto,1,4)+'0'+substring(ric_conto,5,len(ric_conto)) 
where len(ric_conto)  = 12


/***********************   U_BAN_AN ***********************/
/* 	Per l'archivio delle banche non c'è nessun 
	riferimento a codici cliente 
*/


/***********************   INDICE ***********************/
update indice 
set mov_conto = substring(mov_conto,1,4)+'0'+substring(mov_conto,5,len(mov_conto)) 
where len(mov_conto) = 12


/***********************   PART_CLI ***********************/
update part_cli 
set par_codcli = substring(par_codcli,1,4)+'0'+substring(par_codcli,5,len(par_codcli)) 
where len(par_codcli) = 12



/***********************   SALDI_CLI ***********************/
update saldi_cli 
set par_codcli = substring(par_codcli,1,4)+'0'+substring(par_codcli,5,len(par_codcli)) 
where len(par_codcli) = 12


/***********************   PART_FOR ***********************/
update part_for 
set par_codcli = substring(par_codcli,1,4)+'0'+substring(par_codcli,5,len(par_codcli)) 
where len(par_codcli) = 12

/***********************   SALDI_FOR ***********************/
update saldi_for 
set par_codcli = substring(par_codcli,1,4)+'0'+substring(par_codcli,5,len(par_codcli)) 
where len(par_codcli) = 12


/***********************   MOV_CONT ***********************/
update mov_cont 
set mov_conto = substring(mov_conto,1,4)+'0'+substring(mov_conto,5,len(mov_conto)) 
where len(mov_conto) = 12


/***********************   CONTI ***********************/
update conti 
set con_conto = substring(con_conto,1,4)+'0'+substring(con_conto,5,len(con_conto)) 
WHERE CON_TIPOCO = 'C' AND len(con_conto) = 12

update conti 
set con_conto = substring(con_conto,1,4)+'0'+substring(con_conto,5,len(con_conto)) 
WHERE CON_TIPOCO = 'F' AND len(con_conto) = 12


/***********************   CCOSTO ***********************/
update ccosto 
set con_conto = substring(con_conto,1,4)+'0'+substring(con_conto,5,len(con_conto)) 
where len(con_conto) = 12


/***********************   U_PKG_TD ***********************/ 
update u_pkg_td 
set pkg_codcli = '0'+substring(pkg_codcli,1,len(pkg_codcli)) 
where len(pkg_codcli) = 8


/***********************   U_PKG_LE ***********************/ 
update u_pkg_le 
set leg_fornit = '0'+substring(leg_fornit,1,len(leg_fornit)) 
where len(leg_fornit) = 8



/*****************************************************

    ##### #   # #####      ##### ##  # ####
      #   #   # #          #     # # # #   #
      #   ##### ###        ###   #  ## #   #
      #   #   # #          #     #   # #   #
      #   #   # #####      ##### #   # ####

******************************************************/
 
