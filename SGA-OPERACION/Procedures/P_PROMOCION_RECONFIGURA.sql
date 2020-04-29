CREATE OR REPLACE PROCEDURE OPERACION.p_promocion_reconfigura(an_tipo number) is

as_numregistro bouquetxreginsdth.numregistro%type;
ln_idcupon bouquetxreginsdth.idcupon%type;
ln_idpromocion fac_promocion_en_linea_mae.idgrupo%type;
ln_idgrupo fac_promocion_en_linea_mae.idgrupo%type;
ln_cantidad number;
ln_activo number;
as_bouquet bouquetxreginsdth.bouquets%type;
as_resultado  varchar2(200);

lb_primeravez boolean;
ln_existe_tmp number;
lc_codsrv tystabsrv.codsrv%type;

cursor c_bouquet_unico is
select numregistro, count(1)
  from bouquetxreginsdth
 where tipo = 2
   and estado = 1
 group by numregistro
having count(1) = 1;

cursor c_bouquet_varios is
select numregistro, count(1)
  from bouquetxreginsdth
 where tipo = 2
   and estado = 1
 group by numregistro
having count(1) > 1;

cursor c_busca(as_numregistro in bouquetxreginsdth.numregistro%type) is
select * from bouquetxreginsdth
where numregistro = as_numregistro
  and tipo = 2  and estado = 1;

cursor c_buscapreciso(as_numregistro in bouquetxreginsdth.numregistro%type,as_bouquet bouquetxreginsdth.bouquets%type ) is
select * from bouquetxreginsdth
where numregistro = as_numregistro
  and tipo = 2  and estado = 1 and bouquets = as_bouquet;

---Cursor de servicios asociados a bouquets promocionales por pronto pago
cursor c_numregistro_cupon is
select numregistro
  from bouquetxreginsdth
 where tipo = 2
   and estado = 1
   and idcupon is not null
 group by numregistro;
--Cursor de bouquetes promocionales que tienen la misma fecha inicio y fin de vigencia con cuppon
cursor c_bouxreg(a_numregistro in ope_srv_recarga_cab.numregistro%type) is
select a.numregistro,
       trunc(a.fecha_inicio_vigencia) fecha_inicio_vigencia,
       trunc(a.fecha_fin_vigencia) fecha_fin_vigencia,
       trunc(a.fecusu) fecusu,
       a.idcupon
  from bouquetxreginsdth a
 where numregistro = a_numregistro
   and a.tipo = 2
   and a.estado = 1
   and a.idcupon is not null
 group by a.numregistro,
          trunc(a.fecha_inicio_vigencia),
          trunc(a.fecha_fin_vigencia),
          trunc(a.fecusu),
          a.idcupon;

--Cursor de promociones con cupon
cursor c_bouxregxprom(a_numregistro in varchar2, a_idcupon number, a_fecreg date) is
 select a.idpromocion, a.idgrupo, b.idaplicacion
   from fac_promocion_en_linea_mae a, fac_aplicacion_promocion_cab b
  where b.numregistro = a_numregistro
    and a.idpromocion = b.idpromocion
    and a.idgrupo is not null
    and b.estado = 1
    and b.idcupon = a_idcupon
    and trunc(b.fecreg) = a_fecreg
    and not exists (select 1
           from operacion.ope_registros_tmp t
          where t.numregistro = a_numregistro
            and t.idaplicacion = b.idaplicacion);

---Cursor de servicios asociados a bouquets promocionales de venta nueva
cursor c_numregistro is
select numregistro
  from bouquetxreginsdth
 where tipo = 2
   and estado = 1
   and idcupon is null
 group by numregistro;

--Cursor de bouquetes promocionales que tienen la misma fecha inicio y fin de vigencia sin cuppon
cursor c_bouxreg_sc(a_numregistro in ope_srv_recarga_cab.numregistro%type) is
select a.numregistro,
       trunc(a.fecha_inicio_vigencia) fecha_inicio_vigencia,
       trunc(a.fecha_fin_vigencia) fecha_fin_vigencia,
       trunc(a.fecusu) fecusu,
       a.idcupon
  from bouquetxreginsdth a
 where numregistro = a_numregistro
   and a.tipo = 2
   and a.estado = 1
   and a.idcupon is null
 group by a.numregistro,
          trunc(a.fecha_inicio_vigencia),
          trunc(a.fecha_fin_vigencia),
          trunc(a.fecusu),
          a.idcupon;

--Cursor de promociones sin cupon
cursor c_bouxregxprom_sc(a_numregistro in varchar2,a_fecreg date) is
 select distinct a.idgrupo
   from fac_promocion_en_linea_mae a, fac_aplicacion_promocion_cab b
  where b.numregistro = a_numregistro
    and a.idpromocion = b.idpromocion
    and a.idgrupo is not null
    and b.estado = 1
    and b.idcupon is null
    and trunc(b.fecreg) = a_fecreg
    and not exists (select 1
           from operacion.ope_registros_tmp t
          where t.numregistro = a_numregistro
            and t.idgrupo = a.idgrupo);

