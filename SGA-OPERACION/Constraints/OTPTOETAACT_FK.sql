ALTER TABLE OPERACION.OTPTOETAACT ADD (
  CONSTRAINT FK_OTPTOETAACT_ACTIVIDAD 
 FOREIGN KEY (CODACT) 
 REFERENCES OPERACION.ACTIVIDAD (CODACT),
  CONSTRAINT FK_OTPTOETAACT_OTPTOETA 
 FOREIGN KEY (CODOT, PUNTO, CODETA) 
 REFERENCES OPERACION.OTPTOETA (CODOT,PUNTO,CODETA));
