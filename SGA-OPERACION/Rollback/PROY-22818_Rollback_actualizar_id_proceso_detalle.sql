declare
cursor c1 is
select cie.id_proceso,cie.archivo,cie.usureg,cie.fecreg from operacion.cab_inventario_env_adc cie;
begin
  -- Actualizando los registros de detalle
  for cx in c1 loop
    update operacion.inventario_env_adc
       set archivo=cx.archivo
     where id_proceso=cx.id_proceso;
  end loop;
  commit;
end;
/