ALTER TABLE OPERACION.OTINFORME ADD (
  CONSTRAINT FK_OTINFORME_OT 
 FOREIGN KEY (CODOT) 
 REFERENCES OPERACION.OT (CODOT));
