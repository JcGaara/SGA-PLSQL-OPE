CREATE TABLE OPERACION.OTPTOEQUCMP
(
  CODOT        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  ORDENCMP     NUMBER(4)                        NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 1                     NOT NULL,
  COSTO        NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  NUMSERIE     VARCHAR2(30 BYTE),
  FECINS       DATE,
  INSTALADO    NUMBER(1),
  OBSERVACION  VARCHAR2(240 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  ESTADO       VARCHAR2(30 BYTE)
);

COMMENT ON TABLE OPERACION.OTPTOEQUCMP IS 'Componentes del equipo de la orden de trabajo (No es usada, remplazado por WF)';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.FECINS IS 'Fecha de instalacion';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.INSTALADO IS 'Indica si el equipo esta instalado';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.ESTADO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.PUNTO IS 'Punto de la ot';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.ORDEN IS 'Orden en la tabla';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.ORDENCMP IS 'Orden del componente en la tabla';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.CANTIDAD IS 'Cantidad del componente de equipo';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.COSTO IS 'Costo del componente de equipo';

COMMENT ON COLUMN OPERACION.OTPTOEQUCMP.NUMSERIE IS 'Numero de serie del equipo';


