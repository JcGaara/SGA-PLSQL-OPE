CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_DERIVACION_SEF AS


FUNCTION F_VALIDA_INSTALACION_SEF(an_numslc NUMBER)RETURN VARCHAR2 is
an_adi_ar_grupo NUMERIC;
an_adi_ar_idproducto NUMERIC;
an_adi_ei_grupo NUMERIC;
an_adi_ei_idproducto NUMERIC;

an_valida numeric;

BEGIN

/*BEGIN
--Instalacion(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;*/
--Acceso Dedicado a Internet - Acceso a la red

BEGIN
select
a.paquete,b.idproducto into
an_adi_ar_grupo,an_adi_ar_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=520
       and rownum=1;
exception
   when no_data_found then
      an_adi_ar_grupo:=null;
      an_adi_ar_idproducto:=null;
end;
--Acceso Dedicado a Internet - Enlace Internacional
BEGIN
select
      a.paquete, b.idproducto into
      an_adi_ei_grupo,an_adi_ei_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=527
       and rownum=1;
exception
   when no_data_found then
      an_adi_ei_grupo:=null;
      an_adi_ei_idproducto:=null;
end;
--IF an_tiptra is null THEN
        IF ((an_adi_ar_grupo =an_adi_ei_grupo ) and (an_adi_ei_idproducto is not null  and an_adi_ar_idproducto is not null ) ) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
--ELSE
--an_valida:=0;
--END IF;

RETURN(an_valida);
END;


FUNCTION F_INSTALACION_COLOCATION_SEF(an_numslc NUMBER)RETURN VARCHAR2 is
an_colocation NUMERIC;
an_valida numeric;

BEGIN

/*BEGIN
--Instalacion(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;*/

--Internet Colocation
select
count(*) into
an_colocation
from     vtadetptoenl a,
         tystabsrv t
where


       a.numslc =an_numslc
       and a.codsrv=t.codsrv
       and upper(t.dscsrv) like '%COLOCATION%' ;


--IF an_tiptra is null THEN
        IF an_colocation>0 THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
/*ELSE
an_valida:=0;
END IF;*/

RETURN(an_valida);
END;


FUNCTION F_VALIDA_DIRECCION_SEF(an_numslc NUMBER)RETURN VARCHAR2 is
an_direccion NUMERIC;
an_valida numeric;

BEGIN

/*BEGIN
--Instalacion(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;*/

--Direcciones
--INCA GARCILASO DE LA VEGA 1251
--INCA GARCILASO DE LA VEGA 1249
select
count(*) into
an_direccion
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and (upper(a.dirpto) like '%INCA%GARCILASO%DE%LA%VEGA%1251%'
       or upper(a.dirpto) like  '%INCA%GARCILASO%DE%LA%VEGA%1249%');


--IF an_tiptra is null THEN
        IF an_direccion>0 THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
--ELSE
--an_valida:=0;
--END IF;

RETURN(an_valida);
END;

FUNCTION F_VALIDA_VISITA_TEC(an_numslc NUMBER)RETURN VARCHAR2 is
an_contador NUMERIC;
an_tiptra numeric;
an_valida numeric;

BEGIN

