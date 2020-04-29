ALTER TABLE OPERACION.OTPTOETAVAL ADD (
  CONSTRAINT FK_OTPTOETAVAL_CONTRATA 
 FOREIGN KEY (CODCON) 
 REFERENCES OPERACION.CONTRATA (CODCON),
  CONSTRAINT FK_OTPTOETAVAL_OTPTOETA 
 FOREIGN KEY (CODOT, PUNTO, CODETA) 
 REFERENCES OPERACION.OTPTOETA (CODOT,PUNTO,CODETA));