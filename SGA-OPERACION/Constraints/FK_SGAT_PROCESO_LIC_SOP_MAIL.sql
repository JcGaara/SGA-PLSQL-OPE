-- CREATE/RECREATE PRIMARY, UNIQUE AND FOREIGN KEY CONSTRAINTS 
ALTER TABLE OPERACION.SGAT_PROCESO_LIC_SOP_MAIL
  ADD CONSTRAINT FK_LICS_LICM FOREIGN KEY (LICSI_ID_LIC)
  REFERENCES OPERACION.SGAT_PROCESO_LIC_SOP (LICSI_ID_LIC);