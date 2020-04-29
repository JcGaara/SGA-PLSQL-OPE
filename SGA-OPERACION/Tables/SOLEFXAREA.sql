CREATE TABLE OPERACION.SOLEFXAREA
(
  CODDPT         CHAR(6 BYTE),
  CODEF          NUMBER(8)                      NOT NULL,
  NUMSLC         CHAR(10 BYTE)                  NOT NULL,
  ESTSOLEF       NUMBER(2)                      NOT NULL,
  ESRESPONSABLE  NUMBER(1)                      DEFAULT 0                     NOT NULL,
  FECINI         DATE                           DEFAULT sysdate,
  FECFIN         DATE,
  NUMDIAPLA      NUMBER(3),
  OBSERVACION    VARCHAR2(4000 BYTE),
  FECUSU         DATE                           DEFAULT sysdate               NOT NULL,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECAPR         DATE,
  NUMDIAVAL      NUMBER(3),
  AREA           NUMBER(4)                      NOT NULL,
  TIPPROYECTO    NUMBER(2)
);

COMMENT ON TABLE OPERACION.SOLEFXAREA IS 'Estudio de factibilidad asociado a una area';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.ESTSOLEF IS 'Estado de la solicitud de ef';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.ESRESPONSABLE IS 'Identifica que area es responsable de aprobar el ef';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.NUMDIAPLA IS 'Numero de dias de plazo';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.FECAPR IS 'Fecha de aprobación';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.NUMDIAVAL IS 'Numeros de dias valido';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.AREA IS 'Codigo de area';

COMMENT ON COLUMN OPERACION.SOLEFXAREA.TIPPROYECTO IS 'Tipo de Proyecto';


