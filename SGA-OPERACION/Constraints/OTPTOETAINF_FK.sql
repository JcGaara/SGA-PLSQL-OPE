ALTER TABLE OPERACION.OTPTOETAINF ADD (
  CONSTRAINT FK_OTPTOETAINF_OTPTOETA 
 FOREIGN KEY (CODOT, PUNTO, CODETA) 
 REFERENCES OPERACION.OTPTOETA (CODOT,PUNTO,CODETA));
