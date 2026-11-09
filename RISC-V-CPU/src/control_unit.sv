// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Control Unit
//
// Descripción:
// Decodifica las instrucciones RISC-V mediante los campos
// opcode, funct3 y funct7, generando las señales de control
// necesarias para coordinar los módulos del procesador.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 06/11/26
// Versión actual: Segunda versión
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripción
// ------------------------------------------------------------
// 06/11/26    | Kevin Méndez Carvajal  | Primera versión
// 06/11/26    | Kevin Méndez Carvajal  | Segunda versión:
//             |                        | Se agrega ImmSrc como
//             |                        | salida de control para
//             |                        | seleccionar el formato
//             |                        | I-type o S-type del
//             |                        | inmediato según la
//             |                        | instrucción ejecutada.
// ============================================================


// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// Instruction  : Instrucción RISC-V de 32 bits.
//
// SALIDAS
// ------------------------------------------------------------
// RegWrite     : Habilita la escritura en el banco de registros.
// ALUSrc       : Selecciona el segundo operando de la ALU.
// MemWrite     : Habilita la escritura en Data Memory.
// ResultSrc    : Selecciona el dato que se escribe en registros.
// ImmSrc       : Selecciona el formato del inmediato.
// ALUControl   : Código que determina la operación de la ALU.
// ============================================================

module control_unit (
    input  logic [31:0] Instruction,

    output logic        RegWrite,
    output logic        ALUSrc,
    output logic        MemWrite,
    output logic        ResultSrc,
    output logic [1:0]  ImmSrc,
    output logic [3:0]  ALUControl
);

    always_comb begin

        // Valores por defecto
        RegWrite   = 0;
        ALUSrc     = 0;
        MemWrite   = 0;
        ResultSrc  = 0;
        ImmSrc     = 2'b00;
        ALUControl = 4'b0000;

        case (Instruction[6:0])

            // Instrucciones tipo R
            7'b0110011: begin
                case (Instruction[14:12])
                    // ADD o SUB
                    3'b000: begin
                        case (Instruction[31:25])
                            7'b0000000: begin
                                RegWrite   = 1;
                                ALUControl = 4'b0000; // ADD
                            end
                            7'b0100000: begin
                                RegWrite   = 1;
                                ALUControl = 4'b0001; // SUB
                            end
                        endcase
                    end

                    // AND
                    3'b111: begin
                        if (Instruction[31:25] == 7'b0000000) begin
                            RegWrite   = 1;
                            ALUControl = 4'b0010;
                        end
                    end

                    // OR
                    3'b110: begin
                        if (Instruction[31:25] == 7'b0000000) begin
                            RegWrite   = 1;
                            ALUControl = 4'b0011;
                        end
                    end
                endcase
            end

            // ADDI
            7'b0010011: begin
                if (Instruction[14:12] == 3'b000) begin
                    RegWrite   = 1;
                    ALUSrc     = 1;
                    ImmSrc     = 2'b00; // I-type
                    ALUControl = 4'b0000;
                end
            end

            // LW
            7'b0000011: begin
                if (Instruction[14:12] == 3'b010) begin
                    RegWrite   = 1;
                    ALUSrc     = 1;
                    ResultSrc  = 1;
                    ImmSrc     = 2'b00; // I-type
                    ALUControl = 4'b0000;
                end
            end

            // SW
            7'b0100011: begin
                if (Instruction[14:12] == 3'b010) begin
                    ALUSrc     = 1;
                    MemWrite   = 1;
                    ImmSrc     = 2'b01; // S-type
                    ALUControl = 4'b0000;
                end
            end

        endcase
    end
endmodule
