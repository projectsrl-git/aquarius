**********************************************************
PROCEDURE CREA_BOBINE_DISPONIBILI
**********************************************************
	CREATE CURSOR BOBINE_DISPONIBILI (;
		MAG_CODART C(30),;
		MAG_ANAART C(30),;
		MAG_GIACEN N(17,2),;
		MAG_ALTEZZ N(7),;
		MAG_LUNGHE N(8),;
        MAG_QTAIMP N(12,2),;
        SELEZIONE C(3),;
		MAG_PRENOT L)
		
	INDEX ON STR_FILL_ZERO(MAG_ALTEZZ,8)+STR_FILL_ZERO(MAG_LUNGHE,8) DESC TAG MAG_ALTEZZ
		
* Fine - PROCEDURE CREA_BOBINE_DISPONIBILI
**********************************************************


**********************************************************
PROCEDURE CREA_CURPROD
**********************************************************
	CREATE CURSOR CURPROD (;
		ORDINE C(06),;
		DATORD C(10),;
		CODCLI C(10),;
		RAGCLI C(80),;
		DATACONS C(10),;
		GGEVAS  N(3),;
		PRODOTTO C(30),;
		DESART C(50),;
		QTA C(06),;
		UM C(2),;
		ALTEZZA C(06),;
		LUNGHEZZA C(06),;
        SPESSORE C(02),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10),;
		RIVALUTA L)
		
* Fine - PROCEDURE CREA_CURPROD
**********************************************************


**********************************************************
PROCEDURE CREA_CU_ORD
**********************************************************
	CREATE CURSOR CU_ORD (;
		ORDINE C(06),;
		DATORD C(10),;
		CODCLI C(10),;
		RAGCLI C(80),;
		DATACONS C(10),;
		GGEVAS  N(3),;
		PRODOTTO C(30),;
		DESART C(50),;
		QTA C(06),;
		UM C(2),;
		ALTEZZA C(06),;
		LUNGHEZZA C(06),;
        SPESSORE C(02),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10),;
		RIVALUTA L)
		
* Fine - PROCEDURE CU_ORD
**********************************************************
 
**********************************************************
PROCEDURE CREA_CU_SCO_MI
**********************************************************
	CREATE CURSOR CU_SCO_MI (;
		SCO_CODART C(30),;
		SCO_SUBSCO N(5),;
		SCO_ALTEZZ N(5),;
		SCO_LUNGHE N(5),;
        SCO_SPESSO N(5))
		
* Fine - PROCEDURE CREA_CU_SCO_MI
**********************************************************                      

**********************************************************
PROCEDURE CREA_PROGPROD
**********************************************************
	CREATE CURSOR PROGPROD (;
		NUMORD 	C(10),;
		DTCONS 	C(10),;
		RAGSOC	C(80),;
		CODCLI  C(10),;
		DATORD  C(10),;
		CODART  C(30),;
		CODINT  C(30),;
		DESART  C(50),;
		GGEVAS  N(3),;
		QTA		N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;	
		SPESS	N(5),;
		C_ALTEZZ C(5),;
		C_LUNGHE C(5),;
		C_SPESSO C(5),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10),;
		GIA_MESSO L)
		
	INDEX ON ORD_CODSYS TAG ORD_CODSYS
	INDEX ON ALTEZ TAG ALTEZ 
	INDEX ON ALTEZ TAG DISPONI FOR !GIA_MESSO
	INDEX ON C_SPESSO+C_ALTEZZ+C_LUNGHE TAG ROTOLI
                      
* Fine - PROCEDURE CREA_PROGPROD
**********************************************************


