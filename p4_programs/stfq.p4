#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) last_finish;

header H {
    /* empty */
}

struct metadata {
    bit<32> virtual_time;
    bit<32> start;
    bit<32> length;
}

struct headers {
    H   H_header;
}

const bit<32> TIME_MIN = 1;

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
            bit<32> last_finish_tmp;
            last_finish.read(last_finish_tmp, 0);

            if (last_finish_tmp > TIME_MIN && meta.virtual_time < last_finish_tmp) {
                meta.start = last_finish_tmp;
                last_finish_tmp = last_finish_tmp + meta.length;
            } else {
                meta.start = meta.virtual_time;
                last_finish_tmp = meta.virtual_time + meta.length;
            }

            last_finish.write(0, last_finish_tmp);
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
