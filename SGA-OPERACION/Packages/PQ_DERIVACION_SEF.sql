CREATE OR REPLACE PACKAGE OPERACION.PQ_DERIVACION_SEF IS
FUNCTION F_VALIDA_INSTALACION_SEF(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INSTALACION_COLOCATION_SEF(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_VALIDA_DIRECCION_SEF(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_VALIDA_VISITA_TEC(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_VALIDA_DERECHO_ADM(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_VALIDA_ALQ_CONFI(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_VALIDA_ANALISIS_RED(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INS_RPVL_ACCESO(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INS_RPVL_ACCESO_CON(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INS_RPVL_ACCESO_POS(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INS_RPVN_ACCESO(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INS_TELEFONIA_E1PRI(an_numslc NUMBER)RETURN VARCHAR2;

FUNCTION F_INS_RPV_ACCESO(an_numslc NUMBER)RETURN VARCHAR2;

END;
/


