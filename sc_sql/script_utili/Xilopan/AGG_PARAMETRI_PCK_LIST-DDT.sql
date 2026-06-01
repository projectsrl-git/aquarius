
/*
*** AGGIORNAMENTO DEI SEGUENTI PARAMETRI

*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Packing list",
*** sottoscheda "Packing list produzione pannelli truciolari" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Aumento percentuale massimo per Qtà già autorizzate senza necessità di nuova autorizzazione

*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti":
***		- Impedisci la creazione di nuove DDT per clienti a Rischio 1 o Rischio 2
*/

UPDATE U_AZI_PA SET AZI_PKAUPE = 25
UPDATE U_AZI_PA SET AZI_DDTLCK = 1
