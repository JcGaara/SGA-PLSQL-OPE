CREATE OR REPLACE FUNCTION OPERACION.f_serv_canal_adicional_dth(p_idpaq number)
return number is
  /************************************************************
   NOMBRE:     F_SERV_CANAL_ADICIONAL_DTH
   PROPOSITO:  Verifica si un paquete tiene configurado servicios adicionales con bouquets de DTH
   PROGRAMADO EN JOB:  NO

   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------
   1.0        06/03/2009  Joseph Asencios  REQ-85028
   ***********************************************************/
  ln_result number;
  ln_contador number;
begin
      ln_contador:=0;

      select count(a.iddet) into ln_contador
      from detalle_paquete a, producto prd, detalle_paquete b, producto prd2, tystabsrv t, linea_paquete l
      where a.idproducto = prd.idproducto
      and (b.flgprincipal=1 and b.idproducto=prd2.idproducto and b.flgestado = 1)
      and a.paquete=b.paquete
      and a.idpaq = b.idpaq
      and a.idpaq = p_idpaq
      and a.flgestado = 1
      and l.flgestado = 1
      and not(a.flg_te = 1 or a.flg_ti = 1)
      and l.codsrv = t.codsrv
      and l.iddet = a.iddet
      and t.codigo_ext is not null
      and a.flg_opcional = 1;

      if ln_contador > 0 then
         ln_result := 1;
      else
         ln_result := 0;
      end if;
  return ln_result;
end ;
/


