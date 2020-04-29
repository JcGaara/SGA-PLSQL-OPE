declare
  cursor tiptrabajo is
    select t.tiptra, t.descripcion
      from operacion.tiptrabajo t
     where t.tiptra in ('404','407','424','425','428','432','438','454','455','456','457','459','460','461','464','469','470','471','472',
                        '473','474','475','476','480','481','482','483','484','486','487','488','489','490','492','493','498','499','600',
                        '601','602','603','608','609','610','612','658','661','676','718','727','744','746','747','748','749','750','751',
                        '752','757','758','759','760','770','496');

  cursor estado_agendas is
    select t.estagendaini, t.estagendafin, t.tiptra, t.aplica_contrata, t.aplica_pext, t.estsol, t.usureg
      from operacion.SECUENCIA_ESTADOS_AGENDA t
     where t.tiptra = 407
       and t.estagendaini || '-' || t.estagendafin in
           ('1-2','1-36','1-34','4-2','4-34','16-2','16-34','22-2','22-34','36-2','36-34','40-2','41-2','43-2','44-2','45-2','51-2',
            '51-34','64-2','68-2','86-2')
      order by 1 asc;
  
  l_tipopedd tipopedd.tipopedd%type;
  l_count    pls_integer;
  l_tiptrabajo operacion.tiptrabajo.tiptra%type;
