declare
  ln_max_tipopedd   number;
  ln_max_opedd      number;
  maxidlista        number;
  maxidcampo        number;
  maxordentel       number;
  maxordenint       number;
  maxordentv        number;
  maxordenftthint   number;
  maxordenftthtel   number;
begin
 select max(TIPOPEDD) + 1 into ln_max_tipopedd from operacion.tipopedd;
 insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
 values (ln_max_tipopedd, 'Provisión Telefonía FTTH', 'PROCESO_PROV_TLF_FTTH');
 select max(IDOPEDD) + 1 into ln_max_opedd from operacion.opedd;
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd, '1:Activo, 0:Inactivo', 1, 'Asignar número y actualizar ficha técnica', 'ACT_NUM_FT', ln_max_tipopedd, 1);
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd+1, '1:Activo, 0:Inactivo', 2, 'Actualizar modelo ONT', 'ACT_MODEL_ONT', ln_max_tipopedd, 1);
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd+2, '1:Activo, 0:Inactivo', 3, 'Obtener Pass de PINDB y actualiza FT', 'OBT_PASS_PINDB', ln_max_tipopedd,1);
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd+3, '1:Activo, 0:Inactivo', 4, 'Activar TLF', 'ACT_TLF', ln_max_tipopedd, 1);
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd+4, '1:Activo, 0:Inactivo', 5, 'Actualizar Ficha(pass - *)', 'ACT_FT_PASS', ln_max_tipopedd, 1);
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd+5, '1:Activo, 0:Inactivo', 6, 'select replace(:1,:2,''********'') from dual', 'Actualiza_Ficha_JSON_PASS', ln_max_tipopedd, 0);
 insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
 values ( ln_max_opedd+6, '1:Activo, 0:Inactivo', 7, 'Generar reserva BSCS', 'GEN_RES_BSCS', ln_max_tipopedd, 1);
 update ft_campo set valorcampo = 'select DBMS_RANDOM.STRING (''x'', 32) from dual', tipo = 2
 where iddocumento = 14 and idlista = 125;
 select max(idlista)+1 into maxidlista from ft_lista;
 insert into ft_lista (idlista,idtipoobjeto,descripcion,estado)
 values(maxidlista,2,'TIPO_EQU_PROV',1);
 select max(orden)+1 into maxordentel from ft_componentexlista where idcomponente = 20;
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(20,maxidlista,'TIPO_EQU_PROV',1,maxordentel);
select max(orden)+1 into maxordenint from ft_componentexlista where idcomponente = 21;   
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(21,maxidlista,'TIPO_EQU_PROV',1,maxordenint);
select max(orden)+1 into maxordentv from ft_componentexlista where idcomponente = 22;   
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(22,maxidlista,'TIPO_EQU_PROV',1,maxordentv);   
select max(orden)+1 into maxordenftthint from ft_componentexlista where idcomponente = 24;   
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(24,128,'ESTADO FICHA',1,maxordenftthint);   
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(24,maxidlista,'TIPO_EQU_PROV',1,maxordenftthint+1);   
select max(orden)+1 into maxordenftthtel from ft_componentexlista where idcomponente = 25;   
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(25,128,'ESTADO FICHA',1,maxordenftthtel);   
   insert into ft_componentexlista(idcomponente,idlista,etiqueta,flgnecesario,orden)
   values(25,maxidlista,'TIPO_EQU_PROV',1,maxordenftthtel+1);
select max(idcampo)+1 into maxidcampo from ft_campo;   
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo,maxidlista,10,'TIPO_EQU_PROV',1,maxordenint,21,1,'EMTA',1,0); 
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo+1,maxidlista,11,'TIPO_EQU_PROV',1,maxordentel,20,1,'EMTA',1,0);
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo+2,maxidlista,12,'TIPO_EQU_PROV',1,maxordentv,22,1,'select ve.tipo_equ_prov from insprd i, vtaequcom ve where i.codequcom=ve.codequcom and i.pid=:1 and rownum=1',3,0);   
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo+3,128,13,'ESTADO FICHA',1,maxordenftthint,24,1,'0',1,0);
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo+4,128,14,'ESTADO FICHA',1,maxordenftthtel,25,1,'0',1,0);
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo+5,maxidlista,13,'TIPO_EQU_PROV',1,maxordenftthint,24,1,'ONT',1,0);
   insert into ft_campo(idcampo,idlista,iddocumento,etiqueta,flgnecesario,orden,idcomponente,cantidadpid,valorcampo,tipo,flgvisible)
   values(maxidcampo+6,maxidlista,14,'TIPO_EQU_PROV',1,maxordenftthtel,25,1,'ONT',1,0);
 commit;
end;
/