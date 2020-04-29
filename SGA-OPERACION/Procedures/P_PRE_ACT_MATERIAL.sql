CREATE OR REPLACE PROCEDURE OPERACION.P_PRE_ACT_MATERIAL(a_codpre in number ) is

l_codsolot number;

cursor cur_mat is
  SELECT preubieta.codpre,
         preubieta.idubi,
         preubieta.codeta,
         slcpedmatdet.codmat
    FROM ot,
         preubi,
         preubieta,
         slcpedmatcab,
         slcpedmatdet
   WHERE ( preubieta.codpre = preubi.codpre ) and
         ( preubieta.idubi = preubi.idubi ) and
         ( slcpedmatcab.nroped = slcpedmatdet.nroped ) and
         ( slcpedmatcab.ordtra = ot.codot ) and
         ( slcpedmatcab.idubi = preubi.idubi ) and
         ( slcpedmatcab.codeta = preubieta.codeta ) and
         ( ( ot.codsolot = l_codsolot ) AND
         ( preubi.codpre = a_codpre )
         )
  minus
  SELECT preubietamat.codpre,
         preubietamat.idubi,
         preubietamat.codeta,
         preubietamat.codmat
    FROM preubietamat
    where codpre = a_codpre;


BEGIN

   select codsolot into l_codsolot from presupuesto
   where presupuesto.codpre = a_codpre;

  update preubietamat p set (canins_sol , canins_ate ) = (
    select sum(b.canped) ,sum(b.canate) from slcpedmatcab a,slcpedmatdet b, ot
  where ot.codsolot = l_codsolot and
         a.ordtra = ot.codot and
       p.idubi = a.idubi and
       p.codeta = a.codeta and
         p.codmat = b.codmat and
       a.nroped = b.nroped and
       p.contrata = 0)
   where p.codpre = a_codpre;

   commit;

/*
   -- Se insertan lo materiales que no figuran
   for lc1 in cur_mat loop

      insert into preubietamat ( CODPRE, IDUBI, CODETA, CODMAT )
      values ( a_codpre, lc1.idubi, lc1.codeta, lc1.codmat );

   end loop;


   -- se actualiza las cantidades

   update preubietamat pr set pr.CANINS_SOL = 0 , pr.CANINS_ATE = 0
   where pr.codpre = a_codpre;

  update preubietamat pr set ( pr.CANINS_SOL, pr.CANINS_ATE ) = (
    select sum(slcpedmatdet.canped) ,sum(slcpedmatdet.canate)
      FROM ot,
         preubi,
         preubieta,
         slcpedmatcab,
         slcpedmatdet
      WHERE
      preubieta.codpre = pr.codpre and
         preubieta.idubi = pr.idubi and
         preubieta.codeta = pr.codeta and
         slcpedmatdet.codmat = pr.codmat and
         ( preubieta.codpre = preubi.codpre ) and
         ( preubieta.idubi = preubi.idubi ) and
         ( slcpedmatcab.nroped = slcpedmatdet.nroped ) and
         ( slcpedmatcab.ordtra = ot.codot ) and
         ( slcpedmatcab.codinssrv = preubi.codinssrv ) and
         ( slcpedmatcab.codeta = preubieta.codeta ) and
         ( ot.codsolot = l_codsolot ) AND
         ( preubi.codpre = a_codpre )
   )
   where exists (
    select count(*)
      FROM ot,
         preubi,
         preubieta,
         slcpedmatcab,
         slcpedmatdet
      WHERE
      preubieta.codpre = pr.codpre and
         preubieta.idubi = pr.idubi and
         preubieta.codeta = pr.codeta and
         slcpedmatdet.codmat = pr.codmat and
         ( preubieta.codpre = preubi.codpre ) and
         ( preubieta.idubi = preubi.idubi ) and
         ( slcpedmatcab.nroped = slcpedmatdet.nroped ) and
         ( slcpedmatcab.ordtra = ot.codot ) and
         ( slcpedmatcab.codinssrv = preubi.codinssrv ) and
         ( slcpedmatcab.codeta = preubieta.codeta ) and
         ( ot.codsolot = l_codsolot ) AND
         ( preubi.codpre = a_codpre )
   ) ;

*/

EXCEPTION
     WHEN OTHERS THEN
       null;
END;
/