begin

  select t.tipopedd
    into l_tipopedd
    from operacion.tipopedd t
   where t.abrev = 'PRC_HFC_OPT_OV';

  for c_tiptrabajo in tiptrabajo loop
  
    select count(1)
      into l_count
      from operacion.tipopedd c, operacion.opedd d
     where c.abrev = 'PRC_HFC_OPT_OV'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'TIPTRA_OV'
       and d.codigon = c_tiptrabajo.tiptra;
  
    if l_count = 0 then
      insert into operacion.opedd
        (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
      values
        (c_tiptrabajo.tiptra,
         c_tiptrabajo.descripcion,
         'TIPTRA_OV',
         l_tipopedd,
         0);
    end if;
  
    select count(1)
      into l_count
      from operacion.tipopedd c, operacion.opedd d
     where c.abrev = 'PRC_HFC_OPT_OV'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'TIPTRA_VAL_OV'
       and d.codigon = c_tiptrabajo.tiptra;
  
    if l_count = 0 then
      insert into operacion.opedd
        (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
      values
        (c_tiptrabajo.tiptra,
         c_tiptrabajo.descripcion,
         'TIPTRA_VAL_OV',
         l_tipopedd,
         0);
    end if;
  
  end loop;


  -- Inserta estado de SOT (10 - Generada)
  insert into operacion.opedd
    (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (10, 'GENERADA', 'EST_SOT', l_tipopedd, 0);


  -- Inserta configuracion Mejoras Reclamos
  insert into tipopedd
    (DESCRIPCION, ABREV)
  values
    ('SIAC Reclamos', 'reclamos')
  returning tipopedd into l_tipopedd;

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     1,
     'La SOT no cuenta con Reclamo asociado',
     'msj_sot',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     2,
     'No esta permitido generar SOT para este tipo de Trabajo',
     'msj_sot',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 1, '127.0.0.1', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 2, 'SGA', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 3, 'GES_RECL', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 4, '127.0.0.1', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 5, '127.0.0.1', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 6, 'GES_RECL', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 7, 'E', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 8, '1', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 9, 'SIACREC', 'param_req', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 1, 'CERRADO', 'param_agenda', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 2, 'AMPLIADO', 'param_agenda', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 3, 'ACUMULAR', 'param_agenda', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 4, 'NO PRECISADO', 'param_agenda', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     1,
     'http://172.19.74.89:8909/ValidarCredencialesSUWS/ValidarCredencialesSUWSSB11?WSDL',
     'url_ws',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null,
     1,
     'No se realizó ZZ, favor realizarlo por SIAC.
Nro Caso: XX
Nro Reclamo: YY',
     'msj_agenda',
     l_tipopedd,
     1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 2, 'Actualización del Reclamo exitoso', 'msj_agenda', l_tipopedd, 1);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 1, '6', 'fase_averia', l_tipopedd, 1);  


  -- Inserta Tipos de Trabajo 
  insert into operacion.opedd
    (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (725, 'HFC - RECLAMO CLARO EMPRESAS', '', 1235, 1);
  insert into operacion.opedd
    (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (726, 'WIMAX - RECLAMO MANTENIMIENTO CLARO EMPRESAS', '', 1235, 1);
  insert into operacion.opedd
    (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (790, 'DTH - RECLAMO CLARO EMPRESAS', '', 1235, 1);
  insert into operacion.opedd
    (codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (791, 'WLL/SIAC - RECLAMO CLARO EMPRESAS', '', 1466, 6);


  -- Inserta Motivos de Trabajo
  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 144, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 146, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 148, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 141, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 142, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 143, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 149, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 45, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 35, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 664, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 145, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 147, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 651, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 648, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 660, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 647, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 652, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 653, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 843, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 831, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 163, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 684, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 679, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 839, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 826, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 976, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 977, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 123, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 116, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 186, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 41, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 663, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 665, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 979, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 978, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 980, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 937, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 117, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 673, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 131, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 662, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 935, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 986, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 854, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 121, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 115, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 120, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 122, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 646, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 678, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 969, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 961, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 28, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 931, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 677, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 159, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 151, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 152, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 150, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 153, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 156, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 535, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 533, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 527, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 845, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 846, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 534, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 524, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 541, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 824, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 526, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 525, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 522, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 675, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 656, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 674, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 667, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 611, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 668, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 661, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 666, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 659, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 671, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 670, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 650, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 155, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 49, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 596, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 157, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 158, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 154, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 205, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 206, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 50, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 597, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 201, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 204, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 257, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 390, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 174, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 336, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 341, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 283, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 311, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 183, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 185, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 391, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 392, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 258, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 381, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 382, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 259, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 349, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 350, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 351, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 385, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 386, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 343, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 178, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 162, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 339, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 397, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 399, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 166, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 182, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 320, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 329, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 400, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 401, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 869, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 167, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 168, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 294, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 315, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 164, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 165, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 268, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 176, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 177, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 346, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 175, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 181, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 316, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 179, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 345, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 306, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 297, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 321, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 357, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 326, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 273, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 328, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 247, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 334, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 313, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 274, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 307, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 277, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 863, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 866, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 864, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 188, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 862, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 865, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 603, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 169, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 301, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 870, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 855, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 877, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 170, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 171, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 250, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 161, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 249, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 335, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 264, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 379, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 380, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 251, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 254, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 263, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 365, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 366, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 369, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 325, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 359, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 364, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 275, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 324, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 160, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 370, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 278, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (407, 305, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 605, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 454, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 572, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 556, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 567, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 851, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 902, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 473, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 435, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 472, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 926, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 410, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 414, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 411, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 408, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 412, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 217, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 67, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 59, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 65, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 58, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 917, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 206, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 50, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 205, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 201, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 204, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 675, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 656, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 668, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 667, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 611, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 597, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 97, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 417, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 426, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 916, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 907, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 49, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 596, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 91, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 423, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 229, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 527, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 526, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 325, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 364, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 359, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 28, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 931, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 824, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 522, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 541, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 365, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 324, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 275, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 160, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 249, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 161, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 369, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 366, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 370, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 305, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 278, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 677, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 843, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 593, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 575, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 154, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 155, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 62, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 213, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 61, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 63, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 60, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 158, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 150, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 153, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 961, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 678, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 969, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 152, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 157, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 151, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 156, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 159, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 674, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 328, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 273, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 297, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 357, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 321, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 603, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 877, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 169, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 326, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 301, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 274, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 976, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 977, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 826, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 116, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 186, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 277, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 307, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 247, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 313, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 334, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 855, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 524, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 845, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 979, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 980, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 978, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 533, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 525, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 535, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 846, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 534, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 41, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 866, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 863, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 864, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 870, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 869, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 665, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 663, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 188, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 865, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 862, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 679, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 839, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 684, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 648, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 660, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 142, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 143, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 141, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 831, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 163, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 651, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 661, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 666, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 650, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 671, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 670, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 652, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 653, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 647, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 659, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 646, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 144, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 115, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 120, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 673, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 937, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 117, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 121, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 123, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 854, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 122, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 986, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 935, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 145, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 147, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 664, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 146, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 148, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 131, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 662, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 35, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 149, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 45, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 335, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 164, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 315, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 177, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 165, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 345, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 179, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 316, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 311, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 258, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 392, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 183, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 176, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 268, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 185, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 167, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 166, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 399, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 168, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 401, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 400, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 294, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 181, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 175, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 346, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 182, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 397, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 329, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 320, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 391, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 306, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 380, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 379, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 349, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 381, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 351, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 350, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 250, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 171, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 170, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 251, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 264, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 263, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 254, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 341, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 336, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 343, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 283, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 174, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 390, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 257, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 178, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 259, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 382, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 162, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 386, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 385, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (725, 339, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 188, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 441, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 866, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 168, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 167, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 847, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 149, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 186, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (726, 38, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 619, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 193, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 189, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 198, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 191, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 676, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 199, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 190, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 155, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 154, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 618, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 200, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 157, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 156, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 152, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 151, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 159, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 617, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 616, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 613, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 194, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 192, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 615, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 197, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (727, 196, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 999, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 376, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 188, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 248, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 866, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 976, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 148, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 664, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 144, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 146, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 986, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 186, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 147, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 149, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 181, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 175, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 168, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 167, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 385, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 386, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 164, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 183, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 706, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 379, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 382, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 251, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 254, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 132, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 401, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 178, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 162, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 142, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 206, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 626, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 639, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 830, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 155, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 541, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 547, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 205, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 703, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 704, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 995, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 141, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 701, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 711, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 713, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 705, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (752, 708, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 198, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 619, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 189, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 192, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 194, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 190, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 191, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 199, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 193, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 676, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 157, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 154, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 155, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 152, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 156, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 159, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 151, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 200, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 613, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 616, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 615, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 196, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 618, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 617, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (790, 197, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 382, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 178, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 162, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 251, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 254, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 379, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 155, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 626, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 547, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 385, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 386, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 541, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 149, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 986, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 186, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 664, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 708, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 147, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 866, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 376, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 248, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 976, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 999, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 188, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 205, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 148, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 183, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 164, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 142, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 144, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 146, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 168, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 401, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 132, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 175, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 181, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 167, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 703, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 713, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 711, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 206, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 830, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 639, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 704, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 701, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 141, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 706, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 705, user, sysdate);

  insert into operacion.mototxtiptra
    (TIPTRA, CODMOTOT, USUREG, FECREG)
  values
    (791, 995, user, sysdate);
    
  -- Insert de Estados de Agendamientos
  for c_estado_agendas in estado_agendas loop
    for l_tiptra in 1..5 loop
        if l_tiptra = 1 then
           l_tiptrabajo := 725;
        elsif l_tiptra = 2 then
           l_tiptrabajo := 752;
        elsif l_tiptra = 3 then
          l_tiptrabajo := 791;
        elsif l_tiptra = 4 then
          l_tiptrabajo := 727;
        elsif l_tiptra = 5 then
          l_tiptrabajo := 790;
        end if;
              
        select count(1)
          into l_count
          from operacion.SECUENCIA_ESTADOS_AGENDA t
         where t.estagendaini = c_estado_agendas.estagendaini
           and t.estagendafin = c_estado_agendas.estagendafin
           and t.tiptra = l_tiptrabajo;
      
        if l_count = 0 then
          insert into operacion.SECUENCIA_ESTADOS_AGENDA t
            (t.estagendaini,
             t.estagendafin,
             t.tiptra,
             t.aplica_contrata,
             t.aplica_pext,
             t.estsol)
          values
            (c_estado_agendas.estagendaini,
             c_estado_agendas.estagendafin,
             l_tiptrabajo,
             c_estado_agendas.aplica_contrata,
             c_estado_agendas.aplica_pext,
             c_estado_agendas.estsol);
        end if;
    end loop;
  end loop;
  
  update operacion.SECUENCIA_ESTADOS_AGENDA t
     set t.tipo = 'CLIENTE'
   where t.tiptra = 407
     and t.estagendaini || '-' || t.estagendafin in
         ('1-2','1-36','1-34','4-2','4-34','16-2','16-34','22-2','22-34','36-2','36-34','40-2','41-2',
          '43-2','44-2','45-2','51-2','51-34','64-2','68-2','86-2');
  
  -- Insert Motivos de Solucion
  insert into operacion.mot_solucionxtiptra t
    (t.tiptra,
     t.codmot_solucion,
     t.codmot_grupo,
     t.aplica_contrata,
     t.aplica_pext)
    select 752,
           t.codmot_solucion,
           t.codmot_grupo,
           t.aplica_contrata,
           t.aplica_pext
      from operacion.mot_solucionxtiptra t
     where t.tiptra = 407;

  insert into operacion.mot_solucionxtiptra t
    (t.tiptra,
     t.codmot_solucion,
     t.codmot_grupo,
     t.aplica_contrata,
     t.aplica_pext)
    select 791,
           t.codmot_solucion,
           t.codmot_grupo,
           t.aplica_contrata,
           t.aplica_pext
      from operacion.mot_solucionxtiptra t
     where t.tiptra = 407;

  insert into operacion.mot_solucionxtiptra t
    (t.tiptra,
     t.codmot_solucion,
     t.codmot_grupo,
     t.aplica_contrata,
     t.aplica_pext)
    select 727,
           t.codmot_solucion,
           t.codmot_grupo,
           t.aplica_contrata,
           t.aplica_pext
      from operacion.mot_solucionxtiptra t
     where t.tiptra = 498;

  insert into operacion.mot_solucionxtiptra t
    (t.tiptra,
     t.codmot_solucion,
     t.codmot_grupo,
     t.aplica_contrata,
     t.aplica_pext)
    select 790,
           t.codmot_solucion,
           t.codmot_grupo,
           t.aplica_contrata,
           t.aplica_pext
      from operacion.mot_solucionxtiptra t
     where t.tiptra = 498;
         
  commit;

end;
/
