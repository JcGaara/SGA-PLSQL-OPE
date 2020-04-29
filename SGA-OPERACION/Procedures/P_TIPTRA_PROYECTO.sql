CREATE OR REPLACE PROCEDURE OPERACION.P_TIPTRA_PROYECTO (a_numslc in vtatabslcfac.numslc%type)IS
  /******************************************************************************
     NAME:       P_TIPTRA_PROYECTO
     PURPOSE:    Asignacion del tipo de trabajo

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
    1.0         05/10/2009  Hector Huaman M  REQ-103745:Adiciono como parametro de entrada el numero de proyecto
    2.0         12/10/2011  Hector Huaman    SD-267367 Corregir tipo de dato al comparar el  valor de codsrv
    3.0         10/10/2017  Anderson Julca   Optimización del query y traslado de restricción de créditos hacia 
                                             la aprobación de la Oferta Comercial
  ******************************************************************************/
 cursor cur_aut is
 select c.paquete,trim(B.NUMSLC) numslc,c.codsrv, c.idproducto
      from vtatabslcfac B, vtadetptoenl C, tystabsrv E
      where
      /*to_number(B.numslc) not in (select codef from ef where codef = to_number(b.numslc))
      and */b.numslc = c.numslc
      and b.tipo in (0,5)
      and b.estsolfac in ('03')
      and c.codsrv = e.codsrv(+)
      -- ini 3.0
      AND b.tipsrv IN (SELECT o.codigoc FROM tipopedd t, opedd o WHERE t.tipopedd=o.tipopedd AND t.abrev='TIPSRV_CORP')
      AND TRUNC(b.fecapr)>=TRUNC(SYSDATE)-(SELECT TO_NUMBER(valor) FROM constante WHERE constante='IS_DIASDERIV')
      -- fin 3.0
      and c.flgsrv_pri=1
      and c.tiptra is null
      and b.numslc=a_numslc--<1.0>
      group by c.paquete,B.NUMSLC,c.codsrv,c.idproducto;

