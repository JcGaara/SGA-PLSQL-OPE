ALTER TABLE OPERACION.SOT_LIQUIDACION ADD (
  CONSTRAINT FK_CODCONSOTLIQ 
 FOREIGN KEY (CODCON) 
 REFERENCES OPERACION.CONTRATA (CODCON));