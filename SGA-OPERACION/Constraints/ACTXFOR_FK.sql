ALTER TABLE OPERACION.ACTXFOR ADD (
  CONSTRAINT FK_ACTXFOR_ACTIVIDAD 
 FOREIGN KEY (CODACT) 
 REFERENCES OPERACION.ACTIVIDAD (CODACT));