module fifo_top #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(
  input  logic clk,
  input  logic rst,
  input  logic wr_en,
  input  logic rd_en,
  input  logic [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout,
  output logic full,
  output logic empty
);

  logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;

  fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) u_ctrl (
    .clk    (clk),
    .rst    (rst),
    .wr_en  (wr_en),
    .rd_en  (rd_en),
    .wr_ptr (wr_ptr),
    .rd_ptr (rd_ptr),
    .full   (full),
    .empty  (empty)
  );

  fifo_core #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) u_core (
    .clk    (clk),
    .rst    (rst),
    .wr_en  (wr_en),
    .rd_en  (rd_en),
    .wr_ptr (wr_ptr),
    .rd_ptr (rd_ptr),
    .din    (din),
    .dout   (dout)
  );

endmodule

