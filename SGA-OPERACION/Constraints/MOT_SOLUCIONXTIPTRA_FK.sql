ALTER TABLE OPERACION.MOT_SOLUCIONXTIPTRA ADD (
  CONSTRAINT FK_MOT_SOLUCIONXTIPTRA1 
 FOREIGN KEY (TIPTRA) 
 REFERENCES OPERACION.TIPTRABAJO (TIPTRA),
  CONSTRAINT FK_MOT_SOLUCIONXTIPTRA2 
 FOREIGN KEY (CODMOT_SOLUCION) 
 REFERENCES OPERACION.MOT_SOLUCION (CODMOT_SOLUCION));