delete from operacion.constante where constante ='BTN_ACT_DECO';
delete from operacion.constante where constante ='BTN_VAL_TEC';
delete from operacion.constante where constante ='BTN_ACT_CONAX';
delete from operacion.constante where constante ='BTN_BAJ_CONAX';


commit;

DROP PACKAGE OPERACION.PQ_INALAMBRICO;

commit;
