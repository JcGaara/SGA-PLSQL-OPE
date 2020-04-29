CREATE TABLE OPERACION.USUARIOWEB
(
  USUARIO   VARCHAR2(20 BYTE)                   NOT NULL,
  PASSWORD  VARCHAR2(20 BYTE)                   NOT NULL,
  NOMBRE    VARCHAR2(50 BYTE)                   NOT NULL
);

COMMENT ON TABLE OPERACION.USUARIOWEB IS 'Tabla temporal para validación de usuario en el sistema de cortes y reconexiones.';


