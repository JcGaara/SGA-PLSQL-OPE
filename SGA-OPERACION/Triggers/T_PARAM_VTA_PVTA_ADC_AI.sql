CREATE OR REPLACE TRIGGER OPERACION.T_PARAM_VTA_PVTA_ADC_AI
  AFTER INSERT  ON OPERACION.parametro_vta_pvta_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/**************************************************************************
   NOMBRE:     parametro_vta_pvta_adc_AI
   PROPOSITO:  Actualizar vtasuccli

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        22/06/2015                    Se actualizara el plano y la poblacion
   **************************************************************************/
DECLARE
ln_val_nslc number;
cursor sucursal is
select distinct d.codsuc
from vtadetptoenl d ,solot s, inssrv i
where  d.numslc = i.numslc
and d.numpto = i.numpto
and s.numslc = i.numslc
and s.codsolot = :new.codsolot;
cursor sucursal2 is
select distinct d.codsuc
  from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
 where a.codsolot = :new.codsolot
   and a.codcli = b.codcli(+)
   and a.codsolot = c.codsolot(+)
   and c.codinssrv = d.codinssrv(+)
   and d.codsuc = e.codsuc(+);
BEGIN
  select count(1)
    into ln_val_nslc
    from sales.vtatabslcfac vs 
   where vs.numslc=(select numslc 
                      from operacion.solot s 
                     where s.codsolot=:new.codsolot);
  if ln_val_nslc>0 then
     FOR lista IN sucursal LOOP
           update vtasuccli t
              set t.idplano = :new.plano, t.fecultact=sysdate
            WHERE t.codsuc = lista.codsuc
              AND t.idplano is null;

           update vtasuccli t
              set t.ubigeo2 = :new.idpoblado, t.fecultact=sysdate
            WHERE t.codsuc = lista.codsuc
              AND t.ubigeo2 is null; 
     END LOOP;
  else
     for lista2 in sucursal2 loop
           update vtasuccli t
              set t.idplano = :new.plano, t.fecultact=sysdate
            WHERE t.codsuc = lista2.codsuc
              AND t.idplano is null;
           
           update vtasuccli t
              set t.ubigeo2 = :new.idpoblado, t.fecultact=sysdate
            WHERE t.codsuc = lista2.codsuc
              AND t.ubigeo2 is null;

     end loop;
  end if;
END;
/
