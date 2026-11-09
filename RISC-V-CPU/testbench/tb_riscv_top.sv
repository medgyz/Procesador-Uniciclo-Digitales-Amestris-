/*
 * Módulo: tb_riscv_top
 * Descripción: Testbench de integración automatizado para el procesador RISC-V uniciclo.
 * Autor: Verification Engineer - John Hibbert Bonilla
 * Fecha: 09/11/2026
 */

`timescale 1ns / 1ps

module tb_riscv_top;

    logic clk;
    logic reset;
    int errors_count = 0;

    riscv_uniciclo dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        $display("\n==================================================");
        $display("   INICIANDO PRUEBAS DE INTEGRACION AUTOMATIZADAS ");
        $display("==================================================\n");

        // ----------------------------------------------------
        // PRUEBA 1: PROGRAMA ILUSTRATIVO DEL PROFESOR
        // ----------------------------------------------------
        $display("--------------------------------------------------");
        $display("   EJECUTANDO: PROGRAMA ILUSTRATIVO (ENUNCIADO)   ");
        $display("--------------------------------------------------");

        dut.IMEM.memi[0] = 32'h00A00093; // addi x1, x0, 10
        dut.IMEM.memi[1] = 32'h01400113; // addi x2, x0, 20
        dut.IMEM.memi[2] = 32'h022081B3; // add x3, x1, x2
        dut.IMEM.memi[3] = 32'h40118233; // sub x4, x3, x1
        dut.IMEM.memi[4] = 32'h00402023; // sw x4, 0(x0)
        dut.IMEM.memi[5] = 32'h00002283; // lw x5, 0(x0)

        #15;
        reset = 0;

        repeat (12) @(posedge clk);

        if (dut.RF.registros[1] === 32'd10)
            $display("[PASS] Ilustrativo: x1 = %d", dut.RF.registros[1]);
        else begin $display("[FAIL] Ilustrativo: x1 = %d (Esperado: 10)", dut.RF.registros[1]); errors_count++; end

        if (dut.RF.registros[2] === 32'd20)
            $display("[PASS] Ilustrativo: x2 = %d", dut.RF.registros[2]);
        else begin $display("[FAIL] Ilustrativo: x2 = %d (Esperado: 20)", dut.RF.registros[2]); errors_count++; end

        if (dut.RF.registros[3] === 32'd30)
            $display("[PASS] Ilustrativo: x3 = %d", dut.RF.registros[3]);
        else begin $display("[FAIL] Ilustrativo: x3 = %d (Esperado: 30)", dut.RF.registros[3]); errors_count++; end

        if (dut.RF.registros[4] === 32'd20)
            $display("[PASS] Ilustrativo: x4 = %d", dut.RF.registros[4]);
        else begin $display("[FAIL] Ilustrativo: x4 = %d (Esperado: 20)", dut.RF.registros[4]); errors_count++; end

        if (dut.RF.registros[5] === 32'd20)
            $display("[PASS] Ilustrativo: x5 = %d", dut.RF.registros[5]);
        else begin $display("[FAIL] Ilustrativo: x5 = %d (Esperado: 20)", dut.RF.registros[5]); errors_count++; end

        if (dut.DMEM.memd[0] === 32'd20)
            $display("[PASS] Ilustrativo: Mem[0] = %d\n", dut.DMEM.memd[0]);
        else begin $display("[FAIL] Ilustrativo: Mem[0] = %d (Esperado: 20)\n", dut.DMEM.memd[0]); errors_count++; end

        // ----------------------------------------------------
        // PRUEBA 2: PROGRAMA PROPIO DEL GRUPO (7 INSTRUCCIONES)
        // ----------------------------------------------------
        $display("--------------------------------------------------");
        $display("   EJECUTANDO: PROGRAMA PROPIO DEL GRUPO          ");
        $display("--------------------------------------------------");

        dut.IMEM.memi[0] = 32'h00F00093; // addi x1, x0, 15
        dut.IMEM.memi[1] = 32'h00700113; // addi x2, x0, 7
        dut.IMEM.memi[2] = 32'h022081B3; // add x3, x1, x2
        dut.IMEM.memi[3] = 32'h40208233; // sub x4, x1, x2
        dut.IMEM.memi[4] = 32'h0020F2B3; // and x5, x1, x2
        dut.IMEM.memi[5] = 32'h0020E333; // or x6, x1, x2
        dut.IMEM.memi[6] = 32'h00302223; // sw x3, 4(x0)
        dut.IMEM.memi[7] = 32'h00402383; // lw x7, 4(x0)

        reset = 1;
        #15;
        reset = 0;

        repeat (12) @(posedge clk);

        if (dut.RF.registros[1] === 32'd15) $display("[PASS] Propio: x1 = %d", dut.RF.registros[1]);
        else begin $display("[FAIL] Propio: x1 = %d (Esperado: 15)", dut.RF.registros[1]); errors_count++; end

        if (dut.RF.registros[2] === 32'd7) $display("[PASS] Propio: x2 = %d", dut.RF.registros[2]);
        else begin $display("[FAIL] Propio: x2 = %d (Esperado: 7)", dut.RF.registros[2]); errors_count++; end

        if (dut.RF.registros[3] === 32'd22) $display("[PASS] Propio: x3 = %d", dut.RF.registros[3]);
        else begin $display("[FAIL] Propio: x3 = %d (Esperado: 22)", dut.RF.registros[3]); errors_count++; end

        if (dut.RF.registros[4] === 32'd8) $display("[PASS] Propio: x4 = %d", dut.RF.registros[4]);
        else begin $display("[FAIL] Propio: x4 = %d (Esperado: 8)", dut.RF.registros[4]); errors_count++; end

        if (dut.RF.registros[5] === 32'd7) $display("[PASS] Propio: x5 = %d", dut.RF.registros[5]);
        else begin $display("[FAIL] Propio: x5 = %d (Esperado: 7)", dut.RF.registros[5]); errors_count++; end

        if (dut.RF.registros[6] === 32'd15) $display("[PASS] Propio: x6 = %d", dut.RF.registros[6]);
        else begin $display("[FAIL] Propio: x6 = %d (Esperado: 15)", dut.RF.registros[6]); errors_count++; end

        if (dut.RF.registros[7] === 32'd22) $display("[PASS] Propio: x7 = %d", dut.RF.registros[7]);
        else begin $display("[FAIL] Propio: x7 = %d (Esperado: 22)", dut.RF.registros[7]); errors_count++; end

        if (dut.DMEM.memd[1] === 32'd22) $display("[PASS] Propio: Mem[4] = %d", dut.DMEM.memd[1]);
        else begin $display("[FAIL] Propio: Mem[4] = %d (Esperado: 22)", dut.DMEM.memd[1]); errors_count++; end

        // ----------------------------------------------------
        // REPORTE FINAL GLOBAL
        // ----------------------------------------------------
        $display("\n==================================================");
        if (errors_count == 0) begin
            $display("   RESULTADO DE SIMULACION INTEGRAL: SYSTEM PASS  ");
            $display("   Ambos programas ejecutados y validados con exito.");
        end else begin
            $display("   RESULTADO DE SIMULACION INTEGRAL: SYSTEM FAIL  ");
            $display("   Se detectaron %0d fallos en total.", errors_count);
        end
        $display("==================================================\n");

        $finish;
    end

endmodule