begin

      for c_num_cupon in c_numregistro_cupon loop
          for c_bxr in c_bouxreg(c_num_cupon.numregistro) loop
              lb_primeravez := true;
              for c_bxrxp in c_bouxregxprom(c_num_cupon.numregistro, c_bxr.idcupon,c_bxr.fecusu) loop

                  if lb_primeravez then

                     as_bouquet := operacion.f_bouquets(c_bxrxp.idgrupo,c_num_cupon.numregistro);

                     select count(1)
                       into ln_existe_tmp
                       from operacion.ope_registros_tmp a
                      where a.numregistro = c_num_cupon.numregistro
                        and a.idaplicacion = c_bxrxp.idaplicacion;

                     if ln_existe_tmp = 0 then
                         insert into operacion.ope_registros_tmp
                           (numregistro, idaplicacion)
                         values
                           (c_num_cupon.numregistro, c_bxrxp.idaplicacion);

                        select max(codsrv)
                          into lc_codsrv
                          from bouquetxreginsdth a
                         where a.numregistro = c_num_cupon.numregistro
                           and a.estado = 1
                           and a.tipo = 2
                           and a.idcupon = c_bxr.idcupon
                           and trunc(a.fecusu) = c_bxr.fecusu
                           and trunc(a.fecha_inicio_vigencia) = c_bxr.fecha_inicio_vigencia
                           and trunc(a.fecha_fin_vigencia) = c_bxr.fecha_fin_vigencia;

                        update bouquetxreginsdth a
                           set a.estado = 0
                         where a.numregistro = c_num_cupon.numregistro
                           and a.estado = 1
                           and a.tipo = 2
                           and a.idcupon = c_bxr.idcupon
                           and trunc(a.fecusu) = c_bxr.fecusu
                           and trunc(a.fecha_inicio_vigencia) = c_bxr.fecha_inicio_vigencia
                           and trunc(a.fecha_fin_vigencia) = c_bxr.fecha_fin_vigencia;

                        insert into bouquetxreginsdth
                          (numregistro,
                           codsrv,
                           bouquets,
                           tipo,
                           estado,
                           fecha_inicio_vigencia,
                           fecha_fin_vigencia,
                           idcupon)
                        values
                          (c_num_cupon.numregistro,
                           lc_codsrv,
                           as_bouquet,
                           2,
                           1,
                           c_bxr.fecha_inicio_vigencia,
                           c_bxr.fecha_fin_vigencia,
                           c_bxr.idcupon);

                       lb_primeravez := false;
                       exit;
                     end if;

                  end if;

              end loop;
          end loop;

         commit;
      end loop;

      for c_num_c in c_numregistro loop
          for c_bxr_sc in c_bouxreg_sc(c_num_c.numregistro) loop
              lb_primeravez := true;
              for c_bxr_scxp_sc in c_bouxregxprom_sc(c_num_c.numregistro,c_bxr_sc.fecusu) loop

                  if lb_primeravez then

                     as_bouquet := operacion.f_bouquets(c_bxr_scxp_sc.idgrupo,c_num_c.numregistro);

                     select count(1)
                       into ln_existe_tmp
                       from operacion.ope_registros_tmp a
                      where a.numregistro = c_num_c.numregistro
                        and a.idaplicacion = c_bxr_scxp_sc.idgrupo;

                     if ln_existe_tmp = 0 then
                         insert into operacion.ope_registros_tmp
                           (numregistro,idgrupo)
                         values
                           (c_num_c.numregistro, c_bxr_scxp_sc.idgrupo);

                        select max(codsrv)
                          into lc_codsrv
                          from bouquetxreginsdth a
                         where a.numregistro = c_num_c.numregistro
                           and a.estado = 1
                           and a.tipo = 2
                           and trunc(a.fecusu) = c_bxr_sc.fecusu
                           and trunc(a.fecha_inicio_vigencia) = c_bxr_sc.fecha_inicio_vigencia
                           and trunc(a.fecha_fin_vigencia) = c_bxr_sc.fecha_fin_vigencia;

                        update bouquetxreginsdth a
                           set a.estado = 0
                         where a.numregistro = c_num_c.numregistro
                           and a.estado = 1
                           and a.tipo = 2
                           and trunc(a.fecusu) = c_bxr_sc.fecusu
                           and trunc(a.fecha_inicio_vigencia) = c_bxr_sc.fecha_inicio_vigencia
                           and trunc(a.fecha_fin_vigencia) = c_bxr_sc.fecha_fin_vigencia;

                        insert into bouquetxreginsdth
                          (numregistro,
                           codsrv,
                           bouquets,
                           tipo,
                           estado,
                           fecha_inicio_vigencia,
                           fecha_fin_vigencia,
                           idcupon)
                        values
                          (c_num_c.numregistro,
                           lc_codsrv,
                           as_bouquet,
                           2,
                           1,
                           c_bxr_sc.fecha_inicio_vigencia,
                           c_bxr_sc.fecha_fin_vigencia,
                           c_bxr_sc.idcupon);

                       lb_primeravez := false;
                       exit;
                     end if;

                  end if;

              end loop;
          end loop;
          commit;
      end loop;


end p_promocion_reconfigura;
/


