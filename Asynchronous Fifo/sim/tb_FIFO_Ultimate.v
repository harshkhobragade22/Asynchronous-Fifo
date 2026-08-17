`timescale 1ns/1ps

module tb_FIFO_Ultimate();

    parameter DATA_SIZE = 16; 
    parameter ADDRESS_SIZE = 8; // Using 4 (16 depth) for faster simulation
    parameter DEPTH = 1 << ADDRESS_SIZE; 

    reg [DATA_SIZE-1:0] w_data;   
    wire [DATA_SIZE-1:0] r_data;  
    wire w_full, r_empty;      
    reg w_inc, r_inc, w_clk, r_clk, w_rst_n, r_rst_n; 

    FIFO #(DATA_SIZE, ADDRESS_SIZE) dut (
        .r_data(r_data), 
        .w_data(w_data),
        .w_full(w_full),
        .r_empty(r_empty),
        .w_inc(w_inc), 
        .r_inc(r_inc), 
        .w_clk(w_clk), 
        .r_clk(r_clk), 
        .w_rst_n(w_rst_n), 
        .r_rst_n(r_rst_n)
    );

    integer i;
    integer seed = 42;

    // 1. Asynchronous Drifting Clocks
    always #5 w_clk = ~w_clk;      // 10ns period (100 MHz)
    always #13.5 r_clk = ~r_clk;   // 27ns period (~37 MHz)
    
    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb_FIFO_Ultimate);
        // Initialize
        w_clk = 0; r_clk = 0;
        w_rst_n = 1; r_rst_n = 1;     
        w_inc = 0; r_inc = 0; w_data = 0;

        // Reset
        $display("[%0t] Resetting FIFO...", $time);
        #40 w_rst_n = 0; r_rst_n = 0;
        #40 w_rst_n = 1; r_rst_n = 1;
        repeat(3) @(negedge w_clk);

        // ---------------------------------------------------------
        // TEST 1: Fill & Overflow Protection (Your DEPTH+3 method)
        // ---------------------------------------------------------
        $display("\n[%0t] --- TEST 1: Fill and Overflow Test ---", $time);
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            @(negedge w_clk);
            w_data = $random(seed) % 65536;
            w_inc = 1;
            if (w_full) $display("[%0t] Attempting to write %h while FULL (Should be ignored)", $time, w_data);
            else $display("[%0t] Wrote: %h", $time, w_data);
        end
        @(negedge w_clk) w_inc = 0;
        
        // Allow pointers to cross domains
        repeat(10) @(negedge r_clk);

        // ---------------------------------------------------------
        // TEST 2: Empty & Underflow Protection
        // ---------------------------------------------------------
        $display("\n[%0t] --- TEST 2: Empty and Underflow Test ---", $time);
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            @(negedge r_clk);
            r_inc = 1;
            // Note: r_data updates on posedge, so we wait briefly to display it
            #1; 
            if (r_empty) $display("[%0t] Attempting to read while EMPTY (Data invalid)", $time);
            else $display("[%0t] Read:  %h", $time, r_data);
        end
        @(negedge r_clk) r_inc = 0;

        repeat(10) @(negedge w_clk);

        // ---------------------------------------------------------
        // TEST 3: Simultaneous Read/Write Stress Test
        // ---------------------------------------------------------
        $display("\n[%0t] --- TEST 3: Simultaneous Read/Write ---", $time);
        
        // Start reading and writing continuously
        w_inc = 1;
        r_inc = 1;
        
        // Run for 50 write cycles
        for (i = 0; i < 50; i = i + 1) begin
            @(negedge w_clk);
            if (!w_full) w_data = $random(seed) % 65536;
        end
        
        // Power down stimulus
        @(negedge w_clk) w_inc = 0;
        @(negedge r_clk) r_inc = 0;
        
        #200;
        $display("\n[%0t] --- All Tests Completed ---", $time);
        $finish;
    end

endmodule