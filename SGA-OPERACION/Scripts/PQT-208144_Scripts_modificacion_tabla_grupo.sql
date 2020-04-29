alter table operacion.ope_grupo_bouquet_cab
add flg_rota char(1);
update operacion.ope_grupo_bouquet_cab
   set flg_rota='1'
where flg_activo=1;
commit;