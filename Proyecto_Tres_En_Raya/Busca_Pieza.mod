MODULE Busca_Pieza

    ! Función que devuelve la posición de una pieza encontrada
    ! Busca la pieza en una linea recta
    FUNC robtarget Rastreo(robtarget inicio)

        VAR robtarget pieza;
        VAR num tipo;
        VAR robtarget actual;

        ! Vamos a la posición de reposo y abrimos la pinza
        MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;
        AbrirPinza;

        IF inicio.trans.y>0 THEN
            ! Distingue piezas verdes y rojas
            tipo:=1;
            ! Roja
        ELSE
            tipo:=2;
            ! Verde
        ENDIF

        ! Vamos a un punto de inicio de busqueda
        MoveJ offs(inicio,0,0,200),v300,z10,Pinza_Neumatica\WObj:=mesanegra;
        MoveL inicio,v100,fine,Pinza_Neumatica\WObj:=mesanegra;

        IF DInput(di16)=1 THEN
            ! Evitamos errores de inicio de busqueda
            pieza:=inicio;
        ELSEIF tipo=1 THEN
            ! Buscamos una pieza roja
            SearchL\Stop,di16\HighLevel,pieza,Fin_Cubo_Rojo,v40,Pinza_Neumatica\WObj:=mesanegra;
            ! Desfaso para cogerla justo en el centro
            pieza:=Offs(pieza,14,0,0);
        ELSE
            SearchL\Stop,di16\HighLevel,pieza,Fin_Cubo_Verde,v40,Pinza_Neumatica\WObj:=mesanegra;
            pieza:=Offs(pieza,14,0,0);
        ENDIF

        RETURN pieza;

    ERROR
        IF ERRNO=ERR_WHLSEARCH THEN
            
            TPWrite "Las piezas están mal colocadas";
            TPWrite "Revise la colocación";
            actual:=CRobT(\Tool:=Pinza_Neumatica \WObj:=mesanegra);
            MoveL Offs(actual,0,0,200),v100,fine,Pinza_Neumatica\WObj:=mesanegra;
            MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;
            Recoge_Piezas;
            EXIT;
        ENDIF


    ENDFUNC

ENDMODULE