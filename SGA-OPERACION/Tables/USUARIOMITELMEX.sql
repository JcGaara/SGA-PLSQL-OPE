CREATE TABLE OPERACION.USUARIOMITELMEX
(
  IDUSUARIO    NUMBER(10)                       NOT NULL,
  NOMBRES      VARCHAR2(150 BYTE),
  APPATERNO    VARCHAR2(50 BYTE),
  APMATERNO    VARCHAR2(50 BYTE),
  CORREO       VARCHAR2(50 BYTE)                NOT NULL,
  SEXO         CHAR(1 BYTE),
  FECNAC       DATE,
  OCUPACION    VARCHAR2(30 BYTE),
  CODCLI       CHAR(8 BYTE),
  PASSWORD     VARCHAR2(500 BYTE),
  NROCONTRATO  VARCHAR2(30 BYTE),
  TELEFONO     VARCHAR2(50 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate
);

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.IDUSUARIO IS 'Codigo de usuario';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.NOMBRES IS 'Nombres de los usuario';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.APPATERNO IS 'Apellido Paterno';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.APMATERNO IS 'Apellido Materno';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.CORREO IS 'Correo del usuario';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.SEXO IS 'Sexo';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.FECNAC IS 'Fecha de nacimiento';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.OCUPACION IS 'Ocupación del usuario';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.CODCLI IS 'Codido de cliente';

COMMENT ON COLUMN OPERACION.USUARIOMITELMEX.PASSWORD IS 'Password del usuario';


