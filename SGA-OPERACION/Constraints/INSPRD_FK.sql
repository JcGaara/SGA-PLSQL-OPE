ALTER TABLE OPERACION.INSPRD ADD (
  CONSTRAINT FK_INSPRD_ESTINSPRD 
 FOREIGN KEY (ESTINSPRD) 
 REFERENCES OPERACION.ESTINSPRD (ESTINSPRD));