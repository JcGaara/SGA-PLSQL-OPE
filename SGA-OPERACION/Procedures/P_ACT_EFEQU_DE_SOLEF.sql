CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EFEQU_DE_SOLEF( an_codef ef.codef%type ) IS

max_orden efptoequ.orden%type;

cursor cur_equipos is
  SELECT vtadetslcfacequ.numpto punto,
         rownum orden,
         tipequ.codtipequ codtipequ,
         tipequ.tipequ tipequ,
         tipequ.costo costo,
         equcomxope.cantidad cantidad,
		 decode(producto.IDGRUPOPRODUCTO,1,1,2,2,1) tipprp,
		 vtadetslcfacequ.codequcom codequcom
    FROM (select numslc, numpto_prin numpto, codequcom,IDPRODUCTO from vtadetptoenl
          where numslc = LPAD(an_codef,10,'0')  and codequcom is not null) vtadetslcfacequ,
         equcomxope,
         tipequ,
         producto,
         ef
   WHERE vtadetslcfacequ.codequcom = equcomxope.codequcom and
         tipequ.tipequ = equcomxope.tipequ and
         vtadetslcfacequ.numslc = ef.numslc and
         vtadetslcfacequ.idproducto = producto.idproducto (+) and
         ef.codef = an_codef and
         1=1 and
		 equcomxope.esparte = 0
        AND TO_NUMBER(vtadetslcfacequ.numpto) IN (SELECT PUNTO FROM EFPTO WHERE CODEF = an_codef);

BEGIN

-- Se borra los equipos de los puntos que no encuentren en el pry
delete efptoequ where codef = an_codef and punto not in (SELECT PUNTO FROM EFPTO WHERE CODEF = AN_CODEF);

-- Se borra todo lo que sea CISCO y MOTOROLA, el resto queda
delete efptoequ where codef = an_codef and tipequ in (select tipequ from tipequ where grptipequ in (1,6) );

-- esto debria quedar igual
-- Se insertan los equipos
for row_equ in cur_equipos loop
-- Se obtiene el max orden para evitar dup de PK
  select nvl(max( orden) ,0) + 1 into max_orden from efptoequ where
  codef = an_codef and
  punto = row_equ.punto;

  insert into efptoequ(CODEF, PUNTO, ORDEN, CODTIPEQU,tipequ, TIPPRP, CANTIDAD, CODEQUCOM, costo)
  values (an_codef, row_equ.punto, max_orden, --			   + row_equ.orden,
  		  row_equ.codtipequ,row_equ.tipequ, row_equ.tipprp, row_equ.cantidad, row_equ.codequcom, row_equ.costo);

  -- Se insertan los componentes
  insert into efptoequcmp(CODEF, PUNTO, ORDEN, ORDENCMP, CANTIDAD, CODTIPEQU, tipequ, COSTO)
  select an_codef, row_equ.punto, max_orden, rownum, equcomxope.cantidad, equcomxope.codtipequ, equcomxope.tipequ, tipequ.costo
  from equcomxope, tipequ
  where equcomxope.CODEQUCOM = row_equ.codequcom and
        equcomxope.tipequ = tipequ.tipequ and
        equcomxope.esparte = 1;

end loop;

END;
/


