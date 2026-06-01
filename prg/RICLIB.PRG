*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA PER LE RICERCHE DINAMICHE                               ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################



*****************************************************************************
PROCEDURE clirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\clirice"																								           					   																				&& nome della procedura con istruzioni sql
_p_alias	= "cu_cli_an"																										           					   																				&& nome del cursore in cui memorizzare i dati
*_p_campi	= "cli_nazion;cli_ricerc;cli_codcli;cli_ragsoc;cli_indir;cli_locali;cli_pariva;cli_ivacee;cli_baefor;cli_bae;cli_dtclok;cli_conpag;cli_obsol;cli_zona;regione;cli_idsdi;cli_epec;cli_coddir" 	&& ERASMO - 21/06/2023			&& elenco dei campi da visualizzare
_p_campi	= "cli_nazion;cli_ricerc;cli_codcli;cli_ragsoc;cli_indir;cli_locali;cli_pariva;cli_ivacee;cli_baefor;cli_bae;cli_dtclok;cli_conpag;cli_obsol;cli_zona;regione;cli_idsdi;cli_epec" 	&& ERASMO - 20/07/2023			&& elenco dei campi da visualizzare
*_p_testa	= "Naz;Ric.altern;Cod.cliente;Ragione sociale;Indirizzo;Località;P.Iva;Iva cee;Banca Forn.;Banca Cliente;Dt.blocco forn.;Cond.Pagam.;Obsoleto;Zona;Regione;Cod.Destinatario;PEC e-mail;Cod.Impianto" 	&& ERASMO - 21/06/2023	&& intestazione dei campi da visualizzare
_p_testa	= "Naz;Ric.altern;Cod.cliente;Ragione sociale;Indirizzo;Località;P.Iva;Iva cee;Banca Forn.;Banca Cliente;Dt.blocco forn.;Cond.Pagam.;Obsoleto;Zona;Regione;Cod.Destinatario;PEC e-mail" 	&& ERASMO - 20/07/2023	&& intestazione dei campi da visualizzare
_p_tiporic	= "Ragione sociale (inizia per),1,Ragione sociale (contiene),2,Codice cliente,3,Partita iva,4,Agente,5,Ricerca alternativa,6,Località,7,Nazione,8,Iva Cee,9," + ;
              "Banca Forn.,10,Banca Cliente,11,Data blocco fornit.,12,Cod.Condiz.Pagam.,13,Zona,14,Riferimento,15,Listino,16,Codice fiscale,17,Regione,18,Cod.Destinatario,19,PEC e-mail,20,Cod.Gruppo,21,Cod.Impianto (contiene),22" 	&& ERASMO - 21/06/2023
_p_nomeric	= "Ricerca anagrafica clienti"																						           																										&& descrizione della ricerca


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE forrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\forrice"																			
_p_alias	= "cu_for_an"																					
_p_campi	= "for_nazion;for_ricerc;for_codcli;for_ragsoc;for_locali;for_telefo;for_conpag;for_pf;for_ragdue;for_indir;for_bae;for_obsol;for_formapagamento"
_p_testa	= "Naz;Ric.alter.;Cod.for.;Ragione sociale;Località;Telefono;C.pag.;P.Iva;Iva cee;2° rag.soc.;Indirizzo;Banca;Obsoleto;Tipo Pag."
_p_tiporic	= "Ragione sociale (inizia per),1,Ragione sociale (contiene),2,Codice fornitore,3,Partita iva,4,Ricerca alternativa,5,Località,6,Banca,7,Tipo pagamento,8,Riferimento,9,Listino,10,Nazione,11,Iva Cee,12,Codice fiscale,13"
_p_nomeric	= "Ricerca anagrafica fornitori"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE forarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\forarice"																			
_p_alias	= "cu_for_pr"																					
_p_campi	= "fpr_codfor;fpr_ragfor;fpr_codmag;fpr_datuca;fpr_przcon;fpr_seqpri"
_p_testa	= "Cod.for.;Ragione sociale;Magazzino;Dt.Ult.Car.;Prz da contratto;Priorità"
_p_tiporic	= "Codice Fornitore,1,Ragione Sociale,2,Magazzino,3,Dt.Ult.Car. (gg/mm/aaaa),4,Prezzo da contratto,5,Priorità,6"
_p_nomeric	= "Ricerca anagrafica fornitori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE agerice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\AGERICE"																			
_p_alias	= "cu_age_an"																					
_p_campi	= "age_codice;age_ragsoc"					
_p_testa	= "Codice;Descrizione"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca anagrafica agenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE ammrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ammrice"																			
_p_alias	= "cu_amm_tt"																					
_p_campi	= "ord_ammort;ord_numord;ord_datord;ord_codcli;ord_ragsoc;ord_valore;ord_cge;ord_cdarti;ord_dsarti"					
_p_testa	= "Amm.;N.Fatt.;Dt.fattura;Cod.for.;Ragione sociale;Valore;Cge;Articolo;Descrizione"							
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Cod.Fornitore,4"
_p_nomeric	= "Ricerca fatture di acquisto con quote di ammortamento"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE artrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\artrice"																			
_p_alias	= "cu_art_pr"																					
*_p_campi	= "art_codpri;art_descr;art_unimis;art_przven;art_przcos;art_cstmat;art_linea;art_coord;art_codmat;"+;                   
              "art_desmat;art_codcol;art_descol;art_cddiba;art_dsdiba;art_cge;art_datins;art_datvar;art_spesso;art_catmer;art_cldog;art_desrid"
*!*	_p_campi	= "art_codpri;art_descr;art_unimis;art_przven;art_przcos;art_ulpcar;art_linea;art_coord;art_codmat;"+;                   
*!*	              "art_desmat;art_codcol;art_descol;art_cddiba;art_dsdiba;art_cge;art_datins;art_datvar;art_spesso;art_catmer;art_cldog;art_desrid"  && ERASMO - 19/09/2023
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Prezzo costo;Prz.Medio.Pond.;Linea;Coordinate;Cod.materiale;"+;            
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;   
*!*	              "Data ins.;Data mod.;Spessore;Cat.merc.;Classe dog."
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Prezzo costo;Prz.Medio.Pond.;Linea;Coordinate;Cod.materiale;"+;            
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;   
*!*	              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog."  && ERASMO - 04/11/2022
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Prezzo costo;Prz.Medio.Pond.;Linea;Coordinate;Cod.materiale;"+;            
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;   
*!*	              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog.;Des.ridotta/REF"  && ERASMO - 22/05/2023
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Prezzo costo;Costo mat.;Linea;Coordinate;Cod.materiale;"+;            
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;   
*!*	              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog.;Des.ridotta/REF"  && ERASMO - 20/06/2023
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Costo std.;Costo ult.car.;Linea;Coordinate;Cod.materiale;"+;            
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;   
*!*	              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog.;Des.ridotta/REF"  && ERASMO - 19/09/2023
*!*	**=> ERASMO - INIZIO 26/02/2024
*!*	_p_campi	= "art_codpri;art_descr;art_unimis;art_przven;art_przcos;art_ulpcar;art_linea;art_coord;art_codmat;"+;
*!*	              "art_desmat;art_codcol;art_descol;art_cddiba;art_dsdiba;art_cge;art_datins;art_datvar;art_spesso;art_catmer;art_cldog;art_desrid;art_codf1;art_desf1;art_nota1"
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Costo std.;Costo ult.car.;Linea;Coordinate;Cod.materiale;"+;
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;
*!*	              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog.;Des.ridotta/REF;Cod.forn.1;Rag.soc.forn.1;Cod.art.forn.1"
*!*	**=> ERASMO - FINE 26/02/2024
*!*	**=> ERASMO - INIZIO 08/05/2024
*!*	_p_campi	= "art_codpri;art_descr;art_unimis;art_przven;art_przcos;art_ulpcar;art_linea;art_coord;art_codmat;"+;
*!*	              "art_desmat;art_codcol;art_descol;art_cddiba;art_dsdiba;art_cge;art_datins;art_datvar;art_spesso;art_catmer;art_cldog;art_desrid;art_codf1;art_desf1;art_nota1;art_desest"
*!*	_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Costo std.;Costo ult.car.;Linea;Coordinate;Cod.materiale;"+;
*!*	              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;
*!*	              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog.;Des.ridotta/REF;Cod.forn.1;Rag.soc.forn.1;Cod.art.forn.1;Descr.estesa"
*!*	**=> ERASMO - FINE 08/05/2024
**=> ERASMO - INIZIO 19/05/2026
_p_campi	= "art_codpri;art_descr;art_unimis;art_przven;art_przcos;art_ulpcar;art_linea;art_coord;art_codmat;"+;
              "art_desmat;art_codcol;art_descol;art_cddiba;art_dsdiba;art_cge;art_datins;art_datvar;art_spesso;art_catmer;art_cldog;art_desrid;art_codf1;art_desf1;art_nota1;art_desest;art_obsol"
_p_testa	= "Codice articolo;Descrizione;U.m.;Prezzo vendita;Costo std.;Costo ult.car.;Linea;Coordinate;Cod.materiale;"+;
              "Descr.tipo prod.;Cod.colore;Descriz.colore;Cod.distinta base;Descr.distinta base;Cod.conto contabile;"+;
              "Data mod.;Data ins.;Spessore;Cat.merc.;Classe dog.;Des.ridotta/REF;Cod.forn.1;Rag.soc.forn.1;Cod.art.forn.1;Descr.estesa;Obsol."
**=> ERASMO - FINE 19/05/2026

** 01/07/2022 SERGIO INIZIO
*!*	_p_tiporic	= "Codice (contiene),1,Codice (inizia per),2,Descrizione (inizia per),3,Descrizione (contiene),4,Linea prodotto,5,Coordinate,6,Codice tipo prodotto,7,Descr.tipo prodotto,8,"+;
*!*	              "Codice colore,9,Descrizione colore,10,Cod.distinta base,11,Descr.distinta base,12,Cod.conto contabile,13,"+; 
*!*	              "Dat.ins.(aaaa/mm/gg),14,Dat.mod.(aaaa/mm/gg),15,Spessore,16,Categ.merceologica,17,Classe doganale,18,Specifica acq. (contiene),19,"+;
*!*	              "Cod. fornitore,20,Rag.soc. fornitore (contiene),21,Cod. art. fornitore,22,Cod. famiglia categ. sconti art.,23"
_p_tiporic	= "Codice (contiene),1,Codice (inizia per),2,Descrizione (inizia per),3,Descrizione (contiene),4,Descrizione ridotta/REF,5,Linea prodotto,6,Coordinate,7,Codice tipo prodotto,8,Descr.tipo prodotto,9,"+;
              "Codice colore,10,Descrizione colore,11,Cod.distinta base,12,Descr.distinta base,13,Cod.conto contabile,14,"+; 
              "Dat.ins.(aaaa/mm/gg),15,Dat.mod.(aaaa/mm/gg),16,Spessore,17,Categ.merceologica,18,Classe doganale,19,Specifica acq. (contiene),20,"+;
              "Cod. fornitore,21,Rag.soc. fornitore (contiene),22,Cod. art. fornitore,23,Cod. famiglia categ. sconti art.,24"
** 01/07/2022 SERGIO FINE



_p_nomeric	= "Ricerca anagrafica articoli"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE astrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\astrice"																			
_p_alias	= "cu_ast_an"																					
_p_campi	= "ast_numsca;ast_numsch;ast_datsca;ast_codmag;ast_fila_x;ast_pian_x;ast_ubic_x;ast_codcli;"+;
			  "ast_codloc;ast_codcco;ast_cddoc1;ast_anno1;ast_numda1;ast_numal1;ast_datda1;ast_datal1;"+;
			  "ast_cddoc2;ast_anno2;ast_numda2;ast_numal2;ast_datda2;ast_datal2;ast_cddoc3;ast_anno3;"+;
			  "ast_numda3;ast_numal3;ast_datda3;ast_datal3;ast_cddoc4;ast_anno4;ast_numda4;ast_numal4;"+;
			  "ast_datda4;ast_datal4;ast_cddoc5;ast_anno5;ast_numda5;ast_numal5;ast_datda5;ast_datal5;ast_codope"					
_p_testa	= "N.scatola;N.scheda;Data reg.;Mag.;Fila;Piano;Ubicaz.;Cliente;Filiale/ufficio;"+;
			  "Centro di costo;Tipo doc.1;Anno 1;Num.da 1;Num.al 1;Data da 1;Data al 1;Tipo doc.2;Anno 2;"+;
			  "Num.da 2;Num.al 2;Data da 2;Data al 2;Tipo doc.3;Anno 3;Num.da 3;Num.al 3;Data da 3;Data al 3;"+;
			  "Tipo doc.4;Anno 4;Num.da 4;Num.al 4;data da 4;Data al 4;Tipo doc.5;Anno 5;Num.da 5;Num.al 5;"+;
			  "Data da 5;Data al 5;Operatore"							
_p_tiporic	= "N°scatola (decresc.),1,N°scatola (cresc.),2"
_p_nomeric	= "Ricerca archiviazione documenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
*****************************************************************************
*****************************************************************************


*****************************************************************************
PROCEDURE azirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\azirice"																			
_p_alias	= "cu_azi_an"																					
_p_campi	= "azi_ragsoc;"					
_p_testa	= "Ragione sociale;"					
_p_tiporic	= "Codice Societa'"
_p_nomeric	= "Ricerca anagrafica azienda"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE banrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\banrice"																			
_p_alias	= "cu_ban_an"																					
_p_campi	= "ban_codban;ban_prese;ban_desban;ban_indir;ban_loca;ban_codabi;ban_codcab;ban_top"					
_p_testa	= "Banca;Tb;Descrizione banca;Indirizzo;Località;ABI;CAB;Top"					
_p_tiporic	= "Codice Banca,1,Banche pres.effetti,2,Descrizione Banca,3,Località,4,Cod.ABI,5,Cod.CAB,6"
_p_nomeric	= "Ricerca anagrafica banche"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

** 06/10/2022 SERGIO INIZIO
*****************************************************************************
PROCEDURE ricrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric


_p_click 	= "ricerche\ricrice"																			
_p_alias	= "impianti_ri"	

*_p_campi	= "ord_codric;ord_data_r;ord_ragsoc;ord_noteric_r;ord_apeclo"
*_p_testa	= "Codice;Data;Ragione sociale cliente;_______________________________________________ Note ________________________________________________;__A/C__"					
*_p_campi	= "ord_codric;ord_data_r;ord_ccodsche;ord_ragsoc;ord_noteric_r;ord_apeclo"	&& ERASMO - 17/01/2024
*_p_testa	= "Codice;Data;Cod.Impianto;Ragione sociale cliente;Note;A/C"							&& ERASMO - 17/01/2024
*_p_campi	= "ord_codric;ord_data_r;ord_dtults_r;ord_ccodsche;ord_ragsoc;ord_noteric_r;ord_apeclo"	&& ERASMO - 16/02/2024
*_p_testa	= "Codice;Data;Dt.ult.soll.;Cod.Impianto;Ragione sociale cliente;Note;A/C"					&& ERASMO - 16/02/2024
_p_campi	= "ord_codric;ord_data_r;ord_dtults_r;ord_ccodsche;ord_ragsoc;ord_zona;ord_noteric_r;ord_apeclo"	&& ERASMO - 15/03/2024
_p_testa	= "Codice;Data;Dt.ult.soll.;Cod.Impianto;Ragione sociale cliente;Zona;Note;A/C"						&& ERASMO - 15/03/2024

*_p_tiporic	= "Codice richiesta,1,Data richiesta,2,Codice impianto (contenuto),3,Codice cliente,4,Ragione sociale cliente,5"
*_p_tiporic	= "Codice richiesta,1,Data registraz.,2,Codice impianto (contenuto),3,Codice cliente,4,Ragione sociale cliente,5"  && ERASMO - 08/01/2024
*_p_tiporic	= "Codice richiesta,1,Data registraz.,2,Data ult. sollecito,3,Codice impianto (contenuto),4,Codice cliente,5,Ragione sociale cliente,6"  && ERASMO - 16/02/2024
*_p_tiporic	= "Codice richiesta,1,Data registraz.,2,Data ult. sollecito,3,Codice impianto (contenuto),4,Codice cliente,5,Ragione sociale cliente,6,Cod.Zona,6"  && ERASMO - 15/03/2024
_p_tiporic	= "Codice richiesta,1,Data registraz.,2,Data ult. sollecito,3,Codice impianto (contenuto),4,Codice cliente,5,Ragione sociale cliente,6,Cod.Zona,7,Note (contenuto),8"  && ERASMO - 26/08/2024
_p_nomeric	= "Ricerca richieste interventi"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

** 06/10/2022 SERGIO FINE



** 22/10/2022 SERGIO INIZIO
*****************************************************************************
PROCEDURE liirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric


_p_click 	= "ricerche\liirice"																			
_p_alias	= "impianti_li"	

_p_campi	= "lis_codlis;lis_data_dal_r;lis_data_al_r;lis_codrag;lis_notelis_r"					
_p_testa	= "Codice;Data dal;Data al;Ragruppamento;_______________________________________________ Note _______________________________________________"					

_p_tiporic	= "Codice listino,1,Data listino dal,2,Ragruppamento,3"
_p_nomeric	= "Ricerca listini impianti"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

** 22/10/2022 SERGIO FINE


*****************************************************************************
PROCEDURE bofrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bofrice"																			
_p_alias	= "cu_bof_tt"																					
*!*	_p_campi	= "ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_numord;ord_datord;ord_age;ord_valore;ord_chiuso"					
*!*	_p_testa	= "Exp;Mag;Cod.cli.;Ragione sociale;N.bolla;Dt.bolla;Age;Valore;A/c"					

_p_campi	= "ord_itaexp;ord_mags;ord_numord;ord_datord;ord_age;ord_valore;ord_chiuso;ord_codcli;ord_ragsoc"					
_p_testa	= "Exp;Mag;N.bolla;Dt.bolla;Age;Valore;A/c;Cod.cli.;Ragione sociale"					

_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4"
_p_nomeric	= "Ricerca bollette fiscali"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE bolrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bolrice"																			
_p_alias	= "cu_bol_tt"																					
*!*	_p_campi	= "ord_numord;ord_datord_r;ord_age;ord_caus;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_flbol;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_locc;ord_riferi"
*!*	_p_testa	= "N.bolla;Dt.bolla;Age;Top;Valore;A/c;Conf.;Trasm.;Fatt.;Exp;Mag;Cliente;Ragione sociale;Località destinaz.;Riferimento"
*!*	_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Codice Cliente,5,Località destinaz.,6,Riferimento,7"

**=> ERASMO - INIZIO 24/04/2014
*_p_campi	= "ord_numord;ord_datord_r;ord_age;ord_caus;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_flbol;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_locc;ord_riferi;des_tipologia"
*_p_testa	= "N.bolla;Dt.bolla;Age;Top;Valore;A/c;Conf.;Trasm.;Fatt.;Exp;Mag;Cliente;Ragione sociale;Località destinaz.;Riferimento;Tipo documento"
*!*	**=> ERASMO - INIZIO 04/07/2018
*!*	_p_campi	= "ord_numord;ord_datord_r;ord_riferi;ord_age;ord_caus;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_flbol;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_locc;ord_riferi;des_tipologia"
*!*	_p_testa	= "N.bolla;Dt.bolla;Riferimento;Age;Top;Valore;A/c;Conf.;Trasm.;Fatt.;Exp;Mag;Cliente;Ragione sociale;Località destinaz.;Riferimento;Tipo documento"
*!*	**=> ERASMO - FINE 04/07/2018
**=> ERASMO - INIZIO 08/09/2023
_p_campi	= "ord_numord;ord_datord_r;ord_riferi;ord_age;ord_caus;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_flbol;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_locc;des_tipologia"
_p_testa	= "N.bolla;Dt.bolla;Riferimento;Age;Top;Valore;A/c;Conf.;Trasm.;Fatt.;Exp;Mag;Cliente;Ragione sociale;Località destinaz.;Tipo documento"
**=> ERASMO - FINE 08/09/2023
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Codice Cliente,5,Località destinaz.,6,Riferimento,7,Codice tipo documento,8,Descrizione tipo documento,9"
**=> ERASMO - FINE 24/04/2014

