CREATE TABLE OPERACION.INSSRVEQUCMP
(
  CODINSSRV    NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(5)                        NOT NULL,
  ORDENCMP     NUMBER(5)                        NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 1                     NOT NULL,
  FECINS       DATE,
  NUMSERIE     VARCHAR2(20 BYTE),
  OBSERVACION  VARCHAR2(200 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.INSSRVEQUCMP IS 'Componentes de equipos asociados al SID';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.ORDENCMP IS 'Orden del componente de la tabla';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.CANTIDAD IS 'Cantidad del componente de equipo';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.FECINS IS 'Fecha de instalaci�n del componente';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.NUMSERIE IS 'Numero de serie del componente';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.INSSRVEQUCMP.FECUSU IS 'Fecha de registro';