**********************************************************
PROCEDURE CREA_CURSORI_TAPPETO
**********************************************************

	CREATE CURSOR TUNING (;
		CUR_ROTOLI C(50),;
		CUR_BARRE  C(50),;
		NR_FASCE   C(5),;
		HMAX_FASCE C(5);
		)
	INDEX ON NR_FASCE+HMAX_FASCE DESC TAG TUNING
		
	CREATE CURSOR TAPPETO (;
		ID_ROTOLO C(20),;
		RAGSOC	C(80),;
		CODCLI  C(10),;
		NUMORD 	C(10),;
		DATORD  C(10),;
		GGEVAS  N(3),;
		DTCONS 	C(10),;
		DTPRPR  C(10),;
		DTCEFF  C(10),;
		GGDIFF  N(3),;
		MINUTI  N(10),;
		CODART  C(30),;
		CODINT  C(30),;
		DESART  C(50),;
		XCOORD0 N(5),;
		XCOORD1 N(5),;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;	
		YCOORD0 N(5),;
		CESTINO L,;
		SPESS	N(5),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10))
		
	INDEX ON ALTEZ TAG ALTEZ	
	INDEX ON SEZIONE TAG SEZIONE	
	INDEX ON ID_ROTOLO TAG ID_ROTOLO 

	CREATE CURSOR TAPRIBOB (;
		ID_ROTOLO C(20),;
		RAGSOC	C(80),;
		CODCLI  C(10),;
		NUMORD 	C(10),;
		DATORD  C(10),;
		GGEVAS  N(3),;
		DTCONS 	C(10),;
		DTPRPR  C(10),;
		DTCEFF  C(10),;
		GGDIFF  N(3),;
		MINUTI  N(10),;
		CODART  C(30),;
		CODINT  C(30),;
		DESART  C(50),;
		XCOORD0 N(5),;
		XCOORD1 N(5),;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;	
		YCOORD0 N(5),;
		CESTINO L,;
		SPESS	N(5),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10))
		
	INDEX ON ALTEZ TAG ALTEZ	
	INDEX ON SEZIONE TAG SEZIONE	
	INDEX ON ID_ROTOLO TAG ID_ROTOLO 
	
	CREATE CURSOR TAPPETO_TMP0 (; 
		ID_ROTOLO C(20),;
		RAGSOC	C(80),;
		CODCLI  C(10),;
		NUMORD 	C(10),;
		DATORD  C(10),;
		GGEVAS  N(3),;
		DTCONS 	C(10),;
		DTPRPR  C(10),;
		DTCEFF  C(10),;
		GGDIFF  N(3),;
		MINUTI  N(10),;
		CODART  C(30),;
		CODINT  C(30),;
		DESART  C(50),;
		XCOORD0 N(5),;
		XCOORD1 N(5),;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;	
		YCOORD0 N(5),;
		CESTINO L,;
		SPESS	N(5),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10))
		
	INDEX ON ALTEZ TAG ALTEZ	
	INDEX ON SEZIONE TAG SEZIONE	
	INDEX ON ID_ROTOLO TAG ID_ROTOLO 
	SELECT TAPPETO_TMP0
	
	CREATE CURSOR POP_ROTOLI (; 
		ID_ROTOLO C(20),;
		RAGSOC	C(80),;
		CODCLI  C(10),;
		NUMORD 	C(10),;
		DATORD  C(10),;
		GGEVAS  N(3),;
		DTCONS 	C(10),;
		DTPRPR  C(10),;
		DTCEFF  C(10),;
		GGDIFF  N(3),;
		MINUTI  N(10),;
		CODART  C(30),;
		CODINT  C(30),;
		DESART  C(50),;
		XCOORD0 N(5),;
		XCOORD1 N(5),;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;	
		YCOORD0 N(5),;
		CESTINO L,;
		SPESS	N(5),;
		GRP_PROD C(10),;
		MICROFORATO C(1),;
		ADESIVO C(30),;
		DESADE  C(50),;
		ORD_CODSYS C(10))
	
* FINE PROCEDURE CREA_CURSORI_TAPPETO
**********************************************************
	

