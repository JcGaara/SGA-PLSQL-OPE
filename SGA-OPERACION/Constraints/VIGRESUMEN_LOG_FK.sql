ALTER TABLE OPERACION.VIGRESUMEN_LOG ADD (
  CONSTRAINT FK_VIGRESUMENLOG_VIGRESUMEN 
 FOREIGN KEY (ID) 
 REFERENCES OPERACION.VIGRESUMEN (ID));