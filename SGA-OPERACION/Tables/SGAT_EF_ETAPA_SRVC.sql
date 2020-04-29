-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_EF_ETAPA_SRVC
(
  EFESN_ID     NUMBER(5) NOT NULL,
  EFESN_CODETA NUMBER(5) NOT NULL,
  EFESC_TIPPRC CHAR(1) NOT NULL,
  EFESV_MODNEG VARCHAR2(100) NOT NULL,
  EFESN_ESTADO NUMBER(1) DEFAULT 1 NOT NULL,
  EFESV_USUREG VARCHAR2(30) DEFAULT USER NOT NULL,
  EFESD_FECREG DATE DEFAULT SYSDATE NOT NULL,
  EFESV_USUMOD VARCHAR2(30),
  EFESD_FECMOD DATE
)
TABLESPACE OPERACION_DAT
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
-- ADD COMMENTS TO THE COLUMNS 
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESN_ID
  IS 'ID.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESN_CODETA
  IS 'C�DIGO DE ETAPA.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESC_TIPPRC
  IS 'TIPO DE PROCESO - NORMAL/POLITICO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESV_MODNEG 
  IS 'SERVICIOS ADICIONALES.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESN_ESTADO
  IS 'ESTADO DEL COSTO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESV_USUREG
  IS 'USUARIO DE REGISTRO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESD_FECREG
  IS 'FECHA DE REGISTRO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESV_USUMOD
  IS 'USUARIO DE MODIFICACI�N.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESD_FECMOD
  IS 'FECHA DE MODIFICACI�N.';