
insert into OPERACION.TIPROY_SINERGIA (TIPROY, PAIS, CLASEPROY, RUBROINV, PLATAFORMA, DESTIPROY, TIPORED, TIPOUBITEC, SOC_CO, SOC_FI, CECO_RES, PERFILPROY, SEGMENTO, PERFILGRAFO, CLASEGRAFO, PLANIF_NEC, CENTROGRAFO, FLAG_PLANO, GRUPOSERVICIO, CLAVECONTROL, FABRICANTE, CREA_PROYECTO, CECO_SOL, CLASE_ACTIVO, FLAG_MASIVO, PROY_INT_SINERGIA, TIPROY_SAP, TIPROY_PAD, ASIGNA_PEP)
values ('FT4', 'PE', 'J', 'GP', 'F', 'FTTH-HUBS NOP PLANTA INTERNA', 'RF', 'IN', 'PE00', 'PE02', '0211A00116', 'ZPE2TVF', 'F', 'ZRFTVPE', 'RFTV', 'PF1', 'P001', 1, null, null, null, '0', '0210FP@110', '9078', 0, 1, 'FT4', null, 1);

insert into OPERACION.TIPROY_SINERGIA (TIPROY, PAIS, CLASEPROY, RUBROINV, PLATAFORMA, DESTIPROY, TIPORED, TIPOUBITEC, SOC_CO, SOC_FI, CECO_RES, PERFILPROY, SEGMENTO, PERFILGRAFO, CLASEGRAFO, PLANIF_NEC, CENTROGRAFO, FLAG_PLANO, GRUPOSERVICIO, CLAVECONTROL, FABRICANTE, CREA_PROYECTO, CECO_SOL, CLASE_ACTIVO, FLAG_MASIVO, PROY_INT_SINERGIA, TIPROY_SAP, TIPROY_PAD, ASIGNA_PEP)
values ('FTN', 'PE', 'J', 'GP', 'F', 'FTTH-PLANO CONSTRUCCION DE NODO', 'RF', 'IN', 'PE00', 'PE02', '0211A00406', 'ZPE2TVF', 'F', 'ZRFTVPE', 'RFTV', 'PF1', 'P001', 1, null, null, null, '1', '0210FP@110', '9078', 0, 1, 'FTN', null, 1);

