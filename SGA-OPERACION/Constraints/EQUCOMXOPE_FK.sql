ALTER TABLE OPERACION.EQUCOMXOPE ADD (
  CONSTRAINT FK_EQUCOMXOPE_TIPEQU 
 FOREIGN KEY (TIPEQU) 
 REFERENCES OPERACION.TIPEQU (TIPEQU));