ALTER TABLE OPERACION.SOLOTPTO_ID_CONTRATA ADD (
  CONSTRAINT FK_SOL_ID_CONT_SOLOTPTO 
 FOREIGN KEY (CODSOLOT, PUNTO) 
 REFERENCES OPERACION.SOLOTPTO (CODSOLOT,PUNTO));
