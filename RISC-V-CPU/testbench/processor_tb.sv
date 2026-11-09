// ==============================================================================
// PRUEBA DE INTEGRACIÓN: Procesador RISC-V Uniciclo (Capítulo 2)
// Curso: Diseño de Sistemas Digitales (RISC-V RV32I)
// Grupo: Amestris
// ==============================================================================
//
// Descripción:
// Testbench de integración autocontenido para la verificación funcional del
// procesador completo. Precarga la memoria de instrucciones (IMEM.memi), 
// genera el ciclo de reloj y el reset inicial, y comprueba automáticamente
// el contenido final de los registros y la memoria de datos (DMEM.memd).
//
// Autor / Verification Engineer:
// Nombre: John Hibbert Bonilla (Carné: 2024062788)
// Fecha: 09/11/26
// ==============================================================================

`timescale 1ns / 1ps

module processor_tb;

    // --------------------------------------------------------------------------
    // 1. Señales de control y simulación
    // --------------------------------------------------------------------------
    logic clk;
    logic reset;

    int error_count;

    // --------------------------------------------------------------------------
    // 2. Instancia del procesador bajo prueba (DUT)
    // --------------------------------------------------------------------------
    riscv_uniciclo uut (
        .clk(clk),
        .reset(reset)
    );

    // --------------------------------------------------------------------------
    // 3. Generación del reloj (Período = 10 ns -> 100 MHz)
    // --------------------------------------------------------------------------
    always #5 clk = ~clk;

    // --------------------------------------------------------------------------
    // 4. Secuencia principal de prueba y verificación
    // --------------------------------------------------------------------------
    initial begin
        clk = 0;
        reset = 1;
        error_count = 0;

        $display("==================================================================");
        $display("  INICIANDO VERIFICACION DE INTEGRACION COMPLETA   ");
        $display("==================================================================");

        // ----------------------------------------------------------------------
        // Carga del Programa Ilustrativo del Profesor en la memoria (memi)
        // ----------------------------------------------------------------------
        // 0x00 (PC=0)  : addi x1, x0, 10 -> 0x00A00093
        // 0x04 (PC=4)  : addi x2, x0, 20 -> 0x01400113
        // 0x08 (PC=8)  : add  x3, x1, x2 -> 0x002081B3
        // 0x0C (PC=12) : sub  x4, x3, x1 -> 0x40118233
        // 0x10 (PC=16) : sw   x4, 0(x0)  -> 0x00402023
        // 0x14 (PC=20) : lw   x5, 0(x0)  -> 0x00002283
        // ----------------------------------------------------------------------
        uut.IMEM.memi[0] = 32'h00A00093; // Index 0 (Address 0x00)
        uut.IMEM.memi[1] = 32'h01400113; // Index 1 (Address 0x04)
        uut.IMEM.memi[2] = 32'h002081B3; // Index 2 (Address 0x08)
        uut.IMEM.memi[3] = 32'h40118233; // Index 3 (Address 0x0C)
        uut.IMEM.memi[4] = 32'h00402023; // Index 4 (Address 0x10)
        uut.IMEM.memi[5] = 32'h00002283; // Index 5 (Address 0x14)

        // ----------------------------------------------------------------------
        // Verificación de Reset
        // ----------------------------------------------------------------------
        #10;
        if (uut.PC !== 32'h00000000) begin
            $display("[FAIL] PRUEBA RESET: El PC no se inicializo en 0x00000000. PC actual = %h", uut.PC);
            error_count++;
        end else begin
            $display("[PASS] PRUEBA RESET: PC inicializado correctamente en 0x00000000");
        end

        // Liberar reset e iniciar la ejecución secuencial
        #10;
        reset = 0;

        // Dejar correr 6 ciclos completos de reloj (60 ns)
        #60;

        $display("\n------------------------------------------------------------------");
        $display(" VERIFICACION AUTOMATICA DE REGISTROS Y MEMORIA (PROGRAMA 1)     ");
        $display("------------------------------------------------------------------");

        // Verificación Registro x1 (Esperado = 10)
        if (uut.RF.registros[1] === 32'd10) begin
            $display("[PASS] Registro x1 = %d (Esperado: 10)", uut.RF.registros[1]);
        end else begin
            $display("[FAIL] Registro x1 = %d (Esperado: 10)", uut.RF.registros[1]);
            error_count++;
        end

        // Verificación Registro x2 (Esperado = 20)
        if (uut.RF.registros[2] === 32'd20) begin
            $display("[PASS] Registro x2 = %d (Esperado: 20)", uut.RF.registros[2]);
        end else begin
            $display("[FAIL] Registro x2 = %d (Esperado: 20)", uut.RF.registros[2]);
            error_count++;
        end

        // Verificación Registro x3 (Esperado = 30)
        if (uut.RF.registros[3] === 32'd30) begin
            $display("[PASS] Registro x3 = %d (Esperado: 30)", uut.RF.registros[3]);
        end else begin
            $display("[FAIL] Registro x3 = %d (Esperado: 30)", uut.RF.registros[3]);
            error_count++;
        end

        // Verificación Registro x4 (Esperado = 20)
        if (uut.RF.registros[4] === 32'd20) begin
            $display("[PASS] Registro x4 = %d (Esperado: 20)", uut.RF.registros[4]);
        end else begin
            $display("[FAIL] Registro x4 = %d (Esperado: 20)", uut.RF.registros[4]);
            error_count++;
        end

        // Verificación Registro x5 (Esperado = 20)
        if (uut.RF.registros[5] === 32'd20) begin
            $display("[PASS] Registro x5 = %d (Esperado: 20)", uut.RF.registros[5]);
        end else begin
            $display("[FAIL] Registro x5 = %d (Esperado: 20)", uut.RF.registros[5]);
            error_count++;
        end

        // Verificación Memoria de Datos DMEM[0] (Esperado = 20)
        if (uut.DMEM.memd[0] === 32'd20) begin
            $display("[PASS] Memoria de Datos memd[0] = %d (Esperado: 20)", uut.DMEM.memd[0]);
        end else begin
            $display("[FAIL] Memoria de Datos memd[0] = %d (Esperado: 20)", uut.DMEM.memd[0]);
            error_count++;
        end

        // ----------------------------------------------------------------------
        // Resumen final de la simulación
        // ----------------------------------------------------------------------
        $display("\n==================================================================");
        if (error_count == 0) begin
            $display("  RESUMEN FINAL: INTEGRACION COMPLETADA CON EXITO [PASS]          ");
        end else begin
            $display("  RESUMEN FINAL: SE DETECTARON %0d ERRORES DE EJECUCION [FAIL]     ", error_count);
        end
        $display("==================================================================\n");

        $finish;
    end

endmodule