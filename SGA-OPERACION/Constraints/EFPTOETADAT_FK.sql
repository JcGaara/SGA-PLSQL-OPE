ALTER TABLE OPERACION.EFPTOETADAT ADD (
  CONSTRAINT FK_EFPTOETA_EFPTOETADAT 
 FOREIGN KEY (CODEF, PUNTO, CODETA) 
 REFERENCES OPERACION.EFPTOETA (CODEF,PUNTO,CODETA));
