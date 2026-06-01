
RIT=MESSAGEBOX("Funzione di gestione dischetti",292,"ATTENZIONE")
IF RIT=6
   =MESSAGEBOX("Inserire un dischetto già formattato nell'unità A:",62,"ATTENZIONE")
   IF !ExecCommand("select * from bilnew","bilnew")
      return(.f.)
   ENDIF
   SELECT BILNEW
   GO TOP
   IF EOF()
      =MESSAGEBOX("Nessun dato presente in BILNEW",62,"ATTENZIONE")
   ELSE
      COPY TO A:\BILNEW SDF 
   ENDIF  
   WAIT WINDOW 'Operazione conclusa, Buon lavoro...' TIMEOUT(7)
ELSE
   RETURN
ENDIF