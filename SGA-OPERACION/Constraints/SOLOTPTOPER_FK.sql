ALTER TABLE OPERACION.SOLOTPTOPER ADD (
  CONSTRAINT FK_SOLOTPTOPER_SOLOTPTO 
 FOREIGN KEY (CODSOLOT, PUNTO) 
 REFERENCES OPERACION.SOLOTPTO (CODSOLOT,PUNTO));
