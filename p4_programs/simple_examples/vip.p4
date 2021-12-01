#include <core.p4>
#include <v1model.p4>

header packet_t {
        bit<32> pkt_0;
        bit<32> pkt_1;
        bit<32> pkt_2;
        bit<32> pkt_3;
        bit<32> pkt_4;
        bit<32> pkt_5;
        bit<32> pkt_6;
        bit<32> pkt_7;
        bit<32> pkt_8;
        bit<32> pkt_9;
        bit<32> pkt_10;
        bit<32> pkt_11;
        bit<32> pkt_12;
        bit<32> pkt_13;
        bit<32> pkt_14;
        bit<32> pkt_15;
        bit<32> pkt_16;
        bit<32> pkt_17;
}

header vlan_tag_t {
        bit<8> vid;
}

struct headers {
    packet_t                              pkt; 
}

struct metadata {
    bit<32>               sample;
}

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    state start {
        transition accept;
    }
    
}

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

control ingress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    action table0_act() {
        hdr.pkt.pkt_0 = hdr.pkt.pkt_0 + 1;
    }

    table table0 {
        key = {
        }
        actions = {
            table0_act;
        }
    }

    action table0_cp_act() {
        hdr.pkt.pkt_0 = hdr.pkt.pkt_0 + 1;
    }

    table table0_cp {
        key = {
        }
        actions = {
            table0_cp_act;
        }
    }

    action table1_act() {
        hdr.pkt.pkt_1 = hdr.pkt.pkt_1 + 1;
    }

    table table1 {
        key = {
        }
        actions = {
            table1_act;
        }
    }

    action table1_cp_act() {
        hdr.pkt.pkt_1 = hdr.pkt.pkt_1 + 1;
    }

    table table1_cp {
        key = {
        }
        actions = {
            table1_cp_act;
        }
    }

    action table2_act() {
        hdr.pkt.pkt_2 = hdr.pkt.pkt_2 + 1;
    }

    table table2 {
        key = {
        }
        actions = {
            table2_act;
        }
    }

    action table2_cp_act() {
        hdr.pkt.pkt_2 = hdr.pkt.pkt_2 + 1;
    }

    table table2_cp {
        key = {
        }
        actions = {
            table2_cp_act;
        }
    }

    action table3_act() {
        hdr.pkt.pkt_3 = hdr.pkt.pkt_3 + 1;
    }

    table table3 {
        key = {
        }
        actions = {
            table3_act;
        }
    }

    action table3_cp_act() {
        hdr.pkt.pkt_3 = hdr.pkt.pkt_3 + 1;
    }

    table table3_cp {
        key = {
        }
        actions = {
            table3_cp_act;
        }
    }

    action table4_act() {
        hdr.pkt.pkt_4 = hdr.pkt.pkt_4 + 1;
    }

    table table4 {
        key = {
        }
        actions = {
            table4_act;
        }
    }

    action table4_cp_act() {
        hdr.pkt.pkt_4 = hdr.pkt.pkt_4 + 1;
    }

    table table4_cp {
        key = {
        }
        actions = {
            table4_cp_act;
        }
    }

    action table5_act() {
        hdr.pkt.pkt_5 = hdr.pkt.pkt_5 + 1;
    }

    table table5 {
        key = {
        }
        actions = {
            table5_act;
        }
    }

    action table5_cp_act() {
        hdr.pkt.pkt_5 = hdr.pkt.pkt_5 + 1;
    }

    table table5_cp {
        key = {
        }
        actions = {
            table5_cp_act;
        }
    }

    action table6_act() {
        hdr.pkt.pkt_6 = hdr.pkt.pkt_6 + 1;
    }

    table table6 {
        key = {
        }
        actions = {
            table6_act;
        }
    }

    action table6_cp_act() {
        hdr.pkt.pkt_6 = hdr.pkt.pkt_6 + 1;
    }

    table table6_cp {
        key = {
        }
        actions = {
            table6_cp_act;
        }
    }

    action table7_act() {
        hdr.pkt.pkt_7 = hdr.pkt.pkt_7 + 1;
    }

    table table7 {
        key = {
        }
        actions = {
            table7_act;
        }
    }

    action table7_cp_act() {
        hdr.pkt.pkt_7 = hdr.pkt.pkt_7 + 1;
    }

    table table7_cp {
        key = {
        }
        actions = {
            table7_cp_act;
        }
    }

    action table8_act() {
        hdr.pkt.pkt_8 = hdr.pkt.pkt_8 + 1;
    }

    table table8 {
        key = {
        }
        actions = {
            table8_act;
        }
    }

    action table8_cp_act() {
        hdr.pkt.pkt_8 = hdr.pkt.pkt_8 + 1;
    }

    table table8_cp {
        key = {
        }
        actions = {
            table8_cp_act;
        }
    }
    
    action table9_act() {
        hdr.pkt.pkt_9 = hdr.pkt.pkt_9 + 1;
    }

    table table9 {
        key = {
        }
        actions = {
            table9_act;
        }
    }

    action table9_cp_act() {
        hdr.pkt.pkt_9 = hdr.pkt.pkt_9 + 1;
    }

    table table9_cp {
        key = {
        }
        actions = {
            table9_cp_act;
        }
    }

    action table10_act() {
        hdr.pkt.pkt_10 = hdr.pkt.pkt_10 + 1;
    }

    table table10 {
        key = {
        }
        actions = {
            table10_act;
        }
    }

    action table10_cp_act() {
        hdr.pkt.pkt_10 = hdr.pkt.pkt_10 + 1;
    }

    table table10_cp {
        key = {
        }
        actions = {
            table10_cp_act;
        }
    }

    action table11_act() {
        hdr.pkt.pkt_11 = hdr.pkt.pkt_11 + 1;
    }

    table table11 {
        key = {
        }
        actions = {
            table11_act;
        }
    }

    action table11_cp_act() {
        hdr.pkt.pkt_11 = hdr.pkt.pkt_11 + 1;
    }

    table table11_cp {
        key = {
        }
        actions = {
            table11_cp_act;
        }
    }

    action table12_act() {
        hdr.pkt.pkt_12 = hdr.pkt.pkt_12 + 1;
    }

    table table12 {
        key = {
        }
        actions = {
            table12_act;
        }
    }

    action table12_cp_act() {
        hdr.pkt.pkt_12 = hdr.pkt.pkt_12 + 1;
    }

    table table12_cp {
        key = {
        }
        actions = {
            table12_cp_act;
        }
    }
    
    action table13_act() {
        hdr.pkt.pkt_13 = hdr.pkt.pkt_13 + 1;
    }

    table table13 {
        key = {
        }
        actions = {
            table13_act;
        }
    }

    action table13_cp_act() {
        hdr.pkt.pkt_13 = hdr.pkt.pkt_13 + 1;
    }

    table table13_cp {
        key = {
        }
        actions = {
            table13_cp_act;
        }
    }

    action table14_act() {
        hdr.pkt.pkt_14 = hdr.pkt.pkt_14 + 1;
    }

    table table14 {
        key = {
        }
        actions = {
            table14_act;
        }
    }

    action table14_cp_act() {
        hdr.pkt.pkt_14 = hdr.pkt.pkt_14 + 1;
    }

    table table14_cp {
        key = {
        }
        actions = {
            table14_cp_act;
        }
    }
 
    action table15_act() {
        hdr.pkt.pkt_15 = hdr.pkt.pkt_15 + 1;
    }

    table table15 {
        key = {
        }
        actions = {
            table15_act;
        }
    }
    
    action table16_act() {
        hdr.pkt.pkt_16 = hdr.pkt.pkt_16 + 1;
    }

    table table16 {
        key = {
        }
        actions = {
            table16_act;
        }
    }

    action table16_cp_act() {
        hdr.pkt.pkt_16 = hdr.pkt.pkt_16 + 1;
    }

    table table16_cp {
        key = {
        }
        actions = {
            table16_cp_act;
        }
    }

    action table17_act() {
        hdr.pkt.pkt_17 = hdr.pkt.pkt_16 + hdr.pkt.pkt_15;
    }

    table table17 {
        key = {
        }
        actions = {
            table17_act;
        }
    }

    apply {
        table0.apply();
        table0_cp.apply();
        table1.apply();
        table1_cp.apply();
        table2.apply();
        table2_cp.apply();
        table3.apply();
        table3_cp.apply();
        table4.apply();
        table4_cp.apply();
        table5.apply();
        table5_cp.apply();
        table6.apply();
        table6_cp.apply();
        table7.apply();
        table7_cp.apply();

        table8.apply();
        table8_cp.apply();
        table9.apply();
        table9_cp.apply();
        table10.apply();
        table10_cp.apply();
        table11.apply();
        table11_cp.apply();
        table12.apply();
        table12_cp.apply();
        table13.apply();
        table13_cp.apply();
        table14.apply();
        table14_cp.apply();
        
        table15.apply();
        table16.apply();
        table16_cp.apply();
        table17.apply();
    }
}

control egress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {  }
}

control MyDeparser(packet_out packet, in headers hdr) {
    apply { }
}

V1Switch(
MyParser(),
MyVerifyChecksum(),
ingress(),
egress(),
MyComputeChecksum(),
MyDeparser()
) main;
