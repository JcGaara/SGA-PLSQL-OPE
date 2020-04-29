create or replace package OPERACION.PKG_BSCS_CONSULTAS is

   -- Author  : 1541119
   -- Created : 15/04/2019 10:00:20 a.m.
   -- Purpose : 

   procedure SGASS_CONSULTA_LINEAS(PI_TIPODOCUMENTO IN VARCHAR2,
                                   PI_DOCUMENTO     IN VARCHAR2,
                                   PO_CURSOR        OUT SYS_REFCURSOR,
                                   PO_CODERROR      OUT NUMBER,
                                   PO_MSJERROR      OUT VARCHAR2);
end PKG_BSCS_CONSULTAS;
/