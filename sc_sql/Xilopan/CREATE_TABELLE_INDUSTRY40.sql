/*
Tabella ordine_produzione_eseguito (da sistema Industry4 a gestionale, verrà scritta una riga al termine di ogni produzione)
- dataora: DATETIME
- identificativo: STRING
- nomericetta: STRING
- percentuale_truciolo: REAL
- percentuale_sfogliato: REAL
- percentuale_raffinato: REAL
- percentuale_riciclato: REAL
- portata_totale_lavorazione: REAL
- set_pressione_mandata_mmH2O_linea20: REAL
- set_pressione_mandata_mmH2O_linea10_30_40: REAL
- set_velocita_mulino_3_Hz: REAL
- set_velocita_mulino_4_Hz: REAL
- set_velocita_mulino_5_Hz: REAL
*/
CREATE TABLE dbo.ordine_produzione_eseguito (
	dataora DATETIME null,
	identificativo varchar null,
	nomericetta varchar null,
	percentuale_truciolo REAL null,
	percentuale_sfogliato REAL null,
	percentuale_raffinato REAL null,
	percentuale_riciclato REAL null,
	portata_totale_lavorazione REAL null,
	set_pressione_mandata_mmH2O_linea20 REAL null,
	set_pressione_mandata_mmH2O_linea10_30_40 REAL null,
	set_velocita_mulino_3_Hz REAL null,
	set_velocita_mulino_4_Hz REAL null,
	set_velocita_mulino_5_Hz REAL null
)
go


/*
Tabella report_essiccatoio (da sistema Industry4 a gestionale, verrà scritta una riga a cadenza programmate, es: ogni minuto)
- dataora: DATETIME
- totalizzatore_mc_truciolato: REAL
- totalizzatore_mc_sfogliato: REAL
- totalizzatore_mc_chip_raffinato: REAL
- totalizzatore_mc_riciclato: REAL
- gas_bruciato_gcal: REAL
- totalizzatore_polverino_axis: REAL
*/
CREATE TABLE dbo.report_essiccatoio (
	dataora DATETIME null,
	totalizzatore_mc_truciolato REAL null,
	totalizzatore_mc_sfogliato REAL null,
	totalizzatore_mc_chip_raffinato REAL null,
	totalizzatore_mc_riciclato REAL null,
	gas_bruciato_gcal REAL null,
	totalizzatore_polverino_axis REAL null
)
go


/*
Tabella report_linea20 (da sistema Industry4 a gestionale, verrà scritta una riga a cadenza programmata, es: ogni minuto)
- dataora: DATETIME
- polverosita: REAL
- delta_press_sottostazione_mmH20: REAL
- temperatura_sottostazione: REAL
- pressione_linea_aspirazione_mmH20: REAL
- corrente_motore_M1: REAL
- corrente_motore_M6: REAL
*/
CREATE TABLE dbo.report_linea20 (
	dataora DATETIME null,
	polverosita REAL null,
	delta_press_sottostazione_mmH20 REAL null,
	temperatura_sottostazione REAL null,
	pressione_linea_aspirazione_mmH20 REAL null,
	corrente_motore_M1 REAL null,
	corrente_motore_M6 REAL null
)
go


/*
Tabella report_linea10_30_40 (da sistema Industry4 a gestionale, verrà scritta una riga a cadenza programmata, es: ogni minuto)
- dataora: DATETIME
- polverosita: REAL
- delta_press_sottostazione_mmH20: REAL
- temperatura_sottostazione: REAL
- pressione_linea_aspirazione_mmH20: REAL
- corrente_motore_M1: REAL
- corrente_motore_M2: REAL
- corrente_motore_M6: REAL
*/
CREATE TABLE dbo.report_linea10_30_40 (
	dataora DATETIME null,
	polverosita REAL null,
	delta_press_sottostazione_mmH20 REAL null,
	temperatura_sottostazione REAL null,
	pressione_linea_aspirazione_mmH20 REAL null,
	corrente_motore_M1 REAL null,
	corrente_motore_M2 REAL null,
	corrente_motore_M6 REAL null
)
go


/*
Tabella report_zona_mulini3_4_5 (da sistema Industry4 a gestionale, verrà scritta una riga a cadenza programmata, es: ogni minuto)
- dataora: DATETIME
- polverosita: REAL
- delta_press_sottostazione_mmH20: REAL
- temperatura_sottostazione: REAL
- pressione_linea_aspirazione_mmH20: REAL
- corrente_motore_M1: REAL
- corrente_motore_M2: REAL
- corrente_motore_M3: REAL
- corrente_motore_M4: REAL
- corrente_motore_M11: REAL
- corrente_motore_M12: REAL
- velocita_motore_M1: REAL
- velocita_motore_M2: REAL
- velocita_motore_M3: REAL
- velocita_motore_M4: REAL
- velocita_motore_M11: REAL
- velocita_motore_M12: REAL
*/
CREATE TABLE dbo.report_zona_mulini3_4_5 (
	dataora DATETIME null,
	polverosita REAL null,
	delta_press_sottostazione_mmH20 REAL null,
	temperatura_sottostazione REAL null,
	pressione_linea_aspirazione_mmH20 REAL null,
	corrente_motore_M1 REAL null,
	corrente_motore_M2 REAL null,
	corrente_motore_M3 REAL null,
	corrente_motore_M4 REAL null,
	corrente_motore_M11 REAL null,
	corrente_motore_M12 REAL null,
	velocita_motore_M1 REAL null,
	velocita_motore_M2 REAL null,
	velocita_motore_M3 REAL null,
	velocita_motore_M4 REAL null,
	velocita_motore_M11 REAL null,
	velocita_motore_M12 REAL null
)
go
