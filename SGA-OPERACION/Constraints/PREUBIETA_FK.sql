ALTER TABLE OPERACION.PREUBIETA ADD (
  CONSTRAINT FK_PREUBIETA_ESTPREUBIETA 
 FOREIGN KEY (ESTETA) 
 REFERENCES OPERACION.ESTPREUBIETA (ESTETA));