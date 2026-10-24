# Proyecto_Final_-_Capítulo_1:_Los_Cimientos

**Curso:** Diseño de Sistemas Digitales (EL-3310)  
**Institución:** Instituto Tecnológico de Costa Rica (TEC)  
**Profesor:** Ing. Michael González Vega  

---

## Integrantes del Grupo

* **Team Lead:**  Ximena Araya Brenes - Carné: [Número de Carné]
* **Hardware Developer:**  Kevin Mendez Carvajal - Carné: [Número de Carné]
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

## Instrucciones de Ejecución

Abra cualquiera de los enlaces de EDA Playground.

Seleccionar las herramientas de simulación adecuadas en el panel izquierdo (ejemplo: Icarus Verilog o VNSim / Riviera-PRO habilitando SystemVerilog).

Haga clic en el botón Run para ejecutar la simulación.

Revise el panel de la consola (EPWave o la salida de texto) para verificar los mensajes automatizados de PASS / FAIL correspondientes a la matriz de pruebas