_p_nomeric	= "Ricerca documenti di trasporto"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************


*****************************************************************************
PROCEDURE bolresrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bolresrice"																			
_p_alias	= "cu_bol_tt"																					
_p_campi	= "ord_numord;ord_datord_r;ord_age;ord_caus;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_flbol;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc"					
_p_testa	= "N.bolla;Dt.bolla;Age;Top;Valore;A/c;Conf.;Trasm.;Fatt.;Exp;Mag;Cliente;Ragione sociale"					

_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Codice Cliente,5"
_p_nomeric	= "Ricerca documenti di trasporto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE bolfrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bolfrice"																			
_p_alias	= "cu_bol_tt"																					
*!*	_p_campi	= "ord_flgcon;ord_flgtra;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_numord;ord_datord;ord_age;ord_valore;ord_chiuso"					
*!*	_p_testa	= "Conf.;Trasm.;Exp;Mag;Cliente;Ragione sociale;N.bolla;Dt.bolla;Age;Valore;A/c"					

*_p_campi	= "ord_numord;ord_datord;ord_age;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc"					
_p_campi	= "ord_numord;ord_datord_r;ord_age;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc"  && ERASMO - 07/11/2022
_p_testa	= "N.bolla;Dt.bolla;Age;Valore;A/c;Conf.;Trasm.;Exp;Mag;Fornitore;Ragione sociale"					

_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Codice Fornitore,5"
_p_nomeric	= "Ricerca documenti di trasporto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN
 

*****************************************************************************
PROCEDURE budrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\budrice"																			
_p_alias	= "cu_bud_an"																					
_p_campi	= "bud_codgru;bud_desgru;bud_mastro;bud_desmas;bud_imptot"					
_p_testa	= "Cod.gruppo;Descrizione gruppo;Mastro;Descrizione;Importo"					
_p_tiporic	= "Cod.Gruppo,1,Descrizione Gruppo,2"
_p_nomeric	= "Ricerca gestione budget"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE prvclirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prvclirice"																			
_p_alias	= "cu_prv_cl"																					
_p_campi	= "prv_codage;prv_desage;prv_codcli;prv_ragsoc;prv_perprg;prv_perprn"					
_p_testa	= "Agente;Ragione sociale agente;Cliente;Ragione sociale cliente;Provvigione 1;Provvigione 2"					
_p_tiporic	= "Codice agente,1,Codice cliente,2,Ragione sociale cliente,3"
_p_nomeric	= "Ricerca gestione provvigioni agenti per cliente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
PROCEDURE carrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\carrice"																			
_p_alias	= "cu_car_an"																					
_p_campi	= "prv_codage;prv_desage;prv_codcar;prv_descar;prv_perpro"					
_p_testa	= "Agente;Ragione sociale agente;Capo area;Ragione sociale capo area;Provvigione"					
_p_tiporic	= "Codice agente,1,Codice capo area,2"
_p_nomeric	= "Ricerca gestione agenti per capo area"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ccorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ccorice"																			
_p_alias	= "ccosto"																					
_p_campi	= "con_soc;con_anno;con_conto;con_descr;con_abilit"					
_p_testa	= "Soc.;Anno;Codice;Descrizione;Con_abilit"
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca gestione centri di costo"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE cearice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cearice"																			
_p_alias	= "cu_cea_tt"																					
_p_campi	= "ord_numord;ord_datord;ord_ragsoc;ord_valore"					
_p_testa	= "N.acquisto;Data acq.;Ragione sociale;Valore"					
_p_tiporic	= "Numero acquisto,1,Data (gg/mm/aaaa),2,Ragione sociale,3"
_p_nomeric	= "Ricerca cessioni intracomunitarie sugli acquisti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ceerice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ceerice"																			
_p_alias	= "cbilnew"																					
_p_campi	= "Descrizion;Bil_codrig;Corrente;Precedente"					
_p_testa	= "Descrizione;Cod.riga;Imp.corrente;Imp.precedente"					
_p_tiporic	= "Cod. Riga,1"
_p_nomeric	= "Ricerca definizione righe bilancio cee"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE bririce
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bririce"																			
_p_alias	= "cbilancior"																					
_p_campi	= "Descrizion;Bil_codrig;Corrente;Precedente"					
_p_testa	= "Descrizione;Cod.riga;Imp.corrente;Imp.precedente"					
_p_tiporic	= "Cod. Riga,1"
_p_nomeric	= "Ricerca definizione righe bilancio riclassificato"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE ceirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ceirice"																			
_p_alias	= "cu_cei_tt"																					
_p_campi	= "ord_numord;ord_datord;ord_ragsoc;ord_valore"					
_p_testa	= "N.cessione;Data cess;Ragione sociale;Valore"					
_p_tiporic	= "Numero cessione,1,Data (gg/mm/aaaa),2,Ragione sociale,3"
_p_nomeric	= "Ricerca cessioni intracomunitarie sulle vendite"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE cicrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cicrice"																			
_p_alias	= "cu_cic_tt"																					
_p_campi	= "cit_gruppo;cit_MAGA;cit_descri;cit_um"					
_p_testa	= "Gruppo;Mag.;Descrizione articolo;Um"					
_p_tiporic	= "Gruppo ciclo,1,Descrizione ciclo,2"
_p_nomeric	= "Ricerca cicli di lavoro"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE cmdrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cmdrice"																			
_p_alias	= "cu_cmd_an"																					
_p_campi	= "cmd_data;cmd_desc1;cmd_anno;cmd_valore"					
_p_testa	= "Data;Descrizione;Anno;Valore"					
_p_tiporic	= "Data (gg/mm/aaaa),1,Descrizione,2"
_p_nomeric	= "Ricerca gestione comodati"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE cmsrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cmsrice"																			
_p_alias	= "cu_com_tt"																					
_p_campi	= "ord_age;ord_numord;ord_codcli;ord_ragsoc;ribalta2(ord_datord);ord_nprot;ord_valore;ord_chiuso;ord_caus"					
_p_testa	= "Age;Nr.com.;Cod.cli.;Rag sociale;Dt.ord.;Nr.prot.;Valore;Chiuso;Caus"					
_p_tiporic	= "Numero Commessa,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Cod.Cliente,5"
_p_nomeric	= "Ricerca gestione commesse di produzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE comrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\comrice"																			
_p_alias	= "cu_com_an"																					
_p_campi	= "com_cli;com_data2;com_data3;com_data4"					
_p_testa	= "Cliente;Data 2°vis.;Data 3°vis.;Data 4°vis."					
_p_tiporic	= "Cliente,1"
_p_nomeric	= "Ricerca commenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE confrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\confrice"																			
_p_alias	= "cu_int_tt"																					
_p_campi	= "int_conto;int_descri;int_codrig;int_codria"					
_p_testa	= "Nr. Conto;Descrizione;C.R. Dare;C.R. Avere"					
_p_tiporic	= "N.Conto,1,N.R.Dare,2,N.R.Avere,3"
_p_nomeric	= "Ricerca abbinamenti PDC - CEE"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE confbririce
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\confbririce"																			
_p_alias	= "cu_bri_tt"																					
_p_campi	= "int_conto;int_descri;int_codrig;int_codria"					
_p_testa	= "Nr. Conto;Descrizione;C.R. Dare;C.R. Avere"					
_p_tiporic	= "N.Conto,1,N.R.Dare,2,N.R.Avere,3"
_p_nomeric	= "Ricerca abbinamenti PDC - BILANCIO RICLASSIFICATO"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
*PROCEDURE conrice
*****************************************************************************
*PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric
*
*_p_click 	= "ricerche\conrice"																			
*_p_alias	= "cu_con_an"																					
*_p_campi	= "sca_numid;sca_codcli;sca_ragsoc;sca_codart;sca_desart;sca_qtaimp"					
*_p_testa	= "N.Contr.;Cod.Cli.;Ragione Sociale;Cod. Articolo;Descrixione Articolo;Qta' Imp."					
*_p_tiporic	= "Cod.Cliente,Ragione Sociale,N.Identificativo"
*_p_nomeric	= "Ricerca gestione contratti cliente"																	

*DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

*RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE diserice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\diserice"																			
_p_alias	= "cu_dis_an"																					
_p_campi	= "dis_codice;dis_descri;dis_numrev;dis_datrev;dis_codart"					
_p_testa	= "Cod.Disegno;Descrizione;Num.rev.;Data rev.;Cod. Art."					
_p_tiporic	= "Codice,1,Descrizione disegno,2,Numero Revisione,3,Codice Articolo,4"
_p_nomeric	= "Ricerca gestione disegni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE disrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\disrice"																			
_p_alias	= "cu_dis_tt"																					
_p_campi	= "dit_gruppo;dit_descri;dit_um;dit_costo;dit_prezzo"
_p_testa	= "Codice Articolo;Descrizione;UM;Costo;Ricavo"
*_p_tiporic	= "Codice ricetta,1,Descrizione ricetta,2,Componente,3"
_p_tiporic	= "Codice gruppo,1,Descrizione gruppo,2,Cod. Componente,3"  && ERASMO - 29/05/2014
_p_nomeric	= "Ricerca distinte base"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE effrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\effrice"																			
_p_alias	= "cu_eff_tt"																					
_p_campi	= "ord_codcli;ord_ragsoc;ord_age;ord_valore;ord_numord;ord_datord"					
_p_testa	= "Ord_codcli;Ord_ragsoc;Ord_age;Ord_valore;Ord_numord;Ord_datord"					
_p_tiporic	= "Intervento,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Cod. Cliente,5"
_p_nomeric	= "Ricerca cambio effetti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



******************************************************************************
PROCEDURE fagrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\fagrice"																			
_p_alias	= "cu_fag_tt"																					
_p_campi	= "age_codice;age_anno;age_ragsoc;age_numfat;age_datfat;age_imptot;age_provvi;age_numass"					
_p_testa	= "Agente;Anno;Ragione sociale;N.fatt.;Dt.Fatt.;Importo;Provv.;N.assegno"					
_p_tiporic	= "Codice Agente,1,Nome agente,2"
_p_nomeric	= "Ricerca fatture agenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE famrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\famrice"																			
_p_alias	= "cu_fam_tt"																					
_p_campi	= "ord_pam;ord_numord;ord_codcli;ord_ragsoc;ord_ammort;ord_datord;ord_valore;ord_cge;ord_caus"					
_p_testa	= "Pam.;N.Fatt.;Cod.Forn.;Ragione Sociale;Amm.;Dt.Fattura;Valore;Cge;Top"					
_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Cod.Fornitore,4"
_p_nomeric	= "Ricerca fatture d'acquisto da ammortizzare"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE fanrice
*****************************************************************************
* non utilizzata in quanto nella tabella esiste un solo record
* non utilizzata in quanto nella tabella esiste un solo record
* non utilizzata in quanto nella tabella esiste un solo record
* non utilizzata in quanto nella tabella esiste un solo record
* non utilizzata in quanto nella tabella esiste un solo record

*!*	PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

*!*	_p_click 	= "ricerche\fanrice"																			
*!*	_p_alias	= "cchiusura"																					
*!*	_p_campi	= "fin_proper;fin_utiese;fin_perese;fin_bilchi;fin_bilape;;;"					
*!*	_p_testa	= "Prof.Perd.;Uti.Eserc.;Per.Eser.;Bil.Chiu.;Bil.Aper.;;;"					
*!*	_p_tiporic	= "Codice Societa',1"
*!*	_p_nomeric	= "Ricerca parametri chiusura"																	

*!*	DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE faprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\faprice"																			
_p_alias	= "cu_fap_tt"																					
*!*	_p_campi	= "ord_age;ord_numord;ord_codcli;ord_ragsoc;ord_nprot;ord_datord;ord_valore;ord_chiuso;ord_caus"					
*!*	_p_testa	= "Age;N.Fatt.;Cod.Cli.;Ragione Sociale;N.prot.;Dt.Fattura;Valore;Cge;Top"					

*!*	_p_campi	= "ord_age;ord_nprot;ord_numord;ord_datord_r;ord_valore;ord_chiuso;ord_caus;ord_codcli;ord_ragsoc"					
*!*	_p_testa	= "Age;N.Prot.;N.Fatt.;Dt.Fattura;Valore;Cge;Top;Cod.Cli.;Ragione Sociale"					
*!*	_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,N.Protocollo,5,Cod.Cliente,6"

**=> ERASMO - INIZIO 24/04/2014
*_p_campi	= "ord_age;ord_nprot;ord_numord;ord_datord_r;ord_valore;ord_chiuso;ord_caus;ord_codcli;ord_ragsoc;des_tipologia"
*_p_testa	= "Age;N.Prot.;N.Fatt.;Dt.Fattura;Valore;Cge;Top;Cod.Cli.;Ragione Sociale;Tipo documento"
**=> ERASMO - INIZIO 04/07/2018
_p_campi	= "ord_age;ord_nprot;ord_numord;ord_datord_r;ord_riferi;ord_valore;ord_chiuso;ord_caus;ord_codcli;ord_ragsoc;des_tipologia"
_p_testa	= "Age;N.Prot.;N.Fatt.;Dt.Fattura;Riferimento;Valore;Cge;Top;Cod.Cli.;Ragione Sociale;Tipo documento"
**=> ERASMO - FINE 04/07/2018
_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,N.Protocollo,5,Cod.Cliente,6,Codice tipo documento,7,Descrizione tipo documento,8"
**=> ERASMO - FINE 24/04/2014

_p_nomeric	= "Ricerca fatture di vendita"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE fatrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\fatrice"																			
_p_alias	= "cu_fat_tt"				
																	
*!*	_p_campi	= "ord_bollatoiva;ord_age;ord_nprot;ord_numord;ord_datord_r;ord_valore;ord_cge;ord_caus;ord_tipologia;ord_codcli;ord_ragsoc"
*!*	_p_testa	= "Fm;Age;N.Prot.;N.Fatt.;Dt.Fattura;Valore;Cge;Top;Tipo documento;Cod.Cli.;Ragione Sociale"
*!*	_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,N.Protocollo,5,Cod.Cliente,6"

**=> ERASMO - INIZIO 24/04/2014
*_p_campi	= "ord_bollatoiva;ord_age;ord_nprot;ord_numord;ord_datord_r;ord_valore;ord_cge_C;ord_caus;ord_codcli;ord_ragsoc;des_tipologia"
*_p_testa	= "Fm;Age;N.Prot.;N.Fatt.;Dt.Fattura;Valore;Cge;Top;Cod.Cli.;Ragione Sociale;Tipo documento"
**=> ERASMO - INIZIO 04/07/2018
_p_campi	= "ord_bollatoiva;ord_age;ord_nprot;ord_numord;ord_datord_r;ord_riferi;ord_valore;ord_cge_C;ord_caus;ord_codcli;ord_ragsoc;des_tipologia"
*_p_testa	= "Fm;Age;N.Prot.;N.Fatt.;Dt.Fattura;Riferimento;Valore;Cge;Top;Cod.Cli.;Ragione Sociale;Tipo documento"
**=> ERASMO - FINE 04/07/2018
_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,N.Protocollo,5,Cod.Cliente,6,Codice tipo documento,7,Descrizione tipo documento,8"
**=> ERASMO - FINE 24/04/2014
_p_testa	= "Fm;Age;N.Part.;N.Fatt.;Dt.Fattura;Riferimento;Valore;Cge;Top;Cod.Cli.;Ragione Sociale;Tipo documento"  && ERASMO - 04/11/2022

_p_nomeric	= "Ricerca fatture di vendita"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE fidrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\fidrice"																			
_p_alias	= "cu_fid_tt"																					
_p_campi	= "fid_numfid;fid_totfid;fid_codcli;fid_ragsoc;fid_telefo"					
_p_testa	= "Fid_numfid;Fid_totfid;Fid_codcli;Fid_ragsoc;Fid_telefo"					
_p_tiporic	= "Cod.Cliente,1,Ragione Sociale,2,Num.Fideussione,3"
_p_nomeric	= "Ricerca gestione fideussioni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ftprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ftprice"																			
_p_alias	= "cu_ftp_an"																					
_p_campi	= "ftp_codpdv;ftp_despdv;ftp_codcas;ftp_descas;ftp_tipcom;ftp_numser;ftp_tipacq;ftp_numdoc;ftp_datdoc;ftp_codfor;ftp_ragfor;ftp_tipo;ftp_host;ftp_user;ftp_passwo;ftp_pathda;ftp_nomefi;ftp_pathal;ftp_stampa"
_p_testa	= "Sede/Pdv;Descrizione;Componente;Descrizione componente;Tipo componente;Numero di serie;Tipo acquisto;Numero documento;Data documento;Codice fornitore;Ragione sociale;Tipo;Host;User;Password;Dir. di partenza;Nome file;Dir. di arrivo;Bene stampabile"
_p_tiporic	= "Codice Sede/PDV,1,Descrizione,2,Codice componente,3,Descrizione componente,4,Numero di serie,5,Numero documento,6,Dt.Doc. (gg/mm/aaaa),7,Fornitore,8,Tipo,9,Host,10,Users,11,Nome file,12"
_p_nomeric	= "Ricerca anagrafica FTP"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ftpricer
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ftpricer"																			
_p_alias	= "cur_ftp_an"																					
_p_campi	= "ftp_codpdv;ftp_despdv;ftp_codcas;ftp_descas;ftp_tipcom;ftp_numser;ftp_tipacq;ftp_numdoc;ftp_datdoc;ftp_codfor;ftp_ragfor;ftp_tipo;ftp_host;ftp_user;ftp_passwo;ftp_pathda;ftp_nomefi;ftp_pathal;ftp_stampa"
_p_testa	= "Sede/Pdv;Descrizione;Componente;Descrizione componente;Tipo componente;Numero di serie;Tipo acquisto;Numero documento;Data documento;Codice fornitore;Ragione sociale;Tipo;Host;User;Password;Dir. di partenza;Nome file;Dir. di arrivo;Bene stampabile"
_p_tiporic	= "Codice Sede/PDV,1,Descrizione,2,Codice componente,3,Descrizione componente,4,Numero di serie,5,Numero documento,6,Data documento,7,Fornitore,8,Tipo,9,Host,10,Users,11,Nome file,12"
_p_nomeric	= "Ricerca anagrafica FTP"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE gcoricer
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\gcoricer"																			
_p_alias	= "ccontatti"																					
_p_campi	= "Mai_Conta;Mai_Ditta;Mai_Citta;Mai_Cap;Mai_Grossi;Mai_Codice;Mai_Subco;Mai_Iditta;Mai_Setat;Mai_Tiprod"					
_p_testa	= "Contatto;Ditta;Città;Cap;Grossista;Cod;S.cd;Identificaz.ditta;Settore attività;Tipo prodotti"					
_p_tiporic	= "Contatto,1,Ditta,2,Città,3,CAP,4,Grossista,5,Codice,6,Sottocodice,7,Identificazione ditta,8,Settore attività,9,Tipo prodotti,10"
_p_nomeric	= "Ricerca gestione contatti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE imbrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\imbrice"																			
_p_alias	= "cu_imb_tb"																					
_p_campi	= "imb_peslor;imb_codice;imb_descri;imb_volume;imb_dim;imb_pesnet"					
_p_testa	= "Peso lordo;Codice;Descrizione;Volume;Dimensioni;Peso netto"					
_p_tiporic	= "Codice,1"
_p_nomeric	= "Ricerca tabella imballi"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE intrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\intrice"																			
_p_alias	= "cu_int_an"																					
_p_campi	= "int_data;int_age;int_codice;int_art;int_prezzo"					
_p_testa	= "Data;Agente;Codice;Articolo;Prezzo"					
_p_tiporic	= "Data (gg/mm/aaaa),1,Agente,2"
_p_nomeric	= "Ricerca richiesta intervento commerciale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE lavirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lavirice"																			
_p_alias	= "cu_bli_tt"																					
_p_campi	= " ; ; ; ; ; ; "					
_p_testa	= "Ope;Age;N.ord.;Dt. Ordine;Ragione Sociale;Localita;St"					
_p_tiporic	= "Numero Ordine,Data (gg/mm/aaaa),Ragione Sociale,Codice Agente"
_p_nomeric	= "Ricerca bolla di conto lavoro in ingresso"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE lavorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lavorice"																			
_p_alias	= "cu_ctl_tt"																					

