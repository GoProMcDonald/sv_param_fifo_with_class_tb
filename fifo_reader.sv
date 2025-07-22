class fifo_reader;

  virtual fifo_param_intf vif;

  function new(virtual fifo_param_intf vif);
    this.vif = vif;
  endfunction

  task read_process();
    $display(">>> [READ_PROCESS] entered");
    repeat ((1 << vif.ADDR_WIDTH) + 2) begin//读出可能会有延迟（例如 FIFO 为空或 rd_en 为 0 的时候就不会读），所以必须多循环几拍，保证能把之前写进来的数据都读出来。
      @(negedge vif.clk);
      vif.rd_en <= $urandom_range(0, 1);//随机激励 (random stimulus)” —— verification 的核心思维！在实际应用中：写入和读取往往是不同时发生、不等间隔、甚至带有随机性。
        //如果你把写入和读取都做成整齐的同步触发，反而无法测试 FIFO 是否能正确处理“不规则行为”。
        //我们用 $urandom_range(0, 1) 来模拟：有时候读使能、写使能被激活，有时候不激活。这样 FIFO 就需要真的判断 full/empty、处理掉写冲突/读空等问题 —— 这是验证设计鲁棒性所必须的。


      if (vif.rd_en && !vif.empty)
        $display("[READ ] Time: %0t  Data: %0d", $time, vif.dout);
      
      @(negedge vif.clk);
      vif.rd_en <= 0;
    end
  endtask

endclass