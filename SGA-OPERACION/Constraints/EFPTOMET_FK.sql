ALTER TABLE OPERACION.EFPTOMET ADD (
  CONSTRAINT FK_EFPTOMET_EFPTO 
 FOREIGN KEY (CODEF, PUNTO) 
 REFERENCES OPERACION.EFPTO (CODEF,PUNTO));