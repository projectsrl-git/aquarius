

*SET STEP ON 

WAIT WINDOWS "COPY FILE DA CAMPO MEMO"

** CREA UN CURSORE TEMPORANEO DI TEST
CREATE CURSOR TESTO_FILE ;
       (TESTO M)
SELECT TESTO_FILE 
APPEND BLANK
REPLACE TESTO WITH "TESTO DI PROVA"

__cursor_file				= "TESTO_FILE"
__nome_campo_file			= "TESTO"
__nome_file_arrivo			= "TEST.TXT"
__nome_directory_di_arrivo	= "C:\DOC_AQUARIUS\TEST\"


=COPY_FILE(__cursor_file,__nome_campo_file,__nome_file_arrivo,__nome_directory_di_arrivo)

WAIT WINDOWS "COPY FILE DA CAMPO MEMO ESEGUITA CORRETTAMENTE"