_p_campi	= "ord_numord;ord_datord;ord_numbol;ord_datbol;ord_codcli;ord_ragsoc;ord_locali"					
_p_testa	= "N.ord.;Dt.ord.;N.bol.;Dt.bol.;Fornitore;Ragione Sociale;Localita"					

_p_tiporic	= "Numero Ordine,1,Data ord.(gg/mm/aaaa),2,Numero ddt,3,Data ddt (gg/mm/aaaa),4,Ragione Sociale,5"
_p_nomeric	= "Ricerca ordini c/lavoro"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE lavurice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lavurice"																			
_p_alias	= "cu_blu_tt"																					
_p_campi	= " ; ; ; ; ; ; ;"					
_p_testa	= "Mag;Cod.Cli.;Ragione Sociale;N.Bolla;Dt.Bolla;Age;Valore;A/c"					
_p_tiporic	= "Numero Bolla,Data (gg/mm/aaaa),Ragione Sociale,Codice Agente"
_p_nomeric	= "Ricerca documenti di trasporto c/lavoro"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE lecrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lecrice"																			
_p_alias	= "cu_cli_an"																					
_p_campi	= "cli_codcli;cli_ragsoc;cli_indir;cli_locali"					
_p_testa	= "Cod.Cli.;Ragione Sociale;Indirizzo;Città"					
_p_tiporic	= "Ragione Sociale,1,Codice Cliente,2,Partita Iva,3,Agente,4,Ricerca Alternativa,5,Località,6"
_p_nomeric	= "Ricerca (?)"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE legarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\legarice"																			
_p_alias	= "clegacco"																					
_p_campi	= "con_conto;con_descr;con_cco;con_desccs"					
_p_testa	= "Conto;Descrizione conto contabile;C. di costo;Descrizione "					
_p_tiporic	= "Codice conto,1,Descrizione conto,2,Codice centro di costo,3,Descrizione centro di costo,4"
_p_nomeric	= "Ricerca (?)"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE legdrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\legdrice"																			
_p_alias	= "cu_leg_do"																					
_p_campi	= "leg_tipdoc;leg_anno;leg_codcli;leg_numdoc;leg_ragsoc;leg_datdoc;leg_tipcre;leg_numcre;leg_datcre;leg_salcon;leg_dateff;leg_oracre;leg_codope"
_p_testa	= "Tipo doc.;Anno;Cod.cli.;Num.doc.;Ragione sociale;Data doc.;Tipo cre.;Num.doc.cre.;Data doc.cre.; ;Data creaz.;Ora creaz.;Cod.ope"
_p_tiporic	= "Tipo documento di partenza,1,Codice cliente,2,Ragione sociale cliente,3,Tipo doc. / anno / cod.cli. / rag.soc. / num.doc. / data doc. / num.doc.creato,4"
_p_nomeric	= "Ricerca gestione legami tra i documenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE lifrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lifrice"																			
_p_alias	= "cu_lif_tt"																					
*_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_desart;lis_prezzo;lis_sc1;lis_sc2;lis_sc3"
*_p_testa	= "Fornitore;Ragione sociale;Articolo;Descrizione;Prezzo;Sc 1;Sc 2;Sc 3"
*_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_desart;lis_prezzo;lis_datlis;lis_allist;lis_sc1;lis_sc2;lis_sc3"	&& ERASMO - 01/02/2018
*_p_testa	= "Fornitore;Ragione sociale;Articolo;Descrizione;Prezzo;Valido dal;Valido al;Sc 1;Sc 2;Sc 3"				&& ERASMO - 01/02/2018
*_p_tiporic	= "Codice fornitore,1,Codice articolo,2,Data listino (gg/mm/aaaa),3"
_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_desart;lis_prezzo;lis_datlis;lis_allist;lis_sc1;lis_sc2;lis_sc3;lis_qta"	&& ERASMO - 05/12/2019
_p_testa	= "Fornitore;Ragione sociale;Articolo;Descrizione;Prezzo;Valido dal;Valido al;Sc 1;Sc 2;Sc 3;Qta min."				&& ERASMO - 05/12/2019
_p_tiporic	= "Codice fornitore,1,Rag. sociale (contenuto),2,Codice articolo,3,Data listino al (gg/mm/aaaa),4"					&& ERASMO - 05/12/2019
*_p_nomeric	= "Ricerca listini per cliente/articoli"																	
_p_nomeric	= "Ricerca listini fornitore/articolo"  && ERASMO - 05/12/2019

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE lifscrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lifscrice"																			
_p_alias	= "cu_lif_sc"																					
_p_campi	= "lis_codcli;lis_ragsoc;lis_codlis;lis_deslis;lis_sc1;lis_sc2;lis_sc3"					
_p_testa	= "Fornitore;Ragione sociale;Tipo listino;Descrizione;Sc 1;Sc 2;Sc 3"					
_p_tiporic	= "Codice fornitore,1,Tipo listino,2,Data listino (gg/mm/aaaa),3"
_p_nomeric	= "Ricerca listini per fornitore/listini"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE lifscbarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lifscbarice"																			
_p_alias	= "cu_lif_ba"																					
_p_campi	= "lis_tipoli;lis_codlis;lis_deslis;lis_ragsoc;lis_scomagg;lis_desscm;lis_datlis;lis_allist"					
_p_testa	= "Mag;Listino;Descrizione;Fornitore;Sc/mag;Descrizione;Data dal;Data al"	
_p_tiporic	= "Tipo listino,1,Famiglia sconti/maggiorazioni,2,Data listino (gg/mm/aaaa),3,Ragione sociale (inizia per),4,Ragione sociale (contiene),5"
_p_nomeric	= "Ricerca listini per tipologia listino"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ligrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ligrice"																			
_p_alias	= "cu_lis_lg"																					
_p_campi	= "lis_tipo;lis_age;lis_linart;lis_zona;lis_codcli;lis_datlis;lis_allist;lis_valido"					
_p_testa	= "Tipo;Agente;Linea;Zona;Cliente;Data listino;Data validita';Valido"					
_p_tiporic	= "Agente,1,Linea,2,Zona,3,Cliente,4"
_p_nomeric	= "Ricerca tabella validità listini"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

_p_click 	= "ricerche\ribarice"																			
_p_alias	= "cu_ric_tt"																					
_p_campi	= "ric_codcli;ric_ragsoc;ric_nfatt;ric_dtfatt;ric_dtscad;ric_totfat;ric_tranc"					
_p_testa	= "Cod.cliente;Ragione Sociale;Num.Fatt.;Data Fatt.;Data Scad.;Tot.documento;Tot.rata"					
_p_tiporic	= "Codice cliente,1,Ragione Sociale,2,Numero fattura,3"
_p_nomeric	= "Ricerca gestione ricevute bancarie"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE lislrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lislrice"																			
_p_alias	= "cu_lis_li"																					
_p_campi	= "lis_codcli;lis_coddes;lis_linart;lis_lindes;lis_sc1;lis_sc2;lis_sc3 "					
_p_testa	= "Cod. Cli.;Descrizione;Linea Art.;Descrizione;Sconto 1;Sconto 2;Sconto 3"					
_p_tiporic	= "Codice cliente,Linea"
_p_nomeric	= "Ricerca (?)"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE lisrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lisrice"																			
_p_alias	= "cu_lis_tt"																					
***_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_desart;lis_prezzo;lis_sc1;lis_sc2;lis_sc3"					
***_p_testa	= "Cliente;Ragione sociale;Articolo;Descrizione;Prezzo;Sc 1;Sc 2;Sc 3"					
***_p_tiporic	= "Codice cliente,1,Codice articolo,2,Data listino (gg/mm/aaaa),3"
_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_prezzo;lis_datlis;lis_allist;lis_codgli"
*_p_testa	= "Cliente;Ragione sociale;Articolo;Prezzo;Valido da;Valido fino"
*_p_tiporic	= "Codice cliente,1,Ragione sociale,2,Codice articolo,3,Data listino (gg/mm/aaaa),4"
_p_testa	= "Cliente;Ragione sociale;Articolo;Prezzo;Valido da;Valido fino;Tipologia listino"							&& ERASMO - 17/02/2015
_p_tiporic	= "Codice cliente,1,Ragione sociale,2,Codice articolo,3,Data listino (gg/mm/aaaa),4,Tipologia listino,5"	&& ERASMO - 17/02/2015
_p_nomeric	= "Ricerca listini per cliente/articoli"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE lisriceav
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lisriceav"																			
_p_alias	= "cu_lis_av"																					
_p_campi	= "lis_tipoazi;lis_deslis;lis_codart;lis_prezzo;lis_datlis;lis_allist"
_p_testa	= "Tipologia;Descrizione tipologia;Articolo;Prezzo;Valido da;Valido fino"					
_p_tiporic	= "Codice tipologia,1,Descrizione tipologia,2,Codice articolo,3,Data listino (gg/mm/aaaa),4"
_p_nomeric	= "Ricerca listini di vendita azienda/articoli"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE sconti
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\sconti"																			
_p_alias	= "cu_sco_sc"																					
_p_campi	= "codsco;dessco;sconto1;sconto2;sconto3;sconto4;sconto5;dtvada;dtvaal"
_p_testa	= "Tipologia;Descrizione sconto1;sconto2;sconto3;sconto4;sconto5;Valido da;Valido fino"					
_p_tiporic	= "Codice tipologia,1,Descrizione tipologia,2,Data listino (gg/mm/aaaa),3"
_p_nomeric	= "Ricerca tipologie sconti di vendita"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE lisricezona
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lisricezona"																			
_p_alias	= "cu_lis_zo"																					
_p_campi	= "lis_zona;lis_deslis;lis_codart;lis_prezzo;lis_datlis;lis_allist"
_p_testa	= "Zona;Descrizione zona;Articolo;Prezzo;Valido da;Valido fino"					
_p_tiporic	= "Codice zona,1,Descrizione zona,2,Codice articolo,3,Data listino (gg/mm/aaaa),4"
_p_nomeric	= "Ricerca listini di vendita azienda/articoli"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN




*****************************************************************************

*****************************************************************************
PROCEDURE lisriceaa
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lisriceaa"																			
_p_alias	= "cu_lis_aa"																					
_p_campi	= "lis_tipoazi;lis_deslis;lis_codart;lis_prezzo;lis_datlis;lis_allist"
_p_testa	= "Tipologia;Descrizione tipologia;Articolo;Prezzo;Valido da;Valido fino"					
_p_tiporic	= "Codice tipologia,1,Descrizione tipologia,2,Codice articolo,3,Data listino (gg/mm/aaaa),4"
_p_nomeric	= "Ricerca listini di acquisto azienda/articoli"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE lisricv
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lisricv"																			
_p_alias	= "cu_lis_ve"																					
_p_campi	= "lis_codart;lis_desart;lis_tipo;lis_prezzo;lis_sco;lis_prov1"					
_p_testa	= "Articolo;Descrizione;Tipo;Prezzo;Sconto;Provvigione"					
_p_tiporic	= "Codice Articolo,1,Tipo Listino,2"
_p_nomeric	= "Ricerca listini per articoli/tipo listino"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE listaric
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\listaric"																			
_p_alias	= "cu_lis_ag"																					
_p_campi	= "lis_age;lis_codart;lis_prezzo;lis_datlis;lis_allist;lis_pubbli"					
_p_testa	= "Cod. age.;Cod. art.;Prezzo;Data dal;Data al;Mat.pub"					
_p_tiporic	= "Codice agente,1,Codice articolo,2"
_p_nomeric	= "Ricerca (?)"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE lisctsrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric


_p_click 	= "ricerche\lisctsrice"																			
_p_alias	= "cu_lis_ts"																					
_p_campi	= "lis_flaggn;lis_tipopr;lis_grcolf;lis_grcolr;lis_spesso;lis_datada;lis_dataal;lis_prezzo;lis_codcli;lis_ragsoc"					
_p_testa	= "N;T;F;R;Spes.;Data dal;Data al;Prezzo;Cod.cliente;Ragione sociale"					
_p_tiporic	= "Grezzo nobilitato,1,Tipo prodotto,2,Colore fronte,3,Colore retro,4,Codice cliente,5,Ragione sociale,6"
_p_nomeric	= "Ricerca"																	



DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************





*****************************************************************************
PROCEDURE cmerice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric


_p_click 	= "ricerche\cmerice"																			
_p_alias	= "cu_sco_cm"																					
_p_campi	= "sco_codcli;sco_ragsoc;sco_catmer;sco_sc1;sco_sc2;sco_sc3;sco_sc4;sco_datlis;sco_allist"
_p_testa	= "Cliente;Ragione sociale;Cat. merc.;Sconto1;Sconto2;Sconto3;Sconto4;Valido da;Valido fino"					
_p_tiporic	= "Codice cliente,1,Ragione sociale,2,Cat. Merc.,3,Data listino (gg/mm/aaaa),4"
_p_nomeric	= "Ricerca sconti per cliente/categoria merceologica"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE locrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\locrice"																			
_p_alias	= "cu_loc_an"																					
_p_campi	= "loc_codloc;loc_codcli;loc_ragsoc;loc_locali;loc_indiri;loc_cap;loc_cf"					
_p_testa	= "C.L.;Cod.CL/FO.;Ragione Sociale;Località;Indirizzo;Cap;CF"					
*_p_tiporic	= "Codice Localita,1,Codice Cliente,2,Ragione Sociale,3"
*_p_tiporic	= "Ragione Sociale,1,Codice Cliente,2,Codice Localita,1" 
_p_tiporic	= "Ragione Sociale (inizia per),1,Ragione Sociale (contiene),2,Codice Cliente,3,Codice Localita,4"  && ERASMO - 13/10/2015
_p_nomeric	= "Ricerca anagrafica località di consegna"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE logrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\logrice"																			
_p_alias	= "clog_cont"																					
_p_campi	= "log_progra;log_archiv;log_tipope;log_codope;log_nomope;log_posope;log_codcon;log_descon;log_numreg;log_datreg;log_numdoc;log_datdoc;log_valdoc;log_datope;log_oraope"					
_p_testa	= "Programma;Archivio;Tipo operaz.;Cod.Utente;Nome Utente;Postazione;Conto Contabile;Descrizione Conto;Num.Reg.;Data Reg.;Num.Doc.;Data Doc.;Importo Doc.;Data Operazione;Ora Operazione"					
_p_tiporic	= "Postazione,1,Nome utente,2,Codice utente,3,Conto contabile,4,Data oper.(gg/mm/aaaa),5"
_p_nomeric	= "Ricerca gestione LOG di monitoraggio procedure"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE logrrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\logrrice"																			
_p_alias	= "clog_rete"																					
_p_campi	= "log_progra;log_archiv;log_tipope;log_codope;log_nomope;log_posope;log_codcon;log_descon;log_numreg;log_datreg;log_numdoc;log_datdoc;log_valdoc;log_datope;log_oraope;log_risult"					
_p_testa	= "Programma;Archivio;Tipo operaz.;Cod.Utente;Nome Utente;Postazione;Conto Contabile;Descrizione Conto;Num.Reg.;Data Reg.;Num.Doc.;Data Doc.;Importo Doc.;Data Operazione;Ora Operazione;Ris."					
_p_tiporic	= "Postazione,1,Nome utente,2,Codice utente,3,Conto contabile,4,Data oper. (gg/mm/aaaa),5,Responso,6"
_p_nomeric	= "Ricerca gestione LOG di monitoraggio procedure"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE macrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\macrice"																			
_p_alias	= "cu_mac_an"																					
_p_campi	= "mac_codice;mac_descri"
_p_testa	= "Codice;Descrizione"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca tabella macchina/operazioni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE magrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\magrice"																			
_p_alias	= "cu_mag_an"																					
_p_campi	= "mag_codmag;mag_codart;mag_desart;mag_unimis;mag_giacen;mag_giacin;mag_costo;mag_impord;mag_ordatt"					
_p_testa	= "Cod.Mag.;Cod. Articolo;Descrizione Articolo;Um;Giacenza;Giac.Iniziale;Costo;Impegnato;Ordinato"					
_p_tiporic	= "Codice Articolo,1,Magazzino / Articolo,2,Magazzino / Codice Fornitore,3"
_p_nomeric	= "Ricerca (?)"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE mancrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\mancrice"																			
_p_alias	= "cu_mac_tt"																					
_p_campi	= "ric_progr;ric_dtfatt;ric_totfat;ric_top;ric_cge"					
_p_testa	= "Numero;data;Totale;Top;Cge"					
_p_tiporic	= "Numero Mandato,1"
_p_nomeric	= "Ricerca reversale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE mandrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\mandrice"																			
_p_alias	= "cu_man_tt"																					
_p_campi	= "ric_progr;ric_dtfatt;ric_totfat;ric_top;ric_cge"					
_p_testa	= "Numero;Data;Totale;Top;Cge"					
_p_tiporic	= "Numero Mandato,1"
_p_nomeric	= "Ricerca mandati di pagamento a fornitore"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************





*****************************************************************************
PROCEDURE marrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\marrice"																			
_p_alias	= "cu_mar_an"																					
_p_campi	= "mar_codcli;mar_ragsoc;mar_numord;ribalta2(mar_datord);mar_numcom;ribalta2(mar_datcom);mar_codart;mar_desart;mar_tipo;mar_numpez;mar_mquadr"					
_p_testa	= "Cod. Cli.;Rag. Sociale;Num. Ord.;Data Ord.;Num. Com.;Data Com.;Cod. Art.;Des. Articolo;Tipo di Lavorazione;Num. Pez.;Mt. Quadr."					
_p_tiporic	= "Codice Cliente,1,Ragione Sociale,2,Codice Articolo,3,Descrizione Articolo,4"
_p_nomeric	= "???????????????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE mdcrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\mdcrice"																			
_p_alias	= "cu_mdc_an"																					
_p_campi	= "mdc_codice;mdc_qtfihh;mdc_percen;mdc_perivc;mdc_ricacq;mdc_rapcst"					
_p_testa	= "Codice;Quota fissa oraria;Percent.;Perc.incid.variab.comm.;Percent.ric. cst di acq.;Rapp. cst tot. mat.+ lav.est."					
_p_tiporic	= "Codice,1"
_p_nomeric	= "Ricerca margine di contribuzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE movrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\movrice"																			
_p_alias	= "cu_mag_mo"																					
_p_campi	= "mov_codmag;mov_codart;mov_numdoc;mov_dtdocu;mov_dtregi;mov_top;mov_qtamov;mov_preacq;mov_preven;mov_valven;mov_valacq;mov_codfor"					
_p_testa	= "Mag.;Articolo;Num.Doc.;Dt.Docum.;Dt.Regi.;Top;Qta;Prz.Costo;Prz.Vend.;Valore Vendita;Valore Acquisto;Cod.Forn."					
_p_tiporic	= "Magazzino / Codice Articolo,1,Magazzino /  Data Documento,2,Magazzino / Codice Fornitore,3"
_p_nomeric	= "Ricerca ??????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************




