ALTER TABLE OPERACION.MATXACT ADD (
  CONSTRAINT FK_MATXACT_ACTIVIDAD 
 FOREIGN KEY (CODACT) 
 REFERENCES OPERACION.ACTIVIDAD (CODACT),
  CONSTRAINT FK_MATXACT_MATOPE 
 FOREIGN KEY (CODMAT) 
 REFERENCES OPERACION.MATOPE (CODMAT));