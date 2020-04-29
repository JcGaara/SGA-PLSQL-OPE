CREATE TABLE OPERACION.OPE_PLANTILLASOT
(
  IDPLANSOT    NUMBER(6)                        NOT NULL,
  DESCRIPCION  VARCHAR2(250 BYTE),
  TIPTRA       NUMBER(6),
  MOTOT        NUMBER(6),
  TIPSRV       CHAR(4 BYTE),
  DIASFECCOM   NUMBER(3),
  AREASOL      NUMBER(4),
  TIPTRAMAN    VARCHAR2(100 BYTE),
  ESTADO       NUMBER(1)                        DEFAULT 0,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECREG       DATE                             DEFAULT sysdate               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECMOD       DATE                             DEFAULT sysdate               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_PLANTILLASOT IS 'Tabla de configuracion de plantillas de sot a usar dentro del proceso de cortes y reconexiones';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.IDPLANSOT IS 'Identificador de la plantilla de sot';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.DESCRIPCION IS 'Descripcion de la plantilla de sot';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.TIPTRA IS 'Identificador del tipo de trabajo asociado';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.MOTOT IS 'Identificador del motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.TIPSRV IS 'Identificador del tipo de servicio (familia)';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.DIASFECCOM IS 'Dias para Fecha de Compromiso';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.AREASOL IS 'Area que debe atender la solicitud';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.TIPTRAMAN IS 'Tipos de trabajo para la sot de suspension a pedido del cliente';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.ESTADO IS '0: Inactivo, 1:Activo';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.USUREG IS 'Usuario de creacion del registro';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.FECREG IS 'Fecha de creacion del resgitro';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.USUMOD IS 'Usuario ultima modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_PLANTILLASOT.FECMOD IS 'Fecha ultima modificacion del registro';