*****************************************************************************
PROCEDURE movstric
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\movstric"																			
_p_alias	= "cumovstall"																					
_p_campi	= "mov_conto;mov_descri"					
_p_testa	= " ; "					
_p_tiporic	= "Conto,Descrizione"
_p_nomeric	= "Ricerca archivio conti per stampa prima nota"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE mririce
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\mririce"																			
_p_alias	= "cu_mri_tt"																					
_p_campi	= "ord_codcli;ord_ragsoc;ord_numord;ord_datord;ord_valore;ord_age;ord_chiuso"					
_p_testa	= "Cliente;Ragione sociale;Numero;Data;Valore;Agente;A/c"					
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Agente,4,Cod.cliente,5"
_p_nomeric	= "Ricerca ordine di rifornimento"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE noterice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\noterice"																			
_p_alias	= "cnote_com"																					
_p_campi	= "not_codice;not_testo_c"					
_p_testa	= "Codice;Descrizione"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca Note / Commenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE inrrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\inrrice"																			
_p_alias	= "cu_vendite_tt"	
** 09/06/2023 SERGIO INIZIO																				
*!*	_p_campi	= "ord_numord;ord_datord_r;ord_dtprogr_r;ord_valore;ord_codcli;ord_ragsoc;ord_chiuso_C;ord_caus"	 
*!*	_p_testa	= "Nr. intervento;Data;Data programmata;Valore;Cliente;Ragione sociale cliente    ;A/C;Causale"
*!*	_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Agente,4,Codice tipo documento,5,Descrizione tipo documento,6"

*_p_campi	= "ord_ccodsche;ord_numord;ord_datord_r;ord_dtprogr_r;ord_valore;ord_codcli;ord_ragsoc;ord_chiuso_C;ord_caus"
_p_campi	= "ord_ccodsche;ord_numord;ord_datord_r;ord_dtprogr_r;ord_valore;ord_codcli;ord_ragsoc;ord_chiuso_C;ord_caus;ord_zona"  && ERASMO - 26/01/2024
_p_campi	= "ord_ccodsche;ord_numord;ord_datord_r;ord_dtprogr_r;ord_valore;ord_codcli;ord_ragsoc;ord_chiuso_C;ord_note_interventi_c;ord_caus;ord_zona"  && ERASMO - 06/02/2024
*_p_testa	= "Codice impianto;Nr. intervento;Data;Data programmata;Valore;Cliente;Ragione sociale cliente;A/C;Causale"
*_p_testa	= "Codice impianto;Nr. intervento;Data;Data programmata;Valore;Cliente;Ragione sociale cliente;A/C;Causale;Cod. zona"  && ERASMO - 26/01/2024
_p_testa	= "Codice impianto;Nr.interv.;Data;Data esecuz.;Valore;Cliente;Ragione sociale cliente;A/C;Motivo;Causale;Cod. zona"  && ERASMO - 06/02/2024
*_p_tiporic	= "Codice impianto (contenuto),1,Numero,2,Data (gg/mm/aaaa),3,Ragione Sociale,4,Agente,5,Codice tipo documento,6,Descrizione tipo documento,7"
*_p_tiporic	= "Codice impianto (contenuto),1,Numero,2,Data (gg/mm/aaaa),3,Ragione Sociale (contenuto),4,Agente,5,Codice tipo intervento,6,Descrizione tipo intervento,7"  && ERASMO - 03/07/2023
_p_tiporic	= "Codice impianto (contenuto),1,Numero,2,Data (gg/mm/aaaa),3,Ragione Sociale (contenuto),4,Agente,5,Codice tipo intervento,6,Descrizione tipo intervento,7,Codice zona,8"  && ERASMO - 26/01/2024
** 09/06/2023 SERGIO FINE																					


_p_nomeric	= "Ricerca interventi clienti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE offrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\offrice"																			
_p_alias	= "cu_off_tt"																					
*_p_campi	= "ord_numord;ord_datord_r;ord_valore;ord_age;ord_codcli;ord_ragsoc;des_tipologia;ord_chiuso"
_p_campi	= "ord_numord;ord_datord_r;ord_valore;ord_age;ord_codcli;ord_ragsoc;des_tipologia;ord_chiuso_C"	&& ERASMO - 08/10/2015
*_p_testa	= "Numero;Data;Valore;Age;Cliente;Ragione sociale;Tipo documento"
_p_testa	= "Numero;Data;Valore;Age;Cliente;Ragione sociale;Tipo documento;A/C"							&& ERASMO - 08/10/2015
**=> ERASMO - INIZIO 04/07/2018
_p_campi	= "ord_numord;ord_datord_r;ord_riferi;ord_valore;ord_age;ord_codcli;ord_ragsoc;des_tipologia;ord_chiuso_C"
_p_testa	= "Numero;Data;Riferimento;Valore;Age;Cliente;Ragione sociale;Tipo documento;A/C"
**=> ERASMO - FINE 04/07/2018
*_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Agente,4,Codice tipo documento,5,Descrizione tipo documento,6"
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale (inizia per),3,Ragione Sociale (contiene),4,Agente,5,Codice tipo documento,6,Descrizione tipo documento,7"  && ERASMO - 29/07/2016
_p_nomeric	= "Ricerca preventivi clienti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE ordrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ordrice"																			
_p_alias	= "cu_ord_tt"																					

*!*	_p_testa	= "Numero;Data;Riferimento;Caus.;Valore;Age;A/C;Ope;Cliente;Ragione sociale;Località destinaz.;Tipo documento"
*!*	_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Agente,4,Cod.cliente,5,Località destinaz.,6,Causale,7,Codice tipo documento,8,Descrizione tipo documento,9"



_p_campi	= "ord_numord;ord_datord_r;ord_riferi;ord_caus;ord_valore;ord_age;ord_chiuso_DD;ord_codope;ord_codcli;ord_ragsoc;ord_locc;des_tipologia"
*_p_testa	= "Numero;Data;Numero ordine cliente;Data ordine cliente;Riferimento;Caus.;Valore;Age;A/C;Ope;Cliente;Ragione sociale;Località destinaz.;Tipo documento"
_p_testa	= "Numero;Data;Riferimento ord. cliente;Caus.;Valore;Age;A/C;Ope;Cliente;Ragione sociale;Località destinaz.;Tipo documento"  && ERASMO - 04/12/2023
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Numero ordine cliente,3,Data ordine cliente (gg/mm/aaaa),4,Ragione Sociale,5,Agente,6,Cod.cliente,7,Località destinaz.,8,Causale,9,Codice tipo documento,10,Descrizione tipo documento,11"


_p_nomeric	= "Ricerca ordine cliente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


**********************************************************************************************************************************************************




*****************************************************************************
PROCEDURE orfrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\orfrice"																			
_p_alias	= "cu_orf_tt"																					
*!*	_p_campi	= "ord_flgcon;ord_flgtra;ord_age;ord_numord;ord_datord_r;ord_valore;ord_chiuso;ord_codope;ord_ragsoc;ord_locali"					
*!*	_p_testa	= "Conf.;Trasm.;Age;N.ord.;Dt.Ordine;Valore;St;Ope;Ragione Sociale;Localita"					
*!*	**=> ERASMO - INIZIO 02/04/2015
*!*	_p_campi	= "ord_flgcon_c;ord_numord;ord_datord_r;ord_valore;ord_chiuso_c;ord_codope;ord_ragsoc;ord_locali;ord_age"					
*!*	_p_testa	= "Conf.;N.ord.;Dt.Ordine;Valore;Stato;Operatore;Ragione Sociale;Localita;Ag."
*!*	**=> ERASMO - FINE 02/04/2015
**=> ERASMO - INIZIO 04/07/2018
*_p_campi	= "ord_flgcon_c;ord_numord;ord_datord_r;ord_riferi;ord_valore;ord_chiuso_c;ord_codope;ord_ragsoc;ord_locali;ord_age"
_p_campi	= "ord_flgcon_c;ord_numord;ord_datord_r;ord_riferi;ord_valore;ord_chiuso_c;ord_codope;ord_ragsoc;ord_locali;ord_age;ord_dtcons_r;conta_atch"  && ERASMO - 17/10/2022
*_p_testa	= "Conf.;N.ord.;Dt.Ordine;Riferimento;Valore;Stato;Operatore;Ragione Sociale;Localita;Ag."
_p_testa	= "Conf.;N.ord.;Dt.Ordine;Riferimento;Valore;Stato;Operatore;Ragione Sociale;Localita;Ag.;Dt.Cons;Allegati"  && ERASMO - 17/10/2022
**=> ERASMO - FINE 04/07/2018
_p_tiporic	= "Numero Ordine,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4"
_p_nomeric	= "Ricerca ordine a fornitore"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN



*****************************************************************************
PROCEDURE pagfrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pagfrice"																			
_p_alias	= "cu_man_tt"																					
_p_campi	= "ric_progr;ric_dtfatt;ric_totfat;ric_top;ric_cge"					
_p_testa	= "Numero;Data;Totale;Top;Cge"					
_p_tiporic	= "Numero Mandato,1"
_p_nomeric	= "Ricerca mandati di pagamento fornitori generici"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE palrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\palrice"																			
_p_alias	= "cu_pal_an"																					
_p_campi	= "pal_cod;pal_descr;pal_npez;pal_lung;pal_larg;pal_costo;pal_imp;pal_conto"					
_p_testa	= "Codice;Descrizione pallet;N. pezzi;Lung.;Larg.;Add.;Importo;Conto"					
_p_tiporic	= "Codice pallet,1,Descrizione pallet,2"
_p_nomeric	= "Ricerca gestione archivio pallet"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************





*****************************************************************************
PROCEDURE paprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\paprice"																			
_p_alias	= "cu_pap_an"																					
_p_campi	= "pap_codcli;pap_ragsoc;pap_nfat;pap_impfat;pap_descri;"					
_p_testa	= "Cod.Cli.;Ragione Sociale;N.Fatt;Data Fatt.;Importo;Movimento"					
_p_tiporic	= "Codice Cliente,1,Ragione Sociale,2,Numero Fattura,3"
_p_nomeric	= "Ricerca movimenti aperti temporanei"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************





*****************************************************************************
PROCEDURE pdcrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pdcrice"																			
_p_alias	= "conti"																					
_p_campi	= "con_anno;con_conto;con_descr;con_imp_d;con_imp_a;con_categ;con_codamm;con_codces"
_p_testa	= "Anno;Conto;Descrizione;Dare;Avere;Categ.Amm.(Anagr.);Categ.Amm.(Cespite);Cod.Anagr.Cespite"
_p_tiporic	= "Codice,1,Descrizione,2,Categ.Amm.(Anagr.),3,Categ.Amm.(Cespite),4,Cod.Anagr.Cespite,5"
_p_nomeric	= "Ricerca gestione piano dei conti"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************





*****************************************************************************
PROCEDURE pefrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pefrice"																			
_p_alias	= "cu_por_ef"																					
_p_campi	= "ric_codcli;ric_ragsoc;ric_nfatt;ric_dtfatt;ric_dtscad;ric_tranc;"					
_p_testa	= "Codice Cli,;Ragione Sociale;Num.Fatt.;Dt.Fattura;Dt.Scad.;Tranche;"					
_p_tiporic	= "Codice cliente,1,Rsgione Sociale,2,Numero fattura,3"
_p_nomeric	= "Ricerca ?????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE pedrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pedrice"																			
_p_alias	= "cu_per_pd"																					
_p_campi	= "ped_codice;ped_ragsoc;ped_codpdv;ped_despdv"
_p_testa	= "Cod.Persona;Descrizione;Codice PDV;Descrizione PDV"
_p_tiporic	= "Codice persona,1,Descrizione persona,2,Codice PDV,3,Descrizione PDV,4"
_p_nomeric	= "Ricerca anagrafica legami personale/PDV"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE perrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\perrice"																			
_p_alias	= "cu_per_an"																					
_p_campi	= "per_codice;per_ragsoc;per_indiri;per_locali;per_cap;per_provin;per_tel;per_cell;per_fax;per_email;per_tipcon;per_descon;per_datcon;per_orelav"
_p_testa	= "Codice;Descrizione;Indirizzo;Località;Cap;Provincia;Telefono;Cellulare;Fax;Email;Tipo Contratto;Descrizione Contratto;Data Contratto;Ore"
_p_tiporic	= "Codice persona,1,Descrizione persona,2,Tipo contratto,3,Descrizione Contratto,4,Dt.Cont.(gg/mm/aaaa),5"
_p_nomeric	= "Ricerca anagrafica personale"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE pforrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pforrice"																			
_p_alias	= "cu_ric_tt"																					
_p_campi	= "ric_codcli;ric_ragsoc;ric_nfatt;ric_dtfatt;ric_totfat;ric_dtscad;ric_bapres"					
_p_testa	= "Ric_codcli;Ric_ragsoc;Ric_nfatt;Ric_dtfatt;Ric_totfat;Ric_dtscad;Ric_bapres"					
_p_tiporic	= "Codice cliente,Rsgione Sociale,Numero fattura"
_p_nomeric	= "Ricerca ?????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE pncrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pncrice"																			
_p_alias	= "cu_pnc_bu"																					
_p_campi	= "pnc_datope;pnc_codute;pnc_desute;pnc_desope;pnc_import;pnc_segno;pnc_datreg;pnc_orareg"
_p_testa	= "DtOpe;Utente;Descrizione;Operazione;Importo;Segno;DtReg;OraReg"
_p_tiporic	= "Codice utente,1,Descrizione utente,2,Data operazione,3,Descrizione Operazione,4,Data registrazione,5"
_p_nomeric	= "Ricerca prima nota cassa"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE posrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\posrice"																			
_p_alias	= "cu_pos_an"																					
_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_prezzo;lis_desart;lis_allist;lis_cliart;lis_artgru"					
_p_testa	= "Cod.Cli.;Ragione Sociale;Cod.Articolo;Prezzo;Descrizione Articolo;;;"					
_p_tiporic	= "Codice Cliente/Articolo,1,Codice Articolo,2,Data Listino (gg/mm/aaaa),3"
_p_nomeric	= "Ricerca ?????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE prbrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prbrice"																			
_p_alias	= "cu_prb_tt"																					
_p_campi	= "ord_flgcon;ord_flgtra;ord_mags;ord_codcli;ord_ragsoc;ord_numord;ord_datord;ord_valore;ord_chiuso"
_p_testa	= "Conf.;Trasm.;Mag;Fornitore;Ragione sociale;N.Pre-bolla;Dt.Pre-bolla;Valore;A/C"
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Fornitore,4"
_p_nomeric	= "Ricerca Pre-bolle di reso"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************



*****************************************************************************
PROCEDURE prfrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prfrice"																			
_p_alias	= "cu_prf_tt"																					
_p_campi	= "ord_age;ord_numord;ord_nprot;ord_datord;ord_codcli;ord_ragsoc;ord_valore;ord_cge;"					
_p_testa	= "Age;N.Fatt.;Cod.cli.;Ragione Sociale;N.prot.;Dt.Fattura;Valore;Cge;Top"					
_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,N.Protocollo,5,Cod.Cliente,6"
_p_nomeric	= "Ricerca pre-fatture di trasporto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE procrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\procrice"																			
_p_alias	= "cres_proc"																					
_p_campi	= "utente;procedura;inseriment;cancellazi;modifica; ; ; ;"					
_p_testa	= "Utente;Procedura;Inseriment;Cancellazi;Modifica; ; ; ;"					
_p_tiporic	= "Utente+Procedura"
_p_nomeric	= "Ricerca??????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE proric
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\proric"																			
_p_alias	= "cu_pro_tt"																					
_p_campi	= "ORD_NUMORD;ORD_DATORD;ORS_CODCLI;ORS_RAGSOC;ORD_IDENTI;ORD_MACCHI;ORD_CODMAT"					
_p_testa	= "Nr.Comm.;Data comm.;Cliente;Ragione sociale;Identificazione;Macchina di prod.;Materiale"					
_p_tiporic	= "Numero commessa,1,Data (gg/mm/aaaa),2,Codice cliente,3,Ragione sociale,4,Identificazione,5,Macchina,6,Codice materiale,7"
_p_nomeric	= "Ricerca gestione commesse di produzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************





*****************************************************************************
PROCEDURE prorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prorice"																			
_p_alias	= "cu_pro_an"																					
_p_campi	= "pro_codage;pro_ragsoc;pro_data"					
_p_testa	= "Agente;Ragione Sociale;Data"					
_p_tiporic	= "Codice agente,1,Nome agente,2"
_p_nomeric	= "Ricerca provvigioni subagenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE proricx
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\proricx"																			
_p_alias	= "cu_pro_tt"																					
_p_campi	= "ord_numord;ord_datord;ord_identi;ord_macchi;ord_codmat;ord_desmat;ord_caus;ord_stato;ors_codcli;ors_ragsoc"					
_p_testa	= "Nr.Com.;Data Com.;Identificazione;Macchina;Tipo mat.;Descrizione;Causale;Stato;Codice;Ragione sociale"					
_p_tiporic	= "Numero Commessa,1,Data (gg/mm/aaaa),2,Codice cliente,3,Ragione Sociale,4,Identificazione,5,Macchina,6,Codice materiale,7"
_p_nomeric	= "Ricerca gestione commesse di produzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************




*****************************************************************************
PROCEDURE provrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\provrice"																			
_p_alias	= "cuprovvi"																					
_p_campi	= "ord_age;ord_numord;ord_datord;ord_codcli;ord_ragsoc;ord_codart;ord_qtaord;ord_prznet;ord_valore"					
_p_testa	= "Agente;Num. Fatt.;Data;Cliente;Rag. sociale;Articolo;Quantità;Prezzo;Valore"					
_p_tiporic	= "Numero Fattura,1,Ragione Sociale,2,Data (gg/mm/aaaa),3"
_p_nomeric	= "Ricerca provvigioni agente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE prvdrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prvdrice"																			
_p_alias	= "cu_prv_dd"																					
_p_campi	= "prv_codage;prv_codcli;prv_ragsoc;prv_numfat;prv_datfat;prv_tipodo;prv_imponi;prv_perpro;prv_totpro;prv_codart;prv_desart"					
_p_testa	= "Age;Cod.cli;Ragione sociale;N.fattura;Dt.fatt.;+/-;Imponibile;%;Provvig.;Articolo;Descrizione articolo"					
_p_tiporic	= "N.fattura,1,Ragione sociale,2,Agente,3"
_p_nomeric	= "Ricerca aggiornamento anagrafica provvigionale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************





*****************************************************************************
PROCEDURE prvorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prvorice"																			
_p_alias	= "cu_prv_an"																					
_p_campi	= "prv_codage;prv_codcli;prv_ragsoc;prv_numfat;prv_datfat;prv_tipodo;prv_imponi;prv_perpro;prv_totpro"					
_p_testa	= "Age;Cod.cli;Ragione sociale;N.fattura;Dt.fatt.;+/-;Imponibile;%;Provvig."					
_p_tiporic	= "N.fattura,Ragione sociale,Agente"
_p_nomeric	= "Ricerca aggiornamento anagrafica provvigionale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************




