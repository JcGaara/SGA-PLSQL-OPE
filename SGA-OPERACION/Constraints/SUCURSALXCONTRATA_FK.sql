ALTER TABLE OPERACION.SUCURSALXCONTRATA ADD (
  CONSTRAINT FK_SUC_CODCON 
 FOREIGN KEY (CODCON) 
 REFERENCES OPERACION.CONTRATA (CODCON));