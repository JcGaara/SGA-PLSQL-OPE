ALTER TABLE OPERACION.PREUBIETAFAC ADD (
  CONSTRAINT FK_PREUBIETAFAC_FACTURA 
 FOREIGN KEY (FACTURA) 
 REFERENCES OPERACION.FACTURAPEX (FACTURA),
  CONSTRAINT FK_PREUBIETAFAC_PREUBIETA 
 FOREIGN KEY (CODPRE, IDUBI, CODETA) 
 REFERENCES OPERACION.PREUBIETA (CODPRE,IDUBI,CODETA));
