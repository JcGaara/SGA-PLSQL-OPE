CREATE TABLE OPERACION.EFPTOETA
(
  CODEF       NUMBER(8)                         NOT NULL,
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

COMMENT ON TABLE OPERACION.EFPTOETA IS 'Etapas de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETA.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETA.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETA.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.EFPTOETA.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.EFPTOETA.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EFPTOETA.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EFPTOETA.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTOETA.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTOETA.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.EFPTOETA.COSMAT_S IS 'Costo del material en soles';

COMMENT ON COLUMN OPERACION.EFPTOETA.PCCODTAREA IS 'Task ID de la plantilla';


