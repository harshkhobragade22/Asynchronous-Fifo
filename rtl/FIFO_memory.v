module FIFO_memory #(parameter DATA_SIZE = 16,
    parameter ADDRESS_SIZE = 8)(
    output [DATA_SIZE-1:0] r_data,       
    input [DATA_SIZE-1:0] w_data,       
    input [ADDRESS_SIZE-1:0] w_addr, r_addr,  
    input w_clk_en, w_full, w_clk          
    );

    localparam DEPTH = 1<<ADDRESS_SIZE;     
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];

    assign r_data = mem[r_addr];          

    always @(posedge w_clk)
        if (w_clk_en & ~w_full) mem[w_addr] <= w_data; 

endmodule
