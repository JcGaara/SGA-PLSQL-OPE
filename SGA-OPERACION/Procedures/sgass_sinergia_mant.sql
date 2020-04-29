create or replace procedure operacion.sgass_sinergia_mant  (P_ABREV       VARCHAR2,
                                                            P_DESCRIP     VARCHAR2,
                                                            P_CODIGO      VARCHAR2,
                                                            PO_CURSOR OUT SYS_REFCURSOR) IS
 /*     
    ****************************************************************
    * Nombre SP         : sgass_sinergiapospre
    * Propósito         : Lista de clientes
    * Input             : P_ABREV        --> Descripcion para la tabla TIPOPEDD
                          P_DESCRIP      --> Busqueda por Descripción 
                          P_CODIGO       --> Busqueda por Codigo
    * Output            : po_cursor      --> Cursor con los registros obtenidos de la tabla
    
    * Creado por        : Luigi Sipion
    * Fec Creación      : 26/11/2018
    * Proyeto           : PROY-140119
    * Fec Actualización : N/A
    ****************************************************************
    */
  N_CODIGON_AUX number:=0;
  V_ABREV       varchar2(100):='SINERGIA_SOLICITANTE';
  
  BEGIN
  /*SI ES POR SINERGIA_SOLICITANTE, se trabaja con codigon_aux(0 ó 1 tipo tecnologia)*/
  IF P_ABREV='SINERGIA_SOLICITANTE0' THEN  
     N_CODIGON_AUX:=0;
  END IF; 
   IF P_ABREV='SINERGIA_SOLICITANTE1' THEN  
     N_CODIGON_AUX:=1;
  END IF;  
  
  IF P_ABREV IN ('SINERGIA_POSPRE','SINERGIA_CEGE_OPE','SINERGIA_CEGE_ADM','SINERGIA_ORDEN_INTERNA','CAPEX','OPEX') THEN
      OPEN PO_CURSOR FOR
    SELECT O.DESCRIPCION, O.CODIGOC
      FROM OPEDD O, TIPOPEDD T
     WHERE T.ABREV = P_ABREV 
       AND T.TIPOPEDD = O.TIPOPEDD
       AND ((UPPER(O.DESCRIPCION ) LIKE P_DESCRIP) AND (TRIM(O.CODIGOC) LIKE P_CODIGO))
     ORDER BY O.CODIGON;
   END IF;
   
   IF P_ABREV IN ('SINERGIA_SOLICITANTE0','SINERGIA_SOLICITANTE1') THEN
      OPEN PO_CURSOR FOR
    SELECT O.DESCRIPCION, O.CODIGOC
      FROM OPEDD O, TIPOPEDD T
     WHERE T.ABREV = V_ABREV 
       AND T.TIPOPEDD = O.TIPOPEDD
       AND TRIM(NVL(O.CODIGON_AUX,0)) = N_CODIGON_AUX
       AND ((UPPER(O.DESCRIPCION ) LIKE P_DESCRIP) AND (TRIM(O.CODIGOC) LIKE P_CODIGO))
     ORDER BY O.CODIGON;
   END IF;

END;
/