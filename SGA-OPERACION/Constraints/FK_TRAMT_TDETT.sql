-- CREATE/RECREATE PRIMARY, UNIQUE AND FOREIGN KEY CONSTRAINTS 
ALTER TABLE OPERACION.SGAT_TRAMA_POSTV_DET
  ADD CONSTRAINT FK_TRAMT_TDETT FOREIGN KEY (TPOSTD_TRAMAID )
  REFERENCES OPERACION.SGAT_TRAMA_POSTV (TRPOSTV_TRAMAID );