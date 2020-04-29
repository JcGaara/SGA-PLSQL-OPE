CREATE TABLE OPERACION.OPE_CARGA_INICIAL_TMP
(
  IDCARGAINICIAL            NUMBER              NOT NULL,
  CODIGO_RECARGA_INI        VARCHAR2(8 BYTE),
  CODIGO_RECARGA_FIN        VARCHAR2(8 BYTE),
  FECHA_FIN_VIGENCIA        VARCHAR2(10 BYTE),
  NOMBRE                    VARCHAR2(200 BYTE),
  APELLIDO                  VARCHAR2(200 BYTE),
  TIPO_DOCUMENTO            VARCHAR2(50 BYTE),
  NUMERO_DOCUMENTO          VARCHAR2(30 BYTE),
  FLAG_MANTENIMIENTO        NUMBER,
  FECHA_REGISTRO_SOLICITUD  DATE,
  USUREG                    VARCHAR2(30 BYTE)   DEFAULT user,
  FECREG                    DATE                DEFAULT sysdate,
  USUMOD                    VARCHAR2(30 BYTE)   DEFAULT user,
  FECMOD                    DATE                DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.OPE_CARGA_INICIAL_TMP IS 'Tabla de carga inicial de clientes de DTH que seran migrados a INT y CLARIFY.';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.IDCARGAINICIAL IS 'ID de la tabla';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.CODIGO_RECARGA_INI IS 'CODIGO RECARGA INICIAL';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.CODIGO_RECARGA_FIN IS 'CODIGO RECARGA FINAL';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.FECHA_FIN_VIGENCIA IS 'FECHA FIN VIGENCIA DTH';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.NOMBRE IS 'NOMBRE DEL CLIENTE';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.APELLIDO IS 'NOMBRE DEL APELLIDO';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.TIPO_DOCUMENTO IS 'TIPO DE DOCUMENTO';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.NUMERO_DOCUMENTO IS 'NUMERO DE DOCUMENTO';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.FLAG_MANTENIMIENTO IS 'FLAG MANTENIMIENTO';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.FECHA_REGISTRO_SOLICITUD IS 'FECHA REGISTRO SOLICITUD';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.USUREG IS 'Usuario que insert� el
registro';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.USUMOD IS 'Usuario que modific� el
registro';

COMMENT ON COLUMN OPERACION.OPE_CARGA_INICIAL_TMP.FECMOD IS 'Fecha que se modific� el
registro';


