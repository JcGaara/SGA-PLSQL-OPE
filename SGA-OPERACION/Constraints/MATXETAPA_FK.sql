ALTER TABLE OPERACION.MATXETAPA ADD (
  CONSTRAINT FK_MATXETAPA_ETAPA 
 FOREIGN KEY (CODETA) 
 REFERENCES OPERACION.ETAPA (CODETA),
  CONSTRAINT FK_MATXETAPA_MATOPE 
 FOREIGN KEY (CODMAT) 
 REFERENCES OPERACION.MATOPE (CODMAT));
