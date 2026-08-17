module FIFO #(parameter DATA_SIZE = 16,
    parameter ADDRESS_SIZE = 8)(
    output [DATA_SIZE-1:0] r_data,       
    output w_full,                   
    output r_empty,                  
    input [DATA_SIZE-1:0] w_data,        
    input w_inc, w_clk, w_rst_n,     
    input r_inc, r_clk, r_rst_n        
    );

    wire [ADDRESS_SIZE-1:0] w_addr, r_addr;
    wire [ADDRESS_SIZE:0] w_ptr, r_ptr, w_q2_rptr, r_q2_wptr;

    ff_synchronization #(ADDRESS_SIZE) sync_r2w (    
        .q2(w_q2_rptr), 
        .data_in(r_ptr),
        .clk(w_clk), 
        .rst_n(w_rst_n)
    );

    ff_synchronization #(ADDRESS_SIZE) sync_w2r (       
        .q2(r_q2_wptr), 
        .data_in(w_ptr),
        .clk(r_clk), 
        .rst_n(r_rst_n)
    );

    FIFO_memory #(DATA_SIZE, ADDRESS_SIZE) fifo_mem(    
        .r_data(r_data), 
        .w_data(w_data),
        .w_addr(w_addr), 
        .r_addr(r_addr),
        .w_clk_en(w_inc), 
        .w_full(w_full),
        .w_clk(w_clk)
    );

    rptr_empty #(ADDRESS_SIZE) rptr_empty(         
        .r_empty(r_empty),
        .r_addr(r_addr),
        .r_ptr(r_ptr), 
        .r_q2_wptr(r_q2_wptr),
        .r_inc(r_inc), 
        .r_clk(r_clk),
        .r_rst_n(r_rst_n)
    );

    wptr_full #(ADDRESS_SIZE) wptr_full(          
        .w_full(w_full), 
        .w_addr(w_addr),
        .w_ptr(w_ptr), 
        .w_q2_rptr(w_q2_rptr),
        .w_inc(w_inc), 
        .w_clk(w_clk),
        .w_rst_n(w_rst_n)
    );

endmodule
