   DATA_SCAD   = SPACE(10)
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= "0000"      
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000" 
   VET_DAY[1]= "0000" 
   VET_DAY[2]= "0000"
   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno

   V_CONPAG     = CPA
   V_TUTTO      = TRANCHE("PARA",V_CONPAG,RIBALTA2(DATADOC),DA+AV,VET_DAL,VET_AL,VET_DAY,XVALUTA,___FLAG_POSALL,___CLIENTE)    && 2010-08-04 sergio posticipi per tutto l'anno
   DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
   DATASCAD     = DATA_SCAD


