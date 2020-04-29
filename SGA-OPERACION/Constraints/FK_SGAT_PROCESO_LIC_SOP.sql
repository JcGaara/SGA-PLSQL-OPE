-- CREATE/RECREATE PRIMARY, UNIQUE AND FOREIGN KEY CONSTRAINTS 
ALTER TABLE OPERACION.SGAT_PROCESO_LIC_SOP
  ADD CONSTRAINT PK_SGA_PROCESO_LIC_SOP PRIMARY KEY (LICSI_ID_LIC)
  USING INDEX 
  TABLESPACE OPERACION_DAT
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );

ALTER TABLE OPERACION.SGAT_PROCESO_LIC_SOP
  ADD CONSTRAINT FK_LICS_LICD FOREIGN KEY (LICSI_SECUENCIA)
  REFERENCES OPERACION.SGAT_PROCESO_LIC_DET (LICDI_SECUENCIA);
