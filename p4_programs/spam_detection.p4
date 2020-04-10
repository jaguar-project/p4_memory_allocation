#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) mta_dir;
register<bit<32>>(1) mail_counter;

header H {
    /* empty */
}

struct metadata {
    /* empty */
}

struct headers {
    H   H_header;
}

const bit<32> THRESH = 1000;

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
            bit<32> mta_dir_tmp;
            bit<32> mail_counter_tmp;
            mta_dir.read(mta_dir_tmp, 0);
            mail_counter.read(mail_counter_tmp, 0);

            if (mta_dir_tmp == 1) {
                mta_dir_tmp = 2;
                mail_counter_tmp = 0;
            }

            if (mta_dir_tmp == 2) {
                mail_counter_tmp = mail_counter_tmp + 1;
                if (mail_counter_tmp == THRESH) {
                    mta_dir_tmp = 3;
                }
            }

            mta_dir.write(0, mta_dir_tmp);
            mail_counter.write(0, mail_counter_tmp);
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
