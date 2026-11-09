
// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Instruction Memory
//
// Descripción:
// Almacena las instrucciones del programa en palabras de
// 32 bits. Recibe una dirección de byte proveniente del PC
// y entrega la instrucción correspondiente mediante lectura
// combinacional.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 06/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripcióna
// ------------------------------------------------------------
// 06/11/26    | Kevin Méndez Carvajal  | Primera versión
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// Address      : Dirección de byte proveniente del PC.
//
// SALIDAS
// ------------------------------------------------------------
// Instruction  : Instrucción de 32 bits correspondiente.
// ============================================================

module instruction_memory (

    input  logic [31:0] Address,
    output logic [31:0] Instruction

);

    // ========================================================
    // DECLARACIÓN DE MEMORIA
    // ========================================================

    logic [31:0] memi [0:255];

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Lectura combinacional de instrucciones
    always_comb begin

        Instruction = memi[Address[9:2]];

    end

endmodule
