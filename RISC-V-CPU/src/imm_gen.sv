// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Módulo: Immediate Generator
//
// Descripción:
// Genera y extiende a 32 bits el valor inmediato contenido en
// una instrucción RISC-V. En esta etapa del proyecto se deben
// implementar los formatos de inmediato indicados en la
// especificación del Capítulo 1.
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
// Instr        : Instrucción RISC-V de 32 bits.
// ImmSrc       : Selecciona el formato del inmediato.
//                00: I-type.
//                01: S-type.
//
// SALIDAS
// ------------------------------------------------------------
// ImmExt       : Inmediato extendido a 32 bits.
// ============================================================

module imm_gen (
    input  logic [31:0] Instr,
    input  logic [1:0]  ImmSrc,
    output logic [31:0] ImmExt
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    always_comb begin

        case (ImmSrc)

            // I-type: extraer el inmediato y extender el signo.
            2'b00:
                ImmExt = {{20{Instr[31]}}, Instr[31:20]};

            // S-type: unir los campos y extender el signo.
            2'b01:
                ImmExt = {{20{Instr[31]}},
                          Instr[31:25], Instr[11:7]};

            // Formatos no implementados: salida desconocida.
            default:
                ImmExt = 32'bx;

        endcase

    end

endmodule