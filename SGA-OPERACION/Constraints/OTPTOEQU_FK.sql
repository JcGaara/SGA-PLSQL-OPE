ALTER TABLE OPERACION.OTPTOEQU ADD (
  CONSTRAINT FK_OTPTOEQU_OTPTO 
 FOREIGN KEY (CODOT, PUNTO) 
 REFERENCES OPERACION.OTPTO (CODOT,PUNTO),
  CONSTRAINT FK_OTPTOEQU_TIPEQU 
 FOREIGN KEY (TIPEQU) 
 REFERENCES OPERACION.TIPEQU (TIPEQU));
