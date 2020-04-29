ALTER TABLE OPERACION.MOTOTXAREA ADD (
  CONSTRAINT FK_MOTOTXAREA_AREAOPE 
 FOREIGN KEY (AREA) 
 REFERENCES OPERACION.AREAOPE (AREA),
  CONSTRAINT FK_MOTOTXAREA_MOTOT 
 FOREIGN KEY (CODMOTOT) 
 REFERENCES OPERACION.MOTOT (CODMOTOT));