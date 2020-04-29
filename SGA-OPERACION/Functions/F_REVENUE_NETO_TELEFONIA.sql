CREATE OR REPLACE FUNCTION OPERACION.f_revenue_neto_telefonia(an_codef in number)  RETURN NUMBER IS

SALIDA NUMBER(15,2);
l_numpsp vtatabpspcli.numpsp%type;
l_idopc vtatabpspcli.idopc%type;
l_numlinea number;
l_minxlinea number;
l_ratio number;
l_revenuebruto number(15,4);
l_costo number;
l_traficoD number;
l_preoutd number(15,4);
l_preoutn number(15,4);
l_mintot number (15,4);
l_mindiu number(15,4);
l_minnoc number(15,4);
l_inter number(15,4);
l_mant number(15,4);
l_deudas number(15,4);
l_comitrafico number(15,4);
l_comilinea number(15,4);
l_advertising number(15,4);
l_otros number(15,4);

BEGIN
--Se definen las constantes
   l_minxlinea := 600;
   select valor into l_traficoD from constante where constante = 'TRAFDIUR';
   select valor into l_preoutd from constante where constante = 'POUTDIU';
   select valor into l_preoutn from constante where constante = 'POUTNOC';
--Otras variables
   select valor into l_inter from constante where constante = 'PINTER';
   select valor into l_mant from constante where constante = 'PMANTE';
   select SUM(valor) into l_deudas from constante where constante = 'DEUDAS' or
                                                        constante = 'MARCA' or
                                                        constante = 'FITEL' or
                                                        constante = 'OPSITEL';
   select valor into l_comitrafico from constante where constante = 'COMTRAFICO';
   select valor into l_comilinea from constante where constante = 'COMLINEA';
   select valor into l_advertising from constante where constante = 'ADVLINEA';

--Nro lineas
   select sum(nrocanal) into l_numlinea
      from efpto
      where codef = an_codef;

   l_mintot := l_minxlinea * l_numlinea;
   l_mindiu := l_mintot * l_traficoD;
   l_minnoc := l_mintot - l_mindiu;

   select f_revenue_bruto_telefonia(an_codef) into l_revenuebruto from dual;
   l_otros := ((l_comilinea + l_advertising) * l_numlinea) /24;
   l_costo := l_inter * l_mintot + l_mant * l_numlinea +  l_deudas * l_revenuebruto + l_comitrafico * (l_mindiu * l_preoutd + l_minnoc * l_preoutn);

   salida := l_revenuebruto - l_costo - l_otros;
   RETURN salida;

exception
  when others then
   return null;

END;
/


