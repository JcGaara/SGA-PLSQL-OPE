CREATE TABLE OPERACION.OPE_INS_EQUIPO_DET
(
  IDINS_EQUIPO_DET  NUMBER(8)                   NOT NULL,
  IDINS_EQUIPO      NUMBER(8),
  TIPO              NUMBER(2)                   NOT NULL,
  PUERTO            VARCHAR2(30 BYTE),
  CODINSSRV         NUMBER(10),
  CODSOLOT          NUMBER(8),
  ESTADO            NUMBER(1)                   DEFAULT 1,
  USUREG            VARCHAR2(30 BYTE)           DEFAULT USER,
  FECREG            DATE                        DEFAULT SYSDATE,
  USUMOD            VARCHAR2(30 BYTE)           DEFAULT USER,
  FECMOD            DATE                        DEFAULT SYSDATE
);

COMMENT ON TABLE OPERACION.OPE_INS_EQUIPO_DET IS 'DETALLE PARA CONTROL DE EQUIPOS';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.IDINS_EQUIPO_DET IS 'Identificador de instancia de detalle de equipo';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.IDINS_EQUIPO IS 'Identificador de instancia de equipo';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.TIPO IS '1: Puerto para Lineas telefonicas, 2: puerto para IPs de internet';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.CODINSSRV IS 'Identificador de instancia de servicio';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.CODSOLOT IS 'Identificador de solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.ESTADO IS '1:Activo, 0:Inactivo ';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.USUREG IS 'Usuario   que   insertó   el registro';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.USUMOD IS 'Usuario   que modificó   el registro';

COMMENT ON COLUMN OPERACION.OPE_INS_EQUIPO_DET.FECMOD IS 'Fecha   que se   modificó el registro';


