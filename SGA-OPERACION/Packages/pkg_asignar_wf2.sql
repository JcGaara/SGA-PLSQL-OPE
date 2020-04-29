create or replace package operacion.pkg_asignar_wf2 is

/*******************************************************************************************************
   NOMBRE:       OPERACION.pkg_asignar_wf2
   PROPOSITO:    Paquete para asignar el workflow
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       14/12/2015  Luis Flores                  		   SGA-SD-560640
    2.0       16/03/2016  Alfonso Muñante                    SGA-SD-337664 SERVICIOS ADICIONALES CABLE
    5.0       24/11/2016  Luis Guzmán      Alex Alamo        PROY-20152 - IDEA-24390 - 3Play Inalambrico
    6.0       10/07/2017  Luis Guzmán      Tito Huerta       PROY-27792 - IDEA-34954 - Cambio de Plan
  *******************************************************************************************************/

  procedure asignar_wf(p_fecha date default null);

  procedure asignar_wf_2(p_fecha date default null);

  procedure asignar_wf_portabaja(p_fecha date default null);

  procedure p_asigna_wfbscs_siac(an_tiptransacion number default null);

  function f_valida_tipo_solucion(an_codsolot in number) return number;

  procedure p_asigna_wf_siac_sevadi(an_tiptransacion number default null);
  
  procedure sgasu_asignar_wf_lte;
  
  function sgafun_solucioneslte(an_codsolot in number) return number;

  procedure sgasu_asignar_wf_lte_cp;
end;
/