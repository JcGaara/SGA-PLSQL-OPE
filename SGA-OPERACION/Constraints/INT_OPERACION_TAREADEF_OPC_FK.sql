ALTER TABLE OPERACION.INT_OPERACION_TAREADEF_OPC ADD (
  CONSTRAINT FK_INT_OPERACION_TAREADEFOPC_2 
 FOREIGN KEY (TAREADEF) 
 REFERENCES OPEWF.TAREADEF (TAREADEF));