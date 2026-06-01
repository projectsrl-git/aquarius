*************************
**  RICERCA FORNITORI  **
*************************
PARAMETERS W_VARRIT

PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric,_p_varrit

_p_click 	  = "ricerche\forrice_ric"
_p_alias	  = "cw_for_an"
_p_campi  	  = "for_codcli;for_ragsoc;for_indir;for_cap;for_locali;for_pariva;for_ricerc;for_ragdue"
_p_testa	  = "Codice;Ragione sociale;Indirizzo;Cap;Località;P.Iva;Ric.Alternativa;Seconda Rag.sociale"
_p_tiporic	  = "Codice,1,Rag.Sociale,2,Indirizzo,3,P.Iva,4,Ric.Alternativa,5"
_p_nomeric	  = "Ricerca anagrafica fornitori"
_p_dimcolonne = "7;20;20;4;10;8;15;20"
_p_poscolonne = "2;0;0;2;0;2;0;0" && 0=sinistra;1=destra;2=centro
_p_varrit     = W_VARRIT

DO FORM form\ricerca_for WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric,_p_dimcolonne,_p_poscolonne linked

RETURN
