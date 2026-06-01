***********************
**  RICERCA ARTICOLI **
***********************

PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	  = "ricerche\artrice3_ecash"
_p_alias	  = "cu_art_pr"
_p_campi  	  = "art_descr;art_autore;art_desedi;mag_gianul;art_przven;mag_codmag;art_datins;art_descoa;art_catago;art_argome;art_deslin;art_cdisbn;art_codpri"
_p_testa	  = "Titolo;Autore;Editore;Giacenza;Prezzo;Magazzino;Data;Collana;Categoria;Notizia;Linea;Codice ISBN;Codice Articolo"
_p_tiporic	  = "Titolo,1,Autore,2,Editore,3,Collana,4,Categoria,5,Notizia,6,Codice,7"
_p_nomeric	  = "Ricerca anagrafica articoli"
_p_dimcolonne = "20;20;20;10;10;10;9;20;20;20;20;10;16"
_p_poscolonne = "0;0;0;1;1;2;2;0;0;0;0;0;0" && 0=sinistra;1=destra;2=centro

DO FORM form\ricerca4_ecash WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric,_p_dimcolonne,_p_poscolonne linked

RETURN