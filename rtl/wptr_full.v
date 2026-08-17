module wptr_full #(parameter ADDRESS_SIZE = 8)(
    output reg w_full,                   
    output [ADDRESS_SIZE-1:0] w_addr,       
    output reg [ADDRESS_SIZE :0] w_ptr,    
    input [ADDRESS_SIZE :0] w_q2_rptr,     
    input w_inc, w_clk, w_rst_n            
    );

    reg [ADDRESS_SIZE:0] w_bin;                     
    wire [ADDRESS_SIZE:0] w_gray_next, w_bin_next;   
    wire w_full_val;                             


    always @(posedge w_clk or negedge w_rst_n) begin
        if (!w_rst_n)         
            {w_bin, w_ptr} <= 0;
        else 
            {w_bin, w_ptr} <= {w_bin_next, w_gray_next}; 
    end

    assign w_addr = w_bin[ADDRESS_SIZE-1:0];             
    assign w_bin_next = w_bin + (w_inc & ~w_full);       
    assign w_gray_next = (w_bin_next>>1) ^ w_bin_next;    

    // Check if the FIFO is full
    //------------------------------------------------------------------
    // Simplified version of the three necessary full-tests:
    // assign w_full_val=((w_g_next[ADDRESS_SIZE] !=w_q2_rptr[ADDRESS_SIZE] ) &
    // (w_g_next[ADDRESS_SIZE-1] !=w_q2_rptr[ADDRESS_SIZE-1]) &
    // (w_g_next[ADDRESS_SIZE-2:0]==w_q2_rptr[ADDRESS_SIZE-2:0]));
    //------------------------------------------------------------------
    assign w_full_val = (w_gray_next=={~w_q2_rptr[ADDRESS_SIZE:ADDRESS_SIZE-1], w_q2_rptr[ADDRESS_SIZE-2:0]});

    always @(posedge w_clk or negedge w_rst_n) begin
        if (!w_rst_n)          
            w_full <= 1'b0;
        else 
            w_full <= w_full_val; 
    end
endmodule
