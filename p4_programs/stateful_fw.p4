#include <core.p4>
#include <v1model.p4>

register<bit<32>>(1) established;

header H {
    /* empty */
}

struct metadata {
    bit<32> rtt;
    bit<32> array_index;
    bit<32> src;
    bit<32> dst;
    bit<32> drop;
}

struct headers {
    H   H_header;
}

const bit<32> VALID_IP = 10234;

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
            bit<32> established_tmp;
            established.read(established_tmp, 0);

            meta.array_index = meta.src * 1000 + meta.dst;
            if (meta.src == VALID_IP) {
                established_tmp = 1;
            } else {
                if (meta.dst == VALID_IP) {
                    if (established_tmp == 0) {
                        meta.drop = 1;
                    } else {
                        meta.drop = 0;
                    }
                }
            } 

            established.write(0, established_tmp);
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
