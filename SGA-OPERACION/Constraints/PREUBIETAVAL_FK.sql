ALTER TABLE OPERACION.PREUBIETAVAL ADD (
  CONSTRAINT FK_PREUBIETAVAL_CONTRATA 
 FOREIGN KEY (CODCON) 
 REFERENCES OPERACION.CONTRATA (CODCON),
  CONSTRAINT FK_PREUBIETAVAL_PREUBIETA 
 FOREIGN KEY (CODPRE, IDUBI, CODETA) 
 REFERENCES OPERACION.PREUBIETA (CODPRE,IDUBI,CODETA));
