ALTER TABLE OPERACION.TIPOTPTOXSERVICIO ADD (
  CONSTRAINT FK_TIPOTPTOXSERVICIO_TIPOTPTO 
 FOREIGN KEY (TIPOTPTO) 
 REFERENCES OPERACION.TIPOTPTO (TIPOTPTO));
