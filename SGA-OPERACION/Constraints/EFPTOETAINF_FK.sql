ALTER TABLE OPERACION.EFPTOETAINF ADD (
  CONSTRAINT FK_EFPTOETA_EFPTOETAINF 
 FOREIGN KEY (CODEF, PUNTO, CODETA) 
 REFERENCES OPERACION.EFPTOETA (CODEF,PUNTO,CODETA));