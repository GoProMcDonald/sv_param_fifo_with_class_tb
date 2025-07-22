interface fifo_param_intf #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 4);

  logic clk;
  logic rst;
  logic wr_en;
  logic rd_en;
  logic [DATA_WIDTH-1:0] din;
  logic [DATA_WIDTH-1:0] dout;
  logic full;
  logic empty;

endinterface