*****************************************************************************
PROCEDURE prvrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prvrice"																			
_p_alias	= "cu_prv_an"																					
_p_campi	= "prv_codage;prv_codcli;prv_ragsoc;prv_numfat;prv_datfat;prv_tipodo;prv_imponi;prv_perpro;prv_totpro"					
_p_testa	= "Age;Cod.cli;Ragione sociale;N.fattura;Dt.fatt.;+/-;Imponibile;%;Provvig."					
_p_tiporic	= "N.fattura,1,Ragione sociale,2,Agente,3"
_p_nomeric	= "Ricerca aggiornamento anagrafica provvigionale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE retmoric
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\retmoric"																			
_p_alias	= "cu_mag_mo"																					
_p_campi	= "mov_codmag;mov_codart;mov_numdoc;mo.mov_dtdocu;mov_dtregi;mov_top;mov_qtamov;mov_preacq;mov_preven;mov_valven;mov_valacq;mov_codfor"					
_p_testa	= "Maga.;Cod.Articolo;N.Docum.;Dt.Docum.;Dt.Regis.;Top;Qta.Movim.;Prz. Costo;Prz. Vendita;Valore Vendita;Valore Acquisto;Cod. Cli. / For."					
_p_tiporic	= "Magazzino / Codice Articolo,Data Registrazione,Magazzino / Codice Cliente / Fornitore"
_p_nomeric	= "Ricerca ??????????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE raarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\raarice"																			
_p_alias	= "cu_raa_tt"																					
_p_campi	= "ORD_NUMORD;ORD_DATORD;ORD_CODCLI;ORD_RAGSOC;ORD_CHIUSO;ORD_TOTIMP;ORD_TOTPRE;ORD_TOTRAC;ORD_TOTFAT"					
_p_testa	= "Nr.Compenso;Data;Cd.Amministratore;Ragione Sociale;Chiuso;Compenso;Previdenza;Rit.Acconto;Netto Percepito"					
_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3"
_p_nomeric	= "Ricerca compensi dell'Amministratore"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE form_exe_rice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\form_exe_rice"																			
_p_alias	= "cu_form_exe_rice"																					
_p_campi	= "nomeproc;nomeformexe"
_p_testa	= "Nome Procedura;Nome form eseguito"
_p_tiporic	= "Nome Procedura,1,Nome form eseguito,2"
_p_nomeric	= "Ricerca form eseguiti"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************

*****************************************************************************
PROCEDURE reprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\reprice"																			
_p_alias	= "cu_pjtiprep"																					
_p_campi	= "compa;nomeproc;nomerep;nomerep2;nomerep3;nomerep4"
_p_testa	= "Codice di Accesso;Nome Procedura;Nome 1° report;Nome 2° report;Nome 3° report;Nome 4° report"
_p_tiporic	= "Codice di Accesso,1,Nome Procedura,2,Nome 1° report,3,Nome 2° report,4,Nome 3° report,5,Nome 4° report,6"
_p_nomeric	= "Ricerca report"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE riarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\riarice"																			
_p_alias	= "cu_ria_tt"																					
*_p_campi	= "ORD_NUMORD;ORD_DATORD;ORD_CODCLI;ORD_RAGSOC;ORD_CHIUSO;ORD_TOTIMP;ORD_TOTIVA;ORD_TOTRAC;ORD_TOTFAT"
_p_campi	= "ORD_NUMORD;ORD_DATORD_R;ORD_CODCLI;ORD_RAGSOC;ORD_CHIUSO;ORD_TOTIMP;ORD_TOTIVA;ORD_TOTRAC;ORD_TOTFAT"  && ERASMO - 04/12/2023
_p_testa	= "Nr.Fattura;Dt.Fattura;Cd.Fornitore;Ragione Sociale Fornitore;Chiuso;Tot.Imponibile;Tot.Imposta;Tot.Rit.Acconto;Tot.Fattura"					
_p_tiporic	= "Numero Fattura,1,Data (gg/mm/aaaa),2,Ragione Sociale,3"
_p_nomeric	= "Ricerca fatture fornitore con r.a."																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************




*****************************************************************************
PROCEDURE ribarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ribarice"																			
_p_alias	= "cu_ric_tt"																					
_p_campi	= "ric_codcli;ric_ragsoc;ric_nfatt;ric_dtfatt;ric_dtscad;ric_totfat;ric_tranc"					
_p_testa	= "Cod.cliente;Ragione Sociale;Num.Fatt.;Data Fatt.;Data Scad.;Tot.documento;Tot.rata"					
_p_tiporic	= "Codice cliente,1,Ragione Sociale,2,Numero fattura,3"
_p_nomeric	= "Ricerca gestione ricevute bancarie"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE ribmrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ribmrice"																			
_p_alias	= "cu_rim_tt"																					
_p_campi	= "ric_codcli;ric_ragsoc;ric_nfatt;ric_dtfatt;ric_dtscad;ric_totfat;ric_tranc"					
_p_testa	= "Cod.cliente;Ragione Sociale;Num.Fatt.;Data Fatt.;Data Scad.;Tot.documento;Tot.rata"					
_p_tiporic	= "Codice cliente,1,Ragione Sociale,2,Numero fattura,3"
_p_nomeric	= "Ricerca gestione ricevute bancarie manuali"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE riccmc
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\riccmc"																			
_p_alias	= "cu_cmc_an"																					
_p_campi	= "cmd_numero;cmd_codcli;cmd_ragsoc;cmd_codage;cmd_desage;cmd_indiri"					
_p_testa	= "N.Com.;Cod.Cli;Ragione Sociale;Age;Descrizione Agente;"					
_p_tiporic	= "Codice Cliente,Ragione Sociale,Data Comodato (gg/mm/aaaa),Numero Comodato"
_p_nomeric	= "Ricerca ??????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************




*****************************************************************************
PROCEDURE riccmd
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\riccmd"																			
_p_alias	= "cu_cmd_an"																					
_p_campi	= "cmd_numero;cmd_codcli;cmd_ragsoc;cmd_locali;cmd_data"					
_p_testa	= "Numero;Cod.Cli.;Ragione Sociale;Localita';Data"					
_p_tiporic	= "Codice Cliente,1,Ragione Sociale,2,Data Comodato (gg/mm/aaaa),3,Numero Comodato4,"
_p_nomeric	= "Ricerca ??????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************





*****************************************************************************
PROCEDURE ricinse
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ricinse"																			
_p_alias	= "cu_ins_an"																					
_p_campi	= "ins_codcli;ins_ragsoc;ins_locali"					
_p_testa	= "Cod. Cli.;Ragione Sociale;Localita'"					
_p_tiporic	= "Codice Cliente,Ragione Sociale"
_p_nomeric	= "Ricerca ??????????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE ridrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ridrice"																			
_p_alias	= "cu_rid_an"																					
_p_campi	= "rid_banca;rid_mitten;rid_nomsup;rid_mitfis;rid_desfis;rid_progre;rid_codazi;rid_cifcon"					
_p_testa	= "Banca;Mittente;Nome Supp.;Mitt.Fis.;Des.Fis.;Progress.;Cod.azi.;Cifra con."					
_p_tiporic	= "Cod.Banca,1"
_p_nomeric	= "Ricerca parametri della banca per la creazione automatica file per banca"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE rintrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\rintrice"																			
_p_alias	= "cu_rin_tt"																					
_p_campi	= "ord_codope;ord_numord;ord_datord;ord_codcli;ord_ragsoc; ; ; ; "					
_p_testa	= "Ope;N.Rich.;Dt.rich.;Cod.cli.;Ragione Sociale; ; ; ;"					
_p_tiporic	= "Numero Ordine,Data (gg/mm/aaaa),Ragione Sociale,Codice Agente"
_p_nomeric	= "Ricerca richieste intervento"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE scarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\scarice"																			
_p_alias	= "cu_sca_an"																					
_p_campi	= "sca_codcli;sca_ragsoc;sca_numid;sca_dtscon;sca_impsco;sca_lkg"					
_p_testa	= "Cod.Cliente;Ragione Sociale;Num.Id.;Dt.Scade.;Qta.Impe.;Lire Kg."					
_p_tiporic	= "Cod.Cliente,Ragione Sociale,N.Identificativo"
_p_nomeric	= "Ricerca ???????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE sperice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\sperice"																			
_p_alias	= "cu_spe_tt"																					
_p_campi	= "ord_codcli;ord_ragsoc;ord_numord;ord_datord;ord_valore;ord_flbol"					
_p_testa	= "Cliente;Ragione Sociale;Numero;Data.;Valore;Sped."					
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Agente,4"
_p_nomeric	= "Ricerca distinta di spedizione-paking list"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************



*****************************************************************************
PROCEDURE bforice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bforice"																			
_p_alias	= "cu_bfo_tt"																					
_p_campi	= "ord_flgcon;ord_flgtra;ord_anomax;ord_numide;ord_numord;ord_dator2_r;ord_datord_r;ord_valimp;ord_valore;ord_codbun;ord_ragsoc;ord_codcco;ord_codcli"
_p_testa	= "Conf.;Trasm.;Anom.;N.ide.;N.doc.;Dt.doc.;Dt.reg.;Imponibile;Valore;B.Unit;Fornitore;C.costo;Cd.Forn."
_p_tiporic	= "Numero,1,Data reg.(gg/mm/aaaa),2,Ragione Sociale,3,Codice Fornitore,4,Buisness Unit,5,C. costo,6,Numero Identificativo,7"									
_p_nomeric	= "Ricerca bolle di carico da fornitori (solo causale " + PUB_BFO + ")"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************

*****************************************************************************
PROCEDURE rdcrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\rdcrice"																			
_p_alias	= "cu_bfo_tt"																					
_p_campi	= "ord_flgcon;ord_flgtra;ord_anomax;ord_numide;ord_numord;ord_dator2_r;ord_datord_r;ord_valimp;ord_valore;ord_codbun;ord_ragsoc;ord_codcco;ord_codcli"
_p_testa	= "Conf.;Trasm.;Anom.;N.ide.;N.doc.;Dt.doc.;Dt.reg.;Imponibile;Valore;B.Unit;Fornitore;C.costo;Cd.Forn."
_p_tiporic	= "Numero,1,Data reg.(gg/mm/aaaa),2,Ragione Sociale,3,Codice Fornitore,4,Buisness Unit,5,C. costo,6,Numero Identificativo,7"									
_p_nomeric	= "Ricerca bolle di reso da clienti"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************








**********************************************************************************************************************************************************

*****************************************************************************
PROCEDURE spirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\spirice"																			
_p_alias	= "cu_spi_an"																					
_p_campi	= "spi_codcli;spi_ragsoc;spi_descri;spi_niden;spi_import"					
_p_testa	= "Cod.Cli.;Ragione Sociale;Descrizione Intervento;N.Id.;Importo"					
_p_tiporic	= "Codice Cliente,Rsgione Sociale,Data Int. (gg/mm/aaaa)"
_p_nomeric	= "Ricerca spese/interventi"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************




*****************************************************************************
PROCEDURE tverice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\tverice"																			
_p_alias	= "cu_tve_tt"																					
_p_campi	= "ord_codcli;ord_ragsoc;ord_numord;ord_datord;ord_age;ord_valore;ord_scar"					
_p_testa	= "Cod.cli.;Ragione Sociale;N.bolla;Dt. Bolla;Age;Valore;S/c"					
_p_tiporic	= "Numero Bolla,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4"
_p_nomeric	= "Ricerca bolle di carico vetture"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE blorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\blorice"																			
_p_alias	= "BLOCCAPN"																					
_p_campi	= "BPN_DATADAL_RIBALTATA;BPN_DATAAL_RIBALTATA;SOLO_FATTURE;OPZ_FATTURE"
_p_testa	= "Data blocco dal;Data blocco al;Solo fatture;Opzione fatture"
_p_tiporic	= "Data blocco dal (gg/mm/aaaa),1,Data blocco al  (gg/mm/aaaa),2"
_p_nomeric	= "Ricerca gestione blocco registrazioni contabili"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE valrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\valrice"																			
_p_alias	= "cu_vva_ch"																					
_p_campi	= "vva_codval;vva_nomval;vva_data;vva_change"					
_p_testa	= "Cod.Valuta;Descrizione valuta;Dt.Cambio;Cambio"					
_p_tiporic	= "Codice valuta,1,Dt.Cambio (gg/mm/aaaa),2"
_p_nomeric	= "Ricerca gestione valuta"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE versrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\versrice"																			
_p_alias	= "cu_ver_tt"																					
_p_campi	= "ric_progr;ric_dtfatt;ric_top;ric_cge;ric_descri"					
_p_testa	= "N.incasso;Dt.docum.;Top;Ok cge;Descrizione"					
_p_tiporic	= "Numero incasso,1"
_p_nomeric	= "Ricerca incasso clienti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE visrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\visrice"																			
_p_alias	= "cu_vis_an"																					
_p_campi	= "vis_dtrela;vis_age;vis_denom;vis_via;vis_locali;vis_tele"					
_p_testa	= "Data Rel.;Agente;Denominazione;Via;Localita';Telefono"					
_p_tiporic	= "Data Relazione (gg/mm/aaaa),1,Agente,2"
_p_nomeric	= "Ricerca ???????????"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE PDVRICE
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PDVRICE"																			
_p_alias	= "cu_pdv_an"																					
_p_campi	= "pdv_codcco;pdv_codice;pdv_descri;pdv_indiri;pdv_locali"					
_p_testa	= "C.costo;Codice;Descrizione;Indirizzo;Località"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca business unit"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE PDVTPRIC
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PDVTPRIC"																			
_p_alias	= "cu_pdv_pa"																					
_p_campi	= "pdv_progre;pdv_codice;pdv_descri;pdv_codart;pdv_desart;pdv_codcge;pdv_descge;pdv_tippag"					
_p_testa	= "Prog;Codice;Descrizione;Articolo;Descrizione;C.conto;Descrizione;Tipo"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca tabella tipo pagamenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************

*****************************************************************************
PROCEDURE PDVOPRIC
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PDVOPRIC"																			
_p_alias	= "cu_pdv_cc"																					
_p_campi	= "pdv_progre;pdv_codice;pdv_descri;pdv_codcge;pdv_descge;pdv_tippag"					
_p_testa	= "Prog;Codice;Descrizione;Conto contabile;Descrizione;Tipo"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca tabella tipo operazioni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE autrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\autrice"																			
_p_alias	= "cu_pdv_au"																					
_p_campi	= "pdv_dataut;pdv_codute;pdv_desute;pdv_import;pdv_codbun;pdv_desbun"					
_p_testa	= "Data;Utente;Descrizione;Importo;Pdv;Descrizione"					
_p_tiporic	= "Data,1,Codice Utente,2,Descrizione Utente,3,Codice Pdv,4,Descrizione Pdv,5"
_p_nomeric	= "Ricerca autorizzazione spese"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

**********************************************************************************************************************************************************


*****************************************************************************
PROCEDURE listari2
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\listari2"																			
_p_alias	= "cu_lis_pa"																					
_p_campi	= "lis_age;lis_linea;lis_provvi"					
_p_testa	= "Agente;Linea;Provv."					
_p_tiporic	= "Codice agente,1,Codice linea,2"
_p_nomeric	= "Ricerca provvigioni agenti per linea di prodotto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE pararice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pararice"																		&& nome della procedura con istruzioni sql
_p_alias	= "cu_para"																					&& nome del cursore in cui memorizzare i dati
_p_campi	= "tipo;codice;descri;codpgo;libera"	    && elenco dei campi da visualizzare
_p_testa	= "Tipo;Codice;Descrizione;Conv;Libera"     && impostazione dei campi da visualizzare
_p_tiporic	= "Codice,1,Descrizione,2"	                && elenco delle ricerche della combo box
_p_nomeric	= "Ricerca parametri"           	        && descrizione della ricerca

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE pararic
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pararic"																		&& nome della procedura con istruzioni sql
_p_alias	= "cu_para"																					&& nome del cursore in cui memorizzare i dati
*_p_campi	= "tipo;codice;descri;codpgo;libera"	    && elenco dei campi da visualizzare
_p_campi	= "tipo;c_codice;descri;codpgo;libera;c_disattivo"     && ERASMO - 31/03/2023
*_p_testa	= "Tipo;Codice;Descrizione;Conv;Libera"     && impostazione dei campi da visualizzare
_p_testa	= "Tipo;Codice;Descrizione;Conv;Libera;Disattivo"     && ERASMO - 31/03/2023
*_p_tiporic	= "Codice,1,Descrizione,2"	                && elenco delle ricerche della combo box
_p_tiporic	= "Codice,1,Descrizione,2,Cod.conv.,3,Libera,4"     && ERASMO - 13/12/2024
_p_nomeric	= "Ricerca parametri"           	        && descrizione della ricerca

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE menurice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\menurice"																			
_p_alias	= "cu_tbl_menu"																					
_p_campi	= "menu;label;comando"					
_p_testa	= "Nome menu;Voce menu;Comando"					
_p_tiporic	= "Nome menu,1,Nella voce menu,2,Nel comando,3"
_p_nomeric	= "Ricerca menu principali"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE ceeretr
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ceeretr"																			
_p_alias	= "cu_ret_ce"																					
_p_campi	= "ret_anno;ret_riga;ret_desrig;ret_import"					
_p_testa	= "Anno;Riga;Descrizione;Importo"					
_p_tiporic	= "Codice riga,1"
_p_nomeric	= "Ricerca"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE briretr
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\briretr"																			
_p_alias	= "cu_retti_bil_ric"																					
_p_campi	= "ret_anno;ret_riga;ret_desrig;ret_import"					
_p_testa	= "Anno;Riga;Descrizione;Importo"					
_p_tiporic	= "Codice riga,1"
_p_nomeric	= "Ricerca"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ivarrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ivarrice"																			
_p_alias	= "cu_iva_cr"																					
_p_campi	= "iva_anno;iva_gennai;iva_febbra;iva_marzo;iva_aprile;iva_maggio;iva_giugno;iva_luglio;iva_agosto;iva_settem;iva_ottobr;iva_novemb;iva_dicemb"
_p_testa	= "Anno;Gennaio;Febbraio;Marzo;Aprile;Maggio;Giugno;Luglio;Agosto;Settembre;Ottobre;Novembre;Dicembre"
_p_tiporic	= "Anno,1"
_p_nomeric	= "Ricerca"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN




*****************************************************************************
PROCEDURE ivaesric
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ivaesric"																			
_p_alias	= "cu_iva_es"																					
_p_campi	= "iva_anno;iva_gennai;iva_febbra;iva_marzo;iva_aprile;iva_maggio;iva_giugno;iva_luglio;iva_agosto;iva_settem;iva_ottobr;iva_novemb;iva_dicemb"
_p_testa	= "Anno;Gennaio;Febbraio;Marzo;Aprile;Maggio;Giugno;Luglio;Agosto;Settembre;Ottobre;Novembre;Dicembre"
_p_tiporic	= "Anno,1"
_p_nomeric	= "Ricerca"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE ivaesricf
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ivaesricf"																			
_p_alias	= "cu_iva_es"																					
_p_campi	= "iva_anno;iva_codfor;iva_desfor"
_p_testa	= "Anno;Cod.fornitore,Ragione sociale"
_p_tiporic	= "Ragione sociale,1"
_p_nomeric	= "Ricerca"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************


*****************************************************************************
PROCEDURE linguer
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\linguer"																			
_p_alias	= "clingue"																					
_p_campi	= "codsoc;cod_naz;tipo_doc"					
_p_testa	= "Codice Società;Codice Nazione;Tipo Documento"					
_p_tiporic	= "Codice Nazione,1"
_p_nomeric	= "Ricerca lingue"																	


DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE PDVCORIC
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PDVCORIC"																			
_p_alias	= "cu_con_pe"																					
_p_campi	= "con_codice;con_descri;con_sigla;con_tipcon;con_descon;con_percen"					
_p_testa	= "Codice;Descrizione;Sigla;Tipo;Descrizione;Perc."					
_p_tiporic	= "Codice,1,Descrizione,2,Sigla,3,Tipo,4"
_p_nomeric	= "Ricerca tabella contratti collaboratori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE calrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\calrice"																			
_p_alias	= "cu_cal_la"																					
_p_campi	= "cal_anno;cal_data;cal_sett;cal_gior;cal_lavo;cal_orelav;cal_dtiset;cal_dtfset;cal_oraini;cal_orafin"             &&EM 14/06/2004
_p_testa	= "Anno;Data;Settimana;Giorno;Lavorativo;Ore Lav.;Dt.In.Sett.;Dt.Fi.Sett.;Ora In.G.Lav.;Ora Fin.G.Lav."   &&EM 14/06/2004 
_p_tiporic	= "Anno,1,Data (GG/MM/AAAA),2"
_p_nomeric	= "Ricerca calendario lavorativo"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE asscrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\asscrice"																			
_p_alias	= "cu_cal_as"																					
_p_campi	= "cal_flgcon;cal_flgtra;cal_datass;cal_codpdv;cal_despdv;cal_codcol;cal_descol;cal_desmot"
_p_testa	= "Confermato;Trasmesso;Data Ass.;P.d.v.;Descrizione;Collab.;Ragione sociale;Motivazione"
_p_tiporic	= "Punto di vendita,1,Codice collab.,2,Rag. sociale collab.,3,Data Ass. (gg/mm/aaaa),4"
_p_nomeric	= "Ricerca assenze collaboratori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
PROCEDURE redrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\redrice"																			
_p_alias	= "cu_xls_tt"																					
_p_campi	= "xls_codice;xls_descri"					
_p_testa	= "Codice;Descrizione"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca anagrafica controllo redditività"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE tesrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\tesrice"																			
_p_alias	= "cu_tes_an"																					
_p_campi	= "tes_cogn;tes_nome;tes_loc;tes_prov"					
_p_testa	= "Cognome;Nome;Città;Provincia"					
_p_tiporic	= "Cognome,1,Nome,2,Città,3,Provincia,4"
_p_nomeric	= "Ricerca tessera"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE mimrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\mimrice"																			
_p_alias	= "cux_art_pr"																					
_p_campi	= "art_codpri;art_descr;art_codpac;art_despac;art_sernum;art_notcom;art_datvar;art_tipcom;art_descom"					
_p_testa	= "Componente;Descrizione;Confezione;Descrizione;Serial Number;Note varie;Data creaz.;Tipo;Descrizione"
_p_tiporic	= "Cod. Confezione,1,Descr. Confezione,2,Cod. Componente,3,Descr. Componente,4,Serial Number,5,Tipo,6"
_p_nomeric	= "Ricerca articoli magazzino informatico"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE clifrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\clifrice"																			&& nome della procedura con istruzioni sql
_p_alias	= "cu_cli_fi"																					&& nome del cursore in cui memorizzare i dati
_p_campi	= "fid_codcli;fid_ragsoc"		
_p_testa	= "Cod.cliente;Ragione sociale"
_p_tiporic	= "Ragione sociale,1,Codice cliente,2"
_p_nomeric	= "Ricerca clienti fidelizzati"																	&& descrizione della ricerca

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
*****************************************************************************
PROCEDURE forprrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\forprrice"																			
_p_alias	= "cu_for_pr"																					
_p_campi	= "fpr_codfor;fpr_ragfor;fpr_codart;fpr_desart"
_p_testa	= "Cod.for.;Ragione sociale;Cod.art;Descrizione"
_p_tiporic	= "Codice Fornitore,1,Ragione Sociale,2,Codice Articolo,3,Descrizione Articolo,4"
_p_nomeric	= "Ricerca anagrafica fornitori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
*****************************************************************************
PROCEDURE msgrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\msgrice"																			
_p_alias	= "cu_msg_au"																					
_p_campi	= "msg_codmit;msg_desmit;msg_codope;msg_desope;msg_coddes;msg_desdes;msg_datinv;msg_datric"
_p_testa	= "Codice Mittente;Mittente;Codice Operatore;Operatore;Codice Destinatario;Destinatario;Data invio;Data ricezione"
_p_tiporic	= "Codice Mittente,1,Mittente,2,Codice Operatore,3,Operatore,4,Codice Destinatario,5,Destinatario,6,Data invio,7,Data ricezione,8"
_p_nomeric	= "Ricerca messaggi"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


***FB*************************************************************************
PROCEDURE learice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\learice"																			
_p_alias	= "cu_lea_tt"																						
_p_campi	= "lea_codcli;lea_ragsoc;lea_numcon;lea_datcon;lea_imptot"					
_p_testa	= "Fornitore;Ragione sociale;Numero;Data;Valore totale"									
_p_tiporic	= "Numero Contratto,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Punto Vendita,4,Cod.fornitore,5"
_p_nomeric	= "Ricerca Leasing"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB*************************************************************************
PROCEDURE FINrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\finrice"																			
_p_alias	= "cu_fin_tt"																						
_p_campi	= "fin_codcli;fin_ragsoc;fin_numcon;fin_datcon;fin_imptot"					
_p_testa	= "Fornitore;Ragione sociale;Numero;Data;Valore totale"									
_p_tiporic	= "Numero ,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Punto Vendita,4,Cod.fornitore,5"
_p_nomeric	= "Ricerca Finanziamenti e Mutui"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB*************************************************************************
PROCEDURE conrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\conrice"																			
_p_alias	= "cu_con_tt"																						
_p_campi	= "con_codcli;con_ragsoc;con_numcon;con_datcon;con_imptot"					
_p_testa	= "Fornitore;Ragione sociale;Numero;Data;Importo"									
_p_tiporic	= "Numero Contratto,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Punto Vendita,4,Cod.fornitore,5"
_p_nomeric	= "Ricerca Contratti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB*************************************************************************
PROCEDURE assrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\assrice"																			
_p_alias	= "cu_ass_tt"																						
_p_campi	= "ass_codcli;ass_ragsoc;ass_numass;ass_datass;ass_imptot"					
_p_testa	= "Fornitore;Ragione sociale;Numero;Data;Importo"									
_p_tiporic	= "Numero Assegno,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Punto Vendita,4,Cod.fornitore,5"
_p_nomeric	= "Ricerca Assegni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE cntrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cntrice"																			
_p_alias	= "cu_cnt_tt"		

*!*	_p_campi	= "cnt_ragsoc;cnt_codage;cnt_desage;cnt_codzon;cnt_deszon;cnt_codnaz;cnt_desnaz;cnt_codset;cnt_desset;cnt_codset;cnt_desset;cnt_codzon;cnt_deszon"					
*!*	_p_testa	= "Rag.Sociale;Cod. Agente;Agente;Cod. Zona;Zona;Cod. Nazione;Nazione;Cod. Settore;Settore;Cod. Contatto;Contatto;Cod. Responso;Responso"
																		
_p_campi	= "cnt_ragsoc;cnt_dsconu;cnt_codage;cnt_desage;cnt_codzon;cnt_deszon;cnt_codnaz;cnt_desnaz;cnt_codset;cnt_desset;cnt_codset;cnt_desset;cnt_codzon;cnt_deszon"					
_p_testa	= "Rag.Sociale;Azione;Cod. Agente;Agente;Cod. Zona;Zona;Cod. Nazione;Nazione;Cod. Settore;Settore;Cod. Contatto;Contatto;Cod. Responso;Responso"

_p_tiporic	= "Ragione sociale (inizia per),1,Ragione sociale (contiene),2,Cod. Agente,3,Agente,4,Cod. Nazione,5,Nazione,6,Cod.Zona,7,Zona,8,Cod. Settore,9,Settore,10,Cod. Contatto,11,Contatto,12,Cod. Responso,13,Responso,14"
_p_nomeric	= "Ricerca contatti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE ccxrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric


_p_click 	= "ricerche\ccxrice"																			
_p_alias	= "cu_cco_tt"																					
_p_campi	= "ord_codcco;ord_descco;ord_numcon;ord_datape;ord_fidoconto;ord_1cogno;ord_2cogno;ord_3cogno"					
_p_testa	= "Conto corrente.;Descrizione conto.;N.interno.;Dt.Apertura c.;Fido concesso;Primo coentestatario;Secondo coentestatario;Terzo coentestatario"					
_p_tiporic	= "Numero conto,1,Data apertura (gg/mm/aaaa),2,Primo coentestatario,3,Secondo coentestatario,4,Terzo coentestatario,5"
_p_nomeric	= "Ricerca conto corrente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB************************************************************************
PROCEDURE PARCQrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PARCQrice"																			
_p_alias	= "cu_PAR_CQ"																											
_p_campi	= "PAR_codart;PAR_desart;PAR_PHDA;PAR_PHAL;PAR_VISCDA;PAR_VISCAL;PAR_RESEDA;PAR_RESEAL;PAR_PESPDA;PAR_PESPAL;PAR_ADINDA;PAR_ADINAL;PAR_GRAMDA;PAR_GRAMAL;PAR_ADACDA;PAR_ADACAL;PAR_ADALDA;PAR_ADALAL"
_p_testa	= "Codice Prodotto;Descrizione Prodotto;Ph da;Ph al;Visc. da;Visc. al; Res. sec. da;Res. sec. al;Pes. spec. da;Pes. spec. al;Ades.iniz. da;Ades. iniz. al;Gramm. da;Gremm. al;Ad.Acc.Luc. da;Ad.Acc.Luc. al;Ad.All.Luc. da;Ad.All.Luc. al"
_p_tiporic	= "Codice Prodotto,1,Descrizione Prodotto,2"
_p_nomeric	= "Ricerca Parametri "																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB********************************************************************
PROCEDURE PARMYrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PARMYrice"																			
_p_alias	= "cu_PAR_my"																						
_p_campi	= "PAR_codspe;PAR_PRSCDA;PAR_PRSCAl "					
_p_testa	= "Codice spessore;Prov. scop. da;Prov. scop. al"									
_p_tiporic	= "Codice spessore,1"
_p_nomeric	= "Ricerca Parametri "																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB******************************************************************
PROCEDURE PARFIrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\PARfirice"																			
_p_alias	= "cu_PAR_fi"																						
_p_campi	= "PAR_codice;PAR_DEScri;PAR_MAXORE;PAR_PERSPE;PAR_PERALT"					
_p_testa	= "Codice  ;Descrizione; Temp.Max ; spessore Comp; Altezza comp "									
_p_tiporic	= "Codice ,1,Descrizione ,2"
_p_nomeric	= "Ricerca Parametri "																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE slcrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\slcrice"																			
_p_alias	= "cu_slc_cq"																					
_p_campi	= "slc_codart;slc_desart;slc_datana;slc_codope;slc_codcli;slc_descli;slc_campio;slc_aspe_r;slc_aspe_d;slc_tipade;slc_tipfil;slc_codcol;slc_descol;slc_gramma;slc_spesso;slc_respon;slc_resdat;slc_resora;slc_resi_r;slc_resi_d;slc_altro"
_p_testa	= "Codice Prodotto;Descrizione Prodotto;Data analisi;Operatore;Cod. Cliente;Rag. Soc. Cliente;Campione;Aspetto;Descr. Aspet;Tipo Adesivo;Tipo film;Cod.Col;Colore;Grammat.;Spessore;Responso;Data responso;Ora responso;resistenza;descr resist;Altro"
_p_tiporic	= "Codice Prodotto,1,Descrizione Prodotto,2,Data anal.(gg/mm/aaaa),3,Rag. Soc. Cliente,4,Campione,5,Responso,6,Data resp.(gg/mm/aaaa),7"
_p_nomeric	= "Ricerca prodotti concorrenti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE SPCRICE
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\spcrice"																			
_p_alias	= "cu_pro_my"																					
_p_campi	= "mic_spesso;mic_codmat;mic_desmat;mic_spesda;mic_spesal;mic_speord;mic_lunord"					
_p_testa	= "Codice spessore;Tipo materiale;Descrizione materiale;Spessore compatibile da (my);Spessore std. per ordine a fornitore (my);Lunghezza std. per ordine a fornitore (mtl)"	
_p_tiporic	= "Codice spessore,1,Tipo materiale,2,Descrizione materiale,3"
_p_nomeric	= "Ricerca spessori compatibili"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE CMPRICE
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cmprice"																			
_p_alias	= "cu_pro_ca"																					
_p_campi	= "cap_codlav;cap_codmac;cap_codmat;cap_cddiba;cap_deslav;cap_desmac;cap_desmat;cap_dsdiba"					
_p_testa	= "Lavorazione;Macchina;Tipo;Dist.Base;Descr.Lavorazione;Descr.Macchina;Descr.materiale;Descr. Di.Ba."	
_p_tiporic	= "Codice tipo lavorazione,1,Codice macchina produzione,2,Codice tipo materiale,3,Codice formula Di.Ba.,4"
_p_nomeric	= "Ricerca capacità macchine di produzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE LOTRICE
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lotrice"																			
_p_alias	= "CU_LOT_RI"																					
_p_campi	= "lot_codsoc;lot_nloini;lot_datope;lot_oraope;lot_magsca;lot_magcar;lot_codcau;lot_nlofin"					
_p_testa	= "Cod.società;N°lotto iniz.;Data Operaz.;Ora operaz.;Mag.Sca.;Mag.Car.;Cod.Causale;N°lotto fin."	
_p_tiporic	= "Cod.società,1,N°lotto iniz.,2,Data Operaz.,3,Cod.Causale,4,N°lotto fin.,5"
_p_nomeric	= "Ricerca lotti di produzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE pririce
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pririce"																			
_p_alias	= "cu_pro_im"																					
_p_campi	= "imp_codlav;imp_codmac;inv_datimp;inv_setimp;imp_orelav;imp_oreimp;imp_nrprg1;inv_dtprg1;imp_nrprg2;inv_dtprg2"					
_p_testa	= "Cod.Lavorazione;Cod.Macchina;Data impegnata;Settimana impegnata;Ore lavorative;Ore impegnate;Num.Programma 1;Data Programma 1;Num.Programma 2;Data Programma 2"					
_p_tiporic	= "Cod.Lavorazione,1,Cod.Macchina,2,Data im.(gg/mm/aaaa),3,Sett. imp.(nn/aaaa),4,Num.Programma 1,5,Data Pr1(gg/mm/aaaa),6,Num.Programma 2,7,Data Pr2(gg/mm/aaaa),8"
_p_nomeric	= "Ricerca impegni macchine di produzione"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE elarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\elarice"																			
_p_alias	= "cu_ela_an"																					
_p_campi	= "data_solar;dataela_01;proc_01;proc_02;proc_03;proc_04;proc_05;proc_06;proc_07;proc_08;proc_09;proc_10;totaleanom"
_p_testa	= "Data Solare;Data Elaborazione;Procedura 1;Procedura 2;Procedura 3;Procedura 4;Procedura 5;Procedura 6;Procedura 7;Procedura 8;Procedura 9;Procedura 10;Totale Anomalie"
_p_tiporic	= "Data Solare,1,Data Elaborazione,2,Procedura, 3"
_p_nomeric	= "Ricerca elaborazioni notturne"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN



***********************************************************************
PROCEDURE alcrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\alcrice"																			
_p_alias	= "cu_pro_al"																						
_p_campi	= "alt_finudo;alt_progre;alt_fispda;alt_fispal;alt_cilgom"					
_p_testa	= "Altezza film nudo (mm);Progressivo;Film spalmato (mm) da;Film spalmato (mm) al;Cilindro gommato (mm)"									
_p_tiporic	= "Alt.film nudo (mm),1,Film sp.(mm) da,2,Film sp.(mm) al,3,Cil.gommato (mm),4"
_p_nomeric	= "Ricerca Altezze compatibili"				

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE camrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\camrice"																			
_p_alias	= "cu_cam_an"																					
_p_campi	= "cam_categ;cam_descr;cam_tipoc;cam_contr"
_p_testa	= "Categoria;Descrizione;Tipo Categoria;Contropartita contabile"
_p_tiporic	= "Categoria,1,Descrizione,2,Contropartita contabile,3"
_p_nomeric	= "Ricerca beni ammortizzabili"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
PROCEDURE gperice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\gperice"																			
_p_alias	= "cu_gpe_an"																					
_p_campi	= "gpe_matri;gpe_cognom;gpe_dtass;gpe_dtces;gpe_banca"
_p_testa	= "Matricola;Cognome;Data assunzione;Data cessazione;Banca"
_p_tiporic	= "Matricola,1,Cognome,2,Località,3,Banca,4,Data assunzione,5,Data cessazione,6"
_p_nomeric	= "Ricerca anagrafica personale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
PROCEDURE gpprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\gpprice"																			
_p_alias	= "cu_gpp_mo"																					
_p_campi	= "gpp_anno;gpp_mese;gpp_matri;gpp_cognom;gpp_dapaga"
_p_testa	= "Anno;Mese;Matricola;Cognome;Importo da pagare"
_p_tiporic	= "Matricola,1,Cognome,2,Anno,3,Mese,4"
_p_nomeric	= "Ricerca stipendi personale"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***FB*************************************************************************
PROCEDURE ascrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric


_p_click 	= "ricerche\ascrice"																			
_p_alias	= "cu_asc_tt"																						
_p_campi	= "ass_codcli;ass_ragsoc;ass_numass;ass_datass;ass_imptot"					
_p_testa	= "Fornitore;Ragione sociale;Numero;Data;Importo"									
_p_tiporic	= "Numero Assegno,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Punto Vendita,4,Cod.cliente,5"
_p_nomeric	= "Ricerca effetti attivi"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked


RETURN


*****************************************************************************
PROCEDURE pckrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pckrice"																			
_p_alias	= "cu_pck_tt"																					

_p_campi	= "ord_numord;ord_datord;ord_age;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc"					
_p_testa	= "N.pak.list;Dt.bolla;Age;Valore;A/c;Conf.;Trasm.;Exp;Mag;Cliente;Ragione sociale"					


_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Codice Cliente,5"
_p_nomeric	= "Ricerca documenti di trasporto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE comurice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\comurice"																			
_p_alias	= "comuni"																					
_p_campi	= "cap;comune;provincia"					
_p_testa	= "CAP;Comune;Provincia"					
_p_tiporic	= "CAP,1,Comune,2,Provincia,3"
_p_nomeric	= "Ricerca Comuni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE attrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\attrice"																			
_p_alias	= "u_att_op"																					
_p_campi	= "att_proced;att_despro;att_codope;att_nomope"					
_p_testa	= "Nome Procedura;Descr.Procedura;Cod.Operatore;Descr.Operatore"					
_p_tiporic	= "Nome Procedura,1,Descr.Procedura,2,Cod.Operatore,3,Descr.Operatore,4"
_p_nomeric	= "Ricerca Utenti in uso nelle Procedure"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE toprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\toprice"																			
_p_alias	= "u_top_mo"																					
_p_campi	= "top_magsca;top_magcar;top_causca;top_caucar;top_attivo"					
_p_testa	= "Mag.Scarico;Mag.Carico;Causale Scar.;Causale Car.;Attivo"					
_p_tiporic	= "Mag.Scarico,1,Mag.Carico,2,Causale Scar.,3,Causale Car.,4"
_p_nomeric	= "Ricerca Causali Movimentazione prodotti nei magazzini interni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE lisaltrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lisaltrice"																			
_p_alias	= "cu_lis_al"																					
_p_campi	= "lis_codcli;lis_ragsoc;lis_codart;lis_desart;lis_alteda;lis_alteal;lis_lungda;lis_lungal;lis_prezzo;lis_sc1;lis_sc2;lis_sc3;lis_datlis;lis_allist"					
_p_testa	= "Cliente;Ragione sociale;Articolo;Descrizione;Altezza Da;Altezza Al;Lunghezza Da;Lunghezza Al;Prezzo;Sc 1;Sc 2;Sc 3;Data Val.Da;Data Val.Al"
_p_tiporic	= "Codice cliente,1,Ragione Sociale,2,Codice articolo,3,Dt.list.(gg/mm/aaaa),4"
_p_nomeric	= "Ricerca listini per cliente/articoli/altezza"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE provirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\provirice"																			
_p_alias	= "province"																					
_p_campi	= "sigla;provincia;regione"					
_p_testa	= "Sigla;Provincia;Cod.Regione"					
_p_tiporic	= "Sigla,1,Provincia,2,Cod.Regione,3"
_p_nomeric	= "Ricerca Province"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
PROCEDURE pesrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pesrice"																			
_p_alias	= "u_pes_ve"																					
_p_campi	= "pes_codvet;pes_desvet;pes_rngsca;pes_rngda1;pes_rngal1;pes_rngda2;pes_rngal2;pes_rngda3;pes_rngal3"
_p_campi	= _p_campi + ";pes_rngda4;pes_rngal4;pes_rngda5;pes_rngal5;pes_rngda6;pes_rngal6;pes_rngda7;pes_rngal7"
_p_testa	= "Cod.Vettore;Descrizione;A scaglioni di KG;Range1 Da;Range1 A;Range2 Da;Range2 A;Range3 Da;Range3 A"
_p_testa	= _p_testa + ";Range4 Da;Range4 A;Range5 Da;Range5 A;Range6 Da;Range6 A;Range7 Da;Range7 A"					
_p_tiporic	= "Cod.Vettore,1,Descrizione,2"
_p_nomeric	= "Ricerca Range Pesi dei Vettori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*!*	*****************************************************************************
*!*	PROCEDURE converice
*!*	*****************************************************************************
*!*	PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

