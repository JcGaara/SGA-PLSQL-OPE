ALTER TABLE OPERACION.VIGRESUMEN_DET ADD (
  CONSTRAINT FK_VIGRESUMEN_DET 
 FOREIGN KEY (ID) 
 REFERENCES OPERACION.VIGRESUMEN (ID));
