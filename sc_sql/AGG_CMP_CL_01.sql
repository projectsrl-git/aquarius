
-- SCRIPT UTILITY PER AGGIORNAMENTO ARCHIVIO CAMPIONATURE

update u_cmp_cl
-- AGGIORNAMENTO SCHEDA "DISPONIBILITA' LOTTI"
set	cmp_displo = 'MAGAZZINO CAMPIONATURA',
	cmp_dtcm0x = cmp_dtcm03,
	cmp_orcm0x = cmp_orcm03,
	cmp_cdop0x = 'CQ2',
	cmp_dsop0x = 'C.Q. - Vellucci Mario',
	cmp_dtcm1x = cmp_dtcm13,
	cmp_orcm1x = cmp_orcm13,
	cmp_dsop1x = 'C.Q. - Vellucci Mario',
-- AGGIORNAMENTO SCHEDA "RISPOSTA CAMPIONATURA"
	cmp_seteva = '*',
	cmp_dtumat = cmp_dtcm13,
	cmp_dtcm04 = cmp_dtcm03,
	cmp_orcm04 = cmp_orcm03,
	cmp_cdop04 = 'LO1',
	cmp_dsop04 = 'LOG. - Landi Antonio',
	cmp_dtcm14 = cmp_dtcm13,
	cmp_orcm14 = cmp_orcm13,
	cmp_dsop14 = 'LOG. - Landi Antonio'
-- CONDIZIONE => SOLO LE CAMPIONATURE CON RICHIESTA CAMPIONATURA COMPILATA
 WHERE cmp_dtcm03 <> ''