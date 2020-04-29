CREATE OR REPLACE PACKAGE OPERACION.PQ_OPE_BOUQUET is

  /******************************************************************************
     NAME:       PQ_BOUQUET
     PURPOSE:    Paquete para Administrar loa bouquets
     REVISIONS:
     Ver        Date        Author           Solicitado por        Description
     ---------  ----------  --------------   --------------        ------------------------------------
     1.0        27/09/2010  Alex Alamo                             Creacion RQ142944
     2.0        20/12/2010  Alfonso Pérez     Rolando Martinez     REQ 152190: se modifica el tipo de campo a almacenar.
     3.0        07/04/2011  Luis Patiño                            PROY: Suma de Cargos
  ******************************************************************************/

  -- 1.0 Funcion que concatena los Bouquest segun el Grupo de Bouquets

  FUNCTION F_CONCA_BOUQUET(AN_IDGRUPO ope_grupo_bouquet_cab.IDGRUPO %TYPE)
    RETURN ope_grupo_bouquet_cab.DESCRIPCION%TYPE;

  FUNCTION F_CONCA_BOUQUET_C(AN_IDGRUPO ope_grupo_bouquet_cab.IDGRUPO %TYPE)
    RETURN ope_grupo_bouquet_cab.DESCRIPCION%TYPE;

  PROCEDURE PROC_CONCA_BOUQUET(AN_IDGRUPO  ope_grupo_bouquet_cab.IDGRUPO %TYPE,
                               a_resultado out varchar2);
  --< ini 3.0
  function f_conca_bouquet_srv_susp(ac_codsrv tystabsrv.codsrv%type)
   return ope_grupo_bouquet_cab.descripcion%type;

  function f_conca_bouquet_srv(ac_codsrv tystabsrv.codsrv%type)
   return ope_grupo_bouquet_cab.descripcion%type;

   --fin 3.0>
end PQ_OPE_BOUQUET;
/