ln_valido number;
ln_valida_servicio number;
ln_contvalida number;
BEGIN
for l_sef in cur_aut loop
    ln_valido:=1;

    select count(b.numslc) into ln_contvalida
    from vtadetptoenl b,
    vtadetptoenl c,
    vtatabslcfac d,
    cxcpspchq e
    where
    d.numslc=b.numslc
    and c.numslc=b.numslc
    and c.flgsrv_pri=1
    and b.flgsrv_pri=1
    and c.codsrv<>b.codsrv
    and c.paquete=b.paquete
    and d.estsolfac in ('03')
    and d.tipo in (0,5)
    and c.tiptra is null
    and c.numslc = e.numslc
    and c.numslc=l_sef.numslc
    -- ini 3.0
    AND TRUNC(d.fecapr)>=TRUNC(SYSDATE)-(SELECT TO_NUMBER(valor) FROM constante WHERE constante='IS_DIASDERIV')
    -- fin 3.0
   and c.numslc not in (select codef from ef where codef = to_number(b.numslc));

        if ln_contvalida>0 then
        ln_valido:=0;
        end if;

    if ln_valido=1 then
        CASE
          --Professional Internet Access --Acceso Dedicado a Internet - Enlace Internacional
          WHEN l_sef.idproducto=527 or l_sef.idproducto=523 THEN
               update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
               commit;
          --Acceso Dedicado a Internet - Acceso a la red  (Enlace GPRS)
          WHEN l_sef.idproducto=520 THEN
                --if l_sef.codsrv= 4457 then 2.0
              if l_sef.codsrv= '4457' then
               update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
               commit;
              end if;
          --Alquiler de Equipos
          WHEN l_sef.idproducto=530 THEN
               update vtadetptoenl set tiptra=113 where numslc=l_sef.numslc and paquete=l_sef.paquete;
               commit;

           ---Servicios Adicionales
           WHEN l_sef.idproducto=521 or l_sef.idproducto=5 THEN
                --Derecho de Acceso Lectura SNMP de Router x Cliente --Derecho de Admin. de Router x Usuario del Cliente.
                --if l_sef.codsrv= 2108 or l_sef.codsrv= 1644 then 2.0
                if l_sef.codsrv= '2108' or l_sef.codsrv= '1644' then                
                update vtadetptoenl set tiptra=344 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
                end if;

                --Atención de Avería  --Visita Tecnica Extraordinaria
                --if l_sef.codsrv= 2544 or l_sef.codsrv= 3771  or l_sef.codsrv= 1905  or l_sef.codsrv= 164  or l_sef.codsrv= 3862 then 2.0
                if l_sef.codsrv= '2544' or l_sef.codsrv= '3771'  or l_sef.codsrv= '1905'  or l_sef.codsrv= '0164'  or l_sef.codsrv= '3862' then
                update vtadetptoenl set tiptra=191 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
                end if;

                --Servicio de Análisis de Tráfico de Red del Cliente
                ---if l_sef.codsrv= 4180  then 2.0
                if l_sef.codsrv= '4180'  then                
                update vtadetptoenl set tiptra=343 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
                end if;

               --Programacion de Router
               select count(*) into ln_valida_servicio
               from tystabsrv where
               codsrv=l_sef.codsrv
               and upper(dscsrv) like '%PROGRAMACION DE ROUTER%';

                if ln_valida_servicio>0   then
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
                ln_valida_servicio:=0;
                end if;

        --Value Added Teleconference
         WHEN l_sef.idproducto=605 THEN
               update vtadetptoenl set tiptra=114 where numslc=l_sef.numslc and paquete=l_sef.paquete;
               commit;
          --Telefonía Fija - Servicios Adicionales
          WHEN l_sef.idproducto=502 THEN
                --if l_sef.codsrv= 2544 or l_sef.codsrv= 3771  or l_sef.codsrv= 1905  or l_sef.codsrv= 164  or l_sef.codsrv= 3862 then 2.0
                if l_sef.codsrv= '2544' or l_sef.codsrv= '3771'  or l_sef.codsrv= '1905'  or l_sef.codsrv= '0164'  or l_sef.codsrv= '3862' then
                update vtadetptoenl set tiptra=191 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
                end if;
          --Servicios Adicionales - Internet
          WHEN l_sef.idproducto=682 THEN
                --if l_sef.codsrv= 2544 or l_sef.codsrv= 3771  or l_sef.codsrv= 1905  or l_sef.codsrv= 164  or l_sef.codsrv= 3862 then 2.0
                if l_sef.codsrv= '2544' or l_sef.codsrv= '3771'  or l_sef.codsrv= '1905'  or l_sef.codsrv= '0164'  or l_sef.codsrv= '3862' then                
                update vtadetptoenl set tiptra=191 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
                end if;
          --RPVL ACCESO
          WHEN l_sef.idproducto=708  THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --RPVN ACCESO
          WHEN l_sef.idproducto=727  THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --RPVL ACCESO Contingencia
          WHEN l_sef.idproducto=741  THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          -- RPVL ACCESO POS
          WHEN l_sef.idproducto=754 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --Red Privada Virtual - Acceso Local
          WHEN l_sef.idproducto=698 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Servicio E-mail
          WHEN l_sef.idproducto=524 THEN
                update vtadetptoenl set tiptra=85 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --Shared Server Hosting
          WHEN l_sef.idproducto=551 THEN
                update vtadetptoenl set tiptra=86 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Servicio 0800 Internacional
          WHEN l_sef.idproducto=721 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Servicio 0800 Local
          WHEN l_sef.idproducto=4 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          -- Servicio 0800 Local y Nacional
          WHEN l_sef.idproducto=689 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          -- Servicio 0800 Nacional
          WHEN l_sef.idproducto=688 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Servicio 0801 Local y Nacional
          WHEN l_sef.idproducto=725 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Servicios Adicionales 0 800
          WHEN l_sef.idproducto=6 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Servicios Adicionales 0 800
          WHEN l_sef.idproducto=751 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Telefonía Fija - Líneas Analógicas
          WHEN l_sef.idproducto=503 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Telefonía Fija - Líneas Digitales, DDR
          WHEN l_sef.idproducto=501 THEN
                update vtadetptoenl set tiptra=170 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Telefonía Fija - Líneas Digitales, E1-PRI
          WHEN l_sef.idproducto=500 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Bolsa de Minutos Internacional
          WHEN l_sef.idproducto=203 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Bolsa de Minutos Local
          WHEN l_sef.idproducto=703 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Bolsa de Minutos Local 0800
          WHEN l_sef.idproducto=743 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --Bolsa de Minutos Local Ant.
          WHEN l_sef.idproducto=204 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Bolsa de Minutos Nacional
          WHEN l_sef.idproducto=202 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Fax Server
          WHEN l_sef.idproducto=702 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --Local Private Lines - Puerta
          WHEN l_sef.idproducto=581 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --LPL - Puerta Remota
          WHEN l_sef.idproducto=686 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Fibra Oscura - Puerta Remota
          WHEN l_sef.idproducto=687 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --Dark Fiber Leasing
          WHEN l_sef.idproducto=604 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          --Venta de Equipos
          WHEN l_sef.idproducto=522 THEN
                update vtadetptoenl set tiptra=114 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --COMODATO
          WHEN l_sef.idproducto=694 THEN
                update vtadetptoenl set tiptra=113 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
          --Domestic IP Data - Enlace
          WHEN l_sef.idproducto=514 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Housing
          WHEN l_sef.idproducto=540 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Internacional Private Lines - Enlace
          WHEN l_sef.idproducto=583 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Internacional Private Lines - Puerta
          WHEN l_sef.idproducto=580 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Internet ADSL Telmex
          WHEN l_sef.idproducto=712 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Local IP Data - Puerta
          WHEN l_sef.idproducto=510 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Local IP Data - Puerta Remota
          WHEN l_sef.idproducto=683 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Local IP Data - PVC Adicional
          WHEN l_sef.idproducto=511 THEN
                update vtadetptoenl set tiptra=131 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

           --RPX ACCESO
          WHEN l_sef.idproducto=765 THEN
                update vtadetptoenl set tiptra=388 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Telefonía Fija - Lineas Analogicas Corporativas
          WHEN l_sef.idproducto=758 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;
           --Wholesale Interconection
          WHEN l_sef.idproducto=515 THEN
                update vtadetptoenl set tiptra=1 where numslc=l_sef.numslc and paquete=l_sef.paquete;
                commit;

          else
          ln_valido:= 0;
          END CASE;
  /* EXCEPTION case
             WHEN OTHERS THEN
             ln_valido:= 0; */
    end if;
end loop;

END;
/
