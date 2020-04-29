ALTER TABLE OPERACION.FLUJOXAREAOT ADD (
  CONSTRAINT FK_FLUJOXAREAOT_AREAOPE_1 
 FOREIGN KEY (AREA_ORI) 
 REFERENCES OPERACION.AREAOPE (AREA),
  CONSTRAINT FK_FLUJOXAREAOT_AREAOPE_2 
 FOREIGN KEY (AREA_DES) 
 REFERENCES OPERACION.AREAOPE (AREA));