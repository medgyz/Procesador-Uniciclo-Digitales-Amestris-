// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: RISC-V Uniciclo
//
// Descripción:
// Integra los ocho módulos que conforman el procesador RISC-V
// uniciclo, permitiendo que trabajen en conjunto para ejecutar
// las instrucciones implementadas en el proyecto.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 08/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripción
// ------------------------------------------------------------
// 06/11/26    | Kevin Méndez Carvajal  | Primera versión:
//             |                        | Integración del PC
//             |                        | y la memoria de
//             |                        | instrucciones.
//
// 07/11/26    | Kevin Méndez Carvajal  | Segunda versión:
//             |                        | Integración de los
//             |                        | módulos restantes
//             |                        | para ejecutar
//             |                        | instrucciones
//             |                        | aritméticas.
//
// 08/11/26    | Kevin Méndez Carvajal  | Tercera versión:
//             |                        | Incorporación de la
//             |                        | memoria de datos
//             |                        | para ejecutar LW
//             |                        | y SW.
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Señal de reloj del procesador.
// reset        : Reinicio síncrono activo en alto.
//
// SALIDAS
// ------------------------------------------------------------
// No posee salidas externas. Los resultados de ejecución se
// almacenan en el banco de registros y la memoria de datos.
// ============================================================

module riscv_uniciclo (
    input logic clk,
    input logic reset
);

    // =========================================================
    // 1. Senales del procesador
    // =========================================================

    logic [31:0] PC;
    logic [31:0] PC_next;
    logic [31:0] Instruction;

    // Senales de control
    logic RegWrite;
    logic ALUSrc;
    logic MemWrite;
    logic ResultSrc;
    logic [1:0] ImmSrc;
    logic [3:0] ALUControl;

    // Banco de registros
    logic [31:0] RD1;
    logic [31:0] RD2;

    // Generador de inmediatos
    logic [31:0] ImmExt;

    // ALU
    logic [31:0] ALU_B;
    logic [31:0] ALUResult;
    logic Zero;

    // Memoria de datos
    logic [31:0] ReadData;

    // Resultado para escritura en registros
    logic [31:0] result_search;


    // =========================================================
    // 2. Contador de programa
    // =========================================================

    assign PC_next = PC + 32'd4;

    program_counter PC_inst (
        .clk(clk),
        .reset(reset),
        .PC_next(PC_next),
        .PC(PC)
    );


    // =========================================================
    // 3. Memoria de instrucciones
    // =========================================================

    instruction_memory IMEM (
        .Address(PC),
        .Instruction(Instruction)
    );


    // =========================================================
    // 4. Unidad de control
    // =========================================================

    control_unit CU (
        .Instruction(Instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );


    // =========================================================
    // 5. Banco de registros
    // =========================================================

    register_file RF (
        .clk(clk),
        .A1(Instruction[19:15]),
        .A2(Instruction[24:20]),
        .A3(Instruction[11:7]),
        .WD3(result_search),
        .RegWrite(RegWrite),
        .RD1(RD1),
        .RD2(RD2)
    );


    // =========================================================
    // 6. Generador de inmediatos
    // =========================================================

    imm_gen IMM (
        .Instr(Instruction),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );


    // =========================================================
    // 7. Multiplexor de entrada B de la ALU
    // =========================================================

    mux2to1 #(.WIDTH(32)) MUX_ALU (
        .A(RD2),
        .B(ImmExt),
        .Select(ALUSrc),
        .Y(ALU_B)
    );


    // =========================================================
    // 8. Unidad aritmetica y logica
    // =========================================================

    alu ALU (
        .A(RD1),
        .B(ALU_B),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );


    // =========================================================
    // 9. Memoria de datos
    // =========================================================

    data_memory DMEM (
        .clk(clk),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(RD2),
        .ReadData(ReadData)
    );


    // =========================================================
    // 10. Multiplexor de resultado para escritura
    // =========================================================

    mux2to1 #(.WIDTH(32)) MUX_RESULT (
        .A(ALUResult),
        .B(ReadData),
        .Select(ResultSrc),
        .Y(result_search)
    );

endmodule
