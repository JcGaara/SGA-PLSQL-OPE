CREATE TABLE OPERACION.INT_OPERACION_TAREADEF_OPC
(
  IDDEFOPE  NUMBER(5),
  TAREADEF  NUMBER(6),
  SQL_RES   VARCHAR2(30 BYTE),
  FECUSU    DATE                                DEFAULT sysdate               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECMOD    DATE                                DEFAULT sysdate               NOT NULL,
  USUMOD    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.INT_OPERACION_TAREADEF_OPC IS 'Configuración de Tareas x Operación de interfaz en base a evaluación de una consulta.';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF_OPC.SQL_RES IS 'Cadena para Resultado esperado para la validacion ';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF_OPC.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF_OPC.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF_OPC.FECMOD IS 'Fecha de modificación';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF_OPC.USUMOD IS 'Codigo de Usuario modificación';


