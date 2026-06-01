
WAIT WINDOWS "Sto cancellando i .FXP e ricompilando i .PRG"  NOWAIT

ERASE PRG\*.FXP
ERASE PRG\*.BAK
COMPILE PRG\*.PRG

WAIT WINDOWS "Sto compilando il progetto Aq_controllo_giacenze" NOWAIT

BUILD EXE AQ_CONTROLLO_GIACENZE FROM AQ_CONTROLLO_GIACENZE
        
WAIT WINDOWS "Fine compilazione progetto" NOWAIT
