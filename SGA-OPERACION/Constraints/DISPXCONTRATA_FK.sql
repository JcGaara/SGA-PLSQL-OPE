ALTER TABLE OPERACION.DISPXCONTRATA ADD (
  CONSTRAINT FK_CODCONDISP 
 FOREIGN KEY (CODCON) 
 REFERENCES OPERACION.CONTRATA (CODCON));
