ALTER TABLE OPERACION.SOLOTPTO_ID_REQ ADD (
  CONSTRAINT FK_SOLOTPTO_ID_REQ 
 FOREIGN KEY (CODSOLOT, PUNTO) 
 REFERENCES OPERACION.SOLOTPTO_ID (CODSOLOT,PUNTO));