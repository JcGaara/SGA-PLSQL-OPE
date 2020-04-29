CREATE TABLE OPERACION.ACTIVIDAD
(
  CODACT          NUMBER(5)                     NOT NULL,
  DESCRIPCION     VARCHAR2(200 BYTE)            NOT NULL,
  CODUND          CHAR(3 BYTE)                  NOT NULL,
  COSTO           NUMBER(10,2)                  DEFAULT 0                     NOT NULL,
  CODUSU          VARCHAR2(30 BYTE)             DEFAULT user                  NOT NULL,
  FECUSU          DATE                          DEFAULT SYSDATE               NOT NULL,
  ESPERMISO       NUMBER(1)                     DEFAULT 0,
  MONEDA          CHAR(1 BYTE)                  DEFAULT 'D'                   NOT NULL,
  CODUBI          CHAR(10 BYTE),
  ESTADO          NUMBER(1)                     DEFAULT 1,
  TIPO            NUMBER(1)                     DEFAULT 0,
  FLGCAN          NUMBER(1)                     DEFAULT 0,
  FLGPRYLIQ       CHAR(1 BYTE),
  MONEDA_ID       NUMBER(10),
  FLGMODCOS       NUMBER(1),
  CODPEX          NUMBER(7,2),
  CODEXT          VARCHAR2(20 BYTE),
  COD_SAP         VARCHAR2(18 BYTE),
  COMPONENTE      VARCHAR2(10 BYTE),
  COMPONENTE_GTO  VARCHAR2(10 BYTE),
  CODSAP_MIG      VARCHAR2(18 BYTE)
);

COMMENT ON TABLE OPERACION.ACTIVIDAD IS 'Listado de actividad';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.CODACT IS 'Codigo de la actividad (Pk)';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.DESCRIPCION IS 'Descripcion de la actividad';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.CODUND IS 'Codigo de la unidad';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.COSTO IS 'Costo de la actividad';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.ESPERMISO IS 'Identificar si la actividad es un permiso municipal';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.MONEDA IS 'Codigo de moneda (No es utilizado)';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.CODUBI IS 'Codigo del distrito';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.ESTADO IS 'Estado de la actividad (1 = activo, 0 = inactivo)';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.TIPO IS 'Tipo de actividad';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.FLGCAN IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.FLGPRYLIQ IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.MONEDA_ID IS 'Codigo de moneda';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.FLGMODCOS IS 'Flag que verifica si el costo es modificable';

COMMENT ON COLUMN OPERACION.ACTIVIDAD.CODPEX IS 'Codigo interno de planta externa';


