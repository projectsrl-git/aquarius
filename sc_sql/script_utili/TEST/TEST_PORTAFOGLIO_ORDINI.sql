SELECT	ORD_NUMPRG AS OLD_NUMPRG, 
		ORD_NUMBOP AS OLD_NUMBOP, 
		ORD_NOTEPRO AS OLD_NOTEPRO, 
		ORD_NOTESPE AS OLD_NOTESPE, 
		ORD_NOTEVAR AS OLD_NOTEVAR, 
		ORD_STAPRO AS OLD_STAPRO, 
		ORD_NUMBOD AS OLD_NUMBOD, 
		ORD_NUMBOD2 AS OLD_NUMBOD2, 
		ORD_NUMBOD3 AS OLD_NUMBOD3, 
		* 
from U_ORD_DD 
LEFT OUTER JOIN ( select	u_art_pr.art_codpri, 
				u_art_pr.art_codcol AS COLORE_FRONTE, 
				coalesce(u_art_an.art_codcolret,'') as COLORE_RETRO, 
				coalesce(u_art_an.art_fini,'') as FINI from u_art_pr 
			left outer join u_art_an 
			on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS ANAART 
ON U_ORD_DD.ORD_CODART = ANAART.ART_CODPRI 
LEFT OUTER JOIN (select CODICE, descri as DESFINI from para) as PARA_FIN 
ON PARA_FIN.CODICE = 'FIN'+ANAART.FINI WHERE ANAART.FINITURA = 'C'