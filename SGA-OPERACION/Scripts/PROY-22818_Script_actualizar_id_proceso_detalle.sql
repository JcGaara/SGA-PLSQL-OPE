declare
cursor c1 is
select distinct archivo,usureg,fecreg from operacion.inventario_env_adc order by fecreg asc;
cursor c2 is
select cie.id_proceso,cie.archivo,cie.usureg,cie.fecreg from operacion.cab_inventario_env_adc cie;
begin
  -- Insertando la Cabecera
  for cx in c1 loop
    insert into operacion.cab_inventario_env_adc(id_proceso,archivo,usureg,fecreg) values (operacion.SQ_OPE_CAB_INV.nextval,cx.archivo,cx.usureg,cx.fecreg);
  end loop;
  commit;
  -- Actualizando detalle
  for cy in c2 loop
    update operacion.inventario_env_adc
       set id_proceso=cy.id_proceso
     where fecreg=cy.fecreg
       and usureg=cy.usureg;
  end loop;
  commit;
end;
/