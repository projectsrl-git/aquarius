***********************
**  RICERCA CLIENTI  **
***********************
PARAMETERS W_VARRIT

PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric,_p_varrit

_p_click 	  = "ricerche\clirice_ric"
_p_alias	  = "cw_cli_an"
_p_campi  	  = "cli_codcli;cli_ragsoc;cli_indir;cli_cap;cli_locali;cli_age;descri;cli_pariva;cli_ricerc;cli_ragdue"
_p_testa	  = "Codice;Ragione sociale;Indirizzo;Cap;Località;Agente;Descr.agente;P.Iva;Ric.Alternativa;Seconda Rag.sociale"
_p_tiporic	  = "Codice,1,Rag.Sociale,2,Indirizzo,3,Cod.Agente,4,P.Iva,5,Ric.Alternativa,6"
_p_nomeric	  = "Ricerca anagrafica clienti"
_p_dimcolonne = "7;20;20;4;10;4;15;10;20;20"
_p_poscolonne = "2;0;0;2;0;2;0;0;0;0" && 0=sinistra;1=destra;2=centro
_p_varrit     = W_VARRIT

DO FORM form\ricerca_cli WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric,_p_dimcolonne,_p_poscolonne linked

RETURN
