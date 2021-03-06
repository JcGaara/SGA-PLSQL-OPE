-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_EF_ETAPA_PRM
(
  EFEPN_ID          NUMBER(6) NOT NULL,
  EFEPN_CODN        NUMBER(10),
  EFEPV_CODV        VARCHAR2(100),
  EFEPV_DESCRIPCION VARCHAR2(80) NOT NULL,
  EFEPV_TRANSACCION VARCHAR2(30) NOT NULL,
  EFEPN_VALOR       NUMBER(10),
  EFEPN_ESTADO      NUMBER(1) DEFAULT 1,
  EFEPV_USUREG      VARCHAR2(30) DEFAULT USER NOT NULL,
  EFEPD_FECREG      DATE DEFAULT SYSDATE NOT NULL,
  EFEPV_USUMOD      VARCHAR2(30),
  EFEPD_FECMOD      DATE,
  EFEPN_ID_PADRE    NUMBER(6),
  EFEPV_SISTEMA     VARCHAR2(1) DEFAULT 'N',
  EFEPN_CODN2       NUMBER(10),
  EFEPV_CODV2       VARCHAR2(100)
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
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_ID
  IS 'ID.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN
  IS 'C�DIGO NUMERICO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_CODV
  IS 'C�DIGO CADENA.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_DESCRIPCION
  IS 'DESCRIPCI�N DE LA OPERACI�N.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_TRANSACCION
  IS 'REGLA DE TRANSACCI�N.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_VALOR
  IS 'VALOR AUXILIAR.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_ESTADO
  IS 'ESTADO DE LA OPERACI�N.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_USUREG
  IS 'USUARIO DE REGISTRO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPD_FECREG
  IS 'FECHA DE REGISTRO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_USUMOD
  IS 'USUARIO DE MODIFICACI�N.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPD_FECMOD
  IS 'FECHA DE MODIFICACI�N.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_ID_PADRE
  IS 'ID PADRE';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_SISTEMA
  IS 'INDICADOR DE REGISTRO DE SISTEMA QUE NO DEBE SER ELIMINADO';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPN_CODN2
  IS 'C�DIGO NUMERICO.';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_PRM.EFEPV_CODV2
  IS 'C�DIGO CADENA.';
