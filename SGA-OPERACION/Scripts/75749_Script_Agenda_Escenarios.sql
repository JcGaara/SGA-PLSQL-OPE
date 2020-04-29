declare
cursor c_escenario is
select mst.codmot_solucion,
       mst.codmot_grupo,
       mst.aplica_contrata,
       mst.aplica_pext
  from operacion.mot_solucionxtiptra mst
 where tiptra=485;
begin
  for c1 in c_escenario loop
    insert into operacion.mot_solucionxtiptra(tiptra,codmot_solucion,usureg,fecreg,usumod,fecmod,codmot_grupo,aplica_contrata,aplica_pext) values((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'),c1.codmot_solucion,user,sysdate,user,sysdate,c1.codmot_grupo,c1.aplica_contrata,c1.aplica_pext);
  end loop;
  commit;
end;
/