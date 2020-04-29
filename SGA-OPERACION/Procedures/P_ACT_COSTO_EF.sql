CREATE OR REPLACE PROCEDURE OPERACION.p_act_costo_ef(an_codef in number) is
ln_porcosmocli number;
ln_porcosmatcli number;
ln_cosmo number;
ln_cosmat number;
ln_cosequ number;
ln_pymes_camp_ar number;

begin

-- inicializa los valores
update efptoeta set
cosmat = 0,
cosmo = 0,
cosmat_s = 0,
cosmo_s = 0
where codef = an_codef;

-- se actualiza con el resto de los valores
update efptoeta set
cosmat = (select EFptoeta.cosmat + nvl(sum(a.COSto * a.cantidad),0)
    FROM EFptoetamat a
   WHERE a.CODEF = EFptoeta.CODEF AND
         a.PUNTO = EFptoeta.punto AND
         a.CODETA = EFptoeta.codeta  ),
cosmo =  (select EFptoeta.cosmo + nvl(sum(a.COSto * a.cantidad),0)
    FROM EFptoetaact a
   WHERE a.CODEF = EFptoeta.CODEF AND
         a.PUNTO = EFptoeta.punto AND
         a.CODETA = EFptoeta.codeta  and
         a.moneda_id = 2 ),
cosmo_s =  (select EFptoeta.cosmo + nvl(sum(a.COSto * a.cantidad),0)
    FROM EFptoetaact a
   WHERE a.CODEF = EFptoeta.CODEF AND
         a.PUNTO = EFptoeta.punto AND
         a.CODETA = EFptoeta.codeta and
         a.moneda_id = 1 )
where codef = an_codef;
/*
-- se actualiza con los valores que pagara el cliente y la empresa
update efptoeta set
cosmatcli = (select efptoeta.cosmat * a.porcosmatcli from etapa a where efptoeta.codeta = a.codeta) ,
cosmocli = (select efptoeta.cosmo * a.porcosmocli from etapa a where efptoeta.codeta = a.codeta)
where codef = an_codef;
*/

-- costo por punto
update efpto set
cosmat = (select nvl(sum(a.cosmat),0)
    from efptoeta a
   where   a.codef = efpto.codef  and
          a.punto = efpto.punto ),
cosmo = (select nvl(sum(a.cosmo),0)
    from efptoeta a
   where a.codef = efpto.codef  and
         a.punto = efpto.punto  ),
cosmat_S = (select nvl(sum(a.cosmat_S),0)
    from efptoeta a
   where  a.codef = efpto.codef  and
         a.punto = efpto.punto  ),
cosmo_S = (select nvl(sum(a.cosmo_S),0)
    from efptoeta a
   where a.codef = efpto.codef  and
         a.punto = efpto.punto  ),
cosequ = (select nvl(sum(b.costo * b.cantidad * a.cantidad),0)
    from efptoequ a, efptoequcmp b
   where a.codef = efpto.codef  and
         a.punto = efpto.punto and
     b.costear = 1 and
     a.codef = b.codef  and
         a.punto = b.punto and
     a.orden = b.orden )
where codef = an_codef;


update efpto set
cosequ = (select nvl(sum(a.costo * a.cantidad),0) + cosequ
    from efptoequ a
   where a.codef = efpto.codef  and
         a.punto = efpto.punto and
     a.costear = 1 )
where codef = an_codef;


-- costo por orden
update ef set
cosmat = (select nvl(sum(a.cosmat),0)
    from efpto a
   where  a.codef = ef.codef ),
cosmo = (select nvl(sum(a.cosmo),0)
    from efpto a
   where a.codef = ef.codef  ),
cosmat_S = (select nvl(sum(a.cosmat_S),0)
    from efpto a
   where a.codef = ef.codef  ),
cosmo_S = (select nvl(sum(a.cosmo_S),0)
    from efpto a
   where a.codef = ef.codef  ),
cosequ = (select nvl(sum(a.cosequ),0)
    from efpto a
   where a.codef = ef.codef  )
where codef = an_codef;

  SELECT F_VERIFICA_CAMPANHA_PYMES_AR(lpad(an_codef,10,0))
   INTO ln_pymes_camp_ar
   FROM dual;

   if ln_pymes_camp_ar=1 then
   P_ACT_EF_AR_EF(an_codef);
   end if;
end;
/


