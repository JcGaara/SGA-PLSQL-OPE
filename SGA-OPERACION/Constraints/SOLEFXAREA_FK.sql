ALTER TABLE OPERACION.SOLEFXAREA ADD (
  CONSTRAINT FK_SOLEFXAREA_AREAOPE 
 FOREIGN KEY (AREA) 
 REFERENCES OPERACION.AREAOPE (AREA),
  CONSTRAINT FK_SOLEFXAREA_ESTSOLEF 
 FOREIGN KEY (ESTSOLEF) 
 REFERENCES OPERACION.ESTSOLEF (ESTSOLEF));
