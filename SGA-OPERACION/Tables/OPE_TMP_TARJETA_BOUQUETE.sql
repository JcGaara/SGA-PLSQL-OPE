CREATE GLOBAL TEMPORARY TABLE OPERACION.OPE_TMP_TARJETA_BOUQUETE
(
  NUMREGISTRO  VARCHAR2(10 BYTE),
  SERIE        VARCHAR2(30 BYTE),
  CODEXT       VARCHAR2(10 BYTE)
)
ON COMMIT DELETE ROWS;

COMMENT ON COLUMN OPERACION.OPE_TMP_TARJETA_BOUQUETE.NUMREGISTRO IS 'Numero del registro reginsdth';

COMMENT ON COLUMN OPERACION.OPE_TMP_TARJETA_BOUQUETE.SERIE IS 'Serie de la tarjeta';

COMMENT ON COLUMN OPERACION.OPE_TMP_TARJETA_BOUQUETE.CODEXT IS 'numero de bouquete';


