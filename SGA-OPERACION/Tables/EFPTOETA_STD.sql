CREATE TABLE OPERACION.EFPTOETA_STD
(
  IDPAQ       NUMBER(10)                        NOT NULL,
  PUNTO       NUMBER(10)                        NOT NULL,
  CODETA      NUMBER(5)                         NOT NULL,
  FECINI      DATE                              DEFAULT sysdate,
  FECFIN      DATE,
  COSMO       NUMBER(10,2)                      DEFAULT 0                     NOT NULL,
  COSMOCLI    NUMBER(10,2)                      DEFAULT 0                     NOT NULL,
  COSMAT      NUMBER(10,2)                      DEFAULT 0                     NOT NULL,
  COSMATCLI   NUMBER(10,2)                      DEFAULT 0                     NOT NULL,
  COSMO_S     NUMBER(10,2)                      DEFAULT 0                     NOT NULL,
  COSMAT_S    NUMBER(10,2)                      DEFAULT 0                     NOT NULL,
  PCCODTAREA  NUMBER(15)
);

COMMENT ON TABLE OPERACION.EFPTOETA_STD IS 'Etapas Estandar de cada detalle del Paquete';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.IDPAQ IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.COSMAT_S IS 'Costo del material en soles';

COMMENT ON COLUMN OPERACION.EFPTOETA_STD.PCCODTAREA IS 'Task ID de la plantilla';


