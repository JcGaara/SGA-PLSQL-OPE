create or replace package OPERACION.PROCESOS_INTRAWAY is
  /****************************************************************************
   Nombre Package    : procesos_intraway
   Proposito         : Procedimiento creados para los procesos Intraway
   REVISIONES:
   Ver  Fecha       Autor             Solicitado por    Descripcion
   ---  ----------  ----------------  ----------------  ----------------------
   1.0  08/01/2016  Freddy Gonzales   karen Velezmoro   SD-621816
  ****************************************************************************/
  procedure asigna_idventa(ld_fecha date);
  
  procedure alinea_susp_rec_dup(ld_date date);
  
  procedure act_procesos_baja(ld_fecha date);
  
  procedure actualiza_hub(ld_date date);
  
  procedure reenvio_error(ld_fecha date);
  
  procedure actualiza_est_sot(ld_fecha date);
  
  procedure actualiza_sot(ld_fecha date);
  
  procedure actualiza_trsmambaf(ld_fecha date);
  
  procedure actualiza_tareawfcpy(ld_fecha date);
  
  procedure actualiza_transacciones(ld_fecha date);
  
  procedure invoca_sp(ld_fecha date);

end;
/