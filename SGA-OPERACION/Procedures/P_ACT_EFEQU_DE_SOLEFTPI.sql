CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EFEQU_DE_SOLEFTPI( an_codef ef.codef%type ) IS

max_orden efptoequ.orden%type;
lnidpaq number;
l_conttpi number;
ls_tipsrv tystipsrv.tipsrv%type;
vreg efptoetaact%rowtype;

cursor cur_equipos is
  SELECT vtadetslcfacequ.numpto punto,
           rownum orden,
           tipequ.codtipequ codtipequ,
           tipequ.tipequ tipequ,
           vtadetslcfacequ.cantidad * tipequ.costo costo,
           vtadetslcfacequ.cantidad * equcomxope.cantidad cantidad,
           decode(producto.IDGRUPOPRODUCTO, 1, 1, 2, 2, 1) tipprp,
           vtadetslcfacequ.codequcom codequcom,
           (select max(codeta)
              from operacion.equipoxetapa x
             where x.idsolucion in (select idsolucion
                                      from vtatabslcfac
                                     where numslc = vtadetslcfacequ.numslc
                                    )
               and x.codequcom = vtadetslcfacequ.codequcom) codeta
      FROM (select numslc, numpto_prin numpto, codequcom, IDPRODUCTO, cantidad
              from vtadetptoenl
             where numslc = lpad(an_codef,10,'0')
               and codequcom is not null) vtadetslcfacequ,
           equcomxope,
           tipequ,
           producto,
           ef
     WHERE vtadetslcfacequ.codequcom = equcomxope.codequcom
       and tipequ.tipequ = equcomxope.tipequ
       and vtadetslcfacequ.numslc = ef.numslc
       and vtadetslcfacequ.idproducto = producto.idproducto(+)
       and ef.codef = an_codef
       and 1 = 1
       and equcomxope.esparte = 0;

cursor cur_act_xtpi is
select ve.numslc,min(ve.numpto) punto
from vtatabslcfac v, ef, vtadetptoenl ve, tystabsrv t,producto b
where ef.codef =  an_codef and
      ef.numslc = v.numslc and
      v.numslc = ve.numslc and
      ve.flgsrv_pri = 1 and
      ve.codsrv = t.codsrv and
      ve.idproducto =b.idproducto and
      (b.idtipinstserv=3 or b.idtipinstserv is null) and
      t.tipsrv in ('0059', '0062','0004')
 group by ve.numslc;

BEGIN

-- Se borra los equipos de los puntos que no encuentren en el pry
delete efptoequ where codef = an_codef and punto not in (SELECT PUNTO FROM EFPTO WHERE CODEF = AN_CODEF);

-- Se borra todo lo que sea CISCO y MOTOROLA, el resto queda
delete efptoequ where codef = an_codef and tipequ in (select tipequ from tipequ where grptipequ in (1,6) );
delete efptoetaact where codef = an_codef;
delete efptoeta where codef = an_codef;

-- esto debria quedar igual
-- Se insertan los equipos
for row_equ in cur_equipos loop
-- Se obtiene el max orden para evitar dup de PK
  select nvl(max( orden) ,0) + 1 into max_orden from efptoequ where
  codef = an_codef and
  punto = row_equ.punto;

  insert into efptoequ(CODEF, PUNTO, ORDEN, CODTIPEQU,tipequ, TIPPRP, CANTIDAD, CODEQUCOM, costo, codeta)
  values (an_codef, row_equ.punto, max_orden, --         + row_equ.orden,
        row_equ.codtipequ,row_equ.tipequ, row_equ.tipprp, row_equ.cantidad, row_equ.codequcom, row_equ.costo, row_equ.codeta);

  -- Se insertan los componentes
  insert into efptoequcmp(CODEF, PUNTO, ORDEN, ORDENCMP, CANTIDAD, CODTIPEQU, tipequ, COSTO, codeta)
  select an_codef, row_equ.punto, max_orden, rownum, equcomxope.cantidad, equcomxope.codtipequ, equcomxope.tipequ, tipequ.costo, row_equ.codeta
  from equcomxope, tipequ
  where equcomxope.CODEQUCOM = row_equ.codequcom and
        equcomxope.tipequ = tipequ.tipequ and
        equcomxope.esparte = 1;

end loop;

for row_act_tpi in cur_act_xtpi loop

    select count(idpaq) into l_conttpi from proyecto_tpi where numslc = an_codef;
    if l_conttpi >0 then
                 select idpaq into lnidpaq from proyecto_tpi where numslc = an_codef;
    end if;

    select tipsrv  into ls_tipsrv from vtatabslcfac where numslc = lpad(an_codef, 10, 0);

     if ls_tipsrv = '0059' then
              vreg.costo := 0;
              if lnidpaq in (23,28) then vreg.costo := 191.08;
              elsif lnidpaq in (24,29) then vreg.costo := 222.93;
              elsif lnidpaq in (25,30) then vreg.costo := 31.85;
              end if;
             vreg.moneda := 'D';
             vreg.codact :=4162;
             vreg.codprec :=2;
     end if;
    if ls_tipsrv = '0061' then
             vreg.costo := 80;
             vreg.moneda := 'S';
             vreg.codact :=11791;
             vreg.codprec :=7;
    end if;

    if vreg.moneda = 'D'  then
             vreg.moneda_id := 2;
    else vreg.moneda_id:=1;
    end if;

    if ls_tipsrv = '0059' or ls_tipsrv = '0061' then

          insert into efptoeta (codef, punto, codeta, cosmo)
          values (an_codef, row_act_tpi.punto, 645, vreg.costo);

          insert into efptoetaact (codef, punto, codeta, codact, costo, cantidad, moneda, moneda_id, codprec)
          values (an_codef, row_act_tpi.punto, 645, vreg.codact, vreg.costo, 1, vreg.moneda, vreg.moneda_id, vreg.codprec);

    end if;

end loop;
commit;
END;
/


