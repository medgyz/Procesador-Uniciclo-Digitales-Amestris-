// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Testbench Program Counter (tb_program_counter)
//
// Descripción:
// Prueba unitaria autochequeada (PASS/FAIL) para el módulo
// program_counter. Verifica reinicio síncrono activo en alto,
// actualización de PC <= PC_next en flanco positivo de reloj,
// estabilidad en flanco negativo y prioridad de reset.
//
// Autor / Verification Engineer:
// Nombre: John Hibbert Bonilla
// Fecha de primera versión: 23/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                       | Descripción
// ------------------------------------------------------------
// 23/11/26    | John Hibbert Bonilla  | Primera versión
// ============================================================

`timescale 1ns / 1ps

module tb_program_counter;

    logic        clk;
    logic        reset;
    logic [31:0] PC_next;
    logic [31:0] PC;
    int          errors_count = 0;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .PC_next(PC_next),
        .PC(PC)
    );

    always #5 clk = ~clk;

    initial begin
        clk     = 1'b0;
        reset   = 1'b1;
        PC_next = 32'h00000004;

        $display("\n==================================================");
        $display("   TESTBENCH UNITARIO: PROGRAM COUNTER            ");
        $display("==================================================\n");

        // TC-PC-01: Reset síncrono en flanco de subida
        @(posedge clk);
        #1;
        if (PC === 32'h00000000)
            $display("[PASS] TC-PC-01: Reset activo -> PC = 0x%h", PC);
        else begin
            $display("[FAIL] TC-PC-01: Reset activo -> PC = 0x%h (Esperado: 00000000)", PC);
            errors_count++;
        end

        // TC-PC-02: Liberar reset y avanzar a 0x00000004
        reset   = 1'b0;
        PC_next = 32'h00000004;
        @(posedge clk);
        #1;
        if (PC === 32'h00000004)
            $display("[PASS] TC-PC-02: Avance PC+4 -> PC = 0x%h", PC);
        else begin
            $display("[FAIL] TC-PC-02: Avance PC+4 -> PC = 0x%h (Esperado: 00000004)", PC);
            errors_count++;
        end

        // TC-PC-03: Siguiente instrucción 0x00000008
        PC_next = 32'h00000008;
        @(posedge clk);
        #1;
        if (PC === 32'h00000008)
            $display("[PASS] TC-PC-03: Avance a 0x08 -> PC = 0x%h", PC);
        else begin
            $display("[FAIL] TC-PC-03: Avance a 0x08 -> PC = 0x%h (Esperado: 00000008)", PC);
            errors_count++;
        end

        // TC-PC-04: Cambio de PC_next en negedge no altera PC antes del posedge
        PC_next = 32'h00000020;
        @(negedge clk);
        #1;
        if (PC === 32'h00000008)
            $display("[PASS] TC-PC-04: Estable en negedge -> PC = 0x%h", PC);
        else begin
            $display("[FAIL] TC-PC-04: Cambió en negedge -> PC = 0x%h (Esperado: 00000008)", PC);
            errors_count++;
        end

        // TC-PC-05: Actualiza a 0x00000020 en el siguiente posedge
        @(posedge clk);
        #1;
        if (PC === 32'h00000020)
            $display("[PASS] TC-PC-05: Actualiza en posedge -> PC = 0x%h", PC);
        else begin
            $display("[FAIL] TC-PC-05: Actualiza en posedge -> PC = 0x%h (Esperado: 00000020)", PC);
            errors_count++;
        end

        // TC-PC-06: Reset síncrono con PC_next != 0 retorna a 0x00000000
        reset   = 1'b1;
        PC_next = 32'h00000050;
        @(posedge clk);
        #1;
        if (PC === 32'h00000000)
            $display("[PASS] TC-PC-06: Reset durante ejecución -> PC = 0x%h", PC);
        else begin
            $display("[FAIL] TC-PC-06: Reset durante ejecución -> PC = 0x%h (Esperado: 00000000)", PC);
            errors_count++;
        end

        $display("\n==================================================");
        if (errors_count == 0)
            $display("   RESULTADO PROGRAM COUNTER: UNIT PASS             ");
        else
            $display("   RESULTADO PROGRAM COUNTER: UNIT FAIL (%0d)    ", errors_count);
        $display("==================================================\n");

        $finish;
    end

endmodule