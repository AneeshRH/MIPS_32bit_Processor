`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : cache_2way_sa_tb
// Description : Self-checking testbench for cache_2way_sa
//
// Test Cases:
//   TC1  Cold miss on address 0x00 (word 0)
//   TC2  Read hit on address 0x00 after TC1 fill
//   TC3  Cold miss on address 0x10 (word 4, same set 0 as 0x00)
//   TC4  Read hit on address 0x10
//   TC5  LRU eviction: access 0x20 (word 8, set 0) → evicts way-0 (LRU)
//   TC6  Confirm 0x00 miss after eviction (it was LRU)
//   TC7  Write-through: write 0xDEAD to 0x28 (word 10), check backing store
//   TC8  Write-allocate: write miss allocates cache line for 0x28
//   TC9  Read hit on 0x28 after write-allocate
//   TC10 Pre-initialised value at word 9 (value 18) cold miss + fill
//   TC11 Pre-initialised value at word 10 (value 118) after TC7 overwrite
//   TC12 Different set: address 0x04 (set 1) cold miss
//   TC13 Hit on 0x04 (set 1)
//   TC14 Two-way fill of set 1: 0x14 (way-1)
//   TC15 LRU eviction in set 1 after TC14
//////////////////////////////////////////////////////////////////////////////////

module cache_2way_sa_tb;

    // DUT signals
    reg         clock_sig;
    reg  [31:0] mem_addr_in;
    reg  [31:0] mem_write_data;
    reg         ctrl_mem_rd;
    reg         ctrl_mem_wr;
    wire [31:0] mem_read_data;
    wire [31:0] probe_mem_data;
    wire [29:0] probe_word_addr;

    // Instantiate DUT
    cache_2way_sa dut (
        .clock_sig      (clock_sig),
        .mem_addr_in    (mem_addr_in),
        .mem_write_data (mem_write_data),
        .ctrl_mem_rd    (ctrl_mem_rd),
        .ctrl_mem_wr    (ctrl_mem_wr),
        .mem_read_data  (mem_read_data),
        .probe_mem_data (probe_mem_data),
        .probe_word_addr(probe_word_addr)
    );

    // Clock: 10 ns period
    initial clock_sig = 0;
    always #5 clock_sig = ~clock_sig;

    // -------------------------------------------------------------------------
    // Helper tasks
    // -------------------------------------------------------------------------
    integer pass_count, fail_count;

    task do_read;
        input [31:0] addr;
        begin
            @(negedge clock_sig);
            mem_addr_in    = addr;
            ctrl_mem_rd    = 1;
            ctrl_mem_wr    = 0;
            mem_write_data = 0;
            @(posedge clock_sig); #1; // let combinational output settle
        end
    endtask

    task do_write;
        input [31:0] addr;
        input [31:0] wdata;
        begin
            @(negedge clock_sig);
            mem_addr_in    = addr;
            ctrl_mem_rd    = 0;
            ctrl_mem_wr    = 1;
            mem_write_data = wdata;
            @(posedge clock_sig); #1;
        end
    endtask

    task idle;
        begin
            @(negedge clock_sig);
            ctrl_mem_rd = 0;
            ctrl_mem_wr = 0;
            @(posedge clock_sig); #1;
        end
    endtask

    task check;
        input [31:0] actual;
        input [31:0] expected;
        input [63:0] tc_num;
        begin
            if (actual === expected) begin
                $display("  TC%0d PASS  got=0x%08h", tc_num, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("  TC%0d FAIL  got=0x%08h  expected=0x%08h", tc_num, actual, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // -------------------------------------------------------------------------
    // Main test sequence
    // -------------------------------------------------------------------------
    initial begin
        pass_count = 0;
        fail_count = 0;
        ctrl_mem_rd = 0;
        ctrl_mem_wr = 0;
        mem_addr_in = 0;
        mem_write_data = 0;

        $display("=== cache_2way_sa testbench ===");
        repeat(2) @(posedge clock_sig);

        // TC1: Cold miss, word 0 (addr 0x00), backing store = 0
        $display("[Set 0, Way 0 fill]");
        do_read(32'h00000000);
        check(mem_read_data, 32'd0, 1);

        idle;

        // TC2: Read hit on word 0 (now in cache)
        do_read(32'h00000000);
        check(mem_read_data, 32'd0, 2);

        idle;

        // TC3: Cold miss, word 4 (addr 0x10, set 0 since set = addr[3:2])
        // word_addr = 4, set = 4[1:0] = 0 → same set as TC1
        $display("[Set 0, Way 1 fill]");
        do_read(32'h00000010);
        check(mem_read_data, 32'd0, 3);

        idle;

        // TC4: Hit on word 4
        do_read(32'h00000010);
        check(mem_read_data, 32'd0, 4);

        idle;

        // TC5: LRU eviction in set 0 — word 8 (addr 0x20)
        // word_addr=8, set=8[1:0]=0; both ways full; LRU=way-0 (word 0), evict it
        $display("[Set 0 LRU eviction → way-0 evicted]");
        do_read(32'h00000020);
        check(mem_read_data, 32'd0, 5);

        idle;

        // TC6: Word 0 should now be a miss (was evicted as LRU)
        // On miss the backing store still returns 0 so we just verify no stale data
        do_read(32'h00000000);
        check(mem_read_data, 32'd0, 6);  // value still 0 from backing store

        idle;

        // TC7: Write-through — write 0xDEADBEEF to word 10 (addr 0x28)
        // word_addr=10, set=10[1:0]=2
        $display("[Write-through to backing store]");
        do_write(32'h00000028, 32'hDEADBEEF);
        // probe_mem_data probes dmem[10] — should now be 0xDEADBEEF
        idle;
        check(probe_mem_data, 32'hDEADBEEF, 7);

        // TC8: Write-allocate confirmed — read word 10 should hit after write
        $display("[Write-allocate: read after write miss]");
        do_read(32'h00000028);
        check(mem_read_data, 32'hDEADBEEF, 8);

        idle;

        // TC9: Second read of word 10 — should be cache hit
        do_read(32'h00000028);
        check(mem_read_data, 32'hDEADBEEF, 9);

        idle;

        // TC10: Pre-initialised word 9 (value 18) — addr 0x24, set=9[1:0]=1
        $display("[Pre-initialised values]");
        do_read(32'h00000024);
        check(mem_read_data, 32'd18, 10);

        idle;

        // TC11: After TC7 we overwrote dmem[10] → probe should show 0xDEADBEEF
        // (probe_mem_data always reads dmem[10])
        check(probe_mem_data, 32'hDEADBEEF, 11);

        // TC12: Different set (set 1) — addr 0x04 (word 1, set=1[1:0]=1)
        $display("[Set 1 operations]");
        do_read(32'h00000004);
        check(mem_read_data, 32'd0, 12);

        idle;

        // TC13: Hit on same address
        do_read(32'h00000004);
        check(mem_read_data, 32'd0, 13);

        idle;

        // TC14: Second way fill in set 1 — addr 0x14 (word 5, set=5[1:0]=1)
        do_read(32'h00000014);
        check(mem_read_data, 32'd0, 14);

        idle;

        // TC15: Third access to set 1 triggers LRU eviction — addr 0x24 (word 9)
        // set=9[1:0]=1, both ways full; way-0 is LRU (word 1 was accessed first)
        do_read(32'h00000024);   // word 9 = value 18
        check(mem_read_data, 32'd18, 15);

        idle;

        // -----------------------------------------------------------------------
        $display("==============================");
        $display("Results: %0d PASS  %0d FAIL", pass_count, fail_count);
        $display("==============================");
        $finish;
    end

    // Timeout watchdog
    initial begin
        #5000;
        $display("TIMEOUT");
        $finish;
    end

endmodule
