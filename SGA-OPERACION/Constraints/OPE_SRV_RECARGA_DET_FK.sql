ALTER TABLE OPERACION.OPE_SRV_RECARGA_DET ADD (
  CONSTRAINT FK_OPE_SRV_RECARGA_DET_1 
 FOREIGN KEY (CODINSSRV) 
 REFERENCES OPERACION.INSSRV (CODINSSRV),
  CONSTRAINT FK_OPE_SRV_RECARGA_DET_2 
 FOREIGN KEY (CODSRV) 
 REFERENCES SALES.TYSTABSRV (CODSRV));
