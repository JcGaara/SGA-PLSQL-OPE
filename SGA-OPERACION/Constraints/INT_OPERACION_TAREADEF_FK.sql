ALTER TABLE OPERACION.INT_OPERACION_TAREADEF ADD (
  CONSTRAINT FK_INT_OPERACION_TAREADEF_1 
 FOREIGN KEY (TAREADEF) 
 REFERENCES OPEWF.TAREADEF (TAREADEF));