insert into OPERACION.TIPROY_SINERGIA (TIPROY, PAIS, CLASEPROY, RUBROINV, PLATAFORMA, DESTIPROY, TIPORED, TIPOUBITEC, SOC_CO, SOC_FI, CECO_RES, PERFILPROY, SEGMENTO, PERFILGRAFO, CLASEGRAFO, PLANIF_NEC, CENTROGRAFO, FLAG_PLANO, GRUPOSERVICIO, CLAVECONTROL, FABRICANTE, CREA_PROYECTO, CECO_SOL, CLASE_ACTIVO, FLAG_MASIVO, PROY_INT_SINERGIA, TIPROY_SAP, TIPROY_PAD, ASIGNA_PEP)
values ('FTO', 'PE', 'J', 'GP', 'F', 'FTTH-PLANO NOP', 'RF', 'IN', 'PE00', 'PE02', '0211A00118', 'ZPE2TVF', 'F', 'ZRFTVPE', 'RFTV', 'PF1', 'P001', 1, null, null, null, '0', '0210FP@110', '9078', 0, 1, 'FTO', null, 1);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP,  CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'INFRAESTRUCTURA GPON', 'GP', null, null, 2, null, 1, null, null, 0, '9078', null, '0211A00118', null, 0, '1', 47, user, sysdate, 0, null, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP,  CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'CAPEX VARIABLE GPON', 'CV', null, null, 2, null, 1, null, null, 0, '9078', null, '0211A00406', null, 0, '1', null, user, sysdate, 0, null, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP, CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTO', 'INFRAESTRUCTURA GPON', 'GP', null, null, 2, null, 1, null, null, 0, '9078', null, null, null, 0, '0', null, user, sysdate, 0, null, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP, CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FT4', 'INFRAESTRUCTURA PINT GPON', 'GP', null, null, 2, null, 1, null, null, 0, '9078', null, null, null, 0, '0', null, user, sysdate, 0, null, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP, CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'NEC OPERACIONALES PLANO GPON', 'RF-GP', null, 'MANT', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FTN'
and DESCRIPCION = 'INFRAESTRUCTURA GPON'), 1, 'INGE', 'EM', 0, '9078', 'PE-RF-GP-PEG', '0211A00118', '0210FP@110', 0, null, null, user, sysdate, 0, 0, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP, CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'PLANTA EXTERNA GPON', 'RF-GP', null, 'NUEV', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FTN'
and DESCRIPCION = 'INFRAESTRUCTURA GPON'), 1, 'INGE', 'FC', 0, '9078', 'PE-RF-GP-PEG', '0211A00118', '0210FP@110', 1, null, null, user, sysdate, 0, 1, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP, CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'EM INSTALACION GPON MASIVO GPON', 'RF-CV', 'EM', 'INST', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FTN'
and DESCRIPCION = 'CAPEX VARIABLE GPON'), 1, 'COME', 'EQ', 0, '9078', 'PE-RF-CV-CGP', '0211A00408', '0210FP@110', 0, null, null, user, sysdate, 0, 0, '0061', null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP, CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'MO INSTALACION GPON MASIVO GPON', 'RF-CV', 'MO', 'INST', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FTN'
and DESCRIPCION = 'CAPEX VARIABLE GPON'), 1, 'COME', 'MO', 0, '9078', 'PE-RF-CV-CGP', '0211A00408', '0210FP@110', 0, null, null, user, sysdate, 0, 0, '0061', null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP,CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTN', 'EM MANTENIMIENTO GPON MASIVO GPON', 'RF-CV', 'EM', 'MANT', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FTN'
and DESCRIPCION = 'CAPEX VARIABLE GPON'), 1, 'COME', 'EM', 0, '9078', 'PE-RF-CV-CGP', '0211A00408', '0210FP@110', 0, null, null, user, sysdate, 0, 0, '0061', null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP,  CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FTO', 'NOP PLANO GPON', 'RF-GP', null, 'EXPA', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FTO'
and DESCRIPCION = 'INFRAESTRUCTURA GPON'), 1, 'INGE', null, 0, '9078', 'PE-RF-GP-PEG', '0211A00118', '0210FP@110', 1, null, null,  user, sysdate, 1, 1, null, null);

insert into operacion.tiproy_sinergia_pep (ID_SEQ, TIPROY, DESCRIPCION, RUBROINV, CLASIF_OBRA, NATURALEZA_PEP, NIVEL, ID_SEQ_PAD, ESTADO, AREA, CONSECUTIVO, CREA_GRAFO, CLASE_ACTIVO, TIPOPROYECTO, CECO_RES, CECO_SOL, GENERA_RESERVA, CREA_PEPN2, ID_SEQ_HIJO_NOP,  CODUSU, FECUSU, PEP_ETAPA, ASIGNA_SOT_PEPN3, TIPSRV, ASIGNA_CECO_PRY)
values ((select max(ID_SEQ) + 1 from operacion.tiproy_sinergia_pep), 'FT4', 'NOP PLANTA INTERNA GPON', 'RF-GP', null, 'EXPA', 3, (select ID_SEQ from operacion.tiproy_sinergia_pep
where TIPROY = 'FT4'
and DESCRIPCION = 'INFRAESTRUCTURA PINT GPON'), 1, 'INGE', null, 0, '9078', 'PE-RF-GP-PIG', '0211A00116', '0210FP@110', 1, null, null, user, sysdate, 1, 1, null, null);

commit;
/