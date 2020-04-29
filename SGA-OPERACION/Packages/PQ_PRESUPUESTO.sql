CREATE OR REPLACE PACKAGE OPERACION.PQ_PRESUPUESTO IS
/******************************************************************************
PROCEDIMIENTOS RELACIONADOS AL LLENADO AUTOMATICO DE LAS TABLAS DE PRESUPUESTO
******************************************************************************/
PROCEDURE  P_Llena_Presupuesto_De_Solot(a_codsolot solot.CODSOLOT%type, a_codcli solot.CODCLI%type, a_numslc solot.NUMSLC%type, a_tipsrv solot.TIPSRV%type);
PROCEDURE P_Llena_Presu_De_Solotpto(a_codsolot solotpto.CODSOLOT%type, a_punto solotpto.PUNTO%type,
a_codinssrv solotpto.CODINSSRV%type, a_cid solotpto.CID%type, a_descripcion solotpto.DESCRIPCION%type,
a_direccion solotpto.DIRECCION%type, a_codubi solotpto.CODUBI%type);

END;
/


