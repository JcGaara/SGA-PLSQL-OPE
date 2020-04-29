CREATE TABLE OPERACION.INT_OPERACION_TAREADEF
(
  IDDEFOPE        NUMBER(5)                     NOT NULL,
  TAREADEF        NUMBER(6)                     NOT NULL,
  TIPO            NUMBER(1)                     DEFAULT 1                     NOT NULL,
  IDDEFOPE_ANULA  NUMBER(5),
  ESTTAREA_INI    NUMBER(4)                     NOT NULL,
  ESTTAREA_FIN    NUMBER(4)                     NOT NULL,
  USUREG          VARCHAR2(30 BYTE)             DEFAULT USER                  NOT NULL,
  FECREG          DATE                          DEFAULT SYSDATE               NOT NULL,
  USUMOD          VARCHAR2(30 BYTE)             DEFAULT USER                  NOT NULL,
  FECMOD          DATE                          DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.INT_OPERACION_TAREADEF IS 'Definicion de Operaciones por Tarea segun Tipo y Estados';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF.TIPO IS 'Tipo asociado ';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF.IDDEFOPE_ANULA IS 'operacion de anulacion int_definicion_operacion.iddefope';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF.ESTTAREA_INI IS 'Estado de la Tarea inicial';

COMMENT ON COLUMN OPERACION.INT_OPERACION_TAREADEF.ESTTAREA_FIN IS 'Estado de la Tarea inicial';


