CREATE OR REPLACE PACKAGE OPERACION.PQ_SGA_WIMAX_LTE IS

  /*******************************************************************************************************
   NAME:       OPERACION.PQ_SGA_WIMAX
   PURPOSE:    Paquete de objetos necesarios para
               realizar la migración de WIMAX a LTE
  
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------
    1.0       --          --               Creación
  *******************************************************************************************************/

  -- Funcion que valida si es cliente WIMAX
  function f_val_cli_wimax(v_codcli marketing.vtatabcli.codcli%TYPE)
    return number;
    
  function f_obtiene_sot_cli_wimax (v_codcli marketing.vtatabcli.codcli%TYPE) return number;

  -- Actualizamos la linea en SAND
  procedure p_asoc_wimax_lte(av_linea    in VARCHAR2,
                             av_iccid    in VARCHAR2,
                             av_material in VARCHAR2,
                             an_sot      in number,
                             an_error    out number,
                             av_error    out varchar2);
                             
  procedure p_act_fact_sga_bscs(an_codsolot   number,
                                av_check_apli varchar2,
                                an_error      out number,
                                av_error      out varchar2);
                                
  function f_obt_act_fact_sga_bscs(an_codsolot number) return number;
  
END;
/
