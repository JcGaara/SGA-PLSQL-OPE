ALTER TABLE OPERACION.EF_LOG ADD (
  CONSTRAINT FK_EF_LOG_EF 
 FOREIGN KEY (CODEF) 
 REFERENCES OPERACION.EF (CODEF));