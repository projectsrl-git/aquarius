
DO SETLIB

SET STEP ON 

_cTestoDaRicercare_ 	= "NASTRO"
_par_nSelezione_ 	    = "2"
_par_cTabSource1_   	= "U_ART_PR" 
_par_cNome_campo1a_     = "ART_CODPRI"
_par_cNome_campo1b_     = "ART_DESCR"

=CERCA_IN_TABELLE(_cTestoDaRicercare_,_par_nSelezione_,_par_cTabSource1_,_par_cNome_campo1a_,_par_cNome_campo1b_)
  
