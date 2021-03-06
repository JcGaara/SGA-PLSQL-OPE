CREATE TABLE OPERACION.TMP_CORTE_DTH
(
  CODSOLOT     NUMBER(8)                        NOT NULL,
  CODINSSRV    NUMBER(10)                       NOT NULL,
  PID          NUMBER(10)                       NOT NULL,
  ESTADO       NUMBER(1)                        NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                NOT NULL,
  FECUSU       DATE                             NOT NULL,
  RESULTADO    VARCHAR2(50 BYTE),
  MENSAJE      VARCHAR2(100 BYTE),
  TRANSACCION  CHAR(10 BYTE)
);

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.CODSOLOT IS 'N�mero de SOT de corte.';

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.CODINSSRV IS 'N�mero de servicio.';

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.PID IS 'C�digo de la instancia de producto.';

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.ESTADO IS 'Estado del transaccion (1 GENERADO, 2 INCOMPLETO, 3 COMPLETADO)';

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.RESULTADO IS 'Resultado del env�o de procedimiento de corte DTH';

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.MENSAJE IS 'Mensaje par�metro de procedimiento de env�o de corte DTH';

COMMENT ON COLUMN OPERACION.TMP_CORTE_DTH.TRANSACCION IS 'Si es CORTE o RECONEXION';