*!*	_p_click 	= "ricerche\converice"																			
*!*	_p_alias	= "u_con_ve"																					
*!*	_p_campi	= "con_codvet;con_desvet;con_codnaz;con_codprv;con_desreg;con_pzrng1;con_pzrng2;con_pzrng3;con_pzrng4"
*!*	_p_campi	= _p_campi + ";con_pzrng5;con_pzrng6;con_pzrng7"
*!*	_p_testa	= "Cod.Vettore;Descr.Vettore;Naz.;Prov.;Regione;Prz.Range1;Prz.Range2;Prz.Range3;Prz.Range4"
*!*	_p_testa	= _p_testa + ";Prz.Range5;Prz.Range6;Prz.Range7"			
*!*	_p_tiporic	= "Cod.Vettore,1,Descr.Vettore,2,Nazione,3,Provincia,4,Regione,5"
*!*	_p_nomeric	= "Ricerca Contratti di Trasporto dei Vettori"																	

*!*	DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

*!*	RETURN

**=> ERASMO - INIZIO 07/10/2014
*****************************************************************************
PROCEDURE converice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\converice"																			
_p_alias	= "u_con_ve"																					
_p_campi	= "con_codvet;con_desvet;valida;valial"
_p_testa	= "Cod.Vettore;Descr.Vettore;Validità Dal;Validità Al"			
_p_tiporic	= "Cod.Vettore,1,Descr.Vettore,2,Nazione,3,Provincia,4,Regione,5"
_p_nomeric	= "Ricerca Contratti di Trasporto dei Vettori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN
**=> ERASMO - FINE 07/10/2014

*****************************************************************************
PROCEDURE parrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\parrice"																			
_p_alias	= "u_par_ct"																					
_p_campi	= "par_codnaz;par_desnaz;par_zona;par_tiptra;par_destra;par_przita;par_prze01;par_prze02"
_p_campi	= _p_campi + ";par_prze03;par_prze04;par_prze05;par_prze06;par_prze07;par_prze08;par_prze09"
_p_campi	= _p_campi + ";par_prze10;par_prze11;par_prze12;par_prze13;par_prze14"
_p_testa	= "Cod.Nazione;Descr.Nazione;Zona;Tipo Trasp.;Descr.Trasp.;Prz.Unico;Prz.Estero 1;Prz.Estero 2"
_p_testa	= _p_testa + ";Prz.Estero 3;Prz.Estero 4;Prz.Estero 5;Prz.Estero 6;Prz.Estero 7;Prz.Estero 8;Prz.Estero 9"			
_p_testa	= _p_testa + ";Prz.Estero 10;Prz.Estero 11;Prz.Estero 12;Prz.Estero 13;Prz.Estero 14"			
_p_tiporic	= "Cod.Nazione,1,Descr.Nazione,2,Zona,3,Tipo Trasp.,4,Descr.Trasp.,5"
_p_nomeric	= "Ricerca Parametri Costo di Trasporto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE camprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\camprice"																			
_p_alias	= "u_cmp_cl"																					
_p_campi	= "cmp_numcmp;cmp_datarr;cmp_ragsoc;cmp_desage;cmp_artnum;cmp_altezz;cmp_lunghe"
_p_testa	= "N°Camp.;Data arrivo;Cliente;Agente;Articolo;Altezza;Lunghezza"		
_p_tiporic	= "N°Campionatura,1,Data arrivo,2,Cliente,3,Agente,4,Da Analizzare Superfici,5,Analizzato Superfici,6,"
_p_tiporic	= _p_tiporic + "Senza disp.lotti(Cliente),7,Senza disp.lotti(Agente),8,Con disp.lotti,9,Da risp.Campionatura,10,Risposta Campionatura,11,Articolo,12"
_p_nomeric	= "Ricerca Campionature"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE manrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\manrice"																			
_p_alias	= "u_man_co"																					
_p_campi	= "man_alteda;man_alteal;man_lungda;man_lungal;man_spesda;man_spesal;man_codper;man_codman;man_desman"
_p_testa	= "Altezza Da;Altezza A;Lunghezza Da;Lunghezza A;Spessore Da;Spessore A;Cod.Personal.;Cod.Mandrino;Descr.Mandrino"		
_p_tiporic	= "Altezza Da,1,Lunghezza Da,2,Spessore Da,3,Cod.Personal.,4,Cod.Mandrino,5,Descr.Mandrino,6"
_p_nomeric	= "Ricerca Mandrini"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE scorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\scorice"																			
_p_alias	= "u_sco_mi"																					
_p_campi	= "sco_codart;sco_altezz;sco_lunghe;sco_numbob;sco_scormi"
_p_testa	= "Articolo;Altezza;Lunghezza;Nr.Bobine;Scorta min."		
_p_tiporic	= "Altezza,1,Lunghezza,2,Scorta min.,3"
_p_nomeric	= "Ricerca Scorte Minime"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE regiorice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\regiorice"																			
_p_alias	= "regioni"																					
_p_campi	= "codice;regione"
_p_testa	= "Cod.Regione;Descr.Regione"
_p_tiporic	= "Cod.Regione,1,Descr.Regione,2"
_p_nomeric	= "Ricerca Regioni"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE operice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\operice"																					 && nome della procedura con istruzioni sql
_p_alias	= "res_oper_conf"																						 && nome del cursore in cui memorizzare i dati
_p_campi	= "ope_codice;ope_descri;ope_blkprz;ope_novprz"															 && elenco dei campi da visializzare
_p_testa	= "Codice;Descrizione;Blocco prz. in order entry;No vis. prz. in di.ba."								 && intestazione dei campi da visualizzare
_p_tiporic	= "Codice,1,Descrizione,2"																				 && elenco delle ricerche della combo box
_p_nomeric	= "Ricerca configurazioni utente"																			 && descrizione della ricerca

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE pkgrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pkgrice"																			
_p_alias	= "cu_pkg_tt"																					

_p_campi	= "pkg_numpkg;pkg_datpkg;pkg_numprb;pkg_codcli;pkg_ragsoc;pkg_destin;pkg_codart;pkg_desart;pkg_unitam;pkg_qtaimp;pkg_qtagev;pkg_qtadev;pkg_sc_pkg;pkg_numord;pkg_datord;pkg_datcon;pkg_qtaord;pkg_qtaeva;pkg_qtapkg;pkg_sc_ord"
_p_testa	= "Nr.Pick.;Data;Nr.Prebolla;Cliente;Ragione sociale;Destinazione;Articolo;Descrizione;U.m.;Qtà.Impegnata;Qtà.già.in.ddt;Qtà.da.conf.in.ddt.;S/C pick.;Nr.Ordine;Data Ord.;Data Scad.;Qtà.Ordinata;Qtà.evasa;Qta.in.Pick.;S/C ord."
_p_tiporic	= "Nr.Picking,1,Data Picking(gg/mm/aaaa),2,Nr.Prebolla,3,Codice cliente,4,Rag. Sociale,5,Destinazione,6,Articolo,7,S/C pick.,8"
_p_nomeric	= "Ricerca ordine cliente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE pkgrice_noall
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\pkgrice_noall"																			
_p_alias	= "cu_pkg_tt"																					

_p_campi	= "pkg_numpkg;pkg_datpkg;pkg_numprb;pkg_codcli;pkg_ragsoc;pkg_destin;pkg_codart;pkg_desart;pkg_unitam;pkg_qtaimp;pkg_qtagev;pkg_qtadev;pkg_sc_pkg;pkg_numord;pkg_datord;pkg_datcon;pkg_qtaord;pkg_qtaeva;pkg_qtapkg;pkg_sc_ord"
_p_testa	= "Nr.Pick.;Data;Nr.Prebolla;Cliente;Ragione sociale;Destinazione;Articolo;Descrizione;U.m.;Qtà.Impegnata;Qtà.già.in.ddt;Qtà.da.conf.in.ddt.;S/C pick.;Nr.Ordine;Data Ord.;Data Scad.;Qtà.Ordinata;Qtà.evasa;Qta.in.Pick.;S/C ord."
_p_tiporic	= "Nr.Picking,1,Data Picking(gg/mm/aaaa),2,Nr.Prebolla,3,Codice cliente,4,Rag. Sociale,5,Destinazione,6,Articolo,7,S/C pick.,8"
_p_nomeric	= "Ricerca ordine cliente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE casrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\casrice"																			
_p_alias	= "cu_cas_tt"																					
_p_campi	= "cas_numsca;cas_numsch;cas_datsca;cas_codmag;cas_fila_x;cas_pian_x;cas_ubic_x;cas_codcli;"+;
			  "cas_ragsoc;cas_codloc;cas_codcco;cas_coddoc;cas_desdoc;cas_codope;cas_datfin"
_p_testa	= "N.scatola;N.scheda;Data reg.;Mag.;Fila;Piano;Ubicaz.;Cliente;Ragione Sociale;Filiale/ufficio;"+;
			  "Centro di costo;Tipo documento;Descrizione;Archiviata da;Fino al"
_p_tiporic	= "Numero scatola,1"
_p_nomeric	= "Ricerca cartelle sanitarie"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE matrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\matrice"																			
_p_alias	= "cu_cas_an"																					
_p_campi	= "cas_matric;cas_cognom;cas_nome;cas_codloc;cas_desloc"
_p_testa	= "Cod.Matricola;Cognome;Nome;Cod.Filiale;Descr.Filiale"
_p_tiporic	= "Cod.Matricola,1,Cognome,2,Nome,3"
_p_nomeric	= "Ricerca Matricole"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN



*****************************************************************************
PROCEDURE lislirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\lislirice"																			
_p_alias	= "cu_lis_li"																					
_p_campi	= "lis_codcli;lis_coddes;lis_linart;lis_lindes;lis_codart;lis_desart;lis_sc1;lis_sc2;lis_sc3;lis_pr1"					
_p_testa	= "Cliente;Ragione sociale;Linea;Descrizione;Articolo;Descrizione;Sc 1;Sc 2;Sc 3;Prov."					
*_p_tiporic	= "Codice cliente,1,Codice linea,2,Codice articolo,3,Data listino (gg/mm/aaaa),4"
_p_tiporic	= "Codice cliente,1,Ragione sociale,2,Codice linea,3,Codice articolo,4,Data listino (gg/mm/aaaa),5"  && ERASMO - 06/11/2017
_p_nomeric	= "Ricerca listini per cliente/linea/articolo"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE prvagliscrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\prvagliscrice"																			
_p_alias	= "cu_prv_al"																					
_p_campi	= "prv_codage;prv_desage;prv_codlin;prv_deslin;prv_sco_da;prv_sco_al;prv_provvi"					
_p_testa	= "Agente;Descrizione;Linea;Descrizione;Sc.da;Sc.al;Prov."					
_p_tiporic	= "Codice agente,1,Codice linea,2"
_p_nomeric	= "Ricerca provvigioni per agente/linea/sconto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE BUDRICEAM
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\budriceam"																			
_p_alias	= "CU_BUD_AM"																					
_p_campi	= "bud_codart;bud_desart;bud_um;bud_codmat;bud_linea;bud_serie;bud_anno;bud_mese;bud_quanti;bud_przmed;bud_valore"					
_p_testa	= "Cod.Art.;Descr.Art.;UM;Cod.Mat;Linea;Serie;Anno;Mese;Quantità;Prz.Medio;Valore"	
_p_tiporic	= "Cod.Art.,1,Anno,2,Mese,3"
_p_nomeric	= "Ricerca Budget"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE concarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\concarice"																			
_p_alias	= "u_con_ca"																					
_p_campi	= "con_codvet;con_desvet;con_codnaz;con_codprv;con_desreg"
_p_testa	= "Cod.Vettore;Descr.Vettore;Naz.;Prov.;Regione"
_p_tiporic	= "Cod.Vettore,1,Descr.Vettore,2,Nazione,3,Provincia,4,Regione,5"
_p_nomeric	= "Ricerca Contratti di Trasporto dei Vettori"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***fb***********************************************************************
PROCEDURE MPArice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\MPArice"																			
_p_alias	= "cu_MPA_cq"
_p_campi= "MPA_RESPO1;MPA_RESPO2;MPA_CODMAG;MPA_DESMAG;MPA_CODART;MPA_DESART;MPA_CODFOR;MPA_DESFOR;MPA_NUMORF;MPA_DATORF;MPA_DTCAMA;MPA_NUMLOT;MPA_ANNLOT;"
_p_campi=_p_campi+ "MPA_DTCACQ;MPA_ORCACQ;MPA_CODOPE;MPA_ASPETT;MPA_COLORE;MPA_PH_V;MPA_PH_R;MPA_VISC_V;MPA_VISC_R;"
_p_campi=_p_campi+ "MPA_RESE_V;MPA_RESE_R;MPA_PESP_V;MPA_PESP_R;MPA_RESDT1;MPA_RESOR1;MPA_RESDT2;MPA_RESOR2;MPA_CARTDA;MPA_CARTAL"
_p_testa="I Resp.;II Resp.;Cod.Mag.;Desc.Mag;Cod.Art.;Desc.Art;Cod. Fornitore; Desc.Fornitore; Num.Ord.Forn.;Data Ord.For;Data Car.Maga;Num Lotto;Anno Lotto;"
_p_testa=_p_testa+"Data C.Q.;Ora C.Q.;C.O.;Aspetto;Colore;PH Valore;PH R.;Viscosità;Visc.R;"
_p_testa=_p_testa+"Residuo Secco;Resp.R.S.;Peso Spec.; P.S.Resp;Data I R;Ora I R;Data II Resp;Ora II R;Da articolo; A articolo" 
																					
