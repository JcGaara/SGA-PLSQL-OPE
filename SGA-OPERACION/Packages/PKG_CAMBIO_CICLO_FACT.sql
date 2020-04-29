create or replace package operacion.PKG_CAMBIO_CICLO_FACT is
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_CAMBIO_CICLO_FACT
  PROPOSITO:  Almacenará todos los SP utilizados en SGA para el cambio de ciclo de facturación.
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
     1.0    2016-08-22  Felipe Maguiña       Carmen Munayco      PROY-25526 - IDEA-26291 - Ciclos de Facturación
     2.0    2016-12-16  Juan Gonzales                            SD1044407
  /************************************************************************************************/

  procedure sgasu_camb_ciclo_fact(k_codsolot  in integer,
                                  k_resultado out integer,
                                  k_mensaje   out varchar2);

  procedure sgasu_camb_ciclo_fact(k_id_tareawf in number,
                                  k_id_wf      in number,
                                  k_tarea      in number,
                                  k_tareadef   in number,
                                  k_tipesttar  in number,
                                  k_esttarea   in number,
                                  k_mottarchg  in number,
                                  k_fecini     in date,
                                  k_fecfin     in date);

  procedure sgasi_err_cam_ciclo(k_contrato    integer,
                                k_producto    varchar2,
                                k_descripcion varchar2,
                                k_usuario     varchar2,
                                k_fecha       date,
                                k_ip_app      varchar2,
                                k_resultado   out integer,
                                k_mensaje     out varchar2);
  -- ini 2.0
 FUNCTION f_otiene_cod_id(p_cosolot solot.codsolot%type)
    return solot.codsolot%type;
  -- Fin 2.0

end;
/