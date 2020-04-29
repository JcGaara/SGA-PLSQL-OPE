create or replace package body operacion.pq_cargosadicional is
  /*********************************************************************************************
      NOMBRE:           pq_cargosadicional
      PROPOSITO:        Permite obtener los tipos de Reconexion.
      PROGRAMADO EN JOB:  NO
      REVISIONES:
      Ver     Fecha       Autor             Solicitado por        Descripcion
      ------  ----------  ---------------   -----------------     -----------------------------------
      1.0     22/03/2011  Giovanni Vasquez  Miguel Londoña        REQ-022 Administrar rangos de fechas de cobro y cargos por reconexión
      2.0     16/03/2012  Miguel Londoña    Edilberto Astulle     Correccion de cursor para discriminar pids que no se encuentren en billing
      3.0     06/08/2012  Miguel Londoña    Edilberto Astulle     Cambio en la identificacion de la instancia de producto
      4.0     05/10/2012  Juan Pablo Ramos  Elver Ramirez         REQ.163439 Soluciones Post Venta BAM-BAF
      5.0     05/07/2012  Edilberto Astulle                       PQT-141358-TSK-21430
  ********************************************************************************************/
  --INI 1.0
  procedure p_proceso_cargoreconexion(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is
    -- CURSOR CARGOS PAQUETES
    cursor c_adicional_paq(as_transaccion varchar2) is
      select a.codsolot,
             c.idpaq,
             x.idcnr,
             x.idmoneda,
             x.monto,
             x.idtipocargo,
             s.codcli, -- 3.0
             min(b.pid) as pid
        from trssolot a, insprd b, inssrv c, sales.tys_cargoadicpaq_rel x, wf y, solot s --3.0
       where a.codsolot = y.codsolot
         and a.pid = b.pid
         and b.codinssrv = c.codinssrv
         and c.idpaq = x.idpaq
         and a.tiptrs = 4
         and y.idwf = a_idwf
         and x.estado = 1
         and a.codsolot = s.codsolot  --3.0
         and x.idtipocargo in
             (select idtipocargo
                from sales.tys_tipocargo_mae
               where upper(descripcion) = as_transaccion)
         and exists (select 1 from instxproducto where pid = b.pid) --2.0
         and not exists
             (select 1
                from sales.tys_cargosxsolot_rel cs
               where cs.codsolot = a.codsolot
                 and cs.idtipocargo = x.idtipocargo)
       group by a.codsolot, c.idpaq, x.idcnr, x.idmoneda, x.monto, x.idtipocargo, s.codcli; --3.0

    -- CURSOR CARGOS PRODUCTOS
    cursor c_adicional_prd(as_transaccion varchar2) is
      select a.codsolot,
             t.idproducto,
             x.idcnr,
             x.idmoneda,
             x.monto,
             x.idtipocargo,
             s.codcli, -- 3.0
             min(b.pid) as pid
        from trssolot a, insprd b, tystabsrv t, sales.tys_cargoadicprd_rel x, wf y, solot s --3.0
       where a.codsolot = y.codsolot
         and a.pid = b.pid
         and b.codsrv = t.codsrv
         and t.idproducto = x.idproducto
         and a.tiptrs = 4
         and y.idwf = a_idwf
         and x.estado = 1
         and a.codsolot = s.codsolot  --3.0
         and x.idtipocargo in
             (select idtipocargo
                from sales.tys_tipocargo_mae
               where upper(descripcion) = as_transaccion)
         and not exists
             (select 1
                from sales.tys_cargosxsolot_rel cs
               where cs.codsolot = a.codsolot
                 and cs.idtipocargo = x.idtipocargo)
       group by a.codsolot, t.idproducto, x.idcnr, x.idmoneda, x.monto, x.idtipocargo, s.codcli; --3.0

    --<Ini 4.0>
    -- CURSOR CARGOS PAQUETES BAM BAF
    cursor c_cargo_paq(as_transaccion varchar2) is
      select a.codsolot,
             c.idpaq,
             x.idcnr,
             x.idmoneda,
             x.cobro monto,
             x.idtipocargo,
             s.codcli,
             min(b.pid) as pid
        from trssolot a, insprd b, inssrv c, atccorp.transacciones_pv x, wf y, solot s
       where a.codsolot = y.codsolot
         and a.pid = b.pid
         and b.codinssrv = c.codinssrv
         and c.codinssrv = x.codinssrv
         and a.tiptrs = 4
         and y.idwf = a_idwf
         and x.estado = 2
         and a.codsolot = s.codsolot
         and s.codsolot = x.codsolot
         and x.idtipocargo in
             (select idtipocargo
                from sales.tys_tipocargo_mae
               where upper(descripcion) = as_transaccion)
         and exists (select 1 from instxproducto where pid = b.pid)
         and not exists
             (select 1
                from sales.tys_cargosxsolot_rel cs
               where cs.codsolot = a.codsolot
                 and cs.idtipocargo = x.idtipocargo)
       group by a.codsolot, c.idpaq, x.idcnr, x.idmoneda, x.cobro, x.idtipocargo, s.codcli;
    --<Fin 4.0>
    ln_cuenta     number := 0;
    ln_idinstprod number;
    ln_nivel      number;
    lc_codcli     varchar2(8);
    lc_idcod      varchar2(8);
    ln_resultado  number;
    ln_idtrancorte number;
    ls_transaccion varchar2(50);
    ln_cuenta_transaccion number;
  begin

    --Inicio 5.0
    /*select count(1), min(b.idtrancorte)
      into ln_cuenta_transaccion, ln_idtrancorte
      from cxc_instransaccioncorte b, wf
     where b.idtrancorte in (6,7)
       and b.codsolot = wf.codsolot
       and wf.idwf = a_idwf;*/
    select count(1), min(b.idtrancorte)
    into ln_cuenta_transaccion, ln_idtrancorte
    from operacion.trsoac b, wf 
    where b.idtrancorte in (6,7) and b.codsolot = wf.codsolot and wf.idwf = a_idwf;
    --Fin 5.0
    if ln_idtrancorte = 6 then
      ls_transaccion := 'RECONEXION_SUSPENSION';
    elsif ln_idtrancorte = 7 then
      ls_transaccion := 'RECONEXION_CORTE';
    else
       ln_cuenta_transaccion := 0;
       --<Ini 4.0>
       ls_transaccion := 'RECONEXION_SUSPENSION';
       --<Fin 4.0>
    end if;

    if ln_cuenta_transaccion > 0 then

      for r_filpaq in c_adicional_paq(ls_transaccion) loop

        if ln_cuenta = 0 then  -- solo se debe generar un cargo por
          -- BUSCAR MAXIMO INSTANCIA
          /*<3.0>
          select max(idinstprod),
                 codcli,
                 idcod,
                 nivel
            into ln_idinstprod,
                 lc_codcli,
                 lc_idcod,
                 ln_nivel
            from instxproducto
           where pid = r_filpaq.pid
           group by codcli,
                    idcod,
                    nivel;
          */
          select idinstprod, codcli, idcod, nivel
            into ln_idinstprod,
                 lc_codcli,
                 lc_idcod,
                 ln_nivel
            from instxproducto
           where idinstprod = (select max(idinstprod)
                                from instxproducto
                               where pid = r_filpaq.pid
                                 and codcli = r_filpaq.codcli);
          --</3.0>
          -- INSERTAR DATOS DE CNR (PAQUETES)
          ln_resultado := pq_cnr.f_set_val_libre(r_filpaq.idcnr,
                                                 lc_codcli,
                                                 lc_idcod,
                                                 ln_nivel,
                                                 sysdate,
                                                 1,
                                                 r_filpaq.monto,
                                                 r_filpaq.idmoneda,
                                                 ln_idinstprod,
                                                 null,
                                                 null,
                                                 null,
                                                 1909);

          -- INSERTAR RELACIONES DE DATOS (PAQUETES)
          insert into sales.tys_cargosxsolot_rel
            (codsolot,
             idcnr,
             idtipocargo,
             cantidad,
             estado,
             idseccnr)
          values
            (r_filpaq.codsolot,
             r_filpaq.idcnr,
             r_filpaq.idtipocargo,
             1,
             1,
             ln_resultado);
          ln_cuenta := ln_cuenta + 1;
        end if;

      end loop;

      if ln_cuenta = 0 then
        for r_filprd in c_adicional_prd(ls_transaccion) loop
          -- BUSCAR MAXIMO INSTANCIA
          /*<3.0>
          select max(idinstprod),
                 codcli,
                 idcod,
                 nivel
            into ln_idinstprod,
                 lc_codcli,
                 lc_idcod,
                 ln_nivel
            from instxproducto
           where pid = r_filprd.pid
           group by codcli,
                    idcod,
                    nivel;
          */
          select idinstprod, codcli, idcod, nivel
            into ln_idinstprod,
                 lc_codcli,
                 lc_idcod,
                 ln_nivel
            from instxproducto
           where idinstprod = (select max(idinstprod)
                                from instxproducto
                               where pid = r_filprd.pid
                                 and codcli = r_filprd.codcli);
          --<3.0>
          -- INSERTAR DATOS DE CNR (PRODUCTOS)
          ln_resultado := pq_cnr.f_set_val_libre(r_filprd.idcnr,
                                                 lc_codcli,
                                                 lc_idcod,
                                                 ln_nivel,
                                                 sysdate,
                                                 1,
                                                 r_filprd.monto,
                                                 r_filprd.idmoneda,
                                                 ln_idinstprod,
                                                 null,
                                                 null,
                                                 null,
                                                 1909);

          -- INSERTAR RELACIONES DE DATOS (PRODUCTOS)
          insert into sales.tys_cargosxsolot_rel
            (codsolot,
             idcnr,
             idtipocargo,
             cantidad,
             estado,
             idseccnr)
          values
            (r_filprd.codsolot,
             r_filprd.idcnr,
             r_filprd.idtipocargo,
             1,
             1,
             ln_resultado);
        end loop;
      end if;
    --<Ini 4.0>
    else
      for reg_paq in c_cargo_paq(ls_transaccion) loop

        if ln_cuenta = 0 then
          select idinstprod, codcli, idcod, nivel
            into ln_idinstprod,
                 lc_codcli,
                 lc_idcod,
                 ln_nivel
            from instxproducto
           where idinstprod = (select max(idinstprod)
                                from instxproducto
                               where pid = reg_paq.pid
                                 and codcli = reg_paq.codcli);

          -- INSERTAR DATOS DE CNR (PAQUETES)
          ln_resultado := pq_cnr.f_set_val_libre(reg_paq.idcnr,
                                                 lc_codcli,
                                                 lc_idcod,
                                                 ln_nivel,
                                                 sysdate,
                                                 1,
                                                 reg_paq.monto,
                                                 reg_paq.idmoneda,
                                                 ln_idinstprod,
                                                 null,
                                                 null,
                                                 null,
                                                 1909);

          -- INSERTAR RELACIONES DE DATOS (PAQUETES)
          insert into sales.tys_cargosxsolot_rel
            (codsolot,
             idcnr,
             idtipocargo,
             cantidad,
             estado,
             idseccnr)
          values
            (reg_paq.codsolot,
             reg_paq.idcnr,
             reg_paq.idtipocargo,
             1,
             1,
             ln_resultado);
          ln_cuenta := ln_cuenta + 1;
        end if;

      end loop;
    --<Fin 4.0>
    end if;
  end;
  --FIN 1.0
end;
/