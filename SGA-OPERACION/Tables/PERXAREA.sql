CREATE TABLE OPERACION.PERXAREA
(
  CODTRA         CHAR(8 BYTE)                   NOT NULL,
  CODDPT         CHAR(6 BYTE)                   NOT NULL,
  LOGIN          VARCHAR2(30 BYTE),
  NOMBRE         VARCHAR2(200 BYTE),
  AREA           NUMBER(4),
  FLG_AVISAR_OT  NUMBER(1)                      DEFAULT 0
);

COMMENT ON TABLE OPERACION.PERXAREA IS 'No es usada';

COMMENT ON COLUMN OPERACION.PERXAREA.CODTRA IS 'Codigo de trabajo';

COMMENT ON COLUMN OPERACION.PERXAREA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.PERXAREA.LOGIN IS 'LOGIN';

COMMENT ON COLUMN OPERACION.PERXAREA.NOMBRE IS 'Nombre del personal';

COMMENT ON COLUMN OPERACION.PERXAREA.AREA IS 'Codigo de area';

COMMENT ON COLUMN OPERACION.PERXAREA.FLG_AVISAR_OT IS 'No se utiliza';