BEGIN
--VISITA TECNICA/CONSULTORIA(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;
--Atención de Avería
--Visita Tecnica Extraordinaria

select
count(*) into
an_contador
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=521
       and a.codsrv in(3862,1905,4459,164,2544,3771)
       and rownum=1;

IF an_tiptra is null THEN
        IF an_contador>0 THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
ELSE
an_valida:=0;
END IF;

RETURN(an_valida);
END;

FUNCTION F_VALIDA_DERECHO_ADM(an_numslc NUMBER)RETURN VARCHAR2 is
an_contador NUMERIC;
an_tiptra numeric;
an_valida numeric;

BEGIN

BEGIN
--VISITA TECNICA/CONSULTORIA(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;
--Atención de Avería
--Visita Tecnica Extraordinaria

select
count(*) into
an_contador
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=521
       and a.codsrv in(2108,1644)
       and rownum=1;


IF an_tiptra is null THEN
        IF an_contador>0 THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
ELSE
an_valida:=0;
END IF;

RETURN(an_valida);
END;


FUNCTION F_VALIDA_ALQ_CONFI(an_numslc NUMBER)RETURN VARCHAR2 is
an_contador_config NUMERIC;
an_contador_alquiler NUMERIC;
an_contador_servicio NUMERIC;
an_tiptra numeric;
an_valida numeric;

BEGIN

BEGIN
--VISITA TECNICA/CONSULTORIA(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;
--VERIFICA SI ES INSTALACION
select
     count(*) into
      an_contador_servicio
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc;


--TOTAL SERVICIOS ALQUILER DE EQUIPOS
select
count(*) into
an_contador_alquiler
from     vtadetptoenl v,
tystabsrv t
where
       t.codsrv=v.codsrv
       and t.idproducto=530
       and v.numslc =an_numslc
       and v.crepto = '1'
       and  (( codequcom is null ) or (codequcom is not null and numpto = numpto_prin ));

--TOTAL SERVICIOS CONFIGURACION
select
count(*) into
an_contador_config
from     vtadetptoenl v,
tystabsrv t
where
       t.codsrv=v.codsrv
       and upper(t.dscsrv) like '%PROGRAMACION%DE%ROUTER%'
       and t.idproducto IN (5,521)
       and v.numslc =an_numslc
       and v.crepto = '1'
       and  (( codequcom is null ) or (codequcom is not null and numpto = numpto_prin ));


IF an_tiptra is null THEN
        IF (an_contador_config>0 or an_contador_alquiler>0)and (an_contador_servicio=an_contador_config+an_contador_alquiler) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
ELSE
an_valida:=0;
END IF;

RETURN(an_valida);
END;


FUNCTION F_VALIDA_ANALISIS_RED(an_numslc NUMBER)RETURN VARCHAR2 is
an_contador NUMERIC;
an_tiptra numeric;
an_valida numeric;

BEGIN

BEGIN
--ANALISIS DE RED(no tiene tiptra)
select
a.tiptra into
an_tiptra
from     vtadetptoenl a
where
       a.numslc =an_numslc
       and rownum=1;
exception
   when no_data_found then
      an_tiptra:=null;
end;
--Servicio de Análisis de Tráfico de Red del Cliente

select
count(*) into
an_contador
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=521
       and a.codsrv in(4180)
       and rownum=1;


IF an_tiptra is null THEN
        IF an_contador>0 THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;
ELSE
an_valida:=0;
END IF;

RETURN(an_valida);
END;



FUNCTION F_INS_RPVL_ACCESO(an_numslc NUMBER)RETURN VARCHAR2 is
--5.1
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2008  Hector Huaman M.  Valida que los grupos donde esté registrado el Producto: "RPVL ACCESO" como INSTALACION, tenga asociado : "RPVL CoS1", "RPVL CoS2" o "RPVL CoS3"
******************************************************************************/
an_ra_grupo NUMERIC;
an_ra_idproducto NUMERIC;
an_rpvl_idproducto NUMERIC;

an_valida numeric;

BEGIN
--RPVL ACCESO
BEGIN
select
a.paquete,b.idproducto into
an_ra_grupo,an_ra_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=708
       and rownum=1;
exception
   when no_data_found then
      an_ra_grupo:=null;
      an_ra_idproducto:=null;
end;
--RPVL CoS1 --RPVL CoS2 --RPVL CoS3
BEGIN
select
       b.idproducto into
       an_rpvl_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and a.paquete=an_ra_grupo
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto in(709,710,711)
       and rownum=1;
exception
   when no_data_found then
      an_rpvl_idproducto:=null;
end;

        IF (( an_ra_grupo is not null) and (an_ra_idproducto is not null  and an_rpvl_idproducto is not null ) ) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;


RETURN(an_valida);
END;

FUNCTION F_INS_RPVL_ACCESO_CON(an_numslc NUMBER)RETURN VARCHAR2 is
--5.2
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2008  Hector Huaman M. Valida que los grupos donde esté registrado el Producto: "RPVL ACCESO Contingencia"  como INSTALACION, tenga asociado : "RPVL CoS1", "RPVL CoS2" o "RPVL CoS3"
******************************************************************************/
an_ra_grupo NUMERIC;
an_ra_idproducto NUMERIC;
an_rpvl_idproducto NUMERIC;

an_valida numeric;

BEGIN
--RPVL ACCESO Contingencia
BEGIN
select
a.paquete,b.idproducto into
an_ra_grupo,an_ra_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=741
       and rownum=1;
exception
   when no_data_found then
      an_ra_grupo:=null;
      an_ra_idproducto:=null;
end;
--RPVL CoS1 --RPVL CoS2 --RPVL CoS3
BEGIN
select
       b.idproducto into
       an_rpvl_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and a.paquete=an_ra_grupo
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto in(709,710,711)
       and rownum=1;
exception
   when no_data_found then
      an_rpvl_idproducto:=null;
end;

        IF (( an_ra_grupo is not null) and (an_ra_idproducto is not null  and an_rpvl_idproducto is not null ) ) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;


RETURN(an_valida);
END;

FUNCTION F_INS_RPVL_ACCESO_POS(an_numslc NUMBER)RETURN VARCHAR2 is
--6
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2008  Hector Huaman M.  Valida que los grupos donde esté registrado el Producto: "RPVL ACCESO POS" como INSTALACION, tenga asociado a su mismo grupo una etiqueta del Producto: "RPVL CoS2".
******************************************************************************/
an_ra_grupo NUMERIC;
an_ra_idproducto NUMERIC;
an_rpvl_idproducto NUMERIC;

an_valida numeric;

BEGIN
--RPVL ACCESO POS
BEGIN
select
a.paquete,b.idproducto into
an_ra_grupo,an_ra_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=754
       and rownum=1;
exception
   when no_data_found then
      an_ra_grupo:=null;
      an_ra_idproducto:=null;
end;
--RPVL CoS2
BEGIN
select
       b.idproducto into
       an_rpvl_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and a.paquete=an_ra_grupo
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto in(710)
       and rownum=1;
exception
   when no_data_found then
      an_rpvl_idproducto:=null;
end;

        IF (( an_ra_grupo is not null) and (an_ra_idproducto is not null  and an_rpvl_idproducto is not null ) ) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;


RETURN(an_valida);
END;

FUNCTION F_INS_RPVN_ACCESO(an_numslc NUMBER)RETURN VARCHAR2 is
--7
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2008  Hector Huaman M.  Valida que los grupos donde esté registrado el Producto: RPVN ACCESO  como INSTALACION, tenga asociado : "RPVN CoS1", "RPVN CoS2" o "RPVN CoS3"
******************************************************************************/
an_ra_grupo NUMERIC;
an_ra_idproducto NUMERIC;
an_rpv_idproducto NUMERIC;

an_valida numeric;

BEGIN
--RPVN ACCESO
BEGIN
select
a.paquete,b.idproducto into
an_ra_grupo,an_ra_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=727
       and rownum=1;
exception
   when no_data_found then
      an_ra_grupo:=null;
      an_ra_idproducto:=null;
end;
--RPVN CoS1 --RPVN CoS2 --RPVN CoS3
BEGIN
select
       b.idproducto into
       an_rpv_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and a.paquete=an_ra_grupo
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto in(728,729,730)
       and rownum=1;
exception
   when no_data_found then
      an_rpv_idproducto:=null;
end;

        IF (( an_ra_grupo is not null) and (an_ra_idproducto is not null  and an_rpv_idproducto is not null ) ) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;


RETURN(an_valida);
END;

FUNCTION F_INS_TELEFONIA_E1PRI(an_numslc NUMBER)RETURN VARCHAR2 is
--2
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2008  Hector Huaman M.  Valida que los grupos donde esté registrado el Producto: "Telefonía Fija - Líneas Digitales, E1-PRI" como INSTALACION, tenga asociado a su mismo grupo otra etiqueta del Producto: "Telefonía Fija - Número de Canales".
******************************************************************************/
an_ra_grupo NUMERIC;
an_ra_idproducto NUMERIC;
an_tel_idproducto NUMERIC;
l_countInstalacionTelef NUMERIC;
l_countnumeroadicional NUMERIC;
an_valida numeric;

BEGIN
--Telefonía Fija - Líneas Digitales, E1-PRI
BEGIN
select
a.paquete,b.idproducto into
an_ra_grupo,an_ra_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=500
       and rownum=1;
exception
   when no_data_found then
      an_ra_grupo:=null;
      an_ra_idproducto:=null;
end;
--Telefonía Fija - Número de Canales
BEGIN
select
       b.idproducto into
       an_tel_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and a.paquete=an_ra_grupo
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto in(504)
       and rownum=1;
exception
   when no_data_found then
      an_tel_idproducto:=null;
end;

--Valida cantidad de grupos que tengan el Producto: "Telefonía Fija - Líneas Digitales, E1-PRI" como INSTALACION, sea la misma que la cantidad de grupos con el TipTrab NUMEROS ADICIONALES
select  count(distinct v.grupo) into l_countInstalacionTelef
from vtadetptoenl v where v.numslc=an_numslc and tiptra=1;

select  count(distinct v.grupo) into l_countnumeroadicional
from vtadetptoenl v where v.numslc=an_numslc and tiptra=170;

        IF (( an_ra_grupo is not null) and (an_ra_idproducto is not null  and an_tel_idproducto is not null ) and (l_countInstalacionTelef =l_countnumeroadicional )) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;



RETURN(an_valida);
END;

FUNCTION F_INS_RPV_ACCESO(an_numslc NUMBER)RETURN VARCHAR2 is
--4
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2008  Hector Huaman M.  Valida que los grupos donde esté registrado el Producto: "Red Privada Virtual - Acceso Local" como INSTALACION, tenga asociado a su mismo grupo etiquetas de los Productos: "Red Privada Virtual - Calidades de Servicio" y "Red Privada Virtual - Puerto" .
******************************************************************************/
an_ra_grupo NUMERIC;
an_ra_idproducto NUMERIC;
an_rpv_idproducto NUMERIC;

an_valida numeric;

BEGIN
--Red Privada Virtual - Acceso Local
BEGIN
select
a.paquete,b.idproducto into
an_ra_grupo,an_ra_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto=698
       and rownum=1;
exception
   when no_data_found then
      an_ra_grupo:=null;
      an_ra_idproducto:=null;
end;
--Red Privada Virtual - Calidades de Servicio
BEGIN
select
       b.idproducto into
       an_rpv_idproducto
from     vtadetptoenl a,
       producto b,
       tiptrabajo e
where
        a.idproducto = b.idproducto and
        a.tiptra = e.tiptra(+) and
        a.crepto = '1'
        and a.paquete=an_ra_grupo
        and  (( codequcom is null )or(codequcom is not null and numpto = numpto_prin ))
       and a.numslc =an_numslc
       and b.idproducto in(696)
       and rownum=1;
exception
   when no_data_found then
      an_rpv_idproducto:=null;
end;

        IF (( an_ra_grupo is not null) and (an_ra_idproducto is not null  and an_rpv_idproducto is not null ) ) THEN
        an_valida:=1;
        ELSE
        an_valida:=0;
        END IF;


RETURN(an_valida);
END;



END;
/


