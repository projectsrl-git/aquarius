PUBLIC scelta[5,2]
scelta[1,1]= 0
scelta[1,2]= 50
scelta[2,1]= 50
scelta[2,2]= 100
scelta[3,1]= 100
scelta[3,2]= 50
scelta[4,1]= 50
scelta[4,2]= 0
scelta[5,1]=0
scelta[5,2]=50

PUBLIC collegamento[5,2]
collegamento[1,1]= 25
collegamento[1,2]= 0
collegamento[2,1]= 100
collegamento[2,2]= 0
collegamento[3,1]= 75
collegamento[3,2]= 100
collegamento[4,1]= 0
collegamento[4,2]= 100
collegamento[5,1]=25
collegamento[5,2]=0

PUBLIC input_esterno[5,2]
input_esterno[1,1]= 0
input_esterno[1,2]= 0
input_esterno[2,1]= 100
input_esterno[2,2]= 0
input_esterno[3,1]= 75
input_esterno[3,2]= 100
input_esterno[4,1]= 25
input_esterno[4,2]= 100
input_esterno[5,1]=0
input_esterno[5,2]=0

PUBLIC pub_numero_blocchi,pub_top,pub_left,pub_altezza,pub_larghezza,pub_direzione,pub_descrizione_nodo


pub_numero_blocchi=0

pub_top=20
pub_left=20
pub_altezza=80
pub_larghezza=150

pub_direzione=0


pub_descrizione_nodo=""


DO FORM form\flw_step0_admin
