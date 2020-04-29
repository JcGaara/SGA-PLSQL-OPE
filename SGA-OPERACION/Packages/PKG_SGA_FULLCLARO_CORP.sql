CREATE OR REPLACE PACKAGE OPERACION.PKG_SGA_FULLCLARO_CORP IS

PROCEDURE SGASI_ENTREGA_BONO(PI_NUMERO IN VARCHAR2,
                               PO_CODERROR OUT VARCHAR2,
                               PO_MSJERROR OUT VARCHAR2);
                               
PROCEDURE SGASI_ASIGNA_BONO_FC_CORP(CO_ACTIVADOS OUT SYS_REFCURSOR,
                                    PO_CODERROR OUT VARCHAR2, 
                                    PO_MSJERROR OUT VARCHAR2);                               

END;
/