// Code your design here
// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Módulo: ALU
//
// Descripción:
// Implementa las operaciones aritméticas y lógicas requeridas
// por el procesador RISC-V.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 10/10/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripción
// ------------------------------------------------------------
// 10/10/26    | Kevin Méndez Carvajal   | Primera versión
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// A            : Operando de 32 bits.
// B            : Operando de 32 bits.
// ALUControl   : Código que determina la operación.
//
// SALIDAS
// ------------------------------------------------------------
// Result       : Resultado de la operación.
// Zero         : 1 cuando Result es igual a cero.
// ============================================================

module alu (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUControl,
    output logic [31:0] Result,
    output logic        Zero
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    always_comb begin

        // Seleccionar la operación según ALUControl.
        case (ALUControl)
            4'b0000: Result = A + B;  // Suma
            4'b0001: Result = A - B;  // Resta
            4'b0010: Result = A & B;  // AND bit a bit
            4'b0011: Result = A | B;  // OR bit a bit

            // Resultado para códigos no utilizados.
            default: Result = 32'b0;
        endcase

        // Indicar si el resultado es cero.
        if (Result == 32'b0)
            Zero = 1'b1;
        else
            Zero = 1'b0;

    end

endmodule