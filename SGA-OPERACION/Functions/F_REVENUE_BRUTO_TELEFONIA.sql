CREATE OR REPLACE FUNCTION OPERACION.f_revenue_bruto_telefonia( an_codef in number)  RETURN NUMBER IS

SALIDA NUMBER(15,2);
l_numpsp vtatabpspcli.numpsp%type;
l_idopc vtatabpspcli.idopc%type;
l_numlinea number;
l_minxlinea number;
l_ratio number;
l_traficoD number;
l_minxproc number;
l_preoutd number(15,4);
l_preoutn number(15,4);
l_preintd number(15,4);
l_preintn number(15,4);
l_basica number (15,4);
l_mintot number (15,4);
l_mindiu number (15,4);
l_minnoc number (15,4);
l_sumtrafico number(15,4);
l_suminter number(15,4);
l_sumbasica number(15,4);
l_sumproc number(15,4);
BEGIN
--Se definen las constantes
   l_minxlinea := 600;
   select valor into l_ratio from constante where constante = 'RATIO';
   select valor into l_traficoD from constante where constante = 'TRAFDIUR';
   select valor into l_minxproc from constante where constante = 'AVEMIN';
   select valor into l_preoutd from constante where constante = 'POUTDIU';
   select valor into l_preoutn from constante where constante = 'POUTNOC';
   select valor into l_preintd from constante where constante = 'PINTDIU';
   select valor into l_preintn from constante where constante = 'PINTNOC';
   select valor into l_basica from constante where constante = 'PBASICO';

--Nro lineas
   select sum(nrocanal) into l_numlinea
      from efpto
      where codef = an_codef;
   l_mintot := l_minxlinea * l_numlinea;
   l_mindiu := l_mintot * l_traficoD;
   l_minnoc := l_mintot - l_mindiu;

   l_sumtrafico := l_mindiu * l_preoutd + l_minnoc * l_preoutn;
   l_suminter := (l_mindiu / l_ratio ) * l_preintd + (l_minnoc / l_ratio) * l_preintn;
   l_sumbasica := l_basica * l_numlinea;
   l_sumproc := (l_mindiu / l_minxproc)* l_preoutd + (l_minnoc / l_minxproc)* l_preoutn;
   salida := l_sumtrafico + l_suminter + l_sumbasica + l_sumproc;
   RETURN salida;

exception
  when others then
   return null;

END;
/


