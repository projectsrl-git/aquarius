
* -->> indici con filtro su pre-fatture
* ----------------------------------------------
RELEASE PBL_FAPTN,PBL_FAPTD,PBL_FAPRG,PBL_FAPAG,PBL_FAPTC,PBL_FAPNP
PUBLIC PBL_FAPTN,PBL_FAPTD,PBL_FAPRG,PBL_FAPAG,PBL_FAPTC,PBL_FAPNP

* -->> settaggi di default
* --------------------------
PBL_FAPTN="FAPTN"+PUB_ANNO
PBL_FAPTD="FAPTD"+PUB_ANNO
PBL_FAPRG="FAPRG"+PUB_ANNO
PBL_FAPAG="FAPAG"+PUB_ANNO
PBL_FAPTC="FAPTC"+PUB_ANNO
PBL_FAPNP="TNPROT"+PUB_ANNO

* ========================================================================================

* -->> indici con filtro su fatture
* ----------------------------------------------
RELEASE PBL_FATTN,PBL_FATTD,PBL_FATRG,PBL_FATAG,PBL_FATTC,PBL_FATNP
PUBLIC PBL_FATTN,PBL_FATTD,PBL_FATRG,PBL_FATAG,PBL_FATTC,PBL_FATNP

* -->> settaggi di default
* --------------------------
PBL_FATTN="FATTN"+PUB_ANNO
PBL_FATTD="FATTD"+PUB_ANNO
PBL_FATRG="FATRG"+PUB_ANNO
PBL_FATAG="FATAG"+PUB_ANNO
PBL_FATTC="FATTC"+PUB_ANNO
PBL_FATNP="TNPROT"+PUB_ANNO

* ========================================================================================

* -->> indici con filtro su indice contabilità generale
* ----------------------------------------------
RELEASE PBL_NREGI,PBL_DESCR,PBL_DTREG,PBL_CONTO,PBL_NDOCU,PBL_NPROT,PBL_NANNO
PUBLIC PBL_NREGI,PBL_DESCR,PBL_DTREG,PBL_CONTO,PBL_NDOCU,PBL_NPROT,PBL_NANNO

* -->> settaggi di default
* --------------------------
PBL_NREGI="NREGI"+PUB_ANNO
PBL_DESCR="DESCR"+PUB_ANNO
PBL_DTREG="DTREG"+PUB_ANNO
PBL_CONTO="CONTO"+PUB_ANNO
PBL_NDOCU="NDOCU"+PUB_ANNO
PBL_NPROT="NPROT"+PUB_ANNO
PBL_NANNO="NANNO"+PUB_ANNO

