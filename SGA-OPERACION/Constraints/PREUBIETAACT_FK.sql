ALTER TABLE OPERACION.PREUBIETAACT ADD (
  CONSTRAINT FK_PREUBIETAACT_PREUBIETA 
 FOREIGN KEY (CODPRE, IDUBI, CODETA) 
 REFERENCES OPERACION.PREUBIETA (CODPRE,IDUBI,CODETA));
