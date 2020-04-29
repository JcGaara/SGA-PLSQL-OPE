CREATE TABLE OPERACION.AGENDA_TAREAS_LOG
(
  IDAGENDA          NUMBER,
  CODCON            NUMBER,
  CODCLI            CHAR(8 BYTE),
  FECPROG           DATE,
  FECAGENDA         DATE,
  CODUSU            VARCHAR2(30 BYTE)           DEFAULT user,
  FECUSU            DATE                        DEFAULT sysdate,
  HORAS             NUMBER,
  CODINCIDENCE      NUMBER(8),
  ESTAGE            NUMBER(2),
  TIPO_ACC_LOG      CHAR(1 BYTE),
  IDSEQ             NUMBER                      NOT NULL,
  OBSERVACION       VARCHAR2(500 BYTE),
  ACTA_INSTALACION  VARCHAR2(50 BYTE),
  CODCNT            CHAR(8 BYTE),
  INSTALADOR        VARCHAR2(50 BYTE)
);

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.IDAGENDA IS 'Id Agenda';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.CODCON IS 'Codigo de Contrata';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.FECPROG IS 'Fecha de Programación de Visita';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.FECAGENDA IS 'Fecha de Agenda Ejecución';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.CODUSU IS 'Usuario de Registro';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.FECUSU IS 'Fecha de Registro';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.HORAS IS 'Tiempo de Visita';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.CODINCIDENCE IS 'Incidencia';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.ESTAGE IS 'Estado de Agenda';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.TIPO_ACC_LOG IS 'Tipo de accion que se realizo';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.IDSEQ IS 'Secuencial del log';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.ACTA_INSTALACION IS 'Acta de Instalacion';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.CODCNT IS 'Codigo de Contacto';

COMMENT ON COLUMN OPERACION.AGENDA_TAREAS_LOG.INSTALADOR IS 'Instalador en Sitio';


