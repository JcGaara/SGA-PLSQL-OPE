ALTER TABLE OPERACION.SOLOTPTO_POS ADD (
  CONSTRAINT FK_SOLOTPTO_POS_SOLOTPTO 
 FOREIGN KEY (CODSOLOT, PUNTO) 
 REFERENCES OPERACION.SOLOTPTO (CODSOLOT,PUNTO)
    ON DELETE CASCADE);