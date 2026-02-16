`timescale 1 ps / 100 fs

module MIPSStimulus();

    // 1. Parameters and Signals
    parameter ClockDelay = 10000; // Increased period to 10ns for gate delays
    reg clk, reset;

    // 2. Instantiate the Processor 
    // Ensure the module name 'MIPSpipeline' matches your design file exactly
    MIPSpipeline myMIPS (
        .clk(clk), 
        .reset(reset)
    );

    // 3. Clock Generation
    initial clk = 0;
    always #(ClockDelay/2) clk = ~clk;

    // 4. Main Simulation Control
    initial begin
        // --- Required for EPWave ---
        $dumpfile("dump.vcd"); 
        $dumpvars(0, MIPSStimulus);

        // --- Initialization ---
        $display("Starting Simulation at %t", $time);
        reset = 1;      // Start in reset
        
        // Wait 2 full cycles for everything to clear
        #(ClockDelay * 2); 
        
        // Release reset on the falling edge to avoid race conditions
        @(negedge clk); 
        reset = 0;
        $display("Reset released at %t", $time);

        // --- Run Duration ---
        // 500,000ps allows for 50 cycles at 10ns per cycle
        #500000; 

        $display("Simulation finished at %t", $time);
        $finish;
    end

    // 5. Optional: Monitor PC or key signals in the console
    // This helps confirm the simulation is running even if waves fail
    initial begin
        $monitor("Time: %t | Reset: %b | clk: %b", $time, reset, clk);
    end

endmodule