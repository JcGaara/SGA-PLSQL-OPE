ALTER TABLE OPERACION.DEPTXCONTRATA ADD (
  CONSTRAINT FK_IDSUC_CONTRA 
 FOREIGN KEY (IDSUCXCONTRATA) 
 REFERENCES OPERACION.SUCURSALXCONTRATA (IDSUCXCONTRATA));
