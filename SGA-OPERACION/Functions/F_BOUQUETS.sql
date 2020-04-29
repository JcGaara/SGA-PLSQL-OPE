CREATE OR REPLACE FUNCTION OPERACION.f_bouquets(an_idgrupo in ope_grupo_bouquet_det.idgrupo%type,
                                      ac_numregistro in reginsdth_web.numregistro%type) return varchar2 is
    lc_bouquets bouquetxreginsdth.Bouquets%type;
    ln_contador number;

    cursor c_bouquets is
      select nvl(b.codbouquet, '') descripcion,b.codbouquet
        from ope_grupo_bouquet_det b
       where b.idgrupo = an_idgrupo
         and b.flg_activo = 1;

    cursor c_bouquetxRegins is
      select bxr.bouquets
        from bouquetxreginsdth bxr
       where bxr.numregistro = ac_numregistro
         and bxr.tipo in (0, 1)
         and bxr.estado = 1;
    ln_pos    number;
    lb_existe boolean;
begin

    lc_bouquets := '';
    lb_existe   := false;
    select count(1)
      into ln_contador
      from ope_grupo_bouquet_det d
     where idgrupo = an_idgrupo
       and d.flg_activo = 1;

    if ln_contador > 0 then
      for c_rec in c_bouquets loop
        --existe como bouqeut principal o adicional
        for c_b in c_bouquetxRegins loop
          ln_pos := instr(c_b.bouquets, to_char(c_rec.codbouquet));
          if ln_pos > 0 then
            lb_existe := true;
          end if;
        end loop;
        if not lb_existe then
          lc_bouquets := lc_bouquets || ',' || c_rec.descripcion;
        end if;
        lb_existe:=false;
      end loop;

      lc_bouquets := substr(lc_bouquets, 2, length(lc_bouquets) - 1);

    end if;

    return lc_bouquets;end f_bouquets;
/


