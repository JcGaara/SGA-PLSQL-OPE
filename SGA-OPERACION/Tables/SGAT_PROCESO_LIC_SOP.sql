-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_PROCESO_LIC_SOP
(
  LICSI_ID_LIC       INTEGER NOT NULL,
  LICSI_SECUENCIA    INTEGER NOT NULL,
  LICSV_NOM_LICENCIA VARCHAR2(70),
  LICSI_CODPROV      INTEGER,
  LICSD_FECINICIO    DATE,
  LICSD_FECFIN       DATE,
  LICSV_NUMEROOC     VARCHAR2(20),
  LICSI_POSICIONOC   NUMBER(3),
  LICSV_ENTREGABLES  VARCHAR2(250),
  LICSV_CORREOLIC    VARCHAR2(120),
  LICSN_ESTADOLIC    NUMBER(6) DEFAULT 0,
  LICSI_PERIOREN     INTEGER DEFAULT 0,
  LICSI_TIPO         INTEGER DEFAULT 1,
  LICSV_OBSERVACION  VARCHAR2(250),
  LICSV_USUREG       VARCHAR2(30) DEFAULT USER,
  LICSD_FECREG       DATE DEFAULT SYSDATE,
  LICSV_USUMOD       VARCHAR2(30),
  LICSD_FECMOD       DATE
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
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC
  IS 'IDENTIFICADOR ';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_SECUENCIA
  IS 'N�MERO DE SECUENCIA.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_NOM_LICENCIA
  IS 'DESCRIPCI�N DE LA LICENCIA O SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_CODPROV
  IS 'C�DIGO DEL PROVEEDOR.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECINICIO
  IS 'FECHA DE INICIO DE LICENCIA O SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECFIN
  IS 'FECHA DE FIN DE LICENCIA O SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_NUMEROOC
  IS 'N�MERO DE ORDEN DE COMPRA.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_POSICIONOC
  IS 'POSICI�N DE ORDEN DE COMPRA.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_ENTREGABLES
  IS 'DESCRIPCI�N DEL SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_CORREOLIC
  IS 'CORREO DEL CLIENTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSN_ESTADOLIC
  IS '0: ACTIVO 1: VENCIDO.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_PERIOREN
  IS 'PERIODO DE RENOVACI�N DE LICENCIA/SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_TIPO
  IS '1: LICENCIA 2: SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_OBSERVACION
  IS 'DESCRIPCI�N DE LA LICENCIA O SOPORTE.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_USUREG
  IS 'USUARIO DE REGISTRO.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECREG
  IS 'FECHA DE REGISTRO.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSV_USUMOD
  IS 'USUARIO DE MODIFICACI�N.';
COMMENT ON COLUMN OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECMOD
  IS 'FECHA DE MODIFICACI�N.';




