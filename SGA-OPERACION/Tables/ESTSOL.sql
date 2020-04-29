CREATE TABLE OPERACION.ESTSOL
(
  ESTSOL       NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ABREVI       CHAR(3 BYTE)                     NOT NULL,
  TIPESTSOL    NUMBER(2),
  TIPEST       CHAR(1 BYTE)
);

COMMENT ON TABLE OPERACION.ESTSOL IS 'Estado de solicitud de orden de trabajo ';

COMMENT ON COLUMN OPERACION.ESTSOL.ESTSOL IS 'Estado de la solicitud';

COMMENT ON COLUMN OPERACION.ESTSOL.DESCRIPCION IS 'Descripcion del estado de la solicitud';

COMMENT ON COLUMN OPERACION.ESTSOL.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ESTSOL.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ESTSOL.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.ESTSOL.TIPESTSOL IS 'Tipo de estado de la solicitud';

COMMENT ON COLUMN OPERACION.ESTSOL.TIPEST IS 'Permite agrupar los estados seg#n un tipo, A=Anulado, R=Rechazado, P=Pendiente, T=Transferido';


