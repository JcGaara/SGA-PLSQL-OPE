CREATE TABLE OPERACION.LICENCIAANTIVIRUS
(
  IDLICENCIA  NUMBER(10)                        NOT NULL,
  LICENCIA    CHAR(20 BYTE),
  CODCLI      CHAR(8 BYTE),
  CORREO      VARCHAR2(50 BYTE),
  FECCOMPRA   DATE,
  FECASIG     DATE,
  FECCADUC    DATE,
  VALIDO      CHAR(1 BYTE),
  CODINSSRV   NUMBER(10),
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user,
  FECUSU      DATE                              DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.LICENCIAANTIVIRUS IS 'Registro de Licencias otorgado a los clientes';

COMMENT ON COLUMN OPERACION.LICENCIAANTIVIRUS.IDLICENCIA IS 'Codigo';

COMMENT ON COLUMN OPERACION.LICENCIAANTIVIRUS.LICENCIA IS 'Descripcion de la Licencia';

COMMENT ON COLUMN OPERACION.LICENCIAANTIVIRUS.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.LICENCIAANTIVIRUS.FECCOMPRA IS 'Fecha de compra de la licencia';

COMMENT ON COLUMN OPERACION.LICENCIAANTIVIRUS.FECASIG IS 'Fecha de asignación de la licencia';

COMMENT ON COLUMN OPERACION.LICENCIAANTIVIRUS.FECCADUC IS 'Fecha de vencimiento de la licencia';


