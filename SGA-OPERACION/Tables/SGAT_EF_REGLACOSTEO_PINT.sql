-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_EF_REGLACOSTEO_PINT
(
  EFRCN_ID         NUMBER(4) NOT NULL,
  EFRCN_AB_ID      NUMBER(6),
  EFRCN_TIP_EQUIPO NUMBER(6),
  EFRCC_COND_1     CHAR(1),
  EFRCV_CONCEPTO   VARCHAR2(50) DEFAULT 0 NOT NULL,
  EFRCC_COND_2     CHAR(1) DEFAULT 2 NOT NULL,
  EFRCV_TIP_FIBRA  VARCHAR2(5) DEFAULT '00' NOT NULL,
  EFRCN_DIST_ID    NUMBER(6) DEFAULT 0 NOT NULL,
  EFRCN_CONTINUAR  NUMBER(6) DEFAULT 0 NOT NULL,
  EFRCN_PINT       NUMBER(5) DEFAULT 0 NOT NULL,
  EFRCN_ESTADO     NUMBER(1) DEFAULT 1 NOT NULL,
  EFRCV_USUREG     VARCHAR2(30) DEFAULT USER NOT NULL,
  EFRCD_FECREG     DATE DEFAULT SYSDATE NOT NULL,
  EFRCV_USUMOD     VARCHAR2(30),
  EFRCD_FECMOD     DATE,
  EFRCN_PRIORIDAD  NUMBER(3) DEFAULT 0 NOT NULL,
  EFRCV_CONTINUAR2 VARCHAR2(5) DEFAULT '00' NOT NULL
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
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_ID
  IS 'CODIGO DE LOGICA';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_AB_ID
  IS 'CODIGO DE ANCHO DE BANDA - PARAMETROS';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_TIP_EQUIPO
  IS 'CODIGO DE TIPO AGRUPACI�N EQUIPO';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCC_COND_1
  IS 'CONDICION 1';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCV_CONCEPTO
  IS 'PALABRA RESERVADA PARA LA CONDICION 2';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCC_COND_2
  IS 'CONDICION 2 => 0: NO, 1: SI, 2: SIN VALOR';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCV_TIP_FIBRA
  IS 'CODIGO DE TIPO DE FIBRA';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_DIST_ID
  IS 'CODIGO DE DISTANCIA - PARAMETROS';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_CONTINUAR
  IS 'IR A EFRCN_TIP_EQUIPO PARA CONTINUAR FLUJO';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PINT
  IS 'CODIGO DE MODELO DE EQUIPO DE ACCESO *';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_ESTADO
  IS 'ESTADO DEL REGSITRO';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCV_USUREG
  IS 'USUARIO DE REGISTRO';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCD_FECREG
  IS 'FECHA DE REGISTRO';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCV_USUMOD
  IS 'USUARIO DE MODIFICACION';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCD_FECMOD
  IS 'FECHA DE MODIFICACION';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCN_PRIORIDAD
  IS 'PRIORIDAD DE EJECUCION';
COMMENT ON COLUMN OPERACION.SGAT_EF_REGLACOSTEO_PINT.EFRCV_CONTINUAR2
  IS 'IR A EFRCN_TIP_FIBRA PARA CONTINUAR FLUJO';