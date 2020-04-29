CREATE OR REPLACE PROCEDURE OPERACION.SP_CREO_EJECUTA_INV_INTERFACE(
   tipo number,CodigoSolot in number, NumPunto in number,
   NumOrden in number,CodEta in number,CodUser in varchar2, salida out number) is

l_cont number;
l_nro varchar2(1000);

l_idnroreq number;
l_area number;
/************************************************************
   	NOMBRE:       		SP_CREO_EJECUTA_INV_INTERFACE
   	PROPOSITO:    		-
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripcion
   	---------  ----------  ---------------  ------------------------
  	 1.0        25/08/2004  Carlos Corrales
	 1.0        16/11/2004  Carmen Quilca    Soporte el pedido de equipos por etapa
***********************************************************/
begin
--modificado por descompilado 09/09/2008
/*
   FINANCIAL.PQ_INTERFACE_INV_SGA.proc_busca_cabecera_req (
    tipo,
    CodigoSolot,
    NumPunto,
    NumOrden,
	CodEta,
    CodUser,
    salida);
*/
   -- el dato se guarda en la SOT.
   select count(*) into l_cont from solotpto_id
      where codsolot = CodigoSolot and punto = NumPunto;
   if l_cont = 1 then
      select nroreq into l_nro from solotpto_id
         where codsolot = CodigoSolot and punto = NumPunto;
      l_nro := l_nro||','||trim(to_char(salida,'99999999'));

      if length(l_nro) <= 100 then
         update  solotpto_id set nroreq = l_nro
            where codsolot = CodigoSolot and punto = NumPunto;
      end if;

   end if;

/*************************************************************
SE INSERTA UNA REQUISICION EN SOLOTPTO_ID_REG
**************************************************************/
   SELECT NVL(MAX(IDNROREQ),0) + 1 INTO l_idnroreq FROM SOLOTPTO_ID_REQ;

   SELECT F_GET_AREA_USUARIO INTO l_area FROM DUAL;

   INSERT INTO SOLOTPTO_ID_REQ (IDNROREQ,CODSOLOT,PUNTO,NROREQ,AREA,FLGREQ)
   VALUES(l_idnroreq,CodigoSolot,NumPunto,trim(to_char(salida,'99999999')),l_area,tipo);


End;
/


