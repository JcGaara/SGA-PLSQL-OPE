ALTER TABLE OPERACION.SOLOT_ADI ADD (
  CONSTRAINT FK_SOLOT_ADI_SOLOT 
 FOREIGN KEY (CODSOLOT) 
 REFERENCES OPERACION.SOLOT (CODSOLOT)
    ON DELETE CASCADE);
