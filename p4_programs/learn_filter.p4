#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) filter1;
register<bit<32>>(1) filter2;
register<bit<32>>(1) filter3;

header H {
    /* empty */
}

struct metadata {
    bit<32> member;
}

struct headers {
    H   H_header;
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

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    apply {
        @atomic{
            bit<32> filter1_tmp;
            bit<32> filter2_tmp;
            bit<32> filter3_tmp;
            filter1.read(filter1_tmp, 0);
            filter2.read(filter2_tmp, 0);
            filter3.read(filter3_tmp, 0);
            if (filter1_tmp != 0 && filter2_tmp != 0 && filter3_tmp != 0) {
                meta.member = 1;
            }
            filter1_tmp = 1;
            filter2_tmp = 1;
            filter3_tmp = 1;
            filter1.write(0, filter1_tmp);
            filter2.write(0, filter2_tmp);
            filter3.write(0, filter3_tmp);
        }
    }
}


control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
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
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
