-- Created on 13/06/2016 by HITSS 
declare 
  -- Local variables here
  i_cont_tla integer;
  i_cont_tdl integer;
  i_cont_ttv integer;
begin
  -- Test statements here
  select count(*) into i_cont_tla from operacion.tipopedd where abrev = 'TIPEQU_LTE_ADICIONAL';
  if i_cont_tla = 0 then 
    insert into operacion.tipopedd(descripcion, abrev)
    values('Equipos LTE Adicional.', 'TIPEQU_LTE_ADICIONAL');
    commit;
    
    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', ( select tipequ from operacion.tipequ where upper(descripcion) = upper('DECODIFICADOR HD ARION AF-2710VHDPR') ), 'Deco HD', 'Deco HD', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_LTE_ADICIONAL' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', 7242, 'TARJETA SMART CARD CONAX', 'TARJETA SMART CARD CONAX', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_LTE_ADICIONAL' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', ( select tipequ from operacion.tipequ where upper(descripcion) = upper('DECODIFICADOR CD HANDAN CD-1004SN') ), 'DECO SD', 'DECO SD', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_LTE_ADICIONAL' ), null);
    commit;
  end if; 
  
  select count(*) into i_cont_tdl from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE';
  if i_cont_tdl = 0 then 
    insert into operacion.tipopedd(descripcion, abrev)
    values('Equipos LTE Adicional.', 'TIPEQU_DECO_LTE');
    commit;
    
    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', ( select tipequ from operacion.tipequ where upper(descripcion) = upper('EQUIPOS DIGITALES DECODIFICADORES;tander') ), 'EQUIPOS DIGITALES DECODIFICADORES;tander', 'EQUIPOS DIGITALES DECO', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', ( select tipequ from operacion.tipequ where upper(descripcion) = upper('DECODIFICADOR CD HANDAN CD-1004SN') ), 'DECODIFICADOR CD HANDAN CD-1004SN', 'DECO SD', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', ( select tipequ from operacion.tipequ where upper(descripcion) = upper('DECODIFICADOR HD ARION AF-2710VHDPR') ), 'DECODIFICADOR HD ARION AF-2710VHDPR', 'Deco HD', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( '209', ( select tipequ from operacion.tipequ where upper(descripcion) = upper('DECOD. ARION ARD-2810HP HD PVR 500GB HDD') ), 'DECOD. ARION ARD-2810HP HD PVR 500GB HDD', 'DECO GRABADOR HD (DVR) 3520', ( select tipopedd from operacion.tipopedd where abrev = 'TIPEQU_DECO_LTE' ), null);
    commit;

  end if; 
  
  select count(*) into i_cont_ttv from operacion.tipopedd where abrev = 'TIPTRAVALIDECO';
  if i_cont_ttv = 0 then 
    insert into operacion.tipopedd(descripcion, abrev)
    values('Equipos LTE Adicional.', 'TIPTRAVALIDECO');
    commit;
    
    insert into operacion.opedd (  codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( null, (select tiptra from tiptrabajo where upper(descripcion) = 'WLL/SIAC - TRASLADO EXTERNO'), 'WLL/SIAC - TRASLADO EXTERNO', null, ( select tipopedd from operacion.tipopedd where abrev = 'TIPTRAVALIDECO' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( null, (select tiptra from tiptrabajo where upper(descripcion) = 'WLL/SIAC - CAMBIO DE PLAN'), 'WLL/SIAC - CAMBIO DE PLAN', null, ( select tipopedd from operacion.tipopedd where abrev = 'TIPTRAVALIDECO' ), null);

    insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
    values ( null, (select tiptra from tiptrabajo where upper(descripcion) = 'INSTALACION 3 PLAY INALAMBRICO'), 'INSTALACION 3 PLAY INALAMBRICO', null, ( select tipopedd from operacion.tipopedd where abrev = 'TIPTRAVALIDECO' ), null);
    commit;
  end if; 
exception 
	when others then 
		rollback;
end;
/