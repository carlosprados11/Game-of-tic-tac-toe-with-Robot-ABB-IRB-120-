MODULE Mover_Piezas

    
    PROC PonerDado(robtarget inicio,bool busqueda)

        VAR robtarget punto;
        VAR num tipo;

        ! Caso de que debamos ir directamente a la pieza sin búsqueda previa
        IF busqueda=FALSE THEN
            MoveJ offs(inicio,0,0,200),v300,fine,Pinza_Neumatica\WObj:=mesanegra;
        ENDIF

        MoveL inicio,v100,fine,Pinza_Neumatica\WObj:=mesanegra;
        
        CerrarPinza;
        MoveL offs(inicio,0,0,200),v100,z10,Pinza_Neumatica\WObj:=mesanegra;
        ! Levanta el brazo para evitar choques
        MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;
        ! Se mueve a posicion de reposo

        IF inicio.trans.y>0 THEN
            ! Distingue piezas verdes y rojas
            tipo:=1;
            ! Roja
        ELSE
            tipo:=2;
            ! Verde
        ENDIF

        ! Quito indicador de que se ha producido la interrupcion
        repetir:=FALSE;
        punto:=Menu(tipo);

        ! Activo la interrupción si mueve usuario
        IF tipo=1 THEN
            IWatch interrupcion;
        ENDIF

        ! Movemos el robot a donde debe dejar la pieza
        MoveJ offs(punto,0,0,20),v300,fine,Pinza_Neumatica\WObj:=mesanegra;
        
        IF repetir=FALSE THEN
            MoveL punto,v100,fine,Pinza_Neumatica\WObj:=mesanegra;
        ENDIF

        ! Desactivo la interrupción
        ISleep interrupcion;

        IF repetir=FALSE THEN
            ! Dejamos la pieza y nos vamos a reposo
            AbrirPinza;
            MoveL offs(punto,0,0,20),v100,z10,Pinza_Neumatica\WObj:=mesanegra;
            MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

            Comprueba;
            Ganado;
        ENDIF

    ENDPROC
    

    PROC Recoge_piezas()

        VAR num rojas:=1;
        VAR num verdes:=1;

        ! Recorro todo el tablero comprobando si hay piezas
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO

                ! Si hay una pieza la cojo y la llevo a reposo
                IF tablero{i,j}<>0 THEN

                    MoveJ offs(pos_tab{i,j},0,0,20),v300,fine,Pinza_Neumatica\WObj:=mesanegra;
                    MoveL pos_tab{i,j},v100,fine,Pinza_Neumatica\WObj:=mesanegra;
                    CerrarPinza;
                    MoveL offs(pos_tab{i,j},0,0,20),v100,fine,Pinza_Neumatica\WObj:=mesanegra;
                    MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

                    ! Si es roja
                    IF tablero{i,j}=1 THEN

                        ! Ignoro posiciones del vector de posicion de rojas iniciales vacias
                        WHILE (pieza_r{rojas}.trans.x=0 AND pieza_r{rojas}.trans.y=0) DO
                            rojas:=rojas+1;
                        ENDWHILE

                        MoveJ offs(pieza_r{rojas},0,0,200),v300,fine,Pinza_Neumatica\WObj:=mesanegra;
                        MoveL pieza_r{rojas},v100,fine,Pinza_Neumatica\WObj:=mesanegra;
                        AbrirPinza;
                        MoveL offs(pieza_r{rojas},0,0,200),v100,fine,Pinza_Neumatica\WObj:=mesanegra;
                        MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

                        rojas:=rojas+1;

                        ! Si es verde
                    ELSEIF tablero{i,j}=2 THEN

                        ! Ignoro posiciones del vector de posicion de rojas iniciales vacias
                        WHILE (pieza_v{verdes}.trans.x=0 AND pieza_v{verdes}.trans.y=0) DO
                            verdes:=verdes+1;
                        ENDWHILE

                        MoveJ offs(pieza_v{verdes},0,0,200),v300,fine,Pinza_Neumatica\WObj:=mesanegra;
                        MoveL pieza_v{verdes},v100,fine,Pinza_Neumatica\WObj:=mesanegra;
                        AbrirPinza;
                        MoveL offs(pieza_v{verdes},0,0,200),v100,fine,Pinza_Neumatica\WObj:=mesanegra;
                        MoveAbsJ Punto_Base,v300,fine,Pinza_Neumatica;

                        verdes:=verdes+1;

                    ENDIF
                ENDIF
            ENDFOR
        ENDFOR

    ENDPROC

ENDMODULE