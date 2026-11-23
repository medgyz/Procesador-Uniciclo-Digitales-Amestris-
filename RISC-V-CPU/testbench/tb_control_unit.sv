// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Testbench Control Unit (tb_control_unit)
//
// Descripción:
// Prueba unitaria autochequeada (PASS/FAIL) para el módulo
// control_unit. Verifica la decodificación de señales de control
// (RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl)
// para instrucciones R-type (ADD, SUB, AND, OR), ADDI, LW, SW
// y caso por defecto.
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

module tb_control_unit;

    logic [31:0] Instruction;

    logic        RegWrite;
    logic        ALUSrc;
    logic        MemWrite;
    logic        ResultSrc;
    logic [1:0]  ImmSrc;
    logic [3:0]  ALUControl;

    int          errors_count = 0;

    control_unit dut (
        .Instruction(Instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    initial begin
        $display("\n==================================================");
        $display("   TESTBENCH UNITARIO: CONTROL UNIT               ");
        $display("==================================================\n");

        // TC-CU-01: ADD (add x3, x1, x2 -> 32'h002081B3)
        Instruction = 32'h002081B3;
        #2;
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ALUControl === 4'b0000)
            $display("[PASS] TC-CU-01: ADD decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-01: ADD -> RW=%b AS=%b MW=%b RS=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-02: SUB (sub x4, x1, x2 -> 32'h40208233)
        Instruction = 32'h40208233;
        #2;
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ALUControl === 4'b0001)
            $display("[PASS] TC-CU-02: SUB decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-02: SUB -> RW=%b AS=%b MW=%b RS=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-03: AND (and x5, x1, x2 -> 32'h0020F2B3)
        Instruction = 32'h0020F2B3;
        #2;
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ALUControl === 4'b0010)
            $display("[PASS] TC-CU-03: AND decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-03: AND -> RW=%b AS=%b MW=%b RS=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-04: OR (or x6, x1, x2 -> 32'h0020E333)
        Instruction = 32'h0020E333;
        #2;
        if (RegWrite === 1'b1 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ALUControl === 4'b0011)
            $display("[PASS] TC-CU-04: OR decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-04: OR -> RW=%b AS=%b MW=%b RS=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-05: ADDI (addi x1, x0, 10 -> 32'h00A00093)
        Instruction = 32'h00A00093;
        #2;
        if (RegWrite === 1'b1 && ALUSrc === 1'b1 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("[PASS] TC-CU-05: ADDI decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-05: ADDI -> RW=%b AS=%b MW=%b RS=%b Imm=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-06: LW (lw x5, 0(x0) -> 32'h00002283)
        Instruction = 32'h00002283;
        #2;
        if (RegWrite === 1'b1 && ALUSrc === 1'b1 && MemWrite === 1'b0 &&
            ResultSrc === 1'b1 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("[PASS] TC-CU-06: LW decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-06: LW -> RW=%b AS=%b MW=%b RS=%b Imm=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-07: SW (sw x4, 0(x0) -> 32'h00402023)
        Instruction = 32'h00402023;
        #2;
        if (RegWrite === 1'b0 && ALUSrc === 1'b1 && MemWrite === 1'b1 &&
            ImmSrc === 2'b01 && ALUControl === 4'b0000)
            $display("[PASS] TC-CU-07: SW decodificado correctamente");
        else begin
            $display("[FAIL] TC-CU-07: SW -> RW=%b AS=%b MW=%b Imm=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ImmSrc, ALUControl);
            errors_count++;
        end

        // TC-CU-08: Instrucción nula / por defecto (32'h00000000)
        Instruction = 32'h00000000;
        #2;
        if (RegWrite === 1'b0 && ALUSrc === 1'b0 && MemWrite === 1'b0 &&
            ResultSrc === 1'b0 && ImmSrc === 2'b00 && ALUControl === 4'b0000)
            $display("[PASS] TC-CU-08: Caso por defecto seguro");
        else begin
            $display("[FAIL] TC-CU-08: Caso por defecto -> RW=%b AS=%b MW=%b RS=%b Imm=%b ALU=%b",
                     RegWrite, ALUSrc, MemWrite, ResultSrc, ImmSrc, ALUControl);
            errors_count++;
        end

        $display("\n==================================================");
        if (errors_count == 0)
            $display("   RESULTADO CONTROL UNIT: UNIT PASS              ");
        else
            $display("   RESULTADO CONTROL UNIT: UNIT FAIL (%0d)     ", errors_count);
        $display("==================================================\n");

        $finish;
    end

endmodule