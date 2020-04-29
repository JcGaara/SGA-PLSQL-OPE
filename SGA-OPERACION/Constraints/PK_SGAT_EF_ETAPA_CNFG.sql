-- CREATE/RECREATE PRIMARY, UNIQUE AND FOREIGN KEY CONSTRAINTS 
ALTER TABLE OPERACION.SGAT_EF_ETAPA_CNFG
  ADD CONSTRAINT PK_SGAT_EF_ETAPA_CNFG PRIMARY KEY (EFECN_ID)
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
ALTER TABLE OPERACION.SGAT_EF_ETAPA_CNFG
  ADD CONSTRAINT FK_EFEC_EFES FOREIGN KEY (EFESN_ID)
  REFERENCES OPERACION.SGAT_EF_ETAPA_SRVC (EFESN_ID);