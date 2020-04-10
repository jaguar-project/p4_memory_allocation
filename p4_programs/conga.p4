#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) best_path_util;
register<bit<32>>(1) best_path;

header H {
    /* empty */
}

struct metadata {
    bit<32> util;
    bit<32> path_id;
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
            bit<32> best_path_util_tmp;
            bit<32> best_path_tmp;
            best_path_util.read(best_path_util_tmp, 0);
            best_path.read(best_path_tmp, 0);

            if (meta.util < best_path_util_tmp) {
                best_path_util_tmp = meta.util;
                best_path_tmp = meta.path_id;
            } else if (meta.path_id == best_path_tmp) {
                best_path_util_tmp = meta.util;
            }

            best_path_util.write(0, best_path_util_tmp);
            best_path.write(0, best_path_tmp);
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
