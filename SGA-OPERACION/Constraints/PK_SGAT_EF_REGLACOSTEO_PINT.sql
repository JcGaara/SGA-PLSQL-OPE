-- CREATE/RECREATE PRIMARY, UNIQUE AND FOREIGN KEY CONSTRAINTS 
ALTER TABLE OPERACION.SGAT_EF_REGLACOSTEO_PINT
  ADD CONSTRAINT PK_SGAT_EF_REGLACOSTEO_PINT PRIMARY KEY (EFRCN_ID)
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
