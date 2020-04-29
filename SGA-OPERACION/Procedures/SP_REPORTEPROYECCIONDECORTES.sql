CREATE OR REPLACE PROCEDURE OPERACION.Sp_ReporteProyecciondeCortes(FEC_PROYECCION DATE) is
/*--**********************************************************************
Funcion que carga los documentos vencidos según los criterios establecidos
**********************************************************************\
*/
v_tipcam ctbtipcam.ventca%type;

cursor c_vencidos is
select c.nomabr, c.codcli, sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) -- TODO A DÓLARES
from OPERACION.CXCTABFACVENCIDOS_PROY c, CXCTABFAC f
where (c.nomabr, c.codcli) in (
    select distinct c1.nomabr, c1.codcli
      from OPERACION.CXCTABFACVENCIDOS_PROY c1
      minus
      select distinct nomabr, codcli
      from transacciones_cable t
      where transaccion = 'SUSPENSION' and fecfin is null )
AND c.idfac = f.idfac
group by c.nomabr, c.codcli
HAVING sum(decode(f.moneda_id, 1, f.sldact/v_tipcam, f.sldact)  ) > 40;


v_idfac CXCTABFACVENCIDOS.idfac%type;
r_vencido CXCTABFACVENCIDOS%rowtype;

begin

  dbms_utility.exec_ddl_statement('truncate table OPERACION.CXCTABFACVENCIDOS_PROY');
  dbms_utility.exec_ddl_statement('truncate table OPERACION.pretransacciones_CABLE_PROY');

  select ventca into v_tipcam from ctbtipcam where fectca = trunc(sysdate)  ; -- tipo de cambio del dolar del día

  /*"CARGA DE DOCUMENTOS VENCIDOS*/
      insert into OPERACION.CXCTABFACVENCIDOS_PROY
      select distinct c.nomabr,
                      c.sldact,
                      c.codcli,
                      v.nomcli,
                      ca.descripcion categoria,
                      c.idfac,
                      c.sersut || '-' || c.numsut numdoc,
                      c.fecemi,
                      c.fecven,
                      ca.idcategoria,
                      decode(b.cicfac,14,10,15,10,24,10,25,10,15),-- tipo de servicio: cable 10, triple play 15
                      MIN(trunc(MONTHS_BETWEEN(sysdate, i.fecini)))
        from cxctabfac c, bilfac b, inssrv i, vtatabcli v, categoria ca,
             insprd ip, instxproducto ins, cr
        where c.tipdoc IN ('REC', 'LET')
         and c.estfacrec = 0
         and c.estfac in ('02', '04')
         and b.idfaccxc = c.idfac
         and b.cicfac in (14, 15, 24, 25, 21, 26) -- cable y triple play
         and i.codinssrv = ip.codinssrv
         and ip.flgprinc = 1
         and ip.pid = ins.pid
         and ins.idinstprod = cr.idinstprod
         and cr.idbilfac = b.idbilfac
         and i.estinssrv = 1
         and i.codcli = c.codcli
         and c.codcli = v.codcli
         and ca.idcategoria(+) = v.idcategoria
         and c.fecemi > to_date('01/01/2007', 'dd/mm/yyyy')
         GROUP BY c.nomabr,
                c.sldact,
                c.codcli,
                v.nomcli,
                ca.descripcion,
                c.idfac,
                c.sersut || '-' || c.numsut,
                c.fecemi,
                c.fecven,
                ca.idcategoria,
                decode(b.cicfac,14,10,15,10,24,10,25,10,15);
       commit;



for c in c_vencidos loop
            -- cambio 10/03/2008  Gustavo Ormeño max por min
  select min(idfac) into v_idfac from OPERACION.CXCTABFACVENCIDOS_PROY where codcli = c.codcli and nomabr = c.nomabr ;

  if (v_idfac is not null) then
    select * into r_vencido from OPERACION.CXCTABFACVENCIDOS_PROY where to_number(idfac) = to_number(v_idfac);

    if operacion.pq_corteservicio_cable.f_verificaVoz(c.nomabr) = 0 then -- se verifica si contiene un servicio de voz
      if( r_vencido.diasServ <= 6 ) then -- si el servicio tiene menos de 6 meses
        if ( collections.f_get_emitidos_A_LA_FECHA(r_vencido.codcli,r_vencido.nomabr,r_vencido.idfac, FEC_PROYECCION) >= 3 ) then -- si tiene más de tres adeudados
          insert into pretransacciones_CABLE_PROY
          select t.nomabr, t.sldact, t.codcli, t.nomcli, t.categoria, t.idfac, t.numdoc, t.fecemi, t.fecven, t.idcategoria, t.tipo
           from OPERACION.CXCTABFACVENCIDOS_PROY t where idfac = r_vencido.idfac;
         end if;
       else -- si el servicio tiene más de 6 meses
         if (trunc(FEC_PROYECCION) >= trunc(r_vencido.fecven+61) ) then -- si tiene más de 61 días de vencido el documento más antiguo.
           insert into pretransacciones_CABLE_PROY
           select t.nomabr, t.sldact, t.codcli, t.nomcli, t.categoria, t.idfac, t.numdoc, t.fecemi, t.fecven, t.idcategoria, t.tipo
           from OPERACION.CXCTABFACVENCIDOS_PROY t where idfac = r_vencido.idfac;
        end if;
      end if;
    else -- si tiene un servicio de voz
      if trunc(FEC_PROYECCION) > OPERACION.F_GET_FECHA_UTIL(r_vencido.fecven,15) then
        insert into pretransacciones_CABLE_PROY
        select t.nomabr, t.sldact, t.codcli, t.nomcli, t.categoria, t.idfac, t.numdoc,   t.fecemi, t.fecven, t.idcategoria, t.tipo
        from OPERACION.CXCTABFACVENCIDOS_PROY t where idfac = r_vencido.idfac;
      end if;
    end if;
  end if;
end loop;


end Sp_ReporteProyecciondeCortes;
/


