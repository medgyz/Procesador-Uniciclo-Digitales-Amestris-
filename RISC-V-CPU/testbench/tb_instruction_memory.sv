// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Testbench Instruction Memory (tb_instruction_memory)
//
// Descripción:
// Prueba unitaria autochequeada (PASS/FAIL) para el módulo
// instruction_memory. Verifica lectura combinacional,
// direccionamiento de byte alineado a palabras (Address[9:2])
// y rango superior de memoria.
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

module tb_instruction_memory;

    // 1. Señales de interfaz
    logic [31:0] Address;
    logic [31:0] Instruction;

    // 2. Contador de errores
    int errors_count = 0;

    // 3. Instanciación del DUT (Device Under Test)
    instruction_memory dut (
        .Address(Address),
        .Instruction(Instruction)
    );

    // 4. Estímulos y verificación automática
    initial begin
        $display("\n==================================================");
        $display("   TESTBENCH UNITARIO: INSTRUCTION MEMORY         ");
        $display("==================================================\n");

        // Precarga directa en el arreglo interno memi
        dut.memi[0]   = 32'h00A00093; // Dirección byte 0x00 (PC = 0)
        dut.memi[1]   = 32'h01400113; // Dirección byte 0x04 (PC = 4)
        dut.memi[2]   = 32'h022081B3; // Dirección byte 0x08 (PC = 8)
        dut.memi[7]   = 32'h00402383; // Dirección byte 0x1C (PC = 28)
        dut.memi[255] = 32'hDEADBEEF; // Última posición (0x3FC = 1020)

        // Caso 1: Lectura en Address = 0x00000000 -> memi[0]
        Address = 32'h00000000;
        #2;
        if (Instruction === 32'h00A00093)
            $display("[PASS] TC-IMEM-01: Address 0x00 -> 0x%h", Instruction);
        else begin
            $display("[FAIL] TC-IMEM-01: Address 0x00 -> 0x%h (Esperado: 00A00093)", Instruction);
            errors_count++;
        end

        // Caso 2: Lectura secuencial PC+4 (Address = 0x00000004 -> memi[1])
        Address = 32'h00000004;
        #2;
        if (Instruction === 32'h01400113)
            $display("[PASS] TC-IMEM-02: Address 0x04 -> 0x%h", Instruction);
        else begin
            $display("[FAIL] TC-IMEM-02: Address 0x04 -> 0x%h (Esperado: 01400113)", Instruction);
            errors_count++;
        end

        // Caso 3: Lectura en Address = 0x00000008 -> memi[2]
        Address = 32'h00000008;
        #2;
        if (Instruction === 32'h022081B3)
            $display("[PASS] TC-IMEM-03: Address 0x08 -> 0x%h", Instruction);
        else begin
            $display("[FAIL] TC-IMEM-03: Address 0x08 -> 0x%h (Esperado: 022081B3)", Instruction);
            errors_count++;
        end

        // Caso 4: Lectura en Address = 0x0000001C -> memi[7]
        Address = 32'h0000001C;
        #2;
        if (Instruction === 32'h00402383)
            $display("[PASS] TC-IMEM-04: Address 0x1C -> 0x%h", Instruction);
        else begin
            $display("[FAIL] TC-IMEM-04: Address 0x1C -> 0x%h (Esperado: 00402383)", Instruction);
            errors_count++;
        end

        // Caso 5: Límite superior de memoria (Address = 0x000003FC -> memi[255])
        Address = 32'h000003FC;
        #2;
        if (Instruction === 32'hDEADBEEF)
            $display("[PASS] TC-IMEM-05: Address 0x3FC -> 0x%h", Instruction);
        else begin
            $display("[FAIL] TC-IMEM-05: Address 0x3FC -> 0x%h (Esperado: DEADBEEF)", Instruction);
            errors_count++;
        end

        // Reporte Final
        $display("\n==================================================");
        if (errors_count == 0)
            $display("   RESULTADO INSTRUCTION MEMORY: UNIT PASS          ");
        else
            $display("   RESULTADO INSTRUCTION MEMORY: UNIT FAIL (%0d) ", errors_count);
        $display("==================================================\n");

        $finish;
    end

endmodule