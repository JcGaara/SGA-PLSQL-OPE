CREATE OR REPLACE PROCEDURE OPERACION.P_MIGRAR_MATERIALES_2008(a_contratista varchar2) is
l_punto number;
l_punto_ori number;
l_punto_des number;
v_observacion varchar2(200);
l_consoteta  number;
l_orden number;
Cursor cur_data_contrata is
--Informacion de Materiales a Procesar para CSD
select idmaterial,fecha_doc,a.CODSOLOT,CLIENTE,MATERIAL,DESCRIPCION,a.cantidad,
(select count(*) from solotptoetamat ss, almtabmat mm where ss.codsolot = a.codsolot
  and trim(ss.codmat) = trim(mm.codmat) and trim(mm.cod_sap) = trim(a.material) ) ExisteMatSOT,
(select count(*) from almtabmat where trim(cod_sap) = trim(a.material)) ContAlmtabmat,
(select componente from almtabmat where trim(cod_sap) = trim(a.material)) Componente,
(select codmat from almtabmat where trim(cod_sap) = trim(a.material) ) Codmat,
(select preprm_usd from almtabmat where trim(cod_sap) = trim(a.material) ) Costo,
(select codeta from operacion.conf_comp_etapa aa, almtabmat bb
    where aa.componente = bb.componente and trim(bb.cod_sap) = trim(a.material) ) etapa,
a.nroserie nroserie_excel,B.NROSERIE nroserie_sga,b.centro, b.almacen,
(select tiptra from solot where codsolot = a.codsolot) tipotra,
(select t.alm_descripcion from z_mm_configuracion@pesgaprd t where t.centro = b.centro and t.almacen =b.almacen) centro_desc,
(SELECT descripcion from tiptrabajo where tiptra = (select tiptra from solot where codsolot = a.codsolot)) TIPOTRABAJO,
(select codcon from contrata where nombre = a.contrata) codcon
 from migracion.data_contrata a , operacion.maestro_series_equ b , solot c
 where A.contrata = a_contratista  and
 a.idmaterial < 300000
 AND upper(A.nroserie)  = upper(trim(b.nroserie(+))) and upper(trim(a.material)) = upper(trim(b.cod_sap(+)))
and  c.tiptra = 404 and a.material is not null and a.codsolot = c.codsolot(+);

begin

   for c_d in cur_data_contrata loop
      v_observacion := 'MIGRADO20090223';

      operacion.P_GET_PUNTO_PRINC_SOLOT(c_d.codsolot,l_punto,l_punto_ori,l_punto_des);
      if c_d.ExisteMatSOT = 0 and c_d.etapa is not null then
         select count(*) into l_consoteta  from solotptoeta
         where codsolot = c_d.codsolot and codeta = c_d.etapa;
         if l_consoteta = 0 then--no existe la etapa registrada
           SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from SOLOTPTOETA
           where codsolot = c_d.codsolot and punto = l_punto;
           insert into OPERACION.SOLOTPTOETA(codsolot,punto,orden,codeta,
           CODCON,fecdis,CODUSU)
           values(c_d.codsolot,l_punto,l_orden,c_d.etapa,c_d.codcon,
           c_d.fecha_doc,user || ' - ' || v_observacion);
         else
           select punto,orden into l_punto,l_orden from solotptoeta
           where codsolot = c_d.codsolot and codeta = c_d.etapa;
         end if;
         --Verificar si existe la etapa
         insert into OPERACION.SOLOTPTOETAMAT(codsolot,punto,orden,
         codmat,observacion,candis,cosdis,canliq,cosliq)
         values(c_d.codsolot,l_punto,l_orden,c_d.codmat,
         v_observacion,c_d.cantidad,c_d.costo,c_d.cantidad,c_d.costo);
         --update data_contrata set flg_proceso = 1 where idmaterial = c_d.idmaterial;
      end if;
   end loop;


end P_MIGRAR_MATERIALES_2008;
/