**********************************************************
PROCEDURE CREA_SEZIONI
**********************************************************

	CREATE CURSOR SEZIONI (;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;
		SCARTO  N(5),;
		FLGMULTI L,;
		FLGVIEW  L,;
		SPALMARE L,;
		RIBOBI   L,;
		PATTERN C(254),;
		BOBINA  N(5),;
		CODINT  C(30),;
		GRP_PROD C(10),;
		NUMSEZRAGG N(5))
	INDEX ON SEZIONE TAG SEZIONE
	INDEX ON BOBINA*10000+SEZIONE TAG BOBINA
	INDEX ON LUNGH*10000+SEZIONE TAG LUNGH
	INDEX ON ALTEZ*10000+SEZIONE DESC TAG ALTEZ
	
	CREATE CURSOR SAVEBARRIB (;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;
		SCARTO  N(5),;
		FLGMULTI L,;
		FLGVIEW  L,;
		SPALMARE L,;
		RIBOBI   L,;
		PATTERN C(254),;
		BOBINA  N(5),;
		GRP_PROD C(10),;
		NUMSEZRAGG N(5))
	INDEX ON SEZIONE TAG SEZIONE
	INDEX ON BOBINA*10000+SEZIONE TAG BOBINA
	INDEX ON LUNGH+SEZIONE TAG LUNGH	
			
	
	CREATE CURSOR POP_BARRE (;
		SEZIONE	N(5),;
		ALTEZ	N(5),;
		LUNGH	N(5),;
		SCARTO  N(5),;
		FLGMULTI L,;
		FLGVIEW  L,;
		SPALMARE L,;
		RIBOBI   L,;
		PATTERN C(254),;
		BOBINA  N(5),;
		CODINT  C(30),;
		GRP_PROD C(10),;
		NUMSEZRAGG N(5))
		
			
	CREATE CURSOR CAMBI_BOBINA (;
		ID C(20),;
		BOBINA N(5),;
		ALTEZ  N(5),;
		LUNGH N(5),;
		SPESS N(5),;
		SEZINI N(5),;
		SEZFIN N(5),;
		QTA_ADESIVO N(17,6),;
		QTADGI N(17,6),;
		CODBOB C(30),;
		DESBOB C(50),;
		NUMBARRE N(5),;
		GRP_PROD C(10),;
		FLGVIEW  L)
	INDEX ON ID TAG ID
	INDEX ON BOBINA TAG BOBINA
	INDEX ON SEZFIN TAG SEZIONE

	CREATE CURSOR POP_BOBINE (;
		ID C(20),;
		BOBINA N(5),;
		ALTEZ  N(5),;
		LUNGH N(5),;
		SPESS N(5),;
		SEZINI N(5),;
		SEZFIN N(5),;
		QTA_ADESIVO N(17,6),;
		QTADGI N(17,6),;
		CODBOB C(30),;
		DESBOB C(50),;
		NUMBARRE N(5),;
		GRP_PROD C(10),;
		FLGVIEW  L)	
	
	SELECT CAMBI_BOBINA
	SET ORDER TO BOBINA

	CREATE CURSOR BARRERIB (;
		SEZIRIB	N(5),;
		SEZIONE	N(5),;
		GRP_PROD C(10),;
		ALTEZ   N(5),;
		LUNGH N(5),;
		ALTRIBO N(5),;
		LUNRIBO N(5))
	INDEX ON SEZIRIB TAG SEZIRIB
	INDEX ON SEZIONE TAG SEZIONE
	SET ORDER TO SEZIRIB


* Fine - PROCEDURE CREA_SEZIONI
**********************************************************

**********************************************************
PROCEDURE CREA_OGGETTI_NON_ROTOLI
**********************************************************

	CREATE CURSOR OGGETTI_NON_ROTOLI (;
		ID C(20))
	INDEX ON ID TAG ID
		
	
* Fine - PROCEDURE CREA_OGGETTI_NON_ROTOLI
**********************************************************

**********************************************************
PROCEDURE CREA_PRENOTA_MAGA
**********************************************************

	CREATE CURSOR PRENOTA_MAGA (;
		MAG_CODART C(30),;
		SEZIONE N(5))
	INDEX ON SEZIONE TAG SEZIONE
	INDEX ON MAG_CODART TAG MAG_CODART
	
* Fine - PROCEDURE CREA_PRENOTA_MAGA
**********************************************************




