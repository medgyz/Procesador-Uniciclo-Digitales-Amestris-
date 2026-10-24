# Proyecto_Final_-_Capítulo_1:_Los_Cimientos

**Curso:** Diseño de Sistemas Digitales (EL-3310)  
**Institución:** Instituto Tecnológico de Costa Rica (TEC)  
**Profesor:** Ing. Michael González Vega  

---

## Integrantes del Grupo

* **Team Lead:**  Ximena Araya Brenes - Carné: 2024122095
* **Hardware Developer:**  Kevin Mendez Carvajal - Carné: 2023328177
* **Verification Engineer:** John Hibbert Bonilla - Carné: 2024062788
* **Documentation & Configuration Engineer:** Jason Enrique Ulloa Picado - Carné: 2024159001

---

## Estructura del Proyecto

```text
RISC-V-CPU/
├── src/                    # Código fuente de los módulos SystemVerilog
│   ├── alu.sv              # Unidad Aritmético Lógica
│   ├── register_file.sv    # Banco de Registros (32x32 bits)
│   ├── imm_gen.sv          # Generador de Inmediatos (I-type, S-type)
│   └── mux.sv              # Multiplexor 2:1
├── testbench/              # Testbenches para verificación funcional
│   ├── alu_tb.sv
│   ├── register_file_tb.sv
│   ├── imm_gen_tb.sv
│   └── mux_tb.sv
├── sim/                    # Archivos y resultados de simulación
│   ├── alu_sim
│   ├── imm_sim
│   ├── mux_sim
│   └── rf_sim
├── docs/                   # Documentación técnica e informe
│   └── Informe de Proyecto - DD/
└── README.md               # Archivo de presentación y enlaces
```

---

## Simulaciones en EDA Playground

Para abrir y ejecutar la simulación de cada módulo, acceda a los siguientes enlaces de EDA Playground:

**ALU:** [Enlace a EDA Playground de ALU]

**Register File:** [Enlace a EDA Playground de Register File]

**Immediate Generator:** [Enlace a EDA Playground de Immediate Generator]

**MUX:** [Enlace a EDA Playground de MUX]

---

## Matriz de Pruebas Funcionales

La matriz de pruebas ejecutada para la verificación funcional de cada módulo SystemVerilog es:

| ID | Módulo | Entrada / Condición | Resultado Esperado | Resultado Obtenido | Estado |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **ALU-01** | ALU | Operación ADD: `A = 15, B = 7, ALUControl = 0000` | `Result = 22, Zero = 0` | `Result = 22, Zero = 0` | **PASS** |
| **ALU-02** | ALU | Operación SUB: `A = 15, B = 7, ALUControl = 0001` | `Result = 8, Zero = 0` | `Result = 8, Zero = 0` | **PASS** |
| **ALU-03** | ALU | Operación SUB (Detección Cero): `A = 10, B = 10, ALUControl = 0001` | `Result = 0, Zero = 1` | `Result = 0, Zero = 1` | **PASS** |
| **ALU-04** | ALU | Operación AND: `A = 0xF0F0F0F0, B = 0xFF00FF00, ALUControl = 0010` | `Result = 0xF000F000, Zero = 0` | `Result = 0xF000F000, Zero = 0` | **PASS** |
| **ALU-05** | ALU | Operación OR: `A = 0xF0F0F0F0, B = 0x0F0F0F0F, ALUControl = 0011` | `Result = 0xFFFFFFFF, Zero = 0` | `Result = 0xFFFFFFFF, Zero = 0` | **PASS** |
| **ALU-06** | ALU | Resultado Negativo: `A = 3, B = 5, ALUControl = 0001` | `Result = -2 (0xFFFFFFFE), Zero = 0` | `Result = -2 (0xFFFFFFFE), Zero = 0` | **PASS** |
| **RF-01** | Register File | Escritura y lectura en `x5`: `A3 = 5, WD3 = 25, RegWrite = 1` | `RD1 = 25` (al leer `A1 = 5`) | `RD1 = 25` | **PASS** |
| **RF-02** | Register File | Doble lectura simultánea: `A1 = 5 (25), A2 = 6 (14)` | `RD1 = 25, RD2 = 14` | `RD1 = 25, RD2 = 14` | **PASS** |
| **RF-03** | Register File | Intento de escritura en `x0`: `A3 = 0, WD3 = 100, RegWrite = 1` | `RD1 = 0` (al leer `A1 = 0`) | `RD1 = 0` | **PASS** |
| **IMM-01** | Imm Gen | I-type positivo: `instr = 0x00F00293, ImmSrc = 00` | `ImmExt = 0x0000000F` | `ImmExt = 0x0000000F` | **PASS** |
| **IMM-02** | Imm Gen | I-type negativo (Extensión de signo): `instr = 0xFFF00293, ImmSrc = 00` | `ImmExt = 0xFFFFFFFF` | `ImmExt = 0xFFFFFFFF` | **PASS** |
| **IMM-03** | Imm Gen | S-type positivo: `instr = 0x00528223, ImmSrc = 01` | `ImmExt = 0x00000004` | `ImmExt = 0x00000004` | **PASS** |
| **IMM-04** | Imm Gen | S-type negativo (Extensión de signo): `instr = 0xFE528223, ImmSrc = 01` | `ImmExt = 0xFFFFFFFE` | `ImmExt = 0xFFFFFFFE` | **PASS** |
| **MUX-01** | MUX | Selección de entrada 0: `d0 = 0xAAAA, d1 = 0xBBBB, sel = 0` | `y = 0xAAAA` | `y = 0xAAAA` | **PASS** |
| **MUX-02** | MUX | Selección de entrada 1: `d0 = 0xAAAA, d1 = 0xBBBB, sel = 1` | `y = 0xBBBB` | `y = 0xBBBB` | **PASS** |

---

## Instrucciones de Ejecución

Abra cualquiera de los enlaces de EDA Playground.

Seleccionar las herramientas de simulación adecuadas en el panel izquierdo (ejemplo: Icarus Verilog o VNSim / Riviera-PRO habilitando SystemVerilog).

Haga clic en el botón Run para ejecutar la simulación.

Revise el panel de la consola (EPWave o la salida de texto) para verificar los mensajes automatizados de PASS / FAIL correspondientes a la matriz de pruebas
