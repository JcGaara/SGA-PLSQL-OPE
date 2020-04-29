CREATE TABLE OPERACION.OPE_TVSAT_SLTD_DET
(
  IDSOL         NUMBER(20)                      NOT NULL,
  SERIE         VARCHAR2(30 BYTE)               NOT NULL,
  ARCHIVO       VARCHAR2(30 BYTE),
  IDLOTEFIN     NUMBER(10),
  USUREG        VARCHAR2(30 BYTE)               DEFAULT USER                  NOT NULL,
  FECREG        DATE                            DEFAULT SYSDATE               NOT NULL,
  USUMOD        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  FECMOD        DATE                            DEFAULT SYSDATE               NOT NULL,
  IDSOLDET      NUMBER(20)                      NOT NULL,
  FLG_REVISION  NUMBER(1)                       DEFAULT 0                     NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_TVSAT_SLTD_DET IS 'Tabla donde se registan las tarjetas que estan incluidas dentro de una solicitud de activacion / suspension al conax. Esta tabla debe ser llenada desde una tarea del workflow de suspension / activacion de servicios en el conax';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.IDSOL IS 'Identificador de la solicitud';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.SERIE IS 'Numero de tarjeta equiposdth';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.ARCHIVO IS 'Nombre del archivo en el cual esta incluido la tarjeta';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.IDLOTEFIN IS 'Indica el lote final dentro del cual se proceso la tarjeta. Esto debido a que puede darse el caso que se procese en un lote distinto al del asignado a la solicitud';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.USUREG IS 'Usuario que realizo el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.FECREG IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.USUMOD IS 'Usuario de modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.FECMOD IS 'Fecha de modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.IDSOLDET IS 'Identificador de Detalle de Solicitud';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_DET.FLG_REVISION IS '0: No requiere revisión, 1: Requiere revisión';