_p_tiporic	= "Codice componente,1,Descrizione componente,2,Ragione sociale fornitore,3,Num. ordine fornitore,4,"
_p_tiporic	=_p_tiporic	+"Data ordine fornitore,5,Data carico magazzino,6,Num.lotto,7,Data carico in CQ,8,Primo responso,9,Data primo responso,10,Secondo responso,11,Data secondo responso,12,Nr.Lotto Int.,13"
_p_nomeric	= "Ricerca analisi materie prime adesivi"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***fb***********************************************************************
PROCEDURE MPFrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\MPFrice"																			
_p_alias	= "cu_MPF_cq"
_P_campi= "MPF_RESPO1;MPF_RESPO2;MPF_CODMAG;MPF_DESMAG;MPF_CODART;MPF_DESART;MPF_CODFOR;MPF_DESFOR"
_P_campi=_P_campi+ ";MPF_NUMORF;MPF_DATORF;MPF_DTCAMA;MPF_NUMLOT;MPF_ANNLOT;MPF_DTCACQ;MPF_ORCACQ"
_P_campi=_P_campi+ ";MPF_CODOPE;MPF_ASPETT;MPF_COLORE;MPF_ALTEZZ;MPF_LUNGHE;MPF_SPESSO;MPF_CODCOL"
_P_campi=_P_campi+ ";MPF_DESCOL;MPF_CDCOLR;MPF_DSCOLR;MPF_ELATRA;MPF_ELALON;MPF_PROIMB;MPF_TRATTA"
_P_campi=_P_campi+ ";MPF_PRSC_V;MPF_PRSC_R;MPF_SPES_V;MPF_SPES_R;MPF_ALTE_V;MPF_ALTE_R"
_P_campi=_P_campi+ ";MPF_RESDT1;MPF_RESOR1;MPF_RESDT2;MPF_RESOR2;MPF_CARTDA;MPF_CARTAL"
_P_testa="I Resp;II Resp;Cod.Mag.;Descr.Mag;Codice Film Nudo;Descrizione Film Nudo;Cod. Fornitore;Descr.Fornitore"
_P_testa=_P_testa+";Num.Ord.Forn.;Data Ord.For;Data Car.Mag.;Num Lotto;Anno Lotto;Dt.Car.CQ;Ora Car.CQ"
_P_testa=_P_testa+";C.O.;Aspetto;Colore;Altezza;Lunghezza;Spessore;Col.Origin."
_P_testa=_P_testa+";Descr.Col.Orig.;Colore Ril.;Descr.Col.Ril.;All.Rott.Tras.;All.Rott.Long.;Imbutitura;Trattam."
_P_testa=_P_testa+";Prove Scoppio;Resp.Pr.Scopp.;Spessore Ril.;Resp.Spess.Ril.;Altezza Ril.;Resp.Alt.Ril."
_P_testa=_P_testa+";Data I R;Ora I R;Data II Resp;Ora II R;Da articolo;A articolo"
_p_tiporic="Codice Film Nudo,1,Descrizione Film Nudo,2,Ragione sociale fornitore,3,Num. ordine fornitore,4,Data ordine fornitore,5,Data carico magazzino,6,"
_p_tiporic	=_p_tiporic	+"Num. lotto interno,7,Data carico in CQ,8,Primo responso,9,Data primo responso,10,Secondo responso,11,Data secondo responso,12,Nr.Lotto Int.,13,Spessore Film Nudo,14,Altezza Film Nudo,15"
_p_nomeric	= "Ricerca analisi materie prime film nudo"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***fb***********************************************************************
PROCEDURE SLFrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\slFrice"																			
_p_alias	= "cu_SLF_cq"
_P_campi= "SLF_RESPO1;SLF_RESPO2;SLF_CODMAG;SLF_DESMAG;SLF_CODART;SLF_DESART;SLF_CODPAR;SLF_DESPAR"
_P_campi=_P_campi+ ";SLF_NUMLOT;SLF_ANNLOT;SLF_DATPRO;SLF_DTCACQ;SLF_ORCACQ"
_P_campi=_P_campi+ ";SLF_CODOPE;SLF_CILIND;SLF_FNCDCO;SLF_FNDSCO;SLF_FNCDFO"
_P_campi=_P_campi+ ";SLF_FNDSFO;SLF_FNNULO;SLF_FNANLO;SLF_CODCLI;SLF_DESCLI"
_P_campi=_P_campi+ ";SLF_LA1PHV;SLF_LA1PHR;SLF_LA1VIV;SLF_LA1VIR;SLF_LA2PHV"
_P_campi=_P_campi+ ";SLF_LA2PHR;SLF_LA2VIV;SLF_LA2VIR;SLF_LA3PHV;SLF_LA3PHR"
_P_campi=_P_campi+ ";SLF_LA3VIV;SLF_LA3VIR;SLF_LA4PHV;SLF_LA4PHR;SLF_LA4VIV"
_P_campi=_P_campi+ ";SLF_LA4VIR;SLF_ADPH_V;SLF_ADPH_R;SLF_ADVI_V;SLF_ADVI_R"
_P_campi=_P_campi+ ";SLF_ADRS_V;SLF_ADRS_R;SLF_FSASPE;SLF_FSAI_V;SLF_FSAI_R"
_P_campi=_P_campi+ ";SLF_FSFFIN;SLF_FSANIN;SLF_FSGR_V;SLF_FSGR_R;SLF_FSSPES"
_P_campi=_P_campi+ ";SLF_FSSP_V;SLF_FSRESI;SLF_C3ANCO;SLF_C3RESI;SLF_C7AA_V"
_P_campi=_P_campi+ ";SLF_C7AA_R;SLF_C7AL_V;SLF_C7AL_R;SLF_RESDT1"
_P_campi=_P_campi+ ";SLF_RESOR1;SLF_RESDT2;SLF_RESOR2;SLF_CARTDA"
_P_campi=_P_campi+ ";SLF_CARTAL;SLF_NOTE"
_P_testa="Resp I;Resp II;Codice magazziono;Magazzino;Codice film spalmato;Descrizione;Codice parametro;Descrizione parametro"
_P_testa=_P_testa+";Lotto produzione;Anno lotto;data produzine;Data carico C.Q.;Ora C.Q."
_P_testa=_P_testa+";Operatore;Cilindro;Cod. Colore FN;Des. Colore FN;Cod. forn. FN"
_P_testa=_P_testa+";Des. Forn. FN;Lotto FN;Anno lotto FN;Codice Cliente;Derscrizione cliente"
_P_testa=_P_testa+";Latt. 1 PH;1ph;Latt. 1 visc.;1visc;Latt. 2 PH"
_P_testa=_P_testa+";2ph;Latt. 2 visc.;2visc;Latt. 3 PH;3ph"
_P_testa=_P_testa+";Latt. 3 Visc;3visc;Latt. 4 PH;4ph;Latt. 4 Visc"
_P_testa=_P_testa+";4visc;Ad PH;PH;Ad visc;visc"
_P_testa=_P_testa+";Res.sec;RS;Asp;Ad in.V;Ad.in.R"
_P_testa=_P_testa+";FF inz;Anc.Ini;Gram.V;Gram.R;Spes"
_P_testa=_P_testa+";Sp v;Res.;Ancor;Res Cont. 3;AALuc."
_P_testa=_P_testa+";AALuc. C. R;ALLuc v;ALLuc r;Dt rep I"
_P_testa=_P_testa+";Ora Resp I;Dt Resp II;Ora Resp II;Da codic"
_P_testa=_P_testa+";Al cod;Note"
_p_tiporic="Codice Film spalmato,1,Descrizione Film spalmato,2,Num. lotto di produzione,3,Ragione sociale fornitore,4,Num. lotto di carico,5,"
_p_tiporic=_p_tiporic+ "Ragione sociale cliente,6,Data carico in CQ,7,Primo responso,8,Data primo responso,9,Secondo responso,10,Data secondo responso,11,Nr.Lotto Int.,12"
_p_nomeric	= "Ricerca analisi materie semi lavorato film spalmato"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE cerrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\cerrice"																			
_p_alias	= "u_cer_co"																					
_p_campi	= "cer_numddt;cer_datddt;cer_ragsoc;cer_codart;cer_nrlint;cer_tipprg;cer_numprg;cer_amgprg;cer_progre"
_p_testa	= "Num.DDT;Data DDT;Rag.Soc.Cliente;Articolo;Num.lotto;Tipo Prg.;Num.Prg.;Data Prg.;Progressivo"
_p_tiporic	= "Num.DDT,1,Data DDT(gg/mm/aaaa),2,Rag.Soc.Cliente,3,Articolo,4,Num.lotto,5,Tipo Prg.,6,Num.Prg.,7,Dt.Prg.(gg/mm/aaaa),8"
_p_nomeric	= "Ricerca Certificati di conformità"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE ammcatrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ammcatrice"																			
_p_alias	= "u_amm_ca"																					
_p_campi	= "amm_codamm;amm_descr1;amm_descr2;amm_descr3;amm_peramm;amm_contab;amm_conpar"
_p_testa	= "Codice;Descrizione 1;Descrizione 2;Descrizione 3;Perc.amm.base;Conto contabile;Controp.contabile;"
_p_tiporic	= "Codice,1,Descrizione 1,2,Perc.amm.base,3,Conto contabile,4,Controp.contabile,5"
_p_nomeric	= "Ricerca categorie beni durevoli"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************
PROCEDURE ammcesrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ammcesrice"																			
_p_alias	= "u_amm_at"																					
_p_campi	= "amm_codces;amm_descri;amm_codcat;amm_tipcat;amm_flguso;amm_flgnew;amm_datuti"
_p_testa	= "Codice;Descrizione;Categ.apparten.;Tipo categ.;Flag uso prom.;Flag nuovo/usato;Data utilizzo"
_p_tiporic	= "Codice,1,Descrizione 1,2,Categ.apparten.,3,Tipo categ.,4,Flag nuovo/usato,5"
_p_nomeric	= "Ricerca anagrafica cespiti"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE aggancrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\aggancrice"				&& nome della procedura con istruzioni sql
_p_alias	= "cu_para"							&& nome del cursore in cui memorizzare i dati
_p_campi	= "codi;descri;libe"				&& elenco dei campi da visualizzare
_p_testa	= "Cod.;Descrizione;Aggancio"     && impostazione dei campi da visualizzare
_p_tiporic	= "Codice,1,Descrizione,2"			&& elenco delle ricerche della combo box
_p_nomeric	= "Ricerca parametri aggancio"		&& descrizione della ricerca

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE conantrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\conantrice"																			
_p_alias	= "cu_anf_tt"																					
_p_campi	= "ric_codcli;ric_ragsoc;ric_nfatt;ric_dtfatt;ric_dtscad;ric_totfat;ric_tranc"					
_p_testa	= "Cod.cliente;Ragione Sociale;Num.Fatt.;Data Fatt.;Data Scad.;Tot.documento;Tot.rata"					
_p_tiporic	= "Codice cliente,1,Ragione Sociale,2,Numero fattura,3"
_p_nomeric	= "Ricerca gestione conti anticipo estero"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE anaazirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\anaazirice"																			
_p_alias	= "anaazi"																					
_p_campi	= "B_Client;Codice;RagSoc;Acronimo;Indiriz;ComuneInd;Cap;Piva;CdFisc;Email;Telefono"
_p_testa	= "Tipo Cli./For.;Codice;Ragione Sociale;Acronimo;Indirizzo;Comune;Cap;P.Iva;Cod.Fiscale;E-mail;Telefono"
_p_tiporic	= "Tipo Cli./For.,1,Codice,2,Ragione Sociale,3,Acronimo,4,Comune,5,Telefono,6"
_p_nomeric	= "Ricerca anagrafica clienti/fornitori Omega"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*!*	*****************************************************************************
*!*	PROCEDURE risumanarice
*!*	*****************************************************************************
*!*	PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

*!*	_p_click 	= "ricerche\risumanarice"																			
*!*	_p_alias	= "risumana"																					
*!*	_p_campi	= "Codice;Cognome;Nome;Sigla;Sesso;CodFiscale;PartitaIva;LocNascita;D_Nascita;EMail"
*!*	_p_testa	= "Codice;Cognome;Nome;Sigla;Sesso;Cod.Fiscale;Part.Iva;Loc.Nascita;Data Nascita;E-mail"
*!*	_p_tiporic	= "Codice,1,Cognome,2,Nome,3,Sigla,4,Sesso,5,Loc.Nascita,6"
*!*	_p_nomeric	= "Ricerca anagrafica Risorse umane Omega"

*!*	DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

*!*	RETURN

*!*	*****************************************************************************


*****************************************************************************
PROCEDURE commessarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\commessarice"																			
_p_alias	= "commessa_tt"																					
_p_campi	= "Codice;R_Data;C_Chiusa;RAGSOC_F;DESSOGG_C;Titolo_STR;C_Interna;R_Inizio;R_Fine;CentrCom;CentrComP;TrattCom;D_TrattCom;AreaMerc;ClassTC"
_p_testa	= "Codice;Data;Stato;Cliente per fatt.;1° Risorsa;Titolo;Tipo;Data Inizio;Data Fine;C.comp.;C.comp.P.;Trattativa comm.;Data tr.com.;Area merc.;Classif."  && ERASMO - 08/02/2011
_p_tiporic	= "Cliente (Rag.soc.),1,Risorsa,2,Codice,3,Data (gg/mm/aaaa),4,Tipo(Int.=1/Est.=2),5,Aperta/Chiusa (A/C),6"
_p_nomeric	= "Ricerca anagrafica Commesse"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE timeshtrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\timeshtrice"																			
_p_alias	= "timesht"																					
_p_campi	= "IDTimeSht;IDRisUmana;D_Data;Minuti;Ore;FlgFatt;B_Bloccato"
_p_testa	= "ID Time Sheet;ID Risorsa Umana;Data;Minuti;Ore;Fatturato;Bloccato"
_p_tiporic	= "ID Time Sheet,1,ID Risorsa Umana,2,Data,3,Fatturato (SI/NO),4"
_p_nomeric	= "Ricerca Time Sheet Omega"
		
DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE bdgrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bdgrice"																			
_p_alias	= "timesht"																					
_p_campi	= "BDG_ANNO;BDG_CODCLI;BDG_RAGSOC;BDG_CODNAZ;BDG_DESNAZ;BDG_UM;BDG_TIPART;BDG_QTATOT"
_p_testa	= "Anno;Cod.Cliente;Ragione sociale;Naz.;Descrizione Nazione;UM;Tipo;Quantità"
_p_tiporic	= "Codice cliente,1,Ragione sociale,2,Nazione,3"
_p_nomeric	= "Ricerca Budget annuale di vendita"
		
DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE ricemacrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\ricemacrice"																			
_p_alias	= "ricemac_tt"																					
_p_campi	= "CODICE;DATATARICE;PROGRICE;PRODOTTO;FASCIA;MATERIALE"
_p_testa	= "Codice;Data;Progressivo;Prodotto;Fascia;Materiale"
_p_tiporic	= "Codice/Data,1,Codice,2,Prodotto/Data,3,Fascia,4,Materiale,5"
_p_nomeric	= "Ricerca RICETTE MACCHINA per Spalmatrice"
	
DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE consaderice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\consaderice"																			
_p_alias	= "U_PRD_CT"																					
_p_campi	= "PTT_NUMPRG;PTT_DATGMA;PTT_CODADE;PTT_DESADE"
_p_testa	= "N°progr.;Data prg.;Codice adesivo;Descrizione adesivo"
_p_tiporic	= "Programma produzione,1,Data Programma,2,Codice adesivo,3"
_p_nomeric	= "Ricerca CONSUMO ADESIVI per programma di produzione"
	
DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE turnirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\turnirice"																			
_p_alias	= "TURNI_TT"																					
_p_campi	= "TUR_CODICE;TUR_DESCRI;DATINI;TUR_ORAINI;DATFIN;TUR_ORAFIN"
_p_testa	= "Cod.;Descrizione;Data inizio;Ora inizio;Data fine;Ora fine"
_p_tiporic	= "Codice,1,Data inizio turno,2,Data fine turno,3"
_p_nomeric	= "Ricerca TURNI DI LAVORO per la produzione"
	
DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE risumanarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\risumanarice"
_p_alias	= "RISUMANA"
*_p_campi	= "CODICE_SINT;COGNOME_SINT;NOME_SINT;SESSO_SINT;D_NASCITA_SINT;LOCRESIDENZ_SINT;LOCDOMICIL_SINT;TELMOBILE;EMAIL"
_p_campi	= "VIEW_CODICE;VIEW_COGNOME;VIEW_NOME;VIEW_SESSO;VIEW_D_NASCITA;VIEW_LOCRESIDENZ;VIEW_LOCDOMICIL;TELMOBILE;EMAIL"
_p_testa	= "Codice;Cognome;Nome;Sesso;Data Nascita;Località Residenza;Località Domicilio;Tel.mobile;E-mail aziendale"
_p_tiporic	= "Codice,1,Cognome,2,Nome,3,Sesso (M/F),4,Data Nascita Dal,5,Data Nascita Al,6,Località Residenza,7,Località Domicilio,8"
_p_nomeric	= "Ricerca RISORSE UMANE"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE contrstudirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\contrstudirice"																			
_p_alias	= "contrstudi"																					
_p_campi	= "NUMERO;R_DATA;CODCLI;C_RAGSOC;C_DESATTIV;C_CHIUSO"
_p_testa	= "Numero;Data;Cod.Cliente;Rag.Sociale;1° Attività;A/C"
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Cod.Cliente,3,Rag.Sociale,4,Aperto/Chiuso (A/C),5"
_p_nomeric	= "Ricerca Contratti per studi professionali"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE attincrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\attincrice"															
_p_alias	= "ATTIVITANC"																					
_p_campi	= "CODCLI;STR_RAGSOC;CODATTIV;STR_DESATTIV;R_DATAINIZIO;R_DATAFINE;STR_XFATTURAZ;MESEXFATT;STR_FLGFATTURAB"
_p_testa	= "Cliente;Rag.sociale;C.Attiv.;Descrizione;Inizio;Fine;Per fatt.;Mese fatt.;In Fatturab."
_p_tiporic	= "Codice cliente,1,Ragione sociale,2,Codice attività,3,Descrizione attività,4,Mese fatt.(AAAA/MM),5"
_p_nomeric	= "Ricerca attivtà non concordate"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE  codiciclirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\codiciclirice"															
_p_alias	= "U_CLI_EX"																					
_p_campi	= "CODCLI_AQUARIUS;RAGSOC_AQUARIUS;CODCLI_ZUCCHETTI;CODCLI_SISPAC;CODCLI_COPERNICO"					
_p_testa	= "Ragione sociale aquarius;Codice aquarius;Codice zucchetti;Codice sispac;Codice copernico"					
_p_tiporic	= "Descrizione,1,Codice aquarius,2,Codice zucchetti,3,Codice sispac,4,Codice copernico,5"
_p_nomeric	= "Ricerca codici clienti da decodificare"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE costistudirice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\costistudirice"																			
_p_alias	= "COSTISTUDI"																					
_p_campi	= "CODRIS;DESRIS;N_COSTO;C_UMCOSTO"
_p_testa	= "Cod.Risorsa;Cognome e Nome;1° Costo;UM"
_p_tiporic	= "Cod.Risorsa,1,Cognome e/o Nome,2"
_p_nomeric	= "Ricerca Costi risorse umane per studi professionali"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************


*****************************************************************************
PROCEDURE aggconticommrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\aggconticommrice"																			
_p_alias	= "COMM_GROUP"																					
_p_campi	= "codice;DESCRI"					
_p_testa	= "Codice;Descrizione"					
_p_tiporic	= "Codice,1,Descrizione,2"
_p_nomeric	= "Ricerca aggregati conti commesse"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN
*****************************************************************************



*****************************************************************************
PROCEDURE budgetsintrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\budgetsintrice"																			
_p_alias	= "BUDGET_SINT_TT"																					
_p_campi	= "Codice;Titolo"					
_p_testa	= "Codice;Titolo"					
_p_tiporic	= "Codice,1,Titolo,2"
_p_nomeric	= "Ricerca budget sintetico"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN
*****************************************************************************



*****************************************************************************
PROCEDURE rdarice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\rdarice"																			
_p_alias	= "cu_rda_tt"																					
*!*	_p_campi	= "NUMERO;R_DATA;SUBSTR_DESRIC;D_FLGORF;D_FLGVIS1;STR_ESIVIS1;SUBSTR_MOTVIS1;D_FLGVIS2;STR_ESIVIS2;SUBSTR_MOTVIS2;D_FLGVIS3"
*!*	_p_testa	= "Numero;Data;Richiedente;Chiuso;Visto resp.acq.;Esito;Motivo;Visto resp.stab.;Esito;Motivo;Visto direzione"

_p_campi	= "NUMERO;R_DATA;SUBSTR_DESRIC;D_FLGORF;D_FLGVIS1;STR_ESIVIS1;SUBSTR_MOTVIS1;D_FLGVIS3;STR_ESIVIS3;SUBSTR_MOTVIS3;D_FLGVIS2"
_p_testa	= "Numero;Data;Richiedente;Chiuso;Visto resp.acq.;Esito;Motivo;Visto direzione.;Esito;Motivo;Visto resp.stab."

_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Richiedente,3"
_p_nomeric	= "Ricerca Richiesta di acquisto"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE bfprice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bfprice"																			
_p_alias	= "cu_bfo_tt"																					
_p_campi	= "ord_flgcon;ord_flgtra;ord_anomax;ord_numide;ord_numord;ord_dator2_r;ord_datord_r;ord_valimp;ord_valore;ord_codbun;ord_ragsoc;ord_codcco;ord_codcli"
_p_testa	= "Conf.;Trasm.;Anom.;N.ide.;N.doc.;Dt.doc.;Dt.reg.;Imponibile;Valore;B.Unit;Fornitore;C.costo;Cd.Forn."
_p_tiporic	= "Numero,1,Data reg.(gg/mm/aaaa),2,Ragione Sociale,3,Codice Fornitore,4,Buisness Unit,5,C. costo,6,Numero Identificativo,7"
_p_nomeric	= "Ricerca bolle di carico da fornitori con pesatura (solo causale " + PUB_BFP + ")"

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE bclrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\bclrice"																			
_p_alias	= "cu_bol_tt"																					
_p_campi	= "ord_numord;ord_datord_r;ord_age;ord_caus;ord_valore;ord_chiuso;ord_flgcon;ord_flgtra;ord_flbol;ord_itaexp;ord_mags;ord_codcli;ord_ragsoc;ord_locc;ord_riferi"
_p_testa	= "N.bolla;Dt.bolla;Age;Top;Valore;A/c;Conf.;Trasm.;Fatt.;Exp;Mag;Cliente;Ragione sociale;Località destinaz.;Riferimento"

_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Codice Agente,4,Codice Cliente,5,Località destinaz.,6,Riferimento,7"
_p_nomeric	= "Ricerca documenti di conto lavoro"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


*****************************************************************************
PROCEDURE sdsrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\sdsrice"																			
_p_alias	= "cu_scheda_sicurezza"																					
_p_campi	= "sds_codice;sds_version;sds_datasds;sds_linkdoc;sds_descsds"					
_p_testa	= "Progressivo;versione;scadenza;documento tecnito allegato;descrizione scheda"					
_p_tiporic	= "Codice (inizia per),1,Descrizione scheda sicurezza (contiene),2,Data scadenza,3"  
_p_nomeric	= "Ricerca delle schede di sicurezza/SDS"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

*****************************************************************************

*****************************************************************************
PROCEDURE mdbrice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\mdbrice"																			
_p_alias	= "cu_ord_tt"																					


_p_campi	= "ord_numord;ord_datord_r;ord_caus;ord_valore;ord_age;ord_chiuso_DD;ord_codope;ord_codcli;ord_ragsoc;ord_locc;des_tipologia"
_p_testa	= "Numero;Data;Caus.;Valore;Age;A/C;Ope;Cliente;Ragione sociale;Località destinaz.;Tipo documento"
_p_tiporic	= "Numero,1,Data (gg/mm/aaaa),2,Ragione Sociale,3,Agente,4,Cod.cliente,5,Località destinaz.,6,Causale,7,Codice tipo documento,8,Descrizione tipo documento,9"

_p_nomeric	= "Ricerca contratto cliente"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